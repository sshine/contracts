{-# LANGUAGE DeriveDataTypeable, TypeFamilies, GADTs, FlexibleInstances, FlexibleContexts, UndecidableInstances #-} 
module Contract.Expr
    ( Currency(..) -- constructors exported
    , Var
    , ExprG        -- no constructors exported!
    , BoolE, IntE, RealE
    , i, r, b, v, pair, first, second, acc, obs, chosenBy
    , ppExp, certainExp, eqExp, translExp
    -- evaluation. Polymorphic eval not exported
    , Env, emptyEnv
    , evalI, evalR, evalB, simplifyExp
    ) where


-- to define the exception
import Control.Exception
import Data.Typeable
import System.IO.Unsafe(unsafePerformIO)
import Control.Concurrent

data Currency = EUR | DKK | SEK | USD | GBP | JPY
-- good enough with only FX derivatives. Otherwise we could add this:
-- "... | Stock String | Equity String"
-- These are just tags, not used in expressions / arithmetics
-- (otherwise we might want a GADT for them)

ppCur EUR = "EUR"
ppCur DKK = "DKK"
ppCur SEK = "SEK"
ppCur USD = "USD"
ppCur GBP = "GBP"
ppCur JPY = "JPY"

-- submodule expression starts here
type Var = String

-- Expression GADT:
data ExprG a where
    I :: Int    -> ExprG Int
    R :: Double -> ExprG Double
    B :: Bool   -> ExprG Bool
    V :: Var    -> ExprG a
    -- Pairs:
    Pair :: ExprG a -> ExprG b -> ExprG (a,b)
    Fst :: ExprG (a,b) -> ExprG a
    Snd :: ExprG (a,b) -> ExprG b
    -- observables and external choices
    Obs :: (String, Int) -> ExprG Double
    ChosenBy :: (String, Int) -> ExprG Bool
    -- accumulator. Acc(f,i,a) := f/i(...(f/2(f/1(a))))
    Acc :: (Var, ExprG a) -> Int -> ExprG a -> ExprG a
    -- unary op.s: only "not"
    Not :: ExprG Bool -> ExprG Bool
    -- binary op.s, by type: +-*/ max min < = |
    -- on numerical arguments: +-*/ max min
    Arith :: Num a => AOp -> ExprG a -> ExprG a -> ExprG a
    Less  :: Ord a => ExprG a -> ExprG a -> ExprG Bool
    Equal :: Eq a  => ExprG a -> ExprG a -> ExprG Bool
    Or    :: ExprG Bool -> ExprG Bool -> ExprG Bool

data AOp = Plus | Minus | Times | Max | Min
         deriving (Show)

-- Bool indicating infix operators
ppOp :: AOp -> (String,Bool)
ppOp Plus   = ("+", True)
ppOp Minus  = ("-", True)
ppOp Times  = ("*", True)
ppOp Max    = ("max", False)
ppOp Min    = ("min", False)

-- reading operators
instance Read AOp where
    readsPrec _ ('+':rest) = [(Plus,rest)]
    readsPrec _ ('-':rest) = [(Minus,rest)]
    readsPrec _ ('*':rest) = [(Times,rest)]
    readsPrec _ ('m':'a':'x':rest) = [(Max,rest)]
    readsPrec _ ('m':'i':'n':rest) = [(Min,rest)]
    readsPrec _ _ = []

-- just some aliases
type BoolE = ExprG Bool
type IntE = ExprG Int
type RealE = ExprG Double

-- arithmetic evaluation function
arith :: Num a => AOp -> ExprG a -> ExprG a -> ExprG a
arith op (I i1) (I i2) = I (opsem op i1 i2)
arith op (R r1) (R r2) = R (opsem op r1 r2)
arith Plus e1 e2  = Arith Plus  e1 e2
arith Minus e1 e2 = Arith Minus e1 e2
arith Times e1 e2 = Arith Times e1 e2
arith Max e1 e2   = Arith Max   e1 e2
arith Min e1 e2   = Arith Min   e1 e2

opsem :: (Ord a, Num a) => AOp -> a -> a -> a
opsem Plus = (+)
opsem Minus = (-)
opsem Times = (*)
opsem Max = max
opsem Min = min

-- Num instance, enabling us to write "e1 + e2" for ExprG a with Num a
instance (Decompose (ExprG a), Num (Content (ExprG a)), Num a) =>
    Num (ExprG a) where
    (+) = Arith Plus
    (*) = Arith Times
    (-) = Arith Minus
    negate = Arith Minus (fromInteger 0)
    abs a = (constr a) (abs (content a))
    signum a = (constr a) (signum (content a))
    fromInteger n = (constr (undefined :: ExprG a)) (fromInteger n)
-- there's a pattern... f a = (constr a) (f (content a))

-- enabled with this - slightly weird - helper class
class Num a => Decompose a where
    type Content a
    constr  :: a -> (Content a -> a)
    content :: Num (Content a) => a -> Content a

instance Decompose (ExprG Int) where
    type Content (ExprG Int) = Int
    constr _  = I
    content x = evalI emptyEnv x

instance Decompose (ExprG Double) where
    type Content (ExprG Double) = Double
    constr  _ = R
    content x = evalR emptyEnv x

i = I -- :: Int  -> IntE
r = R -- :: Double -> RealE
b = B -- :: Bool -> BoolE
v = V -- :: String -> ExprG a
pair = Pair
first  = Fst
second  = Snd
obs      = Obs
chosenBy = ChosenBy

acc :: (Num a) => (ExprG a -> ExprG a) -> Int -> ExprG a -> ExprG a
acc _ 0 a = a
acc f i a = let v = newName "v" 
            in Acc (v,f (V v)) i a 

-- using a unique supply, the quick way...
{-# NOINLINE idSupply #-}
idSupply :: MVar Int
idSupply = unsafePerformIO (newMVar 1)
newName :: String -> String
newName s = unsafePerformIO (do next <- takeMVar idSupply
 	                        putMVar idSupply (next+1)
	                        return (s ++ show next))

-- equality: comparing syntax by hash, considering commutativity
eqExp :: ExprG a -> ExprG a -> Bool
eqExp e1 e2 = hashExp e1 == hashExp e2

hashExp :: ExprG a -> Integer
hashExp e = error "not defined yet"

ppExp :: ExprG a -> String
ppExp e = error "not defined yet"

certainExp :: ExprG a -> Bool
certainExp e = case e of
                 V _ -> False       --  if variables are used only for functions in Acc, we could return true here!
                 I _ -> True
                 R _ -> True
                 B _ -> True
                 Pair e1 e2 -> certainExp e1 && certainExp e2
                 Fst e -> certainExp e
                 Snd e -> certainExp e
                 Acc (v,e) i a -> certainExp e && certainExp a
                 Obs _ -> False
                 ChosenBy _ -> False
                 Not e1 -> certainExp e1
                 Arith _ e1 e2 -> certainExp e1 && certainExp e2
                 Less e1 e2 -> certainExp e1 && certainExp e2
                 Equal e1 e2 -> certainExp e1 && certainExp e2
                 Or e1 e2 -> certainExp e1 && certainExp e2

translExp :: ExprG a -> Int -> ExprG a
translExp e 0 = e
translExp e d = 
    case e of
      I _-> e
      R _ -> e
      B _ -> e
      V _ -> e
      Pair e1 e2 -> pair (translExp e1 d) (translExp e2 d)
      Fst e -> Fst (translExp e d)
      Snd e -> Snd (translExp e d)
      Acc (v,e) i a -> Acc (v, translExp e d) i (translExp a d)
      Obs (s,t) -> obs (s,t+d)
      ChosenBy (p,t) -> chosenBy (p,t+d)
      Not e -> Not (translExp e d)
      Arith op e1 e2 -> Arith op (translExp e1 d) (translExp e2 d)
      Less e1 e2 -> Less (translExp e1 d) (translExp e2 d)
      Equal e1 e2 -> Equal (translExp e1 d) (translExp e2 d)
      Or e1 e2 -> Or (translExp e1 d) (translExp e2 d)

--------------------------------------------------------------
-- Evaluation:
data EvalExc = Eval String deriving (Read,Show,Typeable)
instance Exception EvalExc

type Env = (String, Int) -> Maybe Double -- Hack: should use Bool for choice

emptyEnv :: Env
emptyEnv = \(s,i) -> if s == "Time" then Just (fromIntegral i) else Nothing

evalI :: Env -> IntE -> Int
evalR :: Env -> RealE -> Double
evalB :: Env -> BoolE -> Bool
evalI env e = case eval env e of {I n -> n; _ -> throw (Eval "evalI failed")} 
evalR env e = case eval env e of {R n -> n; _ -> throw (Eval "evalR failed")} 
evalB env e = case eval env e of {B n -> n; _ -> throw (Eval "evalB failed")} 

-- ExprG evaluator. Types checked statically, no checks required.
-- Assumes that the expr _can_ be evaluated, required fixings known
eval :: Env -> ExprG a -> ExprG a
eval env e = 
       case e of
         I _ -> e
         R _ -> e
         B _ -> e
         V s -> error ("missing variable env.")
         --
         Pair e1 e2 -> Pair (eval env e1) (eval env e2)
         Fst e -> Fst (eval env e)
         Snd e -> Snd (eval env e)
         --
         Obs u -> case env u of
                    Just r  -> R r
                    Nothing -> e
         ChosenBy (p,i) -> case env (p,i) of -- Hack: False is Double 0 in env.
                             Just r  -> B (r /= 0)
                             Nothing -> e
         --
         Acc (v,e) i a -> let a' = eval env a
                          in if i <= 0 then a
                              else if certainExp a'
                                   then error "missing variable env"
                                   -- eval (addV (v,eval env a') env) (Acc (v,translExp e 1) (i-1) e)
                                   else Acc (v,e) i a'
         --
         Not e' -> case eval env e' of
                     B b -> B (not b)
                     e'' -> Not e''
         Arith op e1 e2 -> arith op (eval env e1) (eval env e2)
         Less e1 e2 -> case (eval env e1, eval env e2) of
                          (I i1, I i2) -> B (i1 < i2)
                          (R r1, R r2) -> B (r1 < r2)
                          (ee1, ee2)   -> Less ee1 ee2
         Equal e1 e2 -> case (eval env e1, eval env e2) of
                          (I i1, I i2) -> B (i1 == i2)
                          (R r1, R r2) -> B (r1 == r2)
                          (B b1, B b2) -> B (b1 == b2)
                          (ee1, ee2)   -> Equal ee1 ee2
         Or e1 e2 -> case (eval env e1, eval env e2) of
                         (B b1, B b2) -> B (b1 || b2)
                         (B True, _ ) -> B True
                         (_, B True ) -> B True
                         (bb1, bb2)   -> Or bb1 bb2

simplifyExp env e = eval env e

module ContractExtracted where

import qualified Prelude

__ :: any
__ = Prelude.error "Logical or arity value used"

and_rect :: (() -> () -> a1) -> a1
and_rect f =
  f __ __

and_rec :: (() -> () -> a1) -> a1
and_rec f =
  and_rect f

eq_rect :: a1 -> a2 -> a1 -> a2
eq_rect x f y =
  f

eq_rec :: a1 -> a2 -> a1 -> a2
eq_rec x f y =
  eq_rect x f y

eq_rec_r :: a1 -> a2 -> a1 -> a2
eq_rec_r x h y =
  eq_rec x h y

data Comparison =
   Eq
 | Lt
 | Gt

compOpp :: Comparison -> Comparison
compOpp r =
  case r of {
   Eq -> Eq;
   Lt -> Gt;
   Gt -> Lt}

data CompareSpecT =
   CompEqT
 | CompLtT
 | CompGtT

compareSpec2Type :: Comparison -> CompareSpecT
compareSpec2Type c =
  case c of {
   Eq -> CompEqT;
   Lt -> CompLtT;
   Gt -> CompGtT}

type CompSpecT a = CompareSpecT

compSpec2Type :: a1 -> a1 -> Comparison -> CompSpecT a1
compSpec2Type x y c =
  compareSpec2Type c

type Sig a =
  a
  -- singleton inductive, whose constructor was exist
  
data Sumbool =
   Left
 | Right

sumbool_rect :: (() -> a1) -> (() -> a1) -> Sumbool -> a1
sumbool_rect f f0 s =
  case s of {
   Left -> f __;
   Right -> f0 __}

sumbool_rec :: (() -> a1) -> (() -> a1) -> Sumbool -> a1
sumbool_rec =
  sumbool_rect

data Sumor a =
   Inleft a
 | Inright

nat_iter :: Int -> (a1 -> a1) -> a1 -> a1
nat_iter n f x =
  (\fO fS n -> if n==0 then fO () else fS (n-1))
    (\_ ->
    x)
    (\n' ->
    f (nat_iter n' f x))
    n

positive_rect :: (Int -> a1 -> a1) -> (Int -> a1 -> a1) -> a1 -> Int -> a1
positive_rect f f0 f1 p =
  case p of {
   unused p0 -> f p0 (positive_rect f f0 f1 p0);
   unused p0 -> f0 p0 (positive_rect f f0 f1 p0);
   1 -> f1}

positive_rec :: (Int -> a1 -> a1) -> (Int -> a1 -> a1) -> a1 -> Int -> a1
positive_rec =
  positive_rect

data N =
   N0
 | Npos Int

n_rect :: a1 -> (Int -> a1) -> N -> a1
n_rect f f0 n =
  case n of {
   N0 -> f;
   Npos x -> f0 x}

n_rec :: a1 -> (Int -> a1) -> N -> a1
n_rec =
  n_rect

z_rect :: a1 -> (Int -> a1) -> (Int -> a1) -> Int -> a1
z_rect f f0 f1 z =
  case z of {
   0 -> f;
   id x -> f0 x;
   negate x -> f1 x}

z_rec :: a1 -> (Int -> a1) -> (Int -> a1) -> Int -> a1
z_rec =
  z_rect

data Reflect =
   ReflectT
 | ReflectF

iff_reflect :: Bool -> Reflect
iff_reflect b =
  case b of {
   True -> and_rec (\_ _ -> ReflectT);
   False -> and_rec (\_ _ -> ReflectF)}

type T = Int

succ :: Int -> Int
succ x =
  case x of {
   unused p -> unused (succ p);
   unused p -> unused p;
   1 -> unused 1}

add :: Int -> Int -> Int
add x y =
  case x of {
   unused p ->
    case y of {
     unused q -> unused (add_carry p q);
     unused q -> unused (add p q);
     1 -> unused (succ p)};
   unused p ->
    case y of {
     unused q -> unused (add p q);
     unused q -> unused (add p q);
     1 -> unused p};
   1 ->
    case y of {
     unused q -> unused (succ q);
     unused q -> unused q;
     1 -> unused 1}}

add_carry :: Int -> Int -> Int
add_carry x y =
  case x of {
   unused p ->
    case y of {
     unused q -> unused (add_carry p q);
     unused q -> unused (add_carry p q);
     1 -> unused (succ p)};
   unused p ->
    case y of {
     unused q -> unused (add_carry p q);
     unused q -> unused (add p q);
     1 -> unused (succ p)};
   1 ->
    case y of {
     unused q -> unused (succ q);
     unused q -> unused (succ q);
     1 -> unused 1}}

pred_double :: Int -> Int
pred_double x =
  case x of {
   unused p -> unused (unused p);
   unused p -> unused (pred_double p);
   1 -> 1}

pred :: Int -> Int
pred x =
  case x of {
   unused p -> unused p;
   unused p -> pred_double p;
   1 -> 1}

pred_N :: Int -> N
pred_N x =
  case x of {
   unused p -> Npos (unused p);
   unused p -> Npos (pred_double p);
   1 -> N0}

data Mask =
   IsNul
 | IsPos Int
 | IsNeg

mask_rect :: a1 -> (Int -> a1) -> a1 -> Mask -> a1
mask_rect f f0 f1 m =
  case m of {
   IsNul -> f;
   IsPos x -> f0 x;
   IsNeg -> f1}

mask_rec :: a1 -> (Int -> a1) -> a1 -> Mask -> a1
mask_rec =
  mask_rect

succ_double_mask :: Mask -> Mask
succ_double_mask x =
  case x of {
   IsNul -> IsPos 1;
   IsPos p -> IsPos (unused p);
   IsNeg -> IsNeg}

double_mask :: Mask -> Mask
double_mask x =
  case x of {
   IsPos p -> IsPos (unused p);
   x0 -> x0}

double_pred_mask :: Int -> Mask
double_pred_mask x =
  case x of {
   unused p -> IsPos (unused (unused p));
   unused p -> IsPos (unused (pred_double p));
   1 -> IsNul}

pred_mask :: Mask -> Mask
pred_mask p =
  case p of {
   IsPos q ->
    case q of {
     1 -> IsNul;
     _ -> IsPos (pred q)};
   _ -> IsNeg}

sub_mask :: Int -> Int -> Mask
sub_mask x y =
  case x of {
   unused p ->
    case y of {
     unused q -> double_mask (sub_mask p q);
     unused q -> succ_double_mask (sub_mask p q);
     1 -> IsPos (unused p)};
   unused p ->
    case y of {
     unused q -> succ_double_mask (sub_mask_carry p q);
     unused q -> double_mask (sub_mask p q);
     1 -> IsPos (pred_double p)};
   1 ->
    case y of {
     1 -> IsNul;
     _ -> IsNeg}}

sub_mask_carry :: Int -> Int -> Mask
sub_mask_carry x y =
  case x of {
   unused p ->
    case y of {
     unused q -> succ_double_mask (sub_mask_carry p q);
     unused q -> double_mask (sub_mask p q);
     1 -> IsPos (pred_double p)};
   unused p ->
    case y of {
     unused q -> double_mask (sub_mask_carry p q);
     unused q -> succ_double_mask (sub_mask_carry p q);
     1 -> double_pred_mask p};
   1 -> IsNeg}

sub :: Int -> Int -> Int
sub x y =
  case sub_mask x y of {
   IsPos z -> z;
   _ -> 1}

mul :: Int -> Int -> Int
mul x y =
  case x of {
   unused p -> add y (unused (mul p y));
   unused p -> unused (mul p y);
   1 -> y}

iter :: Int -> (a1 -> a1) -> a1 -> a1
iter n f x =
  case n of {
   unused n' -> f (iter n' f (iter n' f x));
   unused n' -> iter n' f (iter n' f x);
   1 -> f x}

pow :: Int -> Int -> Int
pow x y =
  iter y (mul x) 1

square :: Int -> Int
square p =
  case p of {
   unused p0 -> unused (unused (add (square p0) p0));
   unused p0 -> unused (unused (square p0));
   1 -> 1}

div2 :: Int -> Int
div2 p =
  case p of {
   unused p0 -> p0;
   unused p0 -> p0;
   1 -> 1}

div2_up :: Int -> Int
div2_up p =
  case p of {
   unused p0 -> succ p0;
   unused p0 -> p0;
   1 -> 1}

size_nat :: Int -> Int
size_nat p =
  case p of {
   unused p0 -> succ (size_nat p0);
   unused p0 -> succ (size_nat p0);
   1 -> succ 0}

size :: Int -> Int
size p =
  case p of {
   unused p0 -> succ (size p0);
   unused p0 -> succ (size p0);
   1 -> 1}

compare_cont :: Int -> Int -> Comparison -> Comparison
compare_cont x y r =
  case x of {
   unused p ->
    case y of {
     unused q -> compare_cont p q r;
     unused q -> compare_cont p q Gt;
     1 -> Gt};
   unused p ->
    case y of {
     unused q -> compare_cont p q Lt;
     unused q -> compare_cont p q r;
     1 -> Gt};
   1 ->
    case y of {
     1 -> r;
     _ -> Lt}}

compare :: Int -> Int -> Comparison
compare x y =
  compare_cont x y Eq

min :: Int -> Int -> Int
min p p' =
  case compare p p' of {
   Gt -> p';
   _ -> p}

max :: Int -> Int -> Int
max p p' =
  case compare p p' of {
   Gt -> p;
   _ -> p'}

eqb :: Int -> Int -> Bool
eqb p q =
  case p of {
   unused p0 ->
    case q of {
     unused q0 -> eqb p0 q0;
     _ -> False};
   unused p0 ->
    case q of {
     unused q0 -> eqb p0 q0;
     _ -> False};
   1 ->
    case q of {
     1 -> True;
     _ -> False}}

leb :: Int -> Int -> Bool
leb x y =
  case compare x y of {
   Gt -> False;
   _ -> True}

ltb :: Int -> Int -> Bool
ltb x y =
  case compare x y of {
   Lt -> True;
   _ -> False}

sqrtrem_step :: (Int -> Int) -> (Int -> Int) -> ((,) Int Mask) -> (,) 
                Int Mask
sqrtrem_step f g p =
  case p of {
   (,) s y ->
    case y of {
     IsPos r ->
      let {s' = unused (unused s)} in
      let {r' = g (f r)} in
      case leb s' r' of {
       True -> (,) (unused s) (sub_mask r' s');
       False -> (,) (unused s) (IsPos r')};
     _ -> (,) (unused s) (sub_mask (g (f 1)) (unused (unused 1)))}}

sqrtrem :: Int -> (,) Int Mask
sqrtrem p =
  case p of {
   unused p0 ->
    case p0 of {
     unused p1 -> sqrtrem_step (\x -> unused x) (\x -> unused x) (sqrtrem p1);
     unused p1 -> sqrtrem_step (\x -> unused x) (\x -> unused x) (sqrtrem p1);
     1 -> (,) 1 (IsPos (unused 1))};
   unused p0 ->
    case p0 of {
     unused p1 -> sqrtrem_step (\x -> unused x) (\x -> unused x) (sqrtrem p1);
     unused p1 -> sqrtrem_step (\x -> unused x) (\x -> unused x) (sqrtrem p1);
     1 -> (,) 1 (IsPos 1)};
   1 -> (,) 1 IsNul}

sqrt :: Int -> Int
sqrt p =
  fst (sqrtrem p)

gcdn :: Int -> Int -> Int -> Int
gcdn n a b =
  (\fO fS n -> if n==0 then fO () else fS (n-1))
    (\_ ->
    1)
    (\n0 ->
    case a of {
     unused a' ->
      case b of {
       unused b' ->
        case compare a' b' of {
         Eq -> a;
         Lt -> gcdn n0 (sub b' a') a;
         Gt -> gcdn n0 (sub a' b') b};
       unused b0 -> gcdn n0 a b0;
       1 -> 1};
     unused a0 ->
      case b of {
       unused p -> gcdn n0 a0 b;
       unused b0 -> unused (gcdn n0 a0 b0);
       1 -> 1};
     1 -> 1})
    n

gcd :: Int -> Int -> Int
gcd a b =
  gcdn ((+) (size_nat a) (size_nat b)) a b

ggcdn :: Int -> Int -> Int -> (,) Int ((,) Int Int)
ggcdn n a b =
  (\fO fS n -> if n==0 then fO () else fS (n-1))
    (\_ -> (,) 1 ((,) a
    b))
    (\n0 ->
    case a of {
     unused a' ->
      case b of {
       unused b' ->
        case compare a' b' of {
         Eq -> (,) a ((,) 1 1);
         Lt ->
          case ggcdn n0 (sub b' a') a of {
           (,) g p ->
            case p of {
             (,) ba aa -> (,) g ((,) aa (add aa (unused ba)))}};
         Gt ->
          case ggcdn n0 (sub a' b') b of {
           (,) g p ->
            case p of {
             (,) ab bb -> (,) g ((,) (add bb (unused ab)) bb)}}};
       unused b0 ->
        case ggcdn n0 a b0 of {
         (,) g p ->
          case p of {
           (,) aa bb -> (,) g ((,) aa (unused bb))}};
       1 -> (,) 1 ((,) a 1)};
     unused a0 ->
      case b of {
       unused p ->
        case ggcdn n0 a0 b of {
         (,) g p0 ->
          case p0 of {
           (,) aa bb -> (,) g ((,) (unused aa) bb)}};
       unused b0 ->
        case ggcdn n0 a0 b0 of {
         (,) g p -> (,) (unused g) p};
       1 -> (,) 1 ((,) a 1)};
     1 -> (,) 1 ((,) 1 b)})
    n

ggcd :: Int -> Int -> (,) Int ((,) Int Int)
ggcd a b =
  ggcdn ((+) (size_nat a) (size_nat b)) a b

nsucc_double :: N -> N
nsucc_double x =
  case x of {
   N0 -> Npos 1;
   Npos p -> Npos (unused p)}

ndouble :: N -> N
ndouble n =
  case n of {
   N0 -> N0;
   Npos p -> Npos (unused p)}

lor :: Int -> Int -> Int
lor p q =
  case p of {
   unused p0 ->
    case q of {
     unused q0 -> unused (lor p0 q0);
     unused q0 -> unused (lor p0 q0);
     1 -> p};
   unused p0 ->
    case q of {
     unused q0 -> unused (lor p0 q0);
     unused q0 -> unused (lor p0 q0);
     1 -> unused p0};
   1 ->
    case q of {
     unused q0 -> unused q0;
     _ -> q}}

land :: Int -> Int -> N
land p q =
  case p of {
   unused p0 ->
    case q of {
     unused q0 -> nsucc_double (land p0 q0);
     unused q0 -> ndouble (land p0 q0);
     1 -> Npos 1};
   unused p0 ->
    case q of {
     unused q0 -> ndouble (land p0 q0);
     unused q0 -> ndouble (land p0 q0);
     1 -> N0};
   1 ->
    case q of {
     unused q0 -> N0;
     _ -> Npos 1}}

ldiff :: Int -> Int -> N
ldiff p q =
  case p of {
   unused p0 ->
    case q of {
     unused q0 -> ndouble (ldiff p0 q0);
     unused q0 -> nsucc_double (ldiff p0 q0);
     1 -> Npos (unused p0)};
   unused p0 ->
    case q of {
     unused q0 -> ndouble (ldiff p0 q0);
     unused q0 -> ndouble (ldiff p0 q0);
     1 -> Npos p};
   1 ->
    case q of {
     unused q0 -> Npos 1;
     _ -> N0}}

lxor :: Int -> Int -> N
lxor p q =
  case p of {
   unused p0 ->
    case q of {
     unused q0 -> ndouble (lxor p0 q0);
     unused q0 -> nsucc_double (lxor p0 q0);
     1 -> Npos (unused p0)};
   unused p0 ->
    case q of {
     unused q0 -> nsucc_double (lxor p0 q0);
     unused q0 -> ndouble (lxor p0 q0);
     1 -> Npos (unused p0)};
   1 ->
    case q of {
     unused q0 -> Npos (unused q0);
     unused q0 -> Npos (unused q0);
     1 -> N0}}

shiftl_nat :: Int -> Int -> Int
shiftl_nat p n =
  nat_iter n (\x -> unused x) p

shiftr_nat :: Int -> Int -> Int
shiftr_nat p n =
  nat_iter n div2 p

shiftl :: Int -> N -> Int
shiftl p n =
  case n of {
   N0 -> p;
   Npos n0 -> iter n0 (\x -> unused x) p}

shiftr :: Int -> N -> Int
shiftr p n =
  case n of {
   N0 -> p;
   Npos n0 -> iter n0 div2 p}

testbit_nat :: Int -> Int -> Bool
testbit_nat p n =
  case p of {
   unused p0 ->
    (\fO fS n -> if n==0 then fO () else fS (n-1))
      (\_ ->
      True)
      (\n' ->
      testbit_nat p0 n')
      n;
   unused p0 ->
    (\fO fS n -> if n==0 then fO () else fS (n-1))
      (\_ ->
      False)
      (\n' ->
      testbit_nat p0 n')
      n;
   1 ->
    (\fO fS n -> if n==0 then fO () else fS (n-1))
      (\_ ->
      True)
      (\n0 ->
      False)
      n}

testbit :: Int -> N -> Bool
testbit p n =
  case p of {
   unused p0 ->
    case n of {
     N0 -> True;
     Npos n0 -> testbit p0 (pred_N n0)};
   unused p0 ->
    case n of {
     N0 -> False;
     Npos n0 -> testbit p0 (pred_N n0)};
   1 ->
    case n of {
     N0 -> True;
     Npos p0 -> False}}

iter_op :: (a1 -> a1 -> a1) -> Int -> a1 -> a1
iter_op op p a =
  case p of {
   unused p0 -> op a (iter_op op p0 (op a a));
   unused p0 -> iter_op op p0 (op a a);
   1 -> a}

to_nat :: Int -> Int
to_nat x =
  iter_op (+) x (succ 0)

of_nat :: Int -> Int
of_nat n =
  (\fO fS n -> if n==0 then fO () else fS (n-1))
    (\_ ->
    1)
    (\x ->
    (\fO fS n -> if n==0 then fO () else fS (n-1))
      (\_ ->
      1)
      (\n0 ->
      succ (of_nat x))
      x)
    n

of_succ_nat :: Int -> Int
of_succ_nat n =
  (\fO fS n -> if n==0 then fO () else fS (n-1))
    (\_ ->
    1)
    (\x ->
    succ (of_succ_nat x))
    n

eq_dec :: Int -> Int -> Sumbool
eq_dec x y =
  positive_rec (\p h y0 ->
    case y0 of {
     unused p0 -> sumbool_rec (\_ -> eq_rec_r p0 Left p) (\_ -> Right) (h p0);
     _ -> Right}) (\p h y0 ->
    case y0 of {
     unused p0 -> sumbool_rec (\_ -> eq_rec_r p0 Left p) (\_ -> Right) (h p0);
     _ -> Right}) (\y0 ->
    case y0 of {
     1 -> Left;
     _ -> Right}) x y

peano_rect :: a1 -> (Int -> a1 -> a1) -> Int -> a1
peano_rect a f p =
  let {
   f2 = peano_rect (f 1 a) (\p0 x -> f (succ (unused p0)) (f (unused p0) x))}
  in
  case p of {
   unused q -> f (unused q) (f2 q);
   unused q -> f2 q;
   1 -> a}

peano_rec :: a1 -> (Int -> a1 -> a1) -> Int -> a1
peano_rec =
  peano_rect

data PeanoView =
   PeanoOne
 | PeanoSucc Int PeanoView

peanoView_rect :: a1 -> (Int -> PeanoView -> a1 -> a1) -> Int -> PeanoView ->
                  a1
peanoView_rect f f0 p p0 =
  case p0 of {
   PeanoOne -> f;
   PeanoSucc p1 p2 -> f0 p1 p2 (peanoView_rect f f0 p1 p2)}

peanoView_rec :: a1 -> (Int -> PeanoView -> a1 -> a1) -> Int -> PeanoView ->
                 a1
peanoView_rec =
  peanoView_rect

peanoView_xO :: Int -> PeanoView -> PeanoView
peanoView_xO p q =
  case q of {
   PeanoOne -> PeanoSucc 1 PeanoOne;
   PeanoSucc p0 q0 -> PeanoSucc (succ (unused p0)) (PeanoSucc (unused p0)
    (peanoView_xO p0 q0))}

peanoView_xI :: Int -> PeanoView -> PeanoView
peanoView_xI p q =
  case q of {
   PeanoOne -> PeanoSucc (succ 1) (PeanoSucc 1 PeanoOne);
   PeanoSucc p0 q0 -> PeanoSucc (succ (unused p0)) (PeanoSucc (unused p0)
    (peanoView_xI p0 q0))}

peanoView :: Int -> PeanoView
peanoView p =
  case p of {
   unused p0 -> peanoView_xI p0 (peanoView p0);
   unused p0 -> peanoView_xO p0 (peanoView p0);
   1 -> PeanoOne}

peanoView_iter :: a1 -> (Int -> a1 -> a1) -> Int -> PeanoView -> a1
peanoView_iter a f p q =
  case q of {
   PeanoOne -> a;
   PeanoSucc p0 q0 -> f p0 (peanoView_iter a f p0 q0)}

eqb_spec :: Int -> Int -> Reflect
eqb_spec x y =
  iff_reflect (eqb x y)

switch_Eq :: Comparison -> Comparison -> Comparison
switch_Eq c c' =
  case c' of {
   Eq -> c;
   x -> x}

mask2cmp :: Mask -> Comparison
mask2cmp p =
  case p of {
   IsNul -> Eq;
   IsPos p0 -> Gt;
   IsNeg -> Lt}

leb_spec0 :: Int -> Int -> Reflect
leb_spec0 x y =
  iff_reflect (leb x y)

ltb_spec0 :: Int -> Int -> Reflect
ltb_spec0 x y =
  iff_reflect (ltb x y)

max_case_strong :: Int -> Int -> (Int -> Int -> () -> a1 -> a1) -> (() -> a1)
                   -> (() -> a1) -> a1
max_case_strong n m compat hl hr =
  let {c = compSpec2Type n m (compare n m)} in
  case c of {
   CompGtT -> compat n (max n m) __ (hl __);
   _ -> compat m (max n m) __ (hr __)}

max_case :: Int -> Int -> (Int -> Int -> () -> a1 -> a1) -> a1 -> a1 -> a1
max_case n m x x0 x1 =
  max_case_strong n m x (\_ -> x0) (\_ -> x1)

max_dec :: Int -> Int -> Sumbool
max_dec n m =
  max_case n m (\x y _ h0 -> h0) Left Right

min_case_strong :: Int -> Int -> (Int -> Int -> () -> a1 -> a1) -> (() -> a1)
                   -> (() -> a1) -> a1
min_case_strong n m compat hl hr =
  let {c = compSpec2Type n m (compare n m)} in
  case c of {
   CompGtT -> compat m (min n m) __ (hr __);
   _ -> compat n (min n m) __ (hl __)}

min_case :: Int -> Int -> (Int -> Int -> () -> a1 -> a1) -> a1 -> a1 -> a1
min_case n m x x0 x1 =
  min_case_strong n m x (\_ -> x0) (\_ -> x1)

min_dec :: Int -> Int -> Sumbool
min_dec n m =
  min_case n m (\x y _ h0 -> h0) Left Right

max_case_strong0 :: Int -> Int -> (() -> a1) -> (() -> a1) -> a1
max_case_strong0 n m x x0 =
  max_case_strong n m (\x1 y _ x2 -> eq_rect __ x2 __) x x0

max_case0 :: Int -> Int -> a1 -> a1 -> a1
max_case0 n m x x0 =
  max_case_strong0 n m (\_ -> x) (\_ -> x0)

max_dec0 :: Int -> Int -> Sumbool
max_dec0 =
  max_dec

min_case_strong0 :: Int -> Int -> (() -> a1) -> (() -> a1) -> a1
min_case_strong0 n m x x0 =
  min_case_strong n m (\x1 y _ x2 -> eq_rect __ x2 __) x x0

min_case0 :: Int -> Int -> a1 -> a1 -> a1
min_case0 n m x x0 =
  min_case_strong0 n m (\_ -> x) (\_ -> x0)

min_dec0 :: Int -> Int -> Sumbool
min_dec0 =
  min_dec

type T0 = N

zero :: N
zero =
  N0

one :: N
one =
  Npos 1

two :: N
two =
  Npos (unused 1)

succ_double :: N -> N
succ_double x =
  case x of {
   N0 -> Npos 1;
   Npos p -> Npos (unused p)}

double :: N -> N
double n =
  case n of {
   N0 -> N0;
   Npos p -> Npos (unused p)}

succ0 :: N -> N
succ0 n =
  case n of {
   N0 -> Npos 1;
   Npos p -> Npos (succ p)}

pred0 :: N -> N
pred0 n =
  case n of {
   N0 -> N0;
   Npos p -> pred_N p}

succ_pos :: N -> Int
succ_pos n =
  case n of {
   N0 -> 1;
   Npos p -> succ p}

add0 :: N -> N -> N
add0 n m =
  case n of {
   N0 -> m;
   Npos p ->
    case m of {
     N0 -> n;
     Npos q -> Npos (add p q)}}

sub0 :: N -> N -> N
sub0 n m =
  case n of {
   N0 -> N0;
   Npos n' ->
    case m of {
     N0 -> n;
     Npos m' ->
      case sub_mask n' m' of {
       IsPos p -> Npos p;
       _ -> N0}}}

mul0 :: N -> N -> N
mul0 n m =
  case n of {
   N0 -> N0;
   Npos p ->
    case m of {
     N0 -> N0;
     Npos q -> Npos (mul p q)}}

compare0 :: N -> N -> Comparison
compare0 n m =
  case n of {
   N0 ->
    case m of {
     N0 -> Eq;
     Npos m' -> Lt};
   Npos n' ->
    case m of {
     N0 -> Gt;
     Npos m' -> compare n' m'}}

eqb0 :: N -> N -> Bool
eqb0 n m =
  case n of {
   N0 ->
    case m of {
     N0 -> True;
     Npos p -> False};
   Npos p ->
    case m of {
     N0 -> False;
     Npos q -> eqb p q}}

leb0 :: N -> N -> Bool
leb0 x y =
  case compare0 x y of {
   Gt -> False;
   _ -> True}

ltb0 :: N -> N -> Bool
ltb0 x y =
  case compare0 x y of {
   Lt -> True;
   _ -> False}

min0 :: N -> N -> N
min0 n n' =
  case compare0 n n' of {
   Gt -> n';
   _ -> n}

max0 :: N -> N -> N
max0 n n' =
  case compare0 n n' of {
   Gt -> n;
   _ -> n'}

div0 :: N -> N
div0 n =
  case n of {
   N0 -> N0;
   Npos p0 ->
    case p0 of {
     unused p -> Npos p;
     unused p -> Npos p;
     1 -> N0}}

even :: N -> Bool
even n =
  case n of {
   N0 -> True;
   Npos p ->
    case p of {
     unused p0 -> True;
     _ -> False}}

odd :: N -> Bool
odd n =
  not (even n)

pow0 :: N -> N -> N
pow0 n p =
  case p of {
   N0 -> Npos 1;
   Npos p0 ->
    case n of {
     N0 -> N0;
     Npos q -> Npos (pow q p0)}}

square0 :: N -> N
square0 n =
  case n of {
   N0 -> N0;
   Npos p -> Npos (square p)}

log2 :: N -> N
log2 n =
  case n of {
   N0 -> N0;
   Npos p0 ->
    case p0 of {
     unused p -> Npos (size p);
     unused p -> Npos (size p);
     1 -> N0}}

size0 :: N -> N
size0 n =
  case n of {
   N0 -> N0;
   Npos p -> Npos (size p)}

size_nat0 :: N -> Int
size_nat0 n =
  case n of {
   N0 -> 0;
   Npos p -> size_nat p}

pos_div_eucl :: Int -> N -> (,) N N
pos_div_eucl a b =
  case a of {
   unused a' ->
    case pos_div_eucl a' b of {
     (,) q r ->
      let {r' = succ_double r} in
      case leb0 b r' of {
       True -> (,) (succ_double q) (sub0 r' b);
       False -> (,) (double q) r'}};
   unused a' ->
    case pos_div_eucl a' b of {
     (,) q r ->
      let {r' = double r} in
      case leb0 b r' of {
       True -> (,) (succ_double q) (sub0 r' b);
       False -> (,) (double q) r'}};
   1 ->
    case b of {
     N0 -> (,) N0 (Npos 1);
     Npos p ->
      case p of {
       1 -> (,) (Npos 1) N0;
       _ -> (,) N0 (Npos 1)}}}

div_eucl :: N -> N -> (,) N N
div_eucl a b =
  case a of {
   N0 -> (,) N0 N0;
   Npos na ->
    case b of {
     N0 -> (,) N0 a;
     Npos p -> pos_div_eucl na b}}

div :: N -> N -> N
div a b =
  fst (div_eucl a b)

modulo :: N -> N -> N
modulo a b =
  snd (div_eucl a b)

gcd0 :: N -> N -> N
gcd0 a b =
  case a of {
   N0 -> b;
   Npos p ->
    case b of {
     N0 -> a;
     Npos q -> Npos (gcd p q)}}

ggcd0 :: N -> N -> (,) N ((,) N N)
ggcd0 a b =
  case a of {
   N0 -> (,) b ((,) N0 (Npos 1));
   Npos p ->
    case b of {
     N0 -> (,) a ((,) (Npos 1) N0);
     Npos q ->
      case ggcd p q of {
       (,) g p0 ->
        case p0 of {
         (,) aa bb -> (,) (Npos g) ((,) (Npos aa) (Npos bb))}}}}

sqrtrem0 :: N -> (,) N N
sqrtrem0 n =
  case n of {
   N0 -> (,) N0 N0;
   Npos p ->
    case sqrtrem p of {
     (,) s m ->
      case m of {
       IsPos r -> (,) (Npos s) (Npos r);
       _ -> (,) (Npos s) N0}}}

sqrt0 :: N -> N
sqrt0 n =
  case n of {
   N0 -> N0;
   Npos p -> Npos (sqrt p)}

lor0 :: N -> N -> N
lor0 n m =
  case n of {
   N0 -> m;
   Npos p ->
    case m of {
     N0 -> n;
     Npos q -> Npos (lor p q)}}

land0 :: N -> N -> N
land0 n m =
  case n of {
   N0 -> N0;
   Npos p ->
    case m of {
     N0 -> N0;
     Npos q -> land p q}}

ldiff0 :: N -> N -> N
ldiff0 n m =
  case n of {
   N0 -> N0;
   Npos p ->
    case m of {
     N0 -> n;
     Npos q -> ldiff p q}}

lxor0 :: N -> N -> N
lxor0 n m =
  case n of {
   N0 -> m;
   Npos p ->
    case m of {
     N0 -> n;
     Npos q -> lxor p q}}

shiftl_nat0 :: N -> Int -> N
shiftl_nat0 a n =
  nat_iter n double a

shiftr_nat0 :: N -> Int -> N
shiftr_nat0 a n =
  nat_iter n div0 a

shiftl0 :: N -> N -> N
shiftl0 a n =
  case a of {
   N0 -> N0;
   Npos a0 -> Npos (shiftl a0 n)}

shiftr0 :: N -> N -> N
shiftr0 a n =
  case n of {
   N0 -> a;
   Npos p -> iter p div0 a}

testbit_nat0 :: N -> Int -> Bool
testbit_nat0 a =
  case a of {
   N0 -> (\x -> False);
   Npos p -> testbit_nat p}

testbit0 :: N -> N -> Bool
testbit0 a n =
  case a of {
   N0 -> False;
   Npos p -> testbit p n}

to_nat0 :: N -> Int
to_nat0 a =
  case a of {
   N0 -> 0;
   Npos p -> to_nat p}

of_nat0 :: Int -> N
of_nat0 n =
  (\fO fS n -> if n==0 then fO () else fS (n-1))
    (\_ ->
    N0)
    (\n' -> Npos
    (of_succ_nat n'))
    n

iter0 :: N -> (a1 -> a1) -> a1 -> a1
iter0 n f x =
  case n of {
   N0 -> x;
   Npos p -> iter p f x}

eq_dec0 :: N -> N -> Sumbool
eq_dec0 n m =
  n_rec (\m0 ->
    case m0 of {
     N0 -> Left;
     Npos p -> Right}) (\p m0 ->
    case m0 of {
     N0 -> Right;
     Npos p0 ->
      sumbool_rec (\_ -> eq_rec_r p0 Left p) (\_ -> Right) (eq_dec p p0)}) n
    m

discr :: N -> Sumor Int
discr n =
  case n of {
   N0 -> Inright;
   Npos p -> Inleft p}

binary_rect :: a1 -> (N -> a1 -> a1) -> (N -> a1 -> a1) -> N -> a1
binary_rect f0 f2 fS2 n =
  let {f2' = \p -> f2 (Npos p)} in
  let {fS2' = \p -> fS2 (Npos p)} in
  case n of {
   N0 -> f0;
   Npos p -> positive_rect fS2' f2' (fS2 N0 f0) p}

binary_rec :: a1 -> (N -> a1 -> a1) -> (N -> a1 -> a1) -> N -> a1
binary_rec =
  binary_rect

peano_rect0 :: a1 -> (N -> a1 -> a1) -> N -> a1
peano_rect0 f0 f n =
  let {f' = \p -> f (Npos p)} in
  case n of {
   N0 -> f0;
   Npos p -> peano_rect (f N0 f0) f' p}

peano_rec0 :: a1 -> (N -> a1 -> a1) -> N -> a1
peano_rec0 =
  peano_rect0

leb_spec1 :: N -> N -> Reflect
leb_spec1 x y =
  iff_reflect (leb0 x y)

ltb_spec1 :: N -> N -> Reflect
ltb_spec1 x y =
  iff_reflect (ltb0 x y)

recursion :: a1 -> (N -> a1 -> a1) -> N -> a1
recursion =
  peano_rect0

sqrt_up :: N -> N
sqrt_up a =
  case compare0 N0 a of {
   Lt -> succ0 (sqrt0 (pred0 a));
   _ -> N0}

log2_up :: N -> N
log2_up a =
  case compare0 (Npos 1) a of {
   Lt -> succ0 (log2 (pred0 a));
   _ -> N0}

lcm :: N -> N -> N
lcm a b =
  mul0 a (div b (gcd0 a b))

eqb_spec0 :: N -> N -> Reflect
eqb_spec0 x y =
  iff_reflect (eqb0 x y)

b2n :: Bool -> N
b2n b =
  case b of {
   True -> Npos 1;
   False -> N0}

setbit :: N -> N -> N
setbit a n =
  lor0 a (shiftl0 (Npos 1) n)

clearbit :: N -> N -> N
clearbit a n =
  ldiff0 a (shiftl0 (Npos 1) n)

ones :: N -> N
ones n =
  pred0 (shiftl0 (Npos 1) n)

lnot :: N -> N -> N
lnot a n =
  lxor0 a (ones n)

max_case_strong1 :: N -> N -> (N -> N -> () -> a1 -> a1) -> (() -> a1) -> (()
                    -> a1) -> a1
max_case_strong1 n m compat hl hr =
  let {c = compSpec2Type n m (compare0 n m)} in
  case c of {
   CompGtT -> compat n (max0 n m) __ (hl __);
   _ -> compat m (max0 n m) __ (hr __)}

max_case1 :: N -> N -> (N -> N -> () -> a1 -> a1) -> a1 -> a1 -> a1
max_case1 n m x x0 x1 =
  max_case_strong1 n m x (\_ -> x0) (\_ -> x1)

max_dec1 :: N -> N -> Sumbool
max_dec1 n m =
  max_case1 n m (\x y _ h0 -> h0) Left Right

min_case_strong1 :: N -> N -> (N -> N -> () -> a1 -> a1) -> (() -> a1) -> (()
                    -> a1) -> a1
min_case_strong1 n m compat hl hr =
  let {c = compSpec2Type n m (compare0 n m)} in
  case c of {
   CompGtT -> compat m (min0 n m) __ (hr __);
   _ -> compat n (min0 n m) __ (hl __)}

min_case1 :: N -> N -> (N -> N -> () -> a1 -> a1) -> a1 -> a1 -> a1
min_case1 n m x x0 x1 =
  min_case_strong1 n m x (\_ -> x0) (\_ -> x1)

min_dec1 :: N -> N -> Sumbool
min_dec1 n m =
  min_case1 n m (\x y _ h0 -> h0) Left Right

max_case_strong2 :: N -> N -> (() -> a1) -> (() -> a1) -> a1
max_case_strong2 n m x x0 =
  max_case_strong1 n m (\x1 y _ x2 -> eq_rect __ x2 __) x x0

max_case2 :: N -> N -> a1 -> a1 -> a1
max_case2 n m x x0 =
  max_case_strong2 n m (\_ -> x) (\_ -> x0)

max_dec2 :: N -> N -> Sumbool
max_dec2 =
  max_dec1

min_case_strong2 :: N -> N -> (() -> a1) -> (() -> a1) -> a1
min_case_strong2 n m x x0 =
  min_case_strong1 n m (\x1 y _ x2 -> eq_rect __ x2 __) x x0

min_case2 :: N -> N -> a1 -> a1 -> a1
min_case2 n m x x0 =
  min_case_strong2 n m (\_ -> x) (\_ -> x0)

min_dec2 :: N -> N -> Sumbool
min_dec2 =
  min_dec1

type T1 = Int

zero0 :: Int
zero0 =
  0

one0 :: Int
one0 =
  id 1

two0 :: Int
two0 =
  id (unused 1)

double0 :: Int -> Int
double0 x =
  case x of {
   0 -> 0;
   id p -> id (unused p);
   negate p -> negate (unused p)}

succ_double0 :: Int -> Int
succ_double0 x =
  case x of {
   0 -> id 1;
   id p -> id (unused p);
   negate p -> negate (pred_double p)}

pred_double0 :: Int -> Int
pred_double0 x =
  case x of {
   0 -> negate 1;
   id p -> id (pred_double p);
   negate p -> negate (unused p)}

pos_sub :: Int -> Int -> Int
pos_sub x y =
  case x of {
   unused p ->
    case y of {
     unused q -> double0 (pos_sub p q);
     unused q -> succ_double0 (pos_sub p q);
     1 -> id (unused p)};
   unused p ->
    case y of {
     unused q -> pred_double0 (pos_sub p q);
     unused q -> double0 (pos_sub p q);
     1 -> id (pred_double p)};
   1 ->
    case y of {
     unused q -> negate (unused q);
     unused q -> negate (pred_double q);
     1 -> 0}}

succ1 :: Int -> Int
succ1 x =
  (+) x (id 1)

pred1 :: Int -> Int
pred1 x =
  (+) x (negate 1)

pow_pos :: Int -> Int -> Int
pow_pos z n =
  iter n ((*) z) (id 1)

pow1 :: Int -> Int -> Int
pow1 x y =
  case y of {
   0 -> id 1;
   id p -> pow_pos x p;
   negate p -> 0}

square1 :: Int -> Int
square1 x =
  case x of {
   0 -> 0;
   id p -> id (square p);
   negate p -> id (square p)}

compare1 :: Int -> Int -> Comparison
compare1 x y =
  case x of {
   0 ->
    case y of {
     0 -> Eq;
     id y' -> Lt;
     negate y' -> Gt};
   id x' ->
    case y of {
     id y' -> compare x' y';
     _ -> Gt};
   negate x' ->
    case y of {
     negate y' -> compOpp (compare x' y');
     _ -> Lt}}

sgn :: Int -> Int
sgn z =
  case z of {
   0 -> 0;
   id p -> id 1;
   negate p -> negate 1}

geb :: Int -> Int -> Bool
geb x y =
  case compare1 x y of {
   Lt -> False;
   _ -> True}

gtb :: Int -> Int -> Bool
gtb x y =
  case compare1 x y of {
   Gt -> True;
   _ -> False}

max1 :: Int -> Int -> Int
max1 n m =
  case compare1 n m of {
   Lt -> m;
   _ -> n}

min1 :: Int -> Int -> Int
min1 n m =
  case compare1 n m of {
   Gt -> m;
   _ -> n}

abs :: Int -> Int
abs z =
  case z of {
   negate p -> id p;
   x -> x}

abs_nat :: Int -> Int
abs_nat z =
  case z of {
   0 -> 0;
   id p -> to_nat p;
   negate p -> to_nat p}

abs_N :: Int -> N
abs_N z =
  case z of {
   0 -> N0;
   id p -> Npos p;
   negate p -> Npos p}

to_N :: Int -> N
to_N z =
  case z of {
   id p -> Npos p;
   _ -> N0}

of_N :: N -> Int
of_N n =
  case n of {
   N0 -> 0;
   Npos p -> id p}

to_pos :: Int -> Int
to_pos z =
  case z of {
   id p -> p;
   _ -> 1}

iter1 :: Int -> (a1 -> a1) -> a1 -> a1
iter1 n f x =
  case n of {
   id p -> iter p f x;
   _ -> x}

pos_div_eucl0 :: Int -> Int -> (,) Int Int
pos_div_eucl0 a b =
  case a of {
   unused a' ->
    case pos_div_eucl0 a' b of {
     (,) q r ->
      let {r' = (+) ((*) (id (unused 1)) r) (id 1)} in
      case (<) r' b of {
       True -> (,) ((*) (id (unused 1)) q) r';
       False -> (,) ((+) ((*) (id (unused 1)) q) (id 1)) ((-) r' b)}};
   unused a' ->
    case pos_div_eucl0 a' b of {
     (,) q r ->
      let {r' = (*) (id (unused 1)) r} in
      case (<) r' b of {
       True -> (,) ((*) (id (unused 1)) q) r';
       False -> (,) ((+) ((*) (id (unused 1)) q) (id 1)) ((-) r' b)}};
   1 ->
    case (<=) (id (unused 1)) b of {
     True -> (,) 0 (id 1);
     False -> (,) (id 1) 0}}

div_eucl0 :: Int -> Int -> (,) Int Int
div_eucl0 a b =
  case a of {
   0 -> (,) 0 0;
   id a' ->
    case b of {
     0 -> (,) 0 0;
     id p -> pos_div_eucl0 a' b;
     negate b' ->
      case pos_div_eucl0 a' (id b') of {
       (,) q r ->
        case r of {
         0 -> (,) (negate q) 0;
         _ -> (,) (negate ((+) q (id 1))) ((+) b r)}}};
   negate a' ->
    case b of {
     0 -> (,) 0 0;
     id p ->
      case pos_div_eucl0 a' b of {
       (,) q r ->
        case r of {
         0 -> (,) (negate q) 0;
         _ -> (,) (negate ((+) q (id 1))) ((-) b r)}};
     negate b' ->
      case pos_div_eucl0 a' (id b') of {
       (,) q r -> (,) q (negate r)}}}

div1 :: Int -> Int -> Int
div1 a b =
  case div_eucl0 a b of {
   (,) q x -> q}

modulo0 :: Int -> Int -> Int
modulo0 a b =
  case div_eucl0 a b of {
   (,) x r -> r}

quotrem :: Int -> Int -> (,) Int Int
quotrem a b =
  case a of {
   0 -> (,) 0 0;
   id a0 ->
    case b of {
     0 -> (,) 0 a;
     id b0 ->
      case pos_div_eucl a0 (Npos b0) of {
       (,) q r -> (,) (of_N q) (of_N r)};
     negate b0 ->
      case pos_div_eucl a0 (Npos b0) of {
       (,) q r -> (,) (negate (of_N q)) (of_N r)}};
   negate a0 ->
    case b of {
     0 -> (,) 0 a;
     id b0 ->
      case pos_div_eucl a0 (Npos b0) of {
       (,) q r -> (,) (negate (of_N q)) (negate (of_N r))};
     negate b0 ->
      case pos_div_eucl a0 (Npos b0) of {
       (,) q r -> (,) (of_N q) (negate (of_N r))}}}

quot :: Int -> Int -> Int
quot a b =
  fst (quotrem a b)

rem :: Int -> Int -> Int
rem a b =
  snd (quotrem a b)

even0 :: Int -> Bool
even0 z =
  case z of {
   0 -> True;
   id p ->
    case p of {
     unused p0 -> True;
     _ -> False};
   negate p ->
    case p of {
     unused p0 -> True;
     _ -> False}}

odd0 :: Int -> Bool
odd0 z =
  case z of {
   0 -> False;
   id p ->
    case p of {
     unused p0 -> False;
     _ -> True};
   negate p ->
    case p of {
     unused p0 -> False;
     _ -> True}}

div3 :: Int -> Int
div3 z =
  case z of {
   0 -> 0;
   id p ->
    case p of {
     1 -> 0;
     _ -> id (div2 p)};
   negate p -> negate (div2_up p)}

quot2 :: Int -> Int
quot2 z =
  case z of {
   0 -> 0;
   id p ->
    case p of {
     1 -> 0;
     _ -> id (div2 p)};
   negate p ->
    case p of {
     1 -> 0;
     _ -> negate (div2 p)}}

log0 :: Int -> Int
log0 z =
  case z of {
   id p0 ->
    case p0 of {
     unused p -> id (size p);
     unused p -> id (size p);
     1 -> 0};
   _ -> 0}

sqrtrem1 :: Int -> (,) Int Int
sqrtrem1 n =
  case n of {
   id p ->
    case sqrtrem p of {
     (,) s m ->
      case m of {
       IsPos r -> (,) (id s) (id r);
       _ -> (,) (id s) 0}};
   _ -> (,) 0 0}

sqrt1 :: Int -> Int
sqrt1 n =
  case n of {
   id p -> id (sqrt p);
   _ -> 0}

gcd1 :: Int -> Int -> Int
gcd1 a b =
  case a of {
   0 -> abs b;
   id a0 ->
    case b of {
     0 -> abs a;
     id b0 -> id (gcd a0 b0);
     negate b0 -> id (gcd a0 b0)};
   negate a0 ->
    case b of {
     0 -> abs a;
     id b0 -> id (gcd a0 b0);
     negate b0 -> id (gcd a0 b0)}}

ggcd1 :: Int -> Int -> (,) Int ((,) Int Int)
ggcd1 a b =
  case a of {
   0 -> (,) (abs b) ((,) 0 (sgn b));
   id a0 ->
    case b of {
     0 -> (,) (abs a) ((,) (sgn a) 0);
     id b0 ->
      case ggcd a0 b0 of {
       (,) g p ->
        case p of {
         (,) aa bb -> (,) (id g) ((,) (id aa) (id bb))}};
     negate b0 ->
      case ggcd a0 b0 of {
       (,) g p ->
        case p of {
         (,) aa bb -> (,) (id g) ((,) (id aa) (negate bb))}}};
   negate a0 ->
    case b of {
     0 -> (,) (abs a) ((,) (sgn a) 0);
     id b0 ->
      case ggcd a0 b0 of {
       (,) g p ->
        case p of {
         (,) aa bb -> (,) (id g) ((,) (negate aa) (id bb))}};
     negate b0 ->
      case ggcd a0 b0 of {
       (,) g p ->
        case p of {
         (,) aa bb -> (,) (id g) ((,) (negate aa) (negate bb))}}}}

testbit1 :: Int -> Int -> Bool
testbit1 a n =
  case n of {
   0 -> odd0 a;
   id p ->
    case a of {
     0 -> False;
     id a0 -> testbit a0 (Npos p);
     negate a0 -> not (testbit0 (pred_N a0) (Npos p))};
   negate p -> False}

shiftl1 :: Int -> Int -> Int
shiftl1 a n =
  case n of {
   0 -> a;
   id p -> iter p ((*) (id (unused 1))) a;
   negate p -> iter p div3 a}

shiftr1 :: Int -> Int -> Int
shiftr1 a n =
  shiftl1 a (negate n)

lor1 :: Int -> Int -> Int
lor1 a b =
  case a of {
   0 -> b;
   id a0 ->
    case b of {
     0 -> a;
     id b0 -> id (lor a0 b0);
     negate b0 -> negate (succ_pos (ldiff0 (pred_N b0) (Npos a0)))};
   negate a0 ->
    case b of {
     0 -> a;
     id b0 -> negate (succ_pos (ldiff0 (pred_N a0) (Npos b0)));
     negate b0 -> negate (succ_pos (land0 (pred_N a0) (pred_N b0)))}}

land1 :: Int -> Int -> Int
land1 a b =
  case a of {
   0 -> 0;
   id a0 ->
    case b of {
     0 -> 0;
     id b0 -> of_N (land a0 b0);
     negate b0 -> of_N (ldiff0 (Npos a0) (pred_N b0))};
   negate a0 ->
    case b of {
     0 -> 0;
     id b0 -> of_N (ldiff0 (Npos b0) (pred_N a0));
     negate b0 -> negate (succ_pos (lor0 (pred_N a0) (pred_N b0)))}}

ldiff1 :: Int -> Int -> Int
ldiff1 a b =
  case a of {
   0 -> 0;
   id a0 ->
    case b of {
     0 -> a;
     id b0 -> of_N (ldiff a0 b0);
     negate b0 -> of_N (land0 (Npos a0) (pred_N b0))};
   negate a0 ->
    case b of {
     0 -> a;
     id b0 -> negate (succ_pos (lor0 (pred_N a0) (Npos b0)));
     negate b0 -> of_N (ldiff0 (pred_N b0) (pred_N a0))}}

lxor1 :: Int -> Int -> Int
lxor1 a b =
  case a of {
   0 -> b;
   id a0 ->
    case b of {
     0 -> a;
     id b0 -> of_N (lxor a0 b0);
     negate b0 -> negate (succ_pos (lxor0 (Npos a0) (pred_N b0)))};
   negate a0 ->
    case b of {
     0 -> a;
     id b0 -> negate (succ_pos (lxor0 (pred_N a0) (Npos b0)));
     negate b0 -> of_N (lxor0 (pred_N a0) (pred_N b0))}}

eq_dec1 :: Int -> Int -> Sumbool
eq_dec1 x y =
  z_rec (\y0 ->
    case y0 of {
     0 -> Left;
     _ -> Right}) (\p y0 ->
    case y0 of {
     id p0 ->
      sumbool_rec (\_ -> eq_rec_r p0 Left p) (\_ -> Right) (eq_dec p p0);
     _ -> Right}) (\p y0 ->
    case y0 of {
     negate p0 ->
      sumbool_rec (\_ -> eq_rec_r p0 Left p) (\_ -> Right) (eq_dec p p0);
     _ -> Right}) x y

leb_spec2 :: Int -> Int -> Reflect
leb_spec2 x y =
  iff_reflect ((<=) x y)

ltb_spec2 :: Int -> Int -> Reflect
ltb_spec2 x y =
  iff_reflect ((<) x y)

sqrt_up0 :: Int -> Int
sqrt_up0 a =
  case compare1 0 a of {
   Lt -> succ1 (sqrt1 (pred1 a));
   _ -> 0}

log2_up0 :: Int -> Int
log2_up0 a =
  case compare1 (id 1) a of {
   Lt -> succ1 (log0 (pred1 a));
   _ -> 0}

div4 :: Int -> Int -> Int
div4 =
  quot

modulo1 :: Int -> Int -> Int
modulo1 =
  rem

lcm0 :: Int -> Int -> Int
lcm0 a b =
  abs ((*) a (div1 b (gcd1 a b)))

eqb_spec1 :: Int -> Int -> Reflect
eqb_spec1 x y =
  iff_reflect ((==) x y)

b2z :: Bool -> Int
b2z b =
  case b of {
   True -> id 1;
   False -> 0}

setbit0 :: Int -> Int -> Int
setbit0 a n =
  lor1 a (shiftl1 (id 1) n)

clearbit0 :: Int -> Int -> Int
clearbit0 a n =
  ldiff1 a (shiftl1 (id 1) n)

lnot0 :: Int -> Int
lnot0 a =
  pred1 (negate a)

ones0 :: Int -> Int
ones0 n =
  pred1 (shiftl1 (id 1) n)

max_case_strong3 :: Int -> Int -> (Int -> Int -> () -> a1 -> a1) -> (() ->
                    a1) -> (() -> a1) -> a1
max_case_strong3 n m compat hl hr =
  let {c = compSpec2Type n m (compare1 n m)} in
  case c of {
   CompGtT -> compat n (max1 n m) __ (hl __);
   _ -> compat m (max1 n m) __ (hr __)}

max_case3 :: Int -> Int -> (Int -> Int -> () -> a1 -> a1) -> a1 -> a1 -> a1
max_case3 n m x x0 x1 =
  max_case_strong3 n m x (\_ -> x0) (\_ -> x1)

max_dec3 :: Int -> Int -> Sumbool
max_dec3 n m =
  max_case3 n m (\x y _ h0 -> h0) Left Right

min_case_strong3 :: Int -> Int -> (Int -> Int -> () -> a1 -> a1) -> (() ->
                    a1) -> (() -> a1) -> a1
min_case_strong3 n m compat hl hr =
  let {c = compSpec2Type n m (compare1 n m)} in
  case c of {
   CompGtT -> compat m (min1 n m) __ (hr __);
   _ -> compat n (min1 n m) __ (hl __)}

min_case3 :: Int -> Int -> (Int -> Int -> () -> a1 -> a1) -> a1 -> a1 -> a1
min_case3 n m x x0 x1 =
  min_case_strong3 n m x (\_ -> x0) (\_ -> x1)

min_dec3 :: Int -> Int -> Sumbool
min_dec3 n m =
  min_case3 n m (\x y _ h0 -> h0) Left Right

max_case_strong4 :: Int -> Int -> (() -> a1) -> (() -> a1) -> a1
max_case_strong4 n m x x0 =
  max_case_strong3 n m (\x1 y _ x2 -> eq_rect __ x2 __) x x0

max_case4 :: Int -> Int -> a1 -> a1 -> a1
max_case4 n m x x0 =
  max_case_strong4 n m (\_ -> x) (\_ -> x0)

max_dec4 :: Int -> Int -> Sumbool
max_dec4 =
  max_dec3

min_case_strong4 :: Int -> Int -> (() -> a1) -> (() -> a1) -> a1
min_case_strong4 n m x x0 =
  min_case_strong3 n m (\x1 y _ x2 -> eq_rect __ x2 __) x x0

min_case4 :: Int -> Int -> a1 -> a1 -> a1
min_case4 n m x x0 =
  min_case_strong4 n m (\_ -> x) (\_ -> x0)

min_dec4 :: Int -> Int -> Sumbool
min_dec4 =
  min_dec3

type Currency = String

type Party = String

data Var =
   V1
 | VS Var

data ObsLabel =
   LabR String
 | LabB String

data Val =
   BVal Bool
 | RVal Double

data Op =
   Add
 | Sub
 | Mult
 | Div
 | And
 | Or
 | Less
 | Leq
 | Equal
 | Not
 | Neg
 | BLit Bool
 | RLit Double
 | Cond

data Exp =
   OpE Op (List Exp)
 | Obs ObsLabel Int
 | VarE Var
 | Acc Exp Int Exp

data Contr =
   Zero
 | Transfer Party Party Currency
 | Scale Exp Contr
 | Translate Int Contr
 | Both Contr Contr
 | If Exp Int Contr Contr

translate :: Int -> Contr -> Contr
translate l x =
  (\fO fS n -> if n==0 then fO () else fS (n-1))
    (\_ ->
    x)
    (\n -> Translate l
    x)
    l

type ExtEnv = ObsLabel -> Int -> Maybe Val

adv_ext :: Int -> ExtEnv -> ExtEnv
adv_ext d e l x =
  e l ((+) d x)

reqb :: Double -> Double -> Bool
reqb x y =
  (&&) ((<=) x y) ((<=) y x)

bind :: (Maybe a1) -> (a1 -> Maybe a2) -> Maybe a2
bind x f =
  case x of {
   Just x' -> f x';
   Nothing -> Nothing}

pure :: a1 -> Maybe a1
pure x =
  Just x

liftM :: (a1 -> a2) -> (Maybe a1) -> Maybe a2
liftM f x =
  bind x ((.) pure f)

liftM2 :: (a1 -> a2 -> a3) -> (Maybe a1) -> (Maybe a2) -> Maybe a3
liftM2 f x y =
  bind x (\x' -> bind y ((.) pure (f x')))

acc_sem :: (Int -> a1 -> a1) -> Int -> a1 -> a1
acc_sem f n z =
  (\fO fS n -> if n==0 then fO () else fS (n-1))
    (\_ ->
    z)
    (\n' ->
    f n (acc_sem f n' z))
    n

opSem :: Op -> (List Val) -> Maybe Val
opSem op vs =
  case op of {
   Add ->
    case vs of {
     [] -> Nothing;
     (:) v l ->
      case v of {
       BVal b -> Nothing;
       RVal x ->
        case l of {
         [] -> Nothing;
         (:) v0 l0 ->
          case v0 of {
           BVal b -> Nothing;
           RVal y ->
            case l0 of {
             [] -> Just (RVal ((+) x y));
             (:) v1 l1 -> Nothing}}}}};
   Sub ->
    case vs of {
     [] -> Nothing;
     (:) v l ->
      case v of {
       BVal b -> Nothing;
       RVal x ->
        case l of {
         [] -> Nothing;
         (:) v0 l0 ->
          case v0 of {
           BVal b -> Nothing;
           RVal y ->
            case l0 of {
             [] -> Just (RVal ((-) x y));
             (:) v1 l1 -> Nothing}}}}};
   Mult ->
    case vs of {
     [] -> Nothing;
     (:) v l ->
      case v of {
       BVal b -> Nothing;
       RVal x ->
        case l of {
         [] -> Nothing;
         (:) v0 l0 ->
          case v0 of {
           BVal b -> Nothing;
           RVal y ->
            case l0 of {
             [] -> Just (RVal ((*) x y));
             (:) v1 l1 -> Nothing}}}}};
   Div ->
    case vs of {
     [] -> Nothing;
     (:) v l ->
      case v of {
       BVal b -> Nothing;
       RVal x ->
        case l of {
         [] -> Nothing;
         (:) v0 l0 ->
          case v0 of {
           BVal b -> Nothing;
           RVal y ->
            case l0 of {
             [] -> Just (RVal ((/) x y));
             (:) v1 l1 -> Nothing}}}}};
   And ->
    case vs of {
     [] -> Nothing;
     (:) v l ->
      case v of {
       BVal x ->
        case l of {
         [] -> Nothing;
         (:) v0 l0 ->
          case v0 of {
           BVal y ->
            case l0 of {
             [] -> Just (BVal ((&&) x y));
             (:) v1 l1 -> Nothing};
           RVal r -> Nothing}};
       RVal r -> Nothing}};
   Or ->
    case vs of {
     [] -> Nothing;
     (:) v l ->
      case v of {
       BVal x ->
        case l of {
         [] -> Nothing;
         (:) v0 l0 ->
          case v0 of {
           BVal y ->
            case l0 of {
             [] -> Just (BVal ((||) x y));
             (:) v1 l1 -> Nothing};
           RVal r -> Nothing}};
       RVal r -> Nothing}};
   Less ->
    case vs of {
     [] -> Nothing;
     (:) v l ->
      case v of {
       BVal b -> Nothing;
       RVal x ->
        case l of {
         [] -> Nothing;
         (:) v0 l0 ->
          case v0 of {
           BVal b -> Nothing;
           RVal y ->
            case l0 of {
             [] -> Just (BVal ((<) x y));
             (:) v1 l1 -> Nothing}}}}};
   Leq ->
    case vs of {
     [] -> Nothing;
     (:) v l ->
      case v of {
       BVal b -> Nothing;
       RVal x ->
        case l of {
         [] -> Nothing;
         (:) v0 l0 ->
          case v0 of {
           BVal b -> Nothing;
           RVal y ->
            case l0 of {
             [] -> Just (BVal ((<=) x y));
             (:) v1 l1 -> Nothing}}}}};
   Equal ->
    case vs of {
     [] -> Nothing;
     (:) v l ->
      case v of {
       BVal b -> Nothing;
       RVal x ->
        case l of {
         [] -> Nothing;
         (:) v0 l0 ->
          case v0 of {
           BVal b -> Nothing;
           RVal y ->
            case l0 of {
             [] -> Just (BVal (reqb x y));
             (:) v1 l1 -> Nothing}}}}};
   Not ->
    case vs of {
     [] -> Nothing;
     (:) v l ->
      case v of {
       BVal x ->
        case l of {
         [] -> Just (BVal (not x));
         (:) v0 l0 -> Nothing};
       RVal r -> Nothing}};
   Neg ->
    case vs of {
     [] -> Nothing;
     (:) v l ->
      case v of {
       BVal b -> Nothing;
       RVal x ->
        case l of {
         [] -> Just (RVal ((-) 0 x));
         (:) v0 l0 -> Nothing}}};
   BLit b ->
    case vs of {
     [] -> Just (BVal b);
     (:) v l -> Nothing};
   RLit r ->
    case vs of {
     [] -> Just (RVal r);
     (:) v l -> Nothing};
   Cond ->
    case vs of {
     [] -> Nothing;
     (:) v l ->
      case v of {
       BVal b ->
        case l of {
         [] -> Nothing;
         (:) v0 l0 ->
          case v0 of {
           BVal x ->
            case l0 of {
             [] -> Nothing;
             (:) v1 l1 ->
              case v1 of {
               BVal y ->
                case l1 of {
                 [] -> Just (BVal
                  (case b of {
                    True -> x;
                    False -> y}));
                 (:) v2 l2 -> Nothing};
               RVal r -> Nothing}};
           RVal x ->
            case l0 of {
             [] -> Nothing;
             (:) v1 l1 ->
              case v1 of {
               BVal b0 -> Nothing;
               RVal y ->
                case l1 of {
                 [] -> Just (RVal
                  (case b of {
                    True -> x;
                    False -> y}));
                 (:) v2 l2 -> Nothing}}}}};
       RVal r -> Nothing}}}

type Env = List (Maybe Val)

lookupEnv :: Var -> Env -> Maybe Val
lookupEnv v rho =
  case v of {
   V1 ->
    case rho of {
     [] -> Nothing;
     (:) x l -> x};
   VS v0 ->
    case rho of {
     [] -> Nothing;
     (:) o xs -> lookupEnv v0 xs}}

esem' :: Exp -> Env -> ExtEnv -> Maybe Val
esem' e rho erho =
  case e of {
   OpE op args ->
    let {
     run = let {
            run l =
              case l of {
               [] -> Just [];
               (:) x xs ->
                liftM2 (\x0 x1 -> (:) x0 x1) (esem' x rho erho) (run xs)}}
           in run}
    in
    bind (run args) (opSem op);
   Obs l i -> erho l i;
   VarE v -> lookupEnv v rho;
   Acc f l z ->
    let {erho' = adv_ext (negate (id l)) erho} in
    acc_sem (\m x -> esem' f ((:) x rho) (adv_ext (id m) erho')) l
      (esem' z rho erho')}

type Trans = Party -> Party -> Currency -> Double

empty_trans' :: Trans
empty_trans' p1 p2 c =
  0

singleton_trans' :: Party -> Party -> Currency -> Double -> Trans
singleton_trans' p1 p2 c r p1' p2' c' =
  case (==) p1 p2 of {
   True -> 0;
   False ->
    case (&&) ((&&) ((==) p1 p1') ((==) p2 p2')) ((==) c c') of {
     True -> r;
     False ->
      case (&&) ((&&) ((==) p1 p2') ((==) p2 p1')) ((==) c c') of {
       True -> negate r;
       False -> 0}}}

add_trans' :: Trans -> Trans -> Trans
add_trans' t1 t2 p1 p2 c =
  (+) (t1 p1 p2 c) (t2 p1 p2 c)

scale_trans' :: Double -> Trans -> Trans
scale_trans' s t p1 p2 c =
  (*) (t p1 p2 c) s

adv_exp :: Int -> Exp -> Exp
adv_exp d e =
  case e of {
   OpE op args -> OpE op (map (adv_exp d) args);
   Obs l i -> Obs l ((+) d i);
   VarE a -> VarE a;
   Acc f n z -> Acc (adv_exp d f) n (adv_exp d z)}

redFun :: Contr -> ExtEnv -> Maybe ((,) Contr Trans)
redFun c rho =
  case c of {
   Zero -> Just ((,) Zero empty_trans');
   Transfer c0 p1 p2 -> Just ((,) Zero (singleton_trans' c0 p1 p2 1));
   Scale e c0 ->
    case redFun c0 rho of {
     Just p ->
      case p of {
       (,) c' t ->
        case esem' e [] rho of {
         Just v0 ->
          case v0 of {
           BVal b -> Nothing;
           RVal v -> Just ((,) (Scale (adv_exp (negate 1) e) c')
            (scale_trans' v t))};
         Nothing -> Nothing}};
     Nothing -> Nothing};
   Translate l c0 ->
    (\fO fS n -> if n==0 then fO () else fS (n-1))
      (\_ ->
      redFun c0 rho)
      (\l' -> Just ((,) (Translate l' c0)
      empty_trans'))
      l;
   Both c1 c2 ->
    case redFun c1 rho of {
     Just p ->
      case p of {
       (,) c1' t1 ->
        case redFun c2 rho of {
         Just p0 ->
          case p0 of {
           (,) c2' t2 -> Just ((,) (Both c1' c2') (add_trans' t1 t2))};
         Nothing -> Nothing}};
     Nothing -> Nothing};
   If b l c1 c2 ->
    case esem' b [] rho of {
     Just v ->
      case v of {
       BVal b0 ->
        case b0 of {
         True -> redFun c1 rho;
         False ->
          (\fO fS n -> if n==0 then fO () else fS (n-1))
            (\_ ->
            redFun c2 rho)
            (\l' -> Just ((,) (If b l' c1 c2)
            empty_trans'))
            l};
       RVal r -> Nothing};
     Nothing -> Nothing}}

plus0 :: Int -> Int -> Int
plus0 n m =
  (\fO fS n -> if n==0 then fO () else fS (n-1))
    (\_ ->
    0)
    (\n0 ->
    (+) n m)
    m

horizon :: Contr -> Int
horizon c =
  case c of {
   Zero -> 0;
   Transfer p p0 c0 -> succ 0;
   Scale e c' -> horizon c';
   Translate l c' -> plus0 l (horizon c');
   Both c1 c2 -> max (horizon c1) (horizon c2);
   If e l c1 c2 -> plus0 l (max (horizon c1) (horizon c2))}

constFoldAcc :: ExtEnv -> (ExtEnv -> (Maybe Val) -> Exp) -> Int -> (ExtEnv ->
                Exp) -> Either Exp ((,) Int Exp)
constFoldAcc rho f l z =
  (\fO fS n -> if n==0 then fO () else fS (n-1))
    (\_ -> Left
    (z rho))
    (\l' ->
    case constFoldAcc (adv_ext (negate 1) rho) f l' z of {
     Left e ->
      case e of {
       OpE op args ->
        case op of {
         BLit b ->
          case args of {
           [] -> Left (f rho (Just (BVal b)));
           (:) e0 l0 -> Right ((,) 0 e)};
         RLit r ->
          case args of {
           [] -> Left (f rho (Just (RVal r)));
           (:) e0 l0 -> Right ((,) 0 e)};
         _ -> Right ((,) 0 e)};
       _ -> Right ((,) 0 e)};
     Right p ->
      case p of {
       (,) n e -> Right ((,) (succ n) e)}})
    l

fromLit :: Exp -> Maybe Val
fromLit e =
  case e of {
   OpE op args ->
    case op of {
     BLit b ->
      case args of {
       [] -> Just (BVal b);
       (:) e0 l -> Nothing};
     RLit r ->
      case args of {
       [] -> Just (RVal r);
       (:) e0 l -> Nothing};
     _ -> Nothing};
   _ -> Nothing}

toLit :: Val -> Exp
toLit e =
  case e of {
   BVal b -> OpE (BLit b) [];
   RVal r -> OpE (RLit r) []}

default0 :: a1 -> (Maybe a1) -> a1
default0 d x =
  case x of {
   Just y -> y;
   Nothing -> d}

specialiseExp :: Exp -> ExtEnv -> Env -> Exp
specialiseExp e rho vars =
  case e of {
   OpE op args ->
    case args of {
     [] ->
      let {
       run = let {
              run es =
                case es of {
                 [] -> Just [];
                 (:) e' es' ->
                  liftM2 (\x x0 -> (:) x x0)
                    (fromLit (specialiseExp e' rho vars)) (run es')}}
             in run}
      in
      default0 e (liftM toLit (bind (run args) (opSem op)));
     (:) e1 l ->
      case l of {
       [] ->
        let {
         run = let {
                run es =
                  case es of {
                   [] -> Just [];
                   (:) e' es' ->
                    liftM2 (\x x0 -> (:) x x0)
                      (fromLit (specialiseExp e' rho vars)) (run es')}}
               in run}
        in
        default0 e (liftM toLit (bind (run args) (opSem op)));
       (:) e2 l0 ->
        case l0 of {
         [] ->
          let {
           run = let {
                  run es =
                    case es of {
                     [] -> Just [];
                     (:) e' es' ->
                      liftM2 (\x x0 -> (:) x x0)
                        (fromLit (specialiseExp e' rho vars)) (run es')}}
                 in run}
          in
          default0 e (liftM toLit (bind (run args) (opSem op)));
         (:) e3 l1 ->
          case l1 of {
           [] ->
            case fromLit (specialiseExp e1 rho vars) of {
             Just v ->
              case v of {
               BVal b ->
                case b of {
                 True -> specialiseExp e2 rho vars;
                 False -> specialiseExp e3 rho vars};
               RVal r -> e};
             Nothing -> e};
           (:) e0 l2 ->
            let {
             run = let {
                    run es =
                      case es of {
                       [] -> Just [];
                       (:) e' es' ->
                        liftM2 (\x x0 -> (:) x x0)
                          (fromLit (specialiseExp e' rho vars)) (run es')}}
                   in run}
            in
            default0 e (liftM toLit (bind (run args) (opSem op)))}}}};
   Obs obs t -> default0 e (liftM toLit (rho obs t));
   VarE v -> default0 e (liftM toLit (lookupEnv v vars));
   Acc f l z ->
    let {z' = \rho0 -> specialiseExp z rho0 vars} in
    let {f' = \rho0 r -> specialiseExp f rho0 ((:) r vars)} in
    case constFoldAcc rho f' l z' of {
     Left e0 -> e0;
     Right p ->
      case p of {
       (,) l' e' -> Acc (specialiseExp f rho ((:) Nothing vars)) l' e'}}}

traverseIfWithin :: ExtEnv -> Exp -> (ExtEnv -> Contr) -> (ExtEnv -> Contr)
                    -> Int -> Either Contr ((,) Exp Int)
traverseIfWithin rho e c1 c2 l =
  case specialiseExp e rho [] of {
   OpE op args ->
    case op of {
     BLit b ->
      case b of {
       True ->
        case args of {
         [] -> Left (c1 rho);
         (:) e0 l0 -> Right ((,) (OpE (BLit True) ((:) e0 l0)) l)};
       False ->
        case args of {
         [] ->
          (\fO fS n -> if n==0 then fO () else fS (n-1))
            (\_ -> Left
            (c2 rho))
            (\l' ->
            traverseIfWithin (adv_ext (id 1) rho) e c1 c2 l')
            l;
         (:) e0 l0 -> Right ((,) (OpE (BLit False) ((:) e0 l0)) l)}};
     x -> Right ((,) (OpE x args) l)};
   x -> Right ((,) x l)}

isZeroLit :: Exp -> Bool
isZeroLit e =
  case e of {
   OpE op args ->
    case op of {
     RLit r ->
      case args of {
       [] -> reqb r 0;
       (:) e0 l -> False};
     _ -> False};
   _ -> False}

specialise :: Contr -> ExtEnv -> Contr
specialise c rho =
  case c of {
   Scale e c' ->
    let {e' = specialiseExp e rho []} in
    case isZeroLit e' of {
     True -> Zero;
     False ->
      case specialise c' rho of {
       Zero -> Zero;
       x -> Scale e' x}};
   Translate l c' ->
    case specialise c' (adv_ext (id l) rho) of {
     Zero -> Zero;
     x -> translate l x};
   Both c1 c2 ->
    case specialise c1 rho of {
     Zero -> specialise c2 rho;
     x ->
      case specialise c2 rho of {
       Zero -> x;
       x0 -> Both x x0}};
   If e l c1 c2 ->
    case traverseIfWithin rho e (specialise c1) (specialise c2) l of {
     Left c' -> c';
     Right p ->
      case p of {
       (,) e' l' -> translate ((-) l l') (If e' l' c1 c2)}};
   _ -> c}

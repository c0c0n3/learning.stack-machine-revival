{-
  An AST for our little arithmetic language and a tiny language
  embedding (EDSL) into Haskell using the `Num` and `Fractional`
  type classes.
-}
module Lang ( Expr(..)
            , eval
            )
    where

import Data.Ratio (numerator, denominator)


{-
  The AST.

  It represents integer arithmetic expressions---a.k.a. arithmetic
  without fractions. Expressions involve sums, subtractions, products,
  and divisions among integer values. Since we're only dealing with
  integers, the result of evaluating an expression should still be
  an integer. For this reason, `x/y` is an integer division which
  returns the quotient `q` of Euclidean division of `x` by `y`---i.e.
  `x = y*q + r, 0 <= r < |y|`.

  The `Nbr` leaf node holds integer literals (constants) like `-3`
  or `42`. The `Plus` inner node holds the left and right hand-side
  of an addition operation like `1 + 2` or `3*4 + 6/(9-7)`. Likewise,
  `Times` represents a multiplication op, `Over` division, and so on.
  Notice how the tree structure neatly works out the problem of tracking
  operation precedence.
-}
data Expr = Nbr Integer
          | Plus Expr Expr
          | Minus Expr Expr
          | Times Expr Expr
          | Over Expr Expr
    deriving Show

{-
  Customary `eval` interpreter.
  Given the AST representation of an arithmetic expression in our
  lang, compute the result of performing the specified operations,
  respecting operation precedence.
-}
eval :: Expr -> Integer
eval (Nbr x)      = x
eval (Plus x y)   = eval x + eval y
eval (Minus x y)  = eval x - eval y
eval (Times x y)  = eval x * eval y
eval (Over x y)   = quot (eval x) (eval y)

{-
  The EDSL.

  Our language lets you write arithmetic expressions using integer
  literals, the usual symbols for arithmetic ops like `+` and `*`,
  plus `(` and `)` symbols to specify operation precedence. For instance,
  `(1 + 2) * 3` is an expression in our language. But how to convert it
  into its corresponding AST, `Times (Plus (Nbr 1) (Nbr 2)) (Nbr 3)`?

  The Haskell `Num` type class gives us an easy way to do that. If a
  type `T` is an instance of `Num`, then whenever Haskell finds an
  expression of type `T` involving integers, `+`, `*` and `-` symbols,
  it uses `T`'s definitions of `fromInteger`, `+`, `*`, etc. to evaluate
  that expression.

  We piggyback on this mechanism to build our AST recursively from a
  symbolic expression. We know that literals like `42` map to leaves
  like `Nbr 42`. So `fromInteger n` must be `Nbr n`. That means when
  Haskell finds `42 :: Expr`, it'll call our `fromInteger` implementation
  to return `Nbr 42`. What about a sum like `1 + 2 :: Expr`? First,
  `fromInteger` gets called on `1` and `2`, returning `Nbr 1` and
  `Nbr 2`, respectively. Then our implementation of `+` gets called.
  So how should we implement `+`? Well, in our example, we want to
  convert `1 + 2` to `Plus (Nbr 1) (Nbr 2)`, right? So `(Nbr 1) + (Nbr 2)`
  should be equal to `Plus (Nbr 1) (Nbr 2)`. Ha! Then if `x :: Expr` and
  `y :: Expr` are the arguments to `+`, the function should return
  `Plus x y`. Sweet. The same applies to `*` and `-`, but for now we
  leave out the other `Num` functions, returning an error.

  Similar to `Num`, we use the `Fractional` type class for division.
-}
instance Num Expr where
    fromInteger = Nbr
    x + y       = Plus x y
    x - y       = Minus x y
    x * y       = Times x y
    abs         = error "abs"
    signum      = error "signum"

instance Fractional Expr where
    fromRational x = Nbr $ quot (numerator x) (denominator x)
    x / y          = Over x y

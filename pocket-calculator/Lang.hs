{-
  An AST for our little arithmetic language and a tiny language
  embedding (EDSL) into Haskell using the Num type class.
-}
module Lang where

{-
  The AST.

  It represents arithmetic expressions involving sums and products.
  The `Lit` leaf node holds integer literals (constants) like `-3`
  or `42`. The `Add` inner node holds the left and right hand-side
  of an addition operation like `1 + 2` or `(3*4) + (5+(6*7))`.
  Likewise, `Mul` represents a multiplication op. Notice how the
  tree structure neatly works out the problem of tracking operation
  precedence.
-}
data Expr = Lit Integer
          | Add Expr Expr
          | Mul Expr Expr
    deriving Show

{-
  Customary `eval` interpreter.
  Given the AST representation of an arithmetic expression in our
  lang, compute the result of performing the specified operations,
  respecting operation precedence.
-}
eval :: Expr -> Integer
eval (Lit x)   = x
eval (Add x y) = eval x + eval y
eval (Mul x y) = eval x * eval y

{-
  The EDSL.

  Our language lets you write arithmetic expressions using integer
  literals, the usual symbols for arithmetic ops like `+` and `*`,
  plus `(` and `)` symbols to specify operation precedence. For instance,
  `(1 + 2) * 3` is an expression in our language. But how to convert it
  into its corresponding AST, `Mul (Add (Lit 1) (Lit 2)) (Lit 3)`?

  The Haskell `Num` type class gives us an easy way to do that. If a
  type `T` is an instance of `Num`, then whenever Haskell finds an
  expression of type `T` involving integers, `+`, `*` and `-` symbols,
  it uses `T`'s definitions of `fromInteger`, `+`, `*`, etc. to evaluate
  that expression.

  We piggyback on this mechanism to build our AST recursively from a
  symbolic expression. We know that literals like `42` map to leaves
  like `Lit 42`. So `fromInteger n` must be `Lit n`. That means when
  Haskell finds `42 :: Expr`, it'll call our `fromInteger` implementation
  to return `Lit 42`. What about a sum like `1 + 2 :: Expr`? First,
  `fromInteger` gets called on `1` and `2`, returning `Lit 1` and
  `Lit 2`, respectively. Then our implementation of `+` gets called.
  So how should we implement `+`? Well, in our example, we want to
  convert `1 + 2` to `Add (Lit 1) (Lit 2)`, right? So `(Lit 1) + (Lit 2)`
  should be equal to `Add (Lit 1) (Lit 2)`. Ha! Then if `x :: Expr` and
  `y :: Expr` are the arguments to `+`, the function should return
  `Add x y`. Sweet. The same applies to `*`, but for now we leave out
  the other `Num` functions, returning an error.
-}
instance Num Expr where
    fromInteger = Lit
    x + y       = Add x y
    x * y       = Mul x y
    x - y       = error "sub"
    abs         = error "abs"
    signum      = error "signum"

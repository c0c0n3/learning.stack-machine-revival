{-
  Visualisation functions.
-}
module Viz (pretty) where

import Lang


{-
  Pretty-print an `Expr` to `stdout`.
  This is another interpreter that turns an AST value into a visual
  representation of a tree. Example:
  > pretty $ (1 + 2) * 3
  Mul
    Add
      1
      2
    3
-}
pretty :: Expr -> IO ()
pretty = putStr . toString

toString :: Expr -> String
toString = showExpr 0

showExpr :: Int -> Expr -> String
showExpr indent (Lit x) = pad indent ++ show x ++ "\n"
showExpr indent (Add x y) = showBranches "Add" indent x y
showExpr indent (Mul x y) = showBranches "Mul" indent x y

showBranches :: String -> Int -> Expr -> Expr -> String
showBranches ctor indent x y = pad indent ++ ctor ++ "\n"
                            ++ showExpr (indent + 2) x
                            ++ showExpr (indent + 2) y

pad :: Int -> String
pad indent = take indent . repeat $ ' '

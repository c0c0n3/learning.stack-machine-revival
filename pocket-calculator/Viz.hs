{-
  Visualisation functions.
-}
module Viz (pretty) where

import Lang


{-
  Pretty-print an `Expr` to `stdout`.
  This is another interpreter that turns an AST value into a visual
  representation of a tree. Example:
  > (1 + 2) * 3 :: Expr
  Times (Plus (Nbr 1) (Nbr 2)) (Nbr 3)
  > pretty $ (1 + 2) * 3
  *
    +
      1
      2
    3
-}
pretty :: Expr -> IO ()
pretty = putStr . toString

toString :: Expr -> String
toString = showExpr 0

showExpr :: Int -> Expr -> String
showExpr indent (Nbr x)     = pad indent ++ show x ++ "\n"
showExpr indent (Plus x y)  = showBranches "+" indent x y
showExpr indent (Minus x y) = showBranches "-" indent x y
showExpr indent (Times x y) = showBranches "*" indent x y
showExpr indent (Over x y)  = showBranches "/" indent x y

showBranches :: String -> Int -> Expr -> Expr -> String
showBranches ctor indent x y = pad indent ++ ctor ++ "\n"
                            ++ showExpr (indent + 2) x
                            ++ showExpr (indent + 2) y

pad :: Int -> String
pad indent = take indent . repeat $ ' '

{-
  Our language compiler.
  It turns language constructs into a (semantically equivalent) bunch
  of low-level instructions a stack machine knows how to run.
-}
module Compiler ( compile
                , compileToFile
                )
    where

import Lang (Expr(..))
import VSM (Instruction(..), MemoryCell(..))

{-
  Compile an arithmetic expression to stack machine instructions.
  Use Reverse Polish Notation to get the job done, implemented as
  a post-order traversal of our expression tree.

  Example:
  > compile $ 1*(2 + 3) + (4 + 5)
  [Op LIT,Val 1,Op LIT,Val 2,Op LIT,Val 3,Op ADD,Op MULT,
   Op LIT,Val 4,Op LIT,Val 5,Op ADD,Op ADD]

  i.e. `1*(2 + 3) + (4 + 5)` gets transformed to `1 2 3 + * 4 5 + +`
-}
compile :: Expr -> [MemoryCell]
compile (Nbr n)     = [Op LIT, Val n]
compile (Plus x y)  = compile x ++ compile y ++ [Op ADD]
compile (Minus x y) = compile x ++ compile y ++ [Op SUB]
compile (Times x y) = compile x ++ compile y ++ [Op MULT]
compile (Over x y)  = compile x ++ compile y ++ [Op DIV]

{-
  Same as `compile` but writes the machine instructions to file.
-}
compileToFile :: FilePath -> Expr -> IO ()
compileToFile path = writeFile path . show . compile

{-
  A virtual stack machine.
  We emulate, in software, the hardware of a super simple multiple
  stack 0-operand machine.
-}
module VSM ( Instruction(..)
           , MemoryCell(..)
           , run
           )
    where

{-
  NOTE. We implement a simplified version of the "generic stack machine"
  Koopman details in "Stack Computers: the new wave"
  - https://users.ece.cmu.edu/~koopman/stack_computers/
  Performance-wise our implementation sucks, but for now we'd rather have
  easy-to-understand code than a fast but complex implementation. For the
  same reason we avoid monadic code which would make the implementation
  much shorter and more robust, but isn't exactly beginner friendly.
-}

{-
  The instructions the CPU supports.
  Or rather, the mnemonics for the op-codes the CPU understands.
-}
data Instruction = LIT   -- put following (int) value on top of stack
                 | ADD   -- pop twice, add values and push result
                 | SUB   -- pop twice, subtract values and push result
                 | MULT  -- pop twice, multiply values and push result
                 | DIV   -- pop twice, (int) divide values and push result
    deriving Show

{-
  The data stack. We only support integer values.
-}
type DataStack = [Integer]

{-
  The program memory.
-}
data MemoryCell = Op Instruction | Val Integer
    deriving Show
type ProgramMemory = [MemoryCell]

{-
  The stack machine.
  The only components for now are a simplified data stack and program
  memory.
  Also the machine can only run instructions linearly from program
  start to end---no branching. But these features are more than enough
  for the arithmetic calculator we want to build.
  A compiled program is a sequence of memory cells which the `run`
  function tries to evaluate to an integer---yes, another interpreter!
-}
data StackMachine = StackMachine DataStack ProgramMemory

newStackMachine :: [MemoryCell] -> StackMachine
newStackMachine = StackMachine []

run :: [MemoryCell] -> Integer
run = (\(StackMachine ds pgm) -> exec ds pgm) . newStackMachine

exec :: DataStack -> ProgramMemory -> Integer
exec ds       (Op LIT : Val x : pgm) = exec ( x       : ds) pgm
exec (y:x:ds) (Op ADD         : pgm) = exec ((x + y)  : ds) pgm
exec (y:x:ds) (Op SUB         : pgm) = exec ((x - y)  : ds) pgm
exec (y:x:ds) (Op MULT        : pgm) = exec ((x * y)  : ds) pgm
exec (y:x:ds) (Op DIV         : pgm) = exec (quot x y : ds) pgm
exec (x:ds)   []                     = x
exec _        _                      = error "kaboom!"
--
-- NOTE
-- ----
-- 1. Argument swap. When we push from program memory to data stack,
-- operation arguments get swapped. For instance, `1 + 2` gets compiled
-- to `[Op LIT, Val 1, Op LIT, Val 2, Op ADD]` and after pushing the
-- first two literals, the data stack is `[2, 1]` and the program list
-- `[Op ADD]`.
-- 2. Termination. At the moment there's no jump instruction so `exec`
-- will eventually use up all the elements of the program list or bomb
-- out before then if the program isn't compiled right.
-- 3. Result. Since we're evaluating arithmetic expressions, if the
-- program is compiled right, after executing it, the top of the stack
-- will hold the result of reducing the input arithmetic expression.
-- If the program is buggy, you either get an error or the last value
-- pushed to the stack before program termination.
--

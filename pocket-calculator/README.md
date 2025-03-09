Pocket Calculator
-----------------
> A calculator from the 80's!

We explore the concepts of language, interpreters, compilers, and
hardware architecture by building a simple pocket calculator.

These are the components that make up our calculator:

- An arithmetic language embedded into Haskell.
- Language interpreters to work out the value of an expression and
  pretty print it.
- A virtual stack machine to simulate the calculator hardware.
- A compiler to transform language expressions into low-level
  instructions the machine can run.

Even though this is just a toy, it should give us a fairly good idea
of how to conceptualise the problem and design a solution.

To run the examples below, get a Nix shell first, then `cd` to the
directory containing this README and run:

```bash
$ ghci Main
```


### Language

We embed a simple arithmetic language into Haskell. We only support
non-negative integers, addition and multiplication. The `Expr` type
(an AST) represents language expressions. For example, parsing the
following arithmetic expression as an `Expr` prints the corresponding
syntax tree.

```
> 1*(2 + 3) + (4 + 5) :: Expr
Plus (Times (Nbr 1) (Plus (Nbr 2) (Nbr 3))) (Plus (Nbr 4) (Nbr 5))
```


### Interpreters

There's an `eval` interpreter to work out the value of an arithmetic
expression. Example:

```
> eval $ 1*(2 + 3) + (4 + 5)
14
```

Another interpreter, `pretty`, prints the syntax tree. Example:

```
> pretty $ 1*(2 + 3) + (4 + 5)
+
  *
    1
    +
      2
      3
  +
    4
    5
```


### Virtual stack machine

We emulate, in software, the hardware of a super simple multiple
stack 0-operand machine. At the moment the machine can only push
an integer value on the stack (`LIT` instruction), add or multiply
the top two stack elements—`ADD` and `MULT`, respectively. Here's
a program to tell the machine to add `1` and `2`:

```
[Op LIT, Val 1, Op LIT, Val 2, Op ADD]
```

If you ask the machine to `run` it, you get back (surprise, surprise!)
`3`.

```
> run [Op LIT, Val 1, Op LIT, Val 2, Op ADD]
3
```


### Compiler

We compile expressions to machine (assembly) code using Reverse Polish
Notation. Example:

```
> compile $ 1*(2 + 3) + (4 + 5)
[Op LIT,Val 1,Op LIT,Val 2,Op LIT,Val 3,Op ADD,Op MULT,Op LIT,Val 4,Op LIT,Val 5,Op ADD,Op ADD]
```

i.e. `1*(2 + 3) + (4 + 5)` gets transformed to `1 2 3 + * 4 5 + +`.
If you compile and run the program you get `14`:

```
> run . compile $ 1*(2 + 3) + (4 + 5)
14
```

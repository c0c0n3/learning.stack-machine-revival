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

We embed a simple arithmetic language into Haskell. The language
lets us work with integer arithmetic expressions—a.k.a. arithmetic
without fractions. Expressions involve sums, subtractions, products,
and divisions among integer values. Since we're only dealing with
integers, the result of evaluating an expression should still be an
integer. For this reason, `x/y` is an integer division which returns
the quotient `q` of Euclidean division of `x` by `y`—i.e.
`x = y*q + r, 0 <= r < |y|`. Example: `14/3` yields `4` because
`14 = 3*4 + 2`.

The `Expr` type (an AST) represents language expressions. For example,
parsing the following arithmetic expression as an `Expr` prints the
corresponding syntax tree.

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
stack 0-operand machine. At the moment the machine can only do integer
arithmetic. A program can push an integer value on the stack with
the `LIT` instruction followed by the value. The `ADD` instruction
adds the top two stack elements. Likewise, the `SUB`, `MULT` and
`DIV` instructions carry out the corresponding arithmetic ops on
the top two stack elements. Here's a program to tell the machine
to add `1` and `2`:

```
[Op LIT, Val 1, Op LIT, Val 2, Op ADD]
```

If you ask the machine to `run` it, you get back (surprise, surprise!)
`3`.

```
> run [Op LIT, Val 1, Op LIT, Val 2, Op ADD]
3
```

Now, a real computer uses binary instructions. So, something like
`Op ADD` or `Val 1` would actually be a bunch of zeros and ones you
load into the machine. That's where we're headed, but for now, we'll
stick with the current instructions because they're easier to work
with. When we introduce binary instructions, the above instructions
will make up our assembly language.


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

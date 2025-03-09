The Stack Machine Revival
-------------------------
> Learning about languages, compilers and interpreters by writing code.

This repo complements the whiteboard sessions we're running to learn
about languages, compilers, and interpreters. The idea is that you
attend the sessions, then practice on your own afterwards. You should
**only look at the code in this repo if you get stuck**. Don't cheat—no
pain, no gain!


### Outline

The goal is to familiarise yourself with key PLT concepts such as
formal semantics, type theory, compilers, program analysis and transformation,
domain-specific languages, and interpreters.

How will we do this? By designing and implementing a language, a
compiler, and a virtual stack machine to execute the compiled code.
Who said stack machines were dead? They're ideal for learning how
computer hardware works without getting bogged down in the complexity
of modern architectures.

Every few sessions, we'll release polished versions of the code you
can look at if you get stuck with the practice.

- https://github.com/c0c0n3/learning.stack-machine-revival/releases

The GitHub releases show how the implementation evolved over time,
starting from a toy to a larger and more sophisticated system.


### Repo contents

At the moment this repo contains:

- [Pocket calculator][calc]. A toy Haskell program to get a feel for
  implementing EDSLs, interpreters, compilers, and hardware emulation.
- [Build system][build]. Nix expressions to start a dev shell with all
  the tools you need (compiler, libs, CLI tools, etc.) as well as expressions
  to build, run, and package code. The only thing you need to install
  is Nix, then, as usual, run `cd nix; nix shell`.

To go back in time, look at GitHub releases.




[build]: ./nix/
[calc]: ./pocket-calculator/

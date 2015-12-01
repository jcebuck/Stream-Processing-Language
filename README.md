# Custom Stream Processing Language (SPL) and Interpreter

In this project I designed a custom language and syntax to solve some domain-specific problems involving streams of integers.
The syntax was influenced by PHP and BASIC.

The tools I used:
* ocamllex - for lexical analysis of an input program.
* ocamlyacc - to associate groupings of lexical tokens with semantic actions.
* OCaml language - to write the interpreter to evaluate and execute code statements.
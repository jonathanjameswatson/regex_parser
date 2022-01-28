# Regex parser

OCaml parsers (not compilers!) for (limited) regular expressions written for compiler construction supervision work.

## Installation

1. Install `ocaml`, `dune`, `core`, `menhir` and `menhirLib`
2. Run `dune build`
3. Run `dune install`

## Formatting

Run `dune build @fmt` and `dune promote` to format the code

## Usage

```txt
Output a sequence of tokens and an AST for a given regular expression

  regex_parser INPUT

=== flags ===

  [-l]           use the generated lexer rather than the custom one
  [-p]           use the generated LR(1) parser rather than the custom recursive
                 descent parser
  [-build-info]  print info about this build and exit
  [-version]     print the version of this build and exit
  [-help]        print this help text and exit
                 (alias: -?)
```

open Core

type token =
  | Character of char
  | Alt
  | Star
  | LBracket
  | RBracket
  | LParen
  | RParen
  | Hyphen
[@@deriving sexp]

val lex : string -> token Queue.t

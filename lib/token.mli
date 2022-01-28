open! Core

type t =
  | Character of char
  | Alt
  | Star
  | LBracket
  | RBracket
  | LParen
  | RParen
  | Hyphen
[@@deriving sexp]

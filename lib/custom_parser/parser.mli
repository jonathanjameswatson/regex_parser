open Core

type expr =
  | Character of char
  | Concat of expr * expr
  | Alt of expr * expr
  | KleeneStar of expr
  | CharacterRange of char * char
  | CharacterList of char list
[@@deriving sexp]

val parse : Lexer.token Queue.t -> expr

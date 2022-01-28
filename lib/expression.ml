open Core

type t =
  | Character of char
  | Concat of t * t
  | Alt of t * t
  | KleeneStar of t
  | CharacterRange of char * char
  | CharacterList of char list
[@@deriving sexp]

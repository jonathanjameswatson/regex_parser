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

let token_of_char = function
  | '|' -> Alt
  | '*' -> Star
  | '[' -> LBracket
  | ']' -> RBracket
  | '(' -> LParen
  | ')' -> RParen
  | '-' -> Hyphen
  | c -> Character c
;;

let lex s =
  String.fold s ~init:(Queue.create ()) ~f:(fun q c ->
      Queue.enqueue q (token_of_char c);
      q)
;;

open Core

let token_of_char = function
  | '|' -> Token.Alt
  | '*' -> Token.Star
  | '[' -> Token.LBracket
  | ']' -> Token.RBracket
  | '(' -> Token.LParen
  | ')' -> Token.RParen
  | '-' -> Token.Hyphen
  | c -> Token.Character c
;;

let lex s =
  String.fold s ~init:(Queue.create ()) ~f:(fun q c ->
      Queue.enqueue q (token_of_char c);
      q)
;;

open Core

let get_corresponding_token = function
  | Token.Character c -> Generated_parser_menhir.CHARACTER c
  | Token.Alt -> Generated_parser_menhir.ALT
  | Token.Star -> Generated_parser_menhir.STAR
  | Token.LBracket -> Generated_parser_menhir.LBRACKET
  | Token.RBracket -> Generated_parser_menhir.RBRACKET
  | Token.LParen -> Generated_parser_menhir.LPAREN
  | Token.RParen -> Generated_parser_menhir.RPAREN
  | Token.Hyphen -> Generated_parser_menhir.HYPHEN
;;

let parse q =
  (MenhirLib.Convert.Simplified.traditional2revised Generated_parser_menhir.start)
    (fun () ->
      ( (match Queue.dequeue q with
        | Some t -> get_corresponding_token t
        | None -> Generated_parser_menhir.EOF)
      , Lexing.dummy_pos
      , Lexing.dummy_pos ))
;;

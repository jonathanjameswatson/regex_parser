{
open Core
open Token

exception Eof
}

rule token = parse
| '|'
    { Alt }
| '*'
    { Star }
| '['
    { LBracket }
| ']'
    { RBracket }
| '('
    { LParen }
| ')'
    { RParen }
| '-'
    { Hyphen }
| [ 'a'-'z' ]
    { Character (String.get (Lexing.lexeme lexbuf) 0) }
| eof { raise Eof }

{
let lex s =
  let lexbuf = Lexing.from_string s in
  let q = Queue.create () in
  try
    while true do
      Queue.enqueue q (token lexbuf)
    done;
    q
  with
  | Eof -> q
}

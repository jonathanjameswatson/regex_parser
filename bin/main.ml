open Core
open Custom_parser

let input_param =
  let open Command.Param in
  anon ("input" %: string)
;;

let handle_input input =
  let q = Lexer.lex input in
  Out_channel.print_string "Tokens:";
  Out_channel.newline stdout;
  Sexp.output_hum stdout (Queue.sexp_of_t Lexer.sexp_of_token q);
  Out_channel.newline stdout;
  Out_channel.print_string "AST:";
  Out_channel.newline stdout;
  Sexp.output_hum stdout (Parser.sexp_of_expr (Parser.parse q));
  Out_channel.newline stdout
;;

let command =
  Command.basic
    ~summary:"Output a sequence of tokens and an AST for a given regular expression"
    (Command.Param.map input_param ~f:(fun input () -> handle_input input))
;;

let () = Command.run ~version:"1.0" ~build_info:"RWO" command

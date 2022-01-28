open Core
open Regex_parser

let handle_input use_generated_lexer use_generated_parser input =
  let q =
    if use_generated_lexer then Generated_lexer.lex input else Custom_lexer.lex input
  in
  Out_channel.print_string "Tokens:";
  Out_channel.newline stdout;
  Sexp.output_hum stdout (Queue.sexp_of_t Token.sexp_of_t q);
  Out_channel.newline stdout;
  let expr =
    if use_generated_parser then Generated_parser.parse q else Custom_rd_parser.parse q
  in
  Out_channel.print_string "AST:";
  Out_channel.newline stdout;
  Sexp.output_hum stdout (Expression.sexp_of_t expr);
  Out_channel.newline stdout
;;

let command =
  Command.basic
    ~summary:"Output a sequence of tokens and an AST for a given regular expression"
    Command.Let_syntax.(
      let%map_open use_generated_lexer =
        flag "-l" no_arg ~doc:" use the generated lexer rather than the custom one"
      and use_generated_parser =
        flag
          "-p"
          no_arg
          ~doc:
            " use the generated LR(1) parser rather than the custom recursive descent \
             parser"
      and input = anon ("input" %: string) in
      fun () -> handle_input use_generated_lexer use_generated_parser input)
;;

let () = Command.run ~version:"1.0" ~build_info:"RWO" command

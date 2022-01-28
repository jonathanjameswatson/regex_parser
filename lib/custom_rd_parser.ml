open Core
open Expression

exception Parse_error

let queue_discard : 'a. 'a Queue.t -> unit = fun q -> ignore (Queue.dequeue_exn q : 'a)

let rec parse_expression tokens =
  let rec parse_character_list_end tokens cs =
    match Queue.peek tokens with
    | Some (Token.Character c) ->
      queue_discard tokens;
      parse_character_list_end tokens (c :: cs)
    | Some Token.RBracket ->
      queue_discard tokens;
      Some (CharacterList (List.rev cs))
    | _ -> raise Parse_error
  in
  let parse_character_range_end tokens c1 =
    match Queue.peek tokens with
    | Some (Token.Character c2) ->
      queue_discard tokens;
      (match Queue.peek tokens with
      | Some Token.RBracket ->
        queue_discard tokens;
        Some (CharacterRange (c1, c2))
      | _ -> raise Parse_error)
    | _ -> raise Parse_error
  in
  let parse_character_class tokens =
    match Queue.peek tokens with
    | Some Token.LBracket ->
      queue_discard tokens;
      (match Queue.peek tokens with
      | Some (Token.Character c1) ->
        queue_discard tokens;
        (match Queue.peek tokens with
        | Some x ->
          (match x with
          | Token.Hyphen ->
            queue_discard tokens;
            parse_character_range_end tokens c1
          | _ -> parse_character_list_end tokens [ c1 ])
        | _ -> raise Parse_error)
      | _ -> raise Parse_error)
    | _ -> None
  in
  let parse_parens tokens =
    match Queue.peek tokens with
    | Some Token.LParen ->
      queue_discard tokens;
      (match parse_expression tokens with
      | Some expression ->
        (match Queue.peek tokens with
        | Some RParen ->
          queue_discard tokens;
          Some expression
        | _ -> raise Parse_error)
      | _ -> raise Parse_error)
    | _ -> None
  in
  let parse_base_expression tokens =
    match Queue.peek tokens with
    | Some Token.LBracket -> parse_character_class tokens
    | Some Token.LParen -> parse_parens tokens
    | Some (Token.Character c) ->
      queue_discard tokens;
      Some (Character c)
    | _ -> None
  in
  let parse_kleene_star tokens =
    match parse_base_expression tokens with
    | Some base_expression ->
      (match Queue.peek tokens with
      | Some Star ->
        queue_discard tokens;
        Some (KleeneStar base_expression)
      | _ -> Some base_expression)
    | _ -> None
  in
  let rec parse_concatenation tokens =
    match parse_kleene_star tokens with
    | Some kleene_star1 ->
      (match parse_concatenation tokens with
      | Some kleene_star2 -> Some (Concat (kleene_star1, kleene_star2))
      | _ -> Some kleene_star1)
    | _ -> None
  in
  match parse_concatenation tokens with
  | Some concatenation1 ->
    (match Queue.peek tokens with
    | Some Token.Alt ->
      queue_discard tokens;
      (match parse_expression tokens with
      | Some concatenation2 -> Some (Alt (concatenation1, concatenation2))
      | _ -> raise Parse_error)
    | _ -> Some concatenation1)
  | _ -> None
;;

let parse q =
  match parse_expression q with
  | Some e when Queue.length q = 0 -> e
  | _ -> raise Parse_error
;;

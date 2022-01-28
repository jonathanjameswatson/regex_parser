%{
  open! Core
%}

%token <char> CHARACTER
%token ALT STAR LBRACKET RBRACKET LPAREN RPAREN HYPHEN EOF

%start start

%type <char list> characters
%type <Expression.t> character_list
%type <Expression.t> character_range
%type <Expression.t> character_class
%type <Expression.t> parens
%type <Expression.t> base_expression
%type <Expression.t> kleene_star
%type <Expression.t> concatenation
%type <Expression.t> expression
%type <Expression.t> start

%%

characters:
| CHARACTER                                    { [$1] }
| CHARACTER characters                         { $1 :: $2 }

character_list:
| LBRACKET characters RBRACKET                 { Expression.CharacterList $2 }

character_range:
| LBRACKET CHARACTER HYPHEN CHARACTER RBRACKET { Expression.CharacterRange ($2, $4) }

character_class:
| character_list                               { $1 }
| character_range                              { $1 }

parens:
| LPAREN expression RPAREN                     { $2 }

base_expression:
| CHARACTER                                    { Expression.Character $1 }
| character_class                              { $1 }
| parens                                       { $1 }

kleene_star:
| base_expression STAR                         { Expression.KleeneStar $1 }
| base_expression                              { $1 }

concatenation:
| kleene_star concatenation                    { Expression.Concat ($1, $2) }
| kleene_star                                  { $1 }

expression:
| concatenation ALT expression                 { Expression.Alt ($1, $3) }
| concatenation                                { $1 }

start:
| expression EOF                               { $1 }

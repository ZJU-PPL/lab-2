%{
open Base.List;;
open Cmd;;
module Type = Type;;
module Term = OptionTyped;;
%}

/* TK means Token */
%token TOK_EOF       /*  EOF  */

%token TOK_LET       /* let   */
%token TOK_EVAL      /* eval  */
%token TOK_CHECK     /* check */

%token TOK_COLON     /* : */
%token TOK_LAMBDA    /* \ */
%token TOK_DOT       /* . */
%token TOK_ADD       /* + */
%token TOK_SUB       /* - */
%token TOK_EQ        /* = */
%token TOK_LT        /* < */
%token TOK_L_PAREN   /* ( */
%token TOK_R_PAREN   /* ) */

%token TOK_IF        /* if   */
%token TOK_THEN      /* then */
%token TOK_ELSE      /* else */
%token TOK_END       /* end  */

%token TOK_FIX       /* fix  */

%token <string> TOK_IDENT         /* x */
%token <int>    TOK_INT_LIT       /* n */
%token <bool>   TOK_BOOL_LIT      /* b */

%token TOK_INT   /* Int  */
%token TOK_BOOL  /* Bool */
%token TOK_ARROW /*  ->  */

%start cmds
%type <Cmd.cmd list> cmds
%type <Cmd.cmd> cmd

%right TOK_ARROW
%left TOK_LT TOK_EQ
%left TOK_ADD TOK_SUB

%%
cmds : 
  | TOK_EOF      { [] }
  | cmd cmds { $1::$2 }
  ;

cmd :
  | TOK_LET TOK_IDENT tm { Let($2, $3)}
  | TOK_LET TOK_IDENT TOK_EQ tm { Let($2, $4)}
  | TOK_EVAL TOK_IDENT { Eval($2, 1000) }
  | TOK_EVAL TOK_IDENT TOK_INT_LIT { Eval($2, $3) }
  | TOK_CHECK TOK_IDENT { Check($2, None)}
  | TOK_CHECK TOK_IDENT ty { Check($2, Some($3)) }
  ;
tm : 
  | tm_app { 
    let ls = rev $1 in
    match ls with
    | [] -> failwith "Impossible"
    | tm::[] -> tm
    | func::args -> fold args ~init:func 
      ~f:(fun func arg->Term.App(func, arg))
  }
  ;

tm_not_app :
  | TOK_L_PAREN tm TOK_R_PAREN { $2 }
  | TOK_IDENT { Term.Var($1) }
  | TOK_LAMBDA TOK_IDENT ty_opt TOK_DOT tm { Term.Lam($2, $3, $5) }
  | TOK_FIX TOK_IDENT ty_opt TOK_EQ tm { Term.Fix($2, $3, $5) }
  | TOK_INT_LIT  { Term.Int($1) }
  | TOK_BOOL_LIT { Term.Bool($1) }
  | tm_not_app TOK_ADD tm_not_app { Term.Add($1, $3) }
  | tm_not_app TOK_SUB tm_not_app { Term.Sub($1, $3) }
  | tm_not_app TOK_EQ tm_not_app { Term.Eq($1, $3) }
  | tm_not_app TOK_LT tm_not_app { Term.Lt($1, $3) }
  | TOK_IF tm TOK_THEN tm TOK_ELSE tm TOK_END { Term.If($2, $4, $6) }
  ;

tm_app : 
  | tm_not_app { $1::[] }
  | tm_app tm_not_app  { $2::$1 }

ty_opt :
  | TOK_COLON ty { Some($2) }
  | { None }
  ;

ty :
  | TOK_L_PAREN ty TOK_R_PAREN { $2 }
  | TOK_BOOL { Type.Bool }
  | TOK_INT  { Type.Int }
  | ty TOK_ARROW ty { Type.Lam($1, $3) }
  ;
%{
  #include "heading.h"
  #include "generators.h"

  int yylex(void);
  extern int yylineno;
  extern FILE *yyout;
  int errors = 0;
%}

 /* Symbols */
%union {
  queu q;
  double d;
  struct ast *a;
  struct symbol *s; /* which symbol */
  struct symlist *sl;
  int fn; /* which function */
}

/* declare tokens */
%token <d> NUMBER

  /*** VBA Tokens ***/
%token DIM
%token MODULE
%token END
%token SUB
%token FUNCTION
%token SELECT
%token CASE
%token IS
%token AS
%token <s> IDENTIFIER
%token DATATYPE
%token <fn> FUNC
%token EOL
%token IF THEN ELSE WHILE DO LET
%nonassoc <fn> CMP

%right EQUAL
%left MINUS PLUS
%left AST SLASH
%type <a> expression expression_list statement statement_list
%type <sl> symbol_list
%type <q> numberlist

%start input
%%
input :   /*    empty   */
| input module_declaration
| input subroutine_definition
| input statement_list {
    printf("= %4.4g\n> ", eval($2));
    treefree($2);  
}
;

module_declaration: /* Nothing */
| MODULE IDENTIFIER subroutine_definition END MODULE
| MODULE IDENTIFIER statement_list END MODULE
| MODULE IDENTIFIER END MODULE
;

subroutine_definition: /* Nothing */
| SUB IDENTIFIER '(' argument ')' statement_list END SUB
| SUB IDENTIFIER END SUB
;

function_definition: /* Nothing */
| FUNCTION IDENTIFIER '(' argument ')' statement_list END FUNCTION
;

statement : IF expression THEN statement_list {
  $$ = newflow('I', $2, $4, NULL);
  }
| IF expression THEN statement_list ELSE statement_list {
  $$ = newflow('I', $2, $4, $6); 
  }
| WHILE expression DO statement_list {$$ = newflow('W', $2, $4, NULL); }
| variable_declaration
| expression
;

statement_list: /* Nothing */ {$$ = NULL;}
| statement statement_list {
  if($2 == NULL) $$ = $1;
  else $$ = newast('L', $1, $2);
}
;

variable_declaration: DIM IDENTIFIER EQUAL numberlist
| DIM IDENTIFIER EQUAL expression
| DIM IDENTIFIER
;

numberlist : NUMBER { $$= appendQueu(newQueu(), $1); }
| numberlist NUMBER { $$= appendQueu($1, $2); }
;

expression: expression PLUS expression { $$ = newast('+', $1, $3); }
| expression MINUS expression { $$ = newast('-', $1, $3); }
| expression AST expression { $$ = newast('*', $1, $3); }
| expression SLASH expression { $$ = newast('/', $1, $3); }
| '(' expression ')' { $$ = $2;}
| NUMBER { $$ = newnum($1);}
| IDENTIFIER { $$ = newref($1); }
| IDENTIFIER EQUAL expression { $$ = newasgn($1, $3); }
| FUNC '(' expression_list ')' { $$ = newfunc($1, $3); }
| IDENTIFIER '(' expression_list ')' { $$ = newcall($1, $3); }
;

argument: /* Nothing */
| DIM IDENTIFIER AS DATATYPE EQUAL expression
| DIM IDENTIFIER EQUAL expression
| DIM IDENTIFIER
| IDENTIFIER EQUAL expression
| IDENTIFIER
;

argument_list: /* nothing */
| argument_list argument
;

expression_list: expression
| expression ',' expression_list { $$ = newast('L', $1, $3); }
;

symbol_list: IDENTIFIER { $$ = newsymlist($1, NULL); }
| IDENTIFIER ',' symbol_list { $$ = newsymlist($1, $3); }
;

%%
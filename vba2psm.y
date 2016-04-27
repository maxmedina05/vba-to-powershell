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
  char *t;
  struct ast *a;
  struct symbol *s; /* which symbol */
  struct symlist *sl;
  int fn; /* which function */
  int i;
}

/* declare tokens */
%token <d> NUMBER

  /*** VBA Tokens ***/
%token DIM
%token MODULE
%token END
%token SUB
%token FUNCTION ATTRIBUTE VB_NAME
%token SELECT
%token CASE
%token IS_OPERATOR TO_OPERATOR
%token AS
%token INTEGER TSTRING DOUBLE
%token <t> STRING
%token <s> IDENTIFIER
%token <fn> FUNC
%token EOL PUBLIC
%token IF THEN ELSE WHILE DO LET
%nonassoc <fn> CMP

%right EQUAL
%left MINUS PLUS
%left AST SLASH
%type <a> expression expression_list statement statement_list variable_declaration
%type <a> case_expression case_expression_list select_case_statement
%type <a> function_definition argument_list argument
%type <sl> symbol_list
%type <i> data_type

%start input
%%
input :   /*    empty   */
| input module_declaration
| input subroutine_definition
| input function_definition {
    genCode($2, yyout);
    treefree($2);  
}
| input statement_list {
    genCode($2, yyout);
    treefree($2);  
}
;

module_declaration: MODULE IDENTIFIER subroutine_definition END MODULE
| MODULE IDENTIFIER statement_list END MODULE
| MODULE IDENTIFIER END MODULE
;

subroutine_definition: SUB IDENTIFIER '(' argument ')' statement_list END SUB
| SUB IDENTIFIER END SUB
;

function_definition:    /* Nothing */ 
| PUBLIC FUNCTION IDENTIFIER '(' ')' statement_list END FUNCTION {$$ = newvbafn($3, NULL, $6);}
| PUBLIC FUNCTION IDENTIFIER '(' argument ')' statement_list END FUNCTION {$$ = newvbafn($3, $5, $7);}
| FUNCTION IDENTIFIER '(' ')' statement_list END FUNCTION {$$ = newvbafn($2, NULL, $5);}
| FUNCTION IDENTIFIER '(' argument ')' statement_list END FUNCTION {$$ = newvbafn($2, $4, $6);}
;

statement_list: /* Nothing */ {$$ = NULL;}
| statement statement_list {
  if($2 == NULL) $$ = $1;
  else $$ = newast('L', $1, $2);
}
;

statement: IF expression THEN statement_list {
    $$ = newflow('I', $2, $4, NULL);
  }
| IF expression THEN statement_list ELSE statement_list {
  $$ = newflow('I', $2, $4, $6); 
  }
| WHILE expression DO statement_list {$$ = newflow('W', $2, $4, NULL); }
| select_case_statement
| variable_declaration
| expression
| ATTRIBUTE VB_NAME EQUAL STRING
;

select_case_statement: SELECT CASE IDENTIFIER case_expression_list END SELECT {
  $$ = newselcase(SELECT_CASE, $3, $4);
}
| SELECT CASE IDENTIFIER END SELECT {$$ = newselcase(SELECT_CASE, $3, NULL);}
;

case_expression_list: /* nothing */ {$$ = NULL;}
| case_expression case_expression_list {
    if($2 == NULL) $$ = $1;
    else $$ = newast('L', $1, $2);
}
;

case_expression: CASE expression statement_list {
    $$ = newcase(CASE_EXPRESSION, $2, $3);
}
| CASE ELSE statement_list
;

variable_declaration: DIM IDENTIFIER AS data_type EQUAL expression {$$ = newDecl('D', $4, $2, $6); }
| DIM IDENTIFIER EQUAL expression {$$ = newDecl('D', 0, $2, $4); }
| DIM IDENTIFIER AS data_type {$$ = newDecl('D', $4, $2, NULL);}
| DIM IDENTIFIER {$$ = newDecl('D', 0, $2, NULL);}
;

data_type: INTEGER {$$ = TYPE_INTEGER;}
| DOUBLE  {$$ = TYPE_DOUBLE;}
| TSTRING  {$$ = TYPE_STRING;}
;

expression: expression CMP expression {$$ = newcmp($2, $1, $3);}
| expression PLUS expression { $$ = newast('+', $1, $3); }
| expression MINUS expression { $$ = newast('-', $1, $3); }
| expression AST expression { $$ = newast('*', $1, $3); }
| expression SLASH expression { $$ = newast('/', $1, $3); }
| IS_OPERATOR CMP expression {$$ = newcmp($2, newisop(), $3);}
| expression TO_OPERATOR expression { $$ = newast(TO_OP, $1, $3);}
| '(' expression ')' { $$ = $2;}
| NUMBER { $$ = newnum($1);}
| IDENTIFIER { $$ = newref($1);}
| IDENTIFIER EQUAL expression { $$ = newasgn($1, $3); }
| FUNC '(' expression_list ')' { $$ = newfunc($1, $3); }
| IDENTIFIER '(' expression_list ')' { $$ = newcall($1, $3); }
| STRING {$$ = newstring($1); }
;

argument: DIM IDENTIFIER AS data_type 
| DIM IDENTIFIER {$$ = newDecl('A', 0, $2, NULL);}
| IDENTIFIER { $$ = newDecl('A', 0, $1, NULL);}
;

argument_list: /* nothing */ { $$ = newDecl('A', 0, "", NULL);}
| argument ',' argument_list {
    if($3 == NULL) $$ = $1;
    else $$ = newast(ARGUMENT_LIST, $1, $3);
  }
;

expression_list: expression
| expression ',' expression_list { $$ = newast('L', $1, $3); }
;

symbol_list: IDENTIFIER { $$ = newsymlist($1, NULL); }
| IDENTIFIER ',' symbol_list { $$ = newsymlist($1, $3); }
;

%%
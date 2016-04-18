%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "generators.h"
#include "heading.h"

int yyerror(char *s);
int yylex(void);
extern int yylineno;
extern FILE *yyout;
%}

 /* Symbols */
%union {
	char *s;
	queu q;
  char c;
  int i;
  double d;
}

/* declare tokens */
%token <d> NUMBER
%token <i> INTEGER
%token <f> FLOAT
%token <s> STRING
%token <s> EOL

	/*** VBA Tokens ***/
%token DIM
%token MODULE
%token END
%token SUB
%token <s> NAME

%left MINUS PLUS EQUAL
%left	AST SLASH
%type <s> expression
%type <s> variable_name
%type <s> assignment_expression
%type <s> variable_declaration
%type <s> statement
%type <q> numberlist

%%

input :		/*		empty		*/
| module_declaration EOL
| input module_declaration EOL
| statement EOL { fprintf(yyout, "%s\n", $1); }
| input statement EOL { fprintf(yyout, "%s\n", $2); }
;

module_declaration: MODULE NAME EOL END MODULE
| MODULE NAME EOL subroutine_definition EOL END MODULE
| MODULE NAME EOL END MODULE
;

subroutine_definition: SUB NAME EOL END SUB
| SUB NAME EOL statement_list END SUB
;

statement_list: statement EOL
| statement_list statement EOL

numberlist : NUMBER {}
| numberlist NUMBER {}
;

statement : NAME numberlist {}
|	expression {$$ = $1;}
| variable_declaration {$$ = $1;}
;

variable_declaration: DIM variable_name EQUAL expression {
	sprintf($$, "$%s= %s", $2, $4);
}
| DIM variable_name { 
	{ sprintf($$, "%s", $2); }
}
;

expression: NUMBER {
	char *str = (char*)malloc( 11*sizeof(double));
  $$ = itoa($1, str, 10);}
|	expression PLUS expression { 
	$$ = (char*)stringBuilder(3, $1, "+", $3).c_str(); free($1); free($3);}
|	expression MINUS expression { 
	$$ = (char*)stringBuilder(3, $1, "-", $3).c_str(); free($1); free($3);}
|	expression AST expression { 
	$$ = (char*)stringBuilder(3, $1, "*", $3).c_str(); free($1); free($3);}
|	expression SLASH expression { 
	$$ = (char*)stringBuilder(3, $1, "/", $3).c_str(); free($1); free($3);}
;

assignment_expression: EQUAL expression { 
	//$$ = (char*)stringBuilder(2, "= ", $2).c_str();}
	sprintf($$, " = %s", $2);}
;

variable_name: NAME { $$ = $1;}
;

EOF: EOL
;

%start input
;

%%
int yyerror(std::string s)
{
  extern int line_num;	// defined and maintained in lex.c
  extern char *yytext;	// defined and maintained in lex.c
  
  std::cerr << "ERROR: " << s << " at symbol \"" << yytext;
  std::cerr << "\" on line " << line_num << std::endl;
  exit(1);
}

int yyerror(char *s)
{
  return yyerror(std::string(s));
}

void yyerror(char *s, ...)
{
	extern int line_num;	// defined and maintained in lex.c
  va_list ap;
  va_start(ap, s);

  fprintf(stderr, "%d: error: ", line_num);
  vfprintf(stderr, s, ap);
  fprintf(stderr, "\n");
}
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
int errors = 0;

std::map<std::string,std::string> symbolTable;

void install(char* type, char *identifier){
  std::string idstr(identifier);
  std::string typestr(type);

  // check if identifier exist
  if(symbolTable.find(identifier) != symbolTable.end()){
    symbolTable[identifier] = typestr;
  }
  else{
    errors++;
    yyerror("Already defined");
  }
}

bool contextCheck(char * identifier){
  std::string idstr(identifier);
  //std::string typestr(type);

  // check if identifier exist
  return (symbolTable.find(identifier) != symbolTable.end());
}

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
%token FUNCTION
%token SELECT
%token CASE
%token IS
%token AS
%token <s> IDENTIFIER
%token DATATYPE

%left MINUS PLUS EQUAL
%left	AST SLASH
%type <s> expression
%type <s> statement
%type <q> numberlist

%%

input :		/*		empty		*/
| module_declaration
| input module_declaration
| subroutine_definition
| input subroutine_definition
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

statement_list: /* Empty */
| statement
| statement_list statement
;

statement : expression {$$ = $1;}
| variable_declaration
;

variable_declaration: DIM IDENTIFIER EQUAL numberlist {
  //std::string idstr($2);
  if(contextCheck($2)) {
    initArray(yyout, 0, $2, $4);
  }
  else {
    initArray(yyout, 0, $2, $4);
  }
}
| DIM IDENTIFIER EQUAL expression {
  //install("Generic", $2);
}
| DIM IDENTIFIER { 
	{ 
    //sprintf($$, "%s", $2);
    //install("Generic", $2);
   }
}
;

numberlist : NUMBER { $$= appendQueu(newQueu(), $1); }
| numberlist NUMBER { $$= appendQueu($1, $2); }
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

argument: /* Nothing */
| DIM IDENTIFIER AS DATATYPE EQUAL expression
| DIM IDENTIFIER EQUAL expression
| DIM IDENTIFIER
| IDENTIFIER EQUAL expression
| IDENTIFIER
;
%start input
;

%%
int yyerror(std::string s)
{
  errors++;
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
  errors++;
	extern int line_num;	// defined and maintained in lex.c
  va_list ap;
  va_start(ap, s);

  fprintf(stderr, "%d: error: ", line_num);
  vfprintf(stderr, s, ap);
  fprintf(stderr, "\n");
}
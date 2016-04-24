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
  struct ast *a;
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
%type <a> exp factor term

%%
calclist: /* nothing */
| calclist exp EOL {
  fprintf(stderr, "%4.4g\n", eval($2));
  treefree($2);
  printf("> ");
}
| calclist: EOL { fprintf(stderr, "> ");}
;

exp: factor
| exp PLUS factor {$$ = newast('+', $1, $3);}
| exp MINUS factor {$$ = newast('-', $1, $3);}
;

factor: term
| factor AST term { $$ = newast('*', $1,$3); }
| factor SLASH term { $$ = newast('/', $1,$3); }
;

term: NUMBER { $$ = newnum($1); }
| '|' term { $$ = newast('|', $2, NULL); }
| '(' exp ')' { $$ = $2; }
| MINUS term { $$ = newast('M', $2, NULL); }
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
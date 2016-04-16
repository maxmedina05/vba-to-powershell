    /*** Definition section ***/
%{
  #include "heading.h"
  int yyerror(char *s);
  int yylex(void);
%}

%%
    /*** Rules sections ***/

%%

int yyerror(string s)
{
  extern int yylineno;	// defined and maintained in lex.c
  extern char *yytext;	// defined and maintained in lex.c
  
  cerr << "ERROR: " << s << " at symbol \"" << yytext;
  cerr << "\" on line " << yylineno << endl;
  exit(1);
}

int yyerror(char *s)
{
  return yyerror(string(s));
}
    /*** C Code section ***/
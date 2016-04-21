%option noyywrap nodefault yylineno
%{
# include "generators.h"
#include "heading.h"
# include "vba2psm.tab.h"

int line_num = 1;

int yyerror(char *s);
# define MAX_STR_CONST 512

    char string_buf[MAX_STR_CONST];
    char *string_buf_ptr;
%}

/* float exponent */
DIGIT [0-9]
EXP	([Ee][-+]?[0-9]+)
ID [a-zA-Z][a-zA-Z0-9_]*
/* La captura de un token tipo string es compleja. Ver http://flex.sourceforge.net/manual/Start-Conditions.html */

%x str

%%
"Module"	{ yylval.s = yytext; return MODULE;}
"Sub"   { yylval.s = yytext; return SUB;}
"End"		{ yylval.s = yytext; return END;}
"Dim"   { yylval.s = yytext; return DIM;}
"Function"   { yylval.s = yytext; return FUNCTION;}
"Select"   { yylval.s = yytext; return SELECT;}
{ID}  {yylval.s = yytext; return IDENTIFIER;}
[-+]?[0-9]+"."[0-9]*{EXP}? |
"."?[0-9]+{EXP}? { yylval.d = atof(yytext); return NUMBER; }
"="     { yylval.s = yytext; return EQUAL; }
"+"     { yylval.s = yytext; return PLUS; }
"-"     { yylval.s = yytext; return MINUS; }
"*"     { yylval.s = yytext; return AST; }
"/"     { yylval.s = yytext; return SLASH; }
"("			{	return '('; };
")"			{	return ')'; };

"\n"    { 
					//yylval.s = "EOL";
 					yylineno++; line_num++; 
 					//return EOL;
 				}
[ \t]   { }
.       { fprintf(
            stderr, 
            "caracter inesperado '%s' linea %d\n", 
            yytext, 
            line_num);
        }

%%
%option noyywrap nodefault

    /*** Definition section ***/
%{
#include "heading.h"
#include "tok.h"
int yyerror(char *s);
int yylineno = 1;
%}

DIGIT [0-9]
INT_CONST {DIGIT}+

%%
    /*** Rules sections ***/
[ \t\n]         ;
{INT_CONST}	{ yylval.int_val = atoi(yytext); return INTEGER_LITERAL; }
"+"		{ yylval.op_val = new std::string(yytext); return PLUS; }
"*"		{ yylval.op_val = new std::string(yytext); return MULT; }

[ \t]*		{}
[\n]		{ yylineno++;	}

.		{ std::cerr << "SCANNER "; yyerror(""); exit(1);	}

%%
    /*** C Code section ***/


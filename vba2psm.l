%option noyywrap nodefault yylineno
%{
# include "heading.h"
# include "generators.h"
# include "vba2psm.tab.h"

int line_num = 1;

# define MAX_STR_CONST 512

    char string_buf[MAX_STR_CONST];
    char *string_buf_ptr;
%}

/* float exponent */
DIGIT [0-9]
EXP	([Ee][-+]?[0-9]+)
ID [a-zA-Z][a-zA-Z0-9_]*

%%
"+"     { yylval.s = yytext; return PLUS; }
"-"     { yylval.s = yytext; return MINUS; }
"*"     { yylval.s = yytext; return AST; }
"/"     { yylval.s = yytext; return SLASH; }
"="     { yylval.s = yytext; return EQUAL; }
","			{	return yytext[0]; return ','; };
"("			{	return yytext[0]; return '('; };
")"			{	return yytext[0]; return ')'; };
	/* comparison ops, all are a CMP token */
">" { yylval.fn = 1; return CMP; }
"<" { yylval.fn = 2; return CMP; }
"<>" { yylval.fn = 3; return CMP; }
"==" { yylval.fn = 4; return CMP; }
">=" { yylval.fn = 5; return CMP; }
"<=" { yylval.fn = 6; return CMP; }
		/* keywords */
"Module"	{ yylval.s = yytext; return MODULE;}
"Sub"   { yylval.s = yytext; return SUB;}
"End"		{ yylval.s = yytext; return END;}
"Dim"   { yylval.s = yytext; return DIM;}
"Function"   { yylval.s = yytext; return FUNCTION;}
"Select"   { yylval.s = yytext; return SELECT;}
"if" { return IF; }
"then" { return THEN; }
"else" { return ELSE; }
"while" { return WHILE; }
"do" { return DO; }
	/* names */
{ID}  {yylval.s = yytext; return IDENTIFIER;}
[-+]?[0-9]+"."[0-9]*{EXP}? |
"."?[0-9]+{EXP}? { yylval.d = atof(yytext); return NUMBER; }
"//".* ;
[ \t] ;/* ignore whitespace */
\\\n { printf("c> "); } /* ignore line continuation */
\n { line_num++; }
. { yyerror("Mystery character %c\n", *yytext); }
%%
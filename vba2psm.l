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
"+"     { return PLUS; }
"-"     { return MINUS; }
"*"     { return AST; }
"/"     { return SLASH; }
"="     { return EQUAL; }
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
"Module"	{ return MODULE;}
"Public" {return PUBLIC;}
"Sub"   { return SUB;}
"End"		{ return END;}
"Dim"   { return DIM;}
"Function"   { return FUNCTION;}
"Select"   { return SELECT;}
"Case" { return CASE;}
"Is" { return IS_OPERATOR;}
"To" { return TO_OPERATOR;}
"As" {return AS;}
"Integer" {return INTEGER;}
"String" {return TSTRING;}
"Double" {return DOUBLE;}
"if" { return IF; }
"then" { return THEN; }
"else"|"Else" { return ELSE; }
"while" { return WHILE; }
"do" { return DO; }
"Attribute" {return ATTRIBUTE;}
"VB_Name" {return VB_NAME;}
\"(\\.|\"\"|[^"\n])*\" { yylval.t= yytext; return STRING; }
	/* names */
{ID}  {yylval.s = lookup(yytext); return IDENTIFIER;}
[-+]?[0-9]+"."[0-9]*{EXP}? |
"."?[0-9]+{EXP}? { yylval.d = atof(yytext); return NUMBER; }
"//".* ;
[ \t] ;/* ignore whitespace */
\\\n { printf("c> "); } /* ignore line continuation */
\n { line_num++; }
. { yyerror("Mystery character %c\n", *yytext); }
%%
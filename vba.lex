%option noyywrap nodefault yylineno

    /*** Definition section ***/
%{
    #include <stdio.h>
%}

%%
    /*** Rules sections ***/
[ \t\n] ;
[0-9]+ {printf("Saw an intenger: %s\n", yytext);}
. ;
%%
    /*** C Code section ***/


/* heading.h */
#ifndef _HEADING
#define _HEADING
#define YY_NO_UNPUT

# include <stdio.h>
# include <stdlib.h>
# include <stdarg.h>
# include <string.h>
# include <math.h>
# include "pscodegen.h"

/* interface to the lexer */
extern int yylineno; /* from lexer */
void yyerror(char *s, ...);

#endif
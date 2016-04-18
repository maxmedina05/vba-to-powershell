/** 
 * @file printString.c
 * @brief Realización de la función printString.
 */
#include <stdlib.h>
#include "generators.h"
extern int yylineno;

/*
 * Generador de impresión de una string.
 * @param dest		Archivo en el que se guardara el codigo c.
 * @param strPtr	String a imprimir.
 * @return Estado de la ejecución.
 */
int printString(FILE * dest, char * strPtr) {
	fprintf(dest, "\t\"%s\"\n", strPtr);
	return 0;
}

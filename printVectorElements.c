/** 
 * @file printVectorElements.c
 * @brief Realización de la función printVectorElements.
 */
#include <stdlib.h>
#include "generators.h"
extern int yylineno;

/*
 * Generador de impresión de un vector.
 * @param dest				Archivo en el que se guardara el codigo c.
 * @param vectorIDSrc		Identificador del vector que se cuenta.
 * @return Estado de la ejecución.
 */
int printVectorElements(FILE * dest, char vectorIDSrc) {
	/* Chequeo de existencia del vector de origen. */
	if ( NULL == vectorTable[vectorIDSrc - 'a'] ) {
		return 1;
	}
	/* Impresion de los valores del vector */
	fprintf(dest, "\t$%c\n", vectorIDSrc);
	return 0;
}

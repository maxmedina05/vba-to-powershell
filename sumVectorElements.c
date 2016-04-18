/**
 * @file sumVectorElements.c
 * @brief Realización de la función sumVectorElements.
 */
#include <stdio.h>
#include <stdlib.h>
#include "generators.h"
extern int yylineno;

/*
 * Generador de sentencia de suma de los elementos de un vector
 * @param dest				Archivo en el que se guardara el codigo c.
 * @param firstTime			Primera vez que se emplea el generador para el vector destino.
 * @param vectorIDTarget	Identificador del vector donde se guarda la suma.
 * @param vectorIDSrc		Identificador del vector que se suma.
 * @return Estado de la ejecución.
 */
int sumVectorElements(FILE * dest, int firstTime, char vectorIDTarget, char vectorIDSrc) {
	fprintf(dest, "\n# Generacion de suma %c <- %c (linea %d)\n",
	vectorIDTarget, vectorIDSrc, yylineno);
	/* Chequeo de existencia del vector de origen. */
	if ( NULL == vectorTable[vectorIDSrc - 'a'] ) {
		return 1;
	}
	/* Suma de los valores del vector */
	fprintf(dest, "\t$%c= 0\n", vectorIDTarget);
	fprintf(dest, "\t$%c | foreach-object -Process { $%c += $_ }\n", vectorIDSrc, vectorIDTarget);
	
	return 0;
}

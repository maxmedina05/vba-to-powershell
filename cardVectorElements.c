/**
 * @file cardVectorElements.c
 * @brief Realización de la función cardVectorElements.
 */
#include <stdlib.h>
#include "generators.h"
extern int yylineno;

/*
 * Generador de sentencia de cardinalidad de un vector
 * @param dest				Archivo en el que se guardara el codigo c.
 * @param firstTime			Primera vez que se emplea el generador para el vector destino (1 = true, 0 = false)
 * @param vectorIDTarget	Identificador del vector donde se guarda la cardinalidad.
 * @param vectorIDSrc		Identificador del vector que se cuenta.
 * @return Estado de la ejecución.
 * @bug Error colosal en la realización: no tiene en cuenta que se trata de una cola y no de un arreglo.
 * Todo el código es actualmente un disparate :()
 */
int cardVectorElements(FILE * dest, int firstTime, char vectorIDTarget, char vectorIDSrc) {
	fprintf(dest, "\n# Generacion de cardinalidad de %c a %c (linea %d)\n",
	vectorIDSrc, vectorIDTarget, yylineno);

	/* Codigo de calculo de la cardinalidad en el compilado */
	//fprintf(dest, "\tappendQueu(%c, lenQueu(%c));\n", vectorIDTarget, vectorIDSrc);
	fprintf(dest, "\t$%c= $%c.length\n", vectorIDTarget, vectorIDSrc);

	return 0;
}

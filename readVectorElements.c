/** 
 * @file readVectorElements.c
 * @brief Realización de la función readVectorElements.
 */
#include <stdlib.h>
#include "generators.h"
extern int yylineno;

/*
 * Generador de lectura de un vector por consola
 * @param dest				Archivo en el que se guardara el codigo c.
 * @param vectorID 			Identificador del vector que se lee.
 * @return Estado de la ejecución.
 */
int readVectorElements(FILE * dest, char vectorID) {
	queu newVec= newQueu();
	if ( vectorTable[vectorID - 'a'] != NULL ) {
		/* Liberar la cola existente (en compilacion) */
		FREEQUEU(vectorTable[vectorID - 'a']);
		/* Liberar la cola existente (en tiempo de ejecucion) */
		fprintf(dest, "\tFREEQUEU(%c);\n", vectorID);
	}
	fprintf(dest, "\tqueu %c= newQueu();\n", vectorID);
	vectorTable[vectorID - 'a']= newVec;

	return 0;
}

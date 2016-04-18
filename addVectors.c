/**
 * @file addVectors.c
 * @brief Realización de la función addVectors.
 */
#include <stdio.h>
#include <stdlib.h>
#include "generators.h"
extern int yylineno;

/*
 * Generador de sentencia de suma de los elementos de 2 vectores término a término.
 * @param dest				Archivo en el que se guardara el codigo c.
 * @param firstTime			Primera vez que se emplea el generador para el vector destino.
 * @param vectorIDTarget	Identificador del vector donde se guarda la suma.
 * @param vectorIDSrc1		Identificador del primer vector que se suma.
 * @param vectorIDSrc2		Identificador del segundo vector que se suma.
 * @return Estado de la ejecución. Diferente de 0 si hay error.
 */
int addVectors(FILE * dest, int firstTime, char vectorIDTarget, char vectorIDSrc1, char vectorIDSrc2) {
	fprintf(dest, "\n# Generacion de suma %c <- %c + %c (linea %d)\n",
	vectorIDTarget, vectorIDSrc1, vectorIDSrc2, yylineno);
	/* Chequeo de existencia del vector1 de origen. */
	if ( NULL == vectorTable[vectorIDSrc1 - 'a'] ) {
		return 1;
	}
	int lenSrc1= lenQueu(vectorTable[vectorIDSrc1 - 'a']);
	/* Chequeo de existencia del vector2 de origen. */
	if ( NULL == vectorTable[vectorIDSrc2 - 'a'] ) {
		return 2;
	}
	int lenSrc2= lenQueu(vectorTable[vectorIDSrc2 - 'a']);
	/* Reparacion del vector resultado. Se sobreescribe si existe. */
	if ( NULL != vectorTable[vectorIDTarget - 'a'] ) {
		freeQueu(vectorTable[vectorIDTarget - 'a']);
	}
	vectorTable[vectorIDTarget - 'a']= newQueu();
	
	fprintf(dest, "# Inicializar vector target");
	fprintf(dest, "\n\t$%c = @()\n", vectorIDTarget);
	fprintf(dest, "\n# Ciclo que recorre las dos listas y asigna al vector target la suma de los elementos que hay en ella");
	fprintf(dest, "\nfor($ii = 0; $ii -le $%c; $ii++){\n\t$%c += $%c[$ii] + $%c[$ii]\n}\n",vectorIDSrc1, vectorIDTarget, vectorIDSrc1, vectorIDSrc2 );

	return 0;
}

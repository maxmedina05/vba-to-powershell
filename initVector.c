/**
 * @file initVector.c
 * @brief Fuente de la realización de la función initVector
 */
#include <stdio.h>
#include "generators.h"
extern int yylineno;

/*
 * Generador de sentencia de declaración/asignación de un vector
 * @param dest		Archivo en el que se guardara el codigo c.
 * @param firstTime Primera vez que se emplea el generador para el vector.
 * @param vectorID	Identificador del vector.
 * @param vect 		Cola de double a asignar.
 * @return Estado de la ejecución.
 * @remark Fue detectado un error grave de realización, que fue corregido.
 * @since 2/18/2016 10:29:41 AM
 */
int initVector(FILE * dest, int firstTime, char vectorID, queu vect) {
	fprintf(dest, "\n# Generacion de asignacion %c <- (linea %d)\n",
	vectorID, yylineno);
	doubleElem *current= NULL;
	if ( NULL == vect || NULL == dest )
		return 1;
	/* Generación del código PowerShell */
	/* Llenado del vector */
	fprintf(dest, "\t$%c= @(", vectorID);
	doubleElem *number= vect->first;
	int i = 0;
	for (i= lenQueu(vect) - 1; i > 0; i-- ) {
		fprintf(dest, "%f, ", number->val);
		number= number->next;
	}
	fprintf(dest, "%f)\n", number->val);
	return 0;
}

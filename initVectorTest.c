/**
 * @file initVectorTest.c
 * @brief Fuente de la prueba de initVector
 */
#include <stdio.h>
#include <stdlib.h>
#include "generators.h"

/**
 * Vector donde se asigna.
 */
static char vector= 'x';
/**
 * Valores en el vector.
 */
static double vals[]= { 2.3, 45.7, 18.9, -3.1416 };
/**
 * Obtiene la longitud del arreglo estático.
 */
#define ARRAYLEN(x,t) (sizeof(x)/sizeof(t))

/**
 * Cola de double
 */
static queu cola= NULL;

/**
 * Contador de línea
 *
 * Este simbolo tiene sentido como parte del proceso de compilación,
 * donde representa el número de línea del fuente. En esta aplicación,
 * no tiene sentido y se le da un valor arbitrario.
 */
int yylineno= 911;

/**
 * Convierte un arreglo de double en una cola de double.
 * @param[in]	x	Arreglo de double.
 * @param[in]	len Longitud del arreglo.
 * @return Cola obtenida.
 */
queu array2queu(double x[], int len) {
	int i;
	queu q= newQueu();
	for ( i= 0; i < len; i++ ) {
		q= appendQueu(q, x[i]);
	}

	return q;
}

/**
 * Punto de entrada de la aplicación de prueba.
 *
 * @param[in]	argc No se usa.
 * @param[in]	argv No se usa.
 *
 * Se llena una cola de double con los elementos de un arreglo
 * y se aplica el generador de asignación de un vector.
 *
 * @return Siempre EXIT_SUCCESS
 */
int main(int argc, char *argv[]) {
	printf("Prueba de la funcion initVector\n\n");

	cola= array2queu(vals, ARRAYLEN(vals,double));
	printf("Primera vez:\n");
	initVector(stdout, vectorTable[vector - 'a'] == NULL, vector, cola);
	vectorTable[vector - 'a']= cola;
	printf("Segunda vez:\n");
	initVector(stdout, vectorTable[vector - 'a'] == NULL, vector, cola);
	vectorTable[vector - 'a']= cola;

	return EXIT_SUCCESS;
}

/**
 * @file SumQueu.c
 * @brief Realización de la función SumQueu
 */
#include "generators.h"

/*
 * Obtiene la suma los elementos de la cola.
 * @param[in]	q 	Cola
 * @return Suma de los elementos de la cola.
 */
double SumQueu(queu q) {
	double s= 0.0;
	doubleElem *current= NULL;
	if ( NULL != q ) {
		current= q->first;
		while ( NULL != current ) {
			s += current->val;
			current= current->next;
		}
	}
	return s;
}

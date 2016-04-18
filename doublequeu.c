/**
 * @file doublequeu.c
 * @brief Realización de las funciones de cola de double.
 */
#include <stdlib.h>
#include "generators.h"

/*
 * Crea una cola de double vacía.
 * @return Nueva cola. Si hay error, es NULL.
 */
queu newQueu() {
	queu n = (queu)malloc(sizeof(headQueu));
	if ( NULL != n ) {
		n->len= 0;
		n->first= n->last= NULL;
	}
	return n;
}

/*
 * Agrega un double a la cola.
 * @param[in,out]	q 	Cola donde se agrega el double.
 * @param[in]		d 	double a agregar
 * @return			La cola donde se agregó o bien NULL si hubo error.
 */
queu appendQueu(queu q, double d) {
	if ( NULL == q )
		return NULL;
	doubleElem *nuevo = (doubleElem*)malloc(sizeof(doubleElem));
	if ( NULL != nuevo ) {
		nuevo->val = d; nuevo->next= NULL;
		if ( q->last )
			(q->last)->next= nuevo;
		q->last= nuevo;
		if ( NULL == q->first ) /* Es el primero de la cola */
			q->first= q->last;
		q->len++;
	}
	return (NULL != nuevo)? q : NULL;
}

/*
 * Obtiene longitud de la cola
 * @param[in]	q 	Cola
 * @return Longitud de la cola. -1 indicará error.
 */
int lenQueu(queu q) {
	if ( q == NULL )
		return -1;
	return q->len;
}

/*
 * Libera cola de double.
 * @param[in]	q 	Cola
 */
void freeQueu(queu q) {
	if ( NULL == q )
		return;

	doubleElem *current= NULL;
	doubleElem *next;
	current= q->first;
	while ( NULL != current ) {
		next= current->next;
		free(current);
		current= next;
	}
	free(q);
}

/*
 * Obtiene un elemento de la cola.
 * @param[in]	q 	Cola
 * @param[in]	pos Posición (índice) en la cola.
 * @warning		Debe garantizarse que el índice no sea superior al mayor en la cola.
 */
double getDouble(queu q, int pos) {
	doubleElem *current= NULL;
	int i= 0;
	double v= 0.0;
	if ( (NULL != q) && (pos >= 0) ) {
		current= q->first;
		while ( (NULL != current) && (i != pos) ) {
			current= current->next;
			i++;
		}
		if ( NULL != current )
			v= current->val;
	}

	return v;
}

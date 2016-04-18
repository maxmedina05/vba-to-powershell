/**
 * @file generators.h
 * @brief Tipos y prototipos de generadores y funciones run-time de VBA
 */
#ifndef _GENERATORS_H
#define _GENERATORS_H
#include <stdio.h>

/**
 * Elemento de cola de double
 */
typedef struct _doubleElem {
	/** Valor del double */
	double val;
	/** Puntero al siguiente elemento */
	struct _doubleElem *next;
} doubleElem;

/**
 * Cabeza de la cola.
 * @since 2/17/2016 11:29:07 AM
 */
typedef struct _headQueu {
	/** Cantidad de elementos en la cola */
	int len;
	/** Puntero al primer elemento de la cola */
	doubleElem *first;
	/** Puntero al último elemento de la cola */
	doubleElem *last;
} headQueu;

/**
 * Cola de double
 *
 * La cola está representada por un puntero a la cabeza
 * de la cola.
 */
typedef headQueu * queu;

/**
 * Crea una cola de double vacía.
 * @return Nueva cola. Si hay error, es NULL.
 */
queu newQueu();

/**
 * Agrega un double a la cola.
 * @param[in,out]	q 	Cola donde se agrega el double.
 * @param[in]		d 	double a agregar
 * @return			La cola donde se agregó o bien NULL si hubo error.
 */
queu appendQueu(queu q, double d);

/**
 * Obtiene longitud de la cola
 * @param[in]	q 	Cola
 * @return Longitud de la cola. -1 indicará error.
 */
int lenQueu(queu q);

/**
 * Obtiene la suma los elementos de la cola.
 * @param[in]	q 	Cola
 * @return Suma de los elementos de la cola.
 */
double SumQueu(queu q);

/**
 * Libera cola de double.
 * @param[in]	q 	Cola
 * @since 2/18/2016 10:07:27 AM
 */
void freeQueu(queu q);

/**
 * Empleo seguro de la función freeQueu()
 * @since 2/18/2016 10:05:59 AM
 */
#define FREEQUEU(x)	freeQueu((x)); (x)= NULL

/**
 * Obtiene un elemento de la cola.
 * @param[in]	q 	Cola
 * @param[in]	pos Posición (índice) en la cola.
 * @warning		Debe garantizarse que el índice no sea superior al mayor en la cola.
 */
double getDouble(queu q, int pos);

/**
 * Tabla de vectores
 *
 * El elemento de la tabla es la cola de double del vector asignado.
 *
 * @warning Esta tabla es para uso interno del compilador y <em>no</em>
 * está presente en el código generado por éste.
 */
extern queu vectorTable['z' - 'a' + 1];

/**
 * Generador de sentencia de declaración/asignación de un vector
 * @param dest		Archivo en el que se guardara el codigo c.
 * @param firstTime Primera vez que se emplea el generador para el vector.
 * @param vectorID	Identificador del vector.
 * @param vect 		Cola de double a asignar.
 * @return Estado de la ejecución.
 * @remark Fue detectado un error grave de realización, que fue corregido.
 * @since 2/18/2016 10:29:41 AM
 */
int initVector(FILE * dest, int firstTime, char vectorID, queu vect);

/**
 * Generador de sentencia de declaración/asignación de una variable
 * @param dest		Archivo en el que se guardara el codigo c.
 * @param firstTime Primera vez que se emplea el generador para el vector.
 * @param vectorID	Identificador del vector.
 * @param vect 		Cola de double a asignar.
 * @return Estado de la ejecución.
 * @remark Fue detectado un error grave de realización, que fue corregido.
 * @since 2/18/2016 10:29:41 AM
 */
int initVariable(FILE * dest, int firstTime, char* varName, queu vect);

/**
 * Generador de sentencia de suma de los elementos de un vector
 * @param dest				Archivo en el que se guardara el codigo c.
 * @param firstTime			Primera vez que se emplea el generador para el vector destino.
 * @param vectorIDTarget	Identificador del vector donde se guarda la suma.
 * @param vectorIDSrc		Identificador del vector que se suma.
 * @return Estado de la ejecución.
 */
int sumVectorElements(FILE * dest, int firstTime, char vectorIDTarget, char vectorIDSrc);

/**
 * Generador de sentencia de cardinalidad de un vector
 * @param dest				Archivo en el que se guardara el codigo c.
 * @param firstTime			Primera vez que se emplea el generador para el vector destino (1 = true, 0 = false)
 * @param vectorIDTarget	Identificador del vector donde se guarda la cardinalidad.
 * @param vectorIDSrc		Identificador del vector que se cuenta.
 * @return Estado de la ejecución.
 */
int cardVectorElements(FILE * dest, int firstTime, char vectorIDTarget, char vectorIDSrc);

/**
 * Generador de sentencia de suma de los elementos de 2 vectores término a término.
 * @param dest				Archivo en el que se guardara el codigo c.
 * @param firstTime			Primera vez que se emplea el generador para el vector destino.
 * @param vectorIDTarget	Identificador del vector donde se guarda la suma.
 * @param vectorIDSrc1		Identificador del primer vector que se suma.
 * @param vectorIDSrc2		Identificador del segundo vector que se suma.
 * @return Estado de la ejecución. Diferente de 0 si hay error.
 * @since 2/17/2016 12:45:38 PM
 */
int addVectors(FILE * dest, int firstTime, char vectorIDTarget, char vectorIDSrc1, char vectorIDSrc2);

/**
 * Generador de impresión de un vector.
 * @param dest				Archivo en el que se guardara el codigo c.
 * @param vectorIDSrc		Identificador del vector que se cuenta.
 * @return Estado de la ejecución.
 */
int printVectorElements(FILE * dest, char vectorIDSrc);

/**
 * Generador de lectura de un vector por consola
 * @param dest				Archivo en el que se guardara el codigo c.
 * @param vectorID 			Identificador del vector que se lee.
 * @return Estado de la ejecución.
 * @since 2/22/2016 9:35:12 PM
 */
int readVectorElements(FILE * dest, char vectorID);

/**
 * Generador de impresión de una string.
 * @param dest				Archivo en el que se guardara el codigo c.
 * @param strPtr			String a imprimir.
 * @return Estado de la ejecución.
 */
int printString(FILE * dest, char * strPtr);

#endif

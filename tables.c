/**
 * @file tables.c
 * @brief Símbolos globales del compilador
 */
#include "generators.h"
 
/*
 * Tabla de vectores
 *
 * El elemento de la tabla es la cola de double del vector asignado.
 * @warning Esta tabla es para uso interno del compilador y <em>no</em>
 * está presente en el código generado por éste.
 */
queu vectorTable['z' - 'a' + 1];

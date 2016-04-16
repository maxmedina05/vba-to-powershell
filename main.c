#include "heading.h"

extern int yylineno; /* from lexer */
extern FILE *yyin;
extern FILE *yyout;

void yyerror(char *s);
// prototype of bison-generated parser function
int yyparse();

/**
 * Handler del archivo de salida compilado.
 */
static FILE *outH= NULL;

/**
 * Handler del archivo de entrada fuente SISLA.
 */
static FILE *inH= NULL;

/**
 * Punto de entrada de la aplicación.
 *
 * @param[in]	argc	Cantidad de parámetros en la línea comando.
 * @param[in]	argv	argv[0] y argv[1] se corresponden con los archivos
 *						de entrada y salida. Si faltan, se asumen la entrada
 *						y salida standard.
 */

int main(int argc, char *argv[]){
	fprintf(stderr, "Traductor VBA -> PowerShell\n");
	fprintf(stderr, "---------- ----- -- ----------\n\n");
	switch ( argc ) {
		case 3:
			outH= fopen(argv[2], "w");
			if ( NULL == outH ) {
				fprintf(stderr, "Imposible salida hacia %s\n", argv[2]);
				return EXIT_FAILURE;
			}
			fprintf(stderr, "Salida hacia %s\n", argv[2]);
		case 2:
			inH= fopen(argv[1], "r");
			if ( NULL == inH ) {
				fprintf(stderr, "Imposible entrada desde %s\n", argv[1]);
				if ( NULL != outH )
					fclose(outH);
				return EXIT_FAILURE;
			}
			fprintf(stderr, "Entrada de %s\n", argv[1]);
			break;
	}
	if ( NULL != inH )
		yyin= inH;
	if ( NULL != outH )
		yyout= outH;
	fprintf(yyout, "# El Codigo Fuente es: %s\n", argv[1]);
	fflush(yyout);
	yyparse();
	fprintf(stderr, "Fuente compilada generada...\n");
	if ( NULL != inH )
		fclose(inH);
	if ( NULL != outH )
		fclose(outH);

	return EXIT_SUCCESS;
}

void yyerror(char *s) {
	fprintf(stderr, "parse error on line %d! Mesage: %s\n",yylineno, s);
	// might as well halt now:
	exit(-1);
}
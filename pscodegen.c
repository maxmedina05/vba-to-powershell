#include "heading.h"

extern int yylineno;

std::string stringBuilder(int n_args, ...) {
	std::stringstream ss;
	va_list vl;
	va_start(vl, n_args);
	for (int i = 1; i <= n_args; i++) {
		char* arg = va_arg(vl, char*);
		if (i < n_args)
			ss << arg << " ";
		else
			ss << arg;
	}
	va_end(vl);
	return ss.str();
}

std::string stringBuilder(int n_args, std::string d, ...) {
	std::stringstream ss;
	va_list vl;
	va_start(vl, n_args);
	for (int i = 1; i <= n_args; i++) {
		char* arg = va_arg(vl, char*);
		if (i < n_args)
			ss << arg << d;
		else
			ss << arg;
	}
	va_end(vl);
	return ss.str();
}

int initArray(FILE * dest, int firstTime, char* identifier, queu vect){
	fprintf(dest, "\n# Generacion de asignacion %s <- (linea %d)\n",
	identifier, yylineno);
	if ( NULL == vect || NULL == dest )
		return 1;
	/* Generación del código PowerShell */
	/* Llenado del vector */
	fprintf(dest, "\t$%s= @(", identifier);
	doubleElem *number= vect->first;
	for ( int i= lenQueu(vect) - 1; i > 0; i-- ) {
		fprintf(dest, "%f, ", number->val);
		number= number->next;
	}
	fprintf(dest, "%f)\n", number->val);
	return 0;
}

int initVariable(FILE * dest, int firstTime, char* identifier){
	fprintf(dest, "\n# Generacion de asignacion %s <- (linea %d)\n",
	identifier, yylineno);

	
}
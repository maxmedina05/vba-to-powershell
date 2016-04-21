#ifndef _PSCODEGEN_H
#define _PSCODEGEN_H

#include "generators.h"

std::string stringBuilder(int n_args, ...);
std::string stringBuilder(int n_args, char d , ...);

int initArray(FILE * dest, int firstTime, char* identifier, queu vect);
int initVariable(FILE * dest, int firstTime, char* identifier);



#endif //_PSCODEGEN_H
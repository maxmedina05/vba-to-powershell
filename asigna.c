#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {


	/* Generacion de asignacion x <- (linea 2) */
double *x= calloc(sizeof(double), 15);
	x[0]= 15.000000;
	printf("\t%f\n", x[0]);
	x[1]= 10.000000;
	printf("\t%f\n", x[1]);
	x[2]= 5.000000;
	printf("\t%f\n", x[2]);
	x[3]= 78.000000;
	printf("\t%f\n", x[3]);
	x[4]= 30.000000;
	printf("\t%f\n", x[4]);
	x[5]= 69.000000;
	printf("\t%f\n", x[5]);
	x[6]= 78.000000;
	printf("\t%f\n", x[6]);
	x[7]= 210.000000;
	printf("\t%f\n", x[7]);
	x[8]= 250.000000;
	printf("\t%f\n", x[8]);
	x[9]= 14.000000;
	printf("\t%f\n", x[9]);
	x[10]= 68.000000;
	printf("\t%f\n", x[10]);
	x[11]= 30.000000;
	printf("\t%f\n", x[11]);
	x[12]= 30.500000;
	printf("\t%f\n", x[12]);
	x[13]= 56.100000;
	printf("\t%f\n", x[13]);
	x[14]= 45.200000;
	printf("\t%f\n", x[14]);

	/* Generacion de asignacion y <- (linea 3) */
double *y= calloc(sizeof(double), 15);
	y[0]= 150.000000;
	printf("\t%f\n", y[0]);
	y[1]= 100.000000;
	printf("\t%f\n", y[1]);
	y[2]= 50.000000;
	printf("\t%f\n", y[2]);
	y[3]= 780.000000;
	printf("\t%f\n", y[3]);
	y[4]= 300.000000;
	printf("\t%f\n", y[4]);
	y[5]= 690.000000;
	printf("\t%f\n", y[5]);
	y[6]= 780.000000;
	printf("\t%f\n", y[6]);
	y[7]= 2100.000000;
	printf("\t%f\n", y[7]);
	y[8]= 2500.000000;
	printf("\t%f\n", y[8]);
	y[9]= 140.000000;
	printf("\t%f\n", y[9]);
	y[10]= 680.000000;
	printf("\t%f\n", y[10]);
	y[11]= 300.000000;
	printf("\t%f\n", y[11]);
	y[12]= 300.500000;
	printf("\t%f\n", y[12]);
	y[13]= 560.100000;
	printf("\t%f\n", y[13]);
	y[14]= 450.200000;
	printf("\t%f\n", y[14]);

	/* Terminacion con limpieza */
	free(x);
	free(y);

	return 0;
}

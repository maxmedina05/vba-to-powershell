# Makefile compilador Vba -> PowerShell
# Se ajustaron las reglas de construccion, que originalmente suponian
# la presencia algun tipo de port Windows de comandos habituales
# en unix/linux.
# Desde: 3/14/2016 8:33:40 PM

# Regla de compilacion de los objetos C.
%.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<
CC = gcc
CFLAGS	= -Wall
FLEX = C:\Dev\win_flex_bison\flex.exe
BISON = C:\Dev\win_flex_bison\bison.exe

SRCS = pscodegen.h generators.h pscodegen.c initVector.c tables.c doublequeu.c \
		sumVectorElements.c SumQueu.c cardVectorElements.c printVectorElements.c \
		printString.c readVectorElements.c addVectors.c
		
OBJS = pscodegen.o initVector.o tables.o vba2psm.lex.o vba2psm.tab.o \
		doublequeu.o sumVectorElements.o SumQueu.o cardVectorElements.o printVectorElements.o \
		printString.o readVectorElements.o addVectors.o
EXES = vba2psm.exe

all : exes

full: all docs vba2psm.jpg

tables.o : tables.c

SumQueu.o : generators.h SumQueu.c

printVectorElements.o : generators.h printVectorElements.c

readVectorElements.o : generators.h readVectorElements.c

printString.o : generators.h printString.c

sumVectorElements.o : generators.h sumVectorElements.c

cardVectorElements.o : generators.h cardVectorElements.c

doublequeu.o : generators.h doublequeu.c

initVector.o : generators.h initVector.c

addVectors.o : addVectors.c

# Construccion del compilador
vba2psm.tab.h vba2psm.tab.c : vba2psm.y
	$(BISON) -d vba2psm.y --graph=vba2psm.gv

vba2psm.jpg : vba2psm.gv
	dot -Tjpg vba2psm.gv -o vba2psm.jpg

vba2psm.lex.c : vba2psm.l vba2psm.tab.h
	$(FLEX) -o vba2psm.lex.c vba2psm.l

vba2psm.lex.o : vba2psm.lex.c

main.o : main.c

pscodegen.o:	pscodegen.h pscodegen.c
		$(CC) $(CFLAGS) -c pscodegen.c -o pscodegen.o

vba2psm.exe : main.o vba2psm.tab.o vba2psm.lex.o vba2psm.a
	$(CC) $(CFLAGS) -o vba2psm.exe main.o vba2psm.lex.o vba2psm.tab.o pscodegen.o -L. vba2psm.a

# Biblioteca de soporte del proyecto 3/27/2015 12:58:25 PM
vba2psm.a : pscodegen.o initVector.o tables.o doublequeu.o sumVectorElements.o \
				SumQueu.o cardVectorElements.o printVectorElements.o \
				printString.o readVectorElements.o addVectors.o
	ar -r vba2psm.a $?

objs : $(OBJS) vba2psm.a

exes : $(EXES)

# Regla modificada. Ver inicio.
doc/index.html : $(SRCS) Doxyfile
	if exist .\doc cmd /C "rd /S /Q .\doc"
	doxygen Doxyfile

# Inconsistencia corregida en la linea siguiente.
docs : doc/index.html

# Regla modificada. Ver inicio.
clean :
	cmd /C "del $(OBJS) $(EXES) vba2psm.a vba2psm.tab.h vba2psm.tab.c vba2psm.lex.c main.o"
	if exist .\doc cmd /C "rd /S /Q .\doc"
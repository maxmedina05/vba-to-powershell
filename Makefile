# Makefile

OBJS	=	bison.o lex.o main.o
CC		=	g++
RM		= del
CP    = copy
CFLAGS	= -g -Wall -ansi -pedantic

vba:	$(OBJS)
		$(CC) $(CFLAGS) $(OBJS) -o VBA2PSM1

lex.o:	lex.c
		$(CC) $(CFLAGS) -c lex.c -o lex.o

lex.c:	vba.lex
		flex vba.lex
		cmd /C "$(CP) lex.yy.c lex.c"

bison.o: bison.c
	$(CC) $(CFLAGS) -c bison.c -o bison.o

bison.c:	vba.y
		bison -d -v vba.y
		cmd /C "$(CP) vba.tab.c bison.c"
		fc vba.tab.h tok.h || $(CP) vba.tab.h tok.h

main.o:	main.c
		$(CC) $(CFLAGS) -c main.c -o main.o

lex.o yac.o main.o	: heading.h
lex.o main.o		: tok.h

clean:
	 cmd /C "$(RM) *.o *~ lex.c lex.o bison.c lex.yy.c vba.output tok.h vba.tab.c vba.tab.h main.o vbashell.exe"
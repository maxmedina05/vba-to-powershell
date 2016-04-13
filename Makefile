# Makefile

OBJS	=	lex.o main.o
CC		=	gcc
RM		= 	rm

vba:	$(OBJS)
		$(CC) $(OBJS) -o vbashell

lex.o:	lex.c
		$(CC) -c lex.c -o lex.o

lex.c:	vba.lex
		flex vba.lex
		xcopy lex.yy.c lex.c /-I

main.o:	main.c
		$(CC) -c main.c -o main.o

clean:         
	$(RM) lex.c lex.o lex.yy.c main.o vbashell.exe
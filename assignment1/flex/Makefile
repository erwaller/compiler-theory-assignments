lexer.exe: lex.yy.c
	gcc -lfl -o lexer.exe lex.yy.c

lex.yy.c: lexer.lex lexer.h
    flex lexer.lex

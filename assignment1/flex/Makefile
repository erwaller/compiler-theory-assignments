lexer: lex.yy.c
	gcc -lfl -o lexer lex.yy.c

lex.yy.c: lexer.lex lexer.h
	flex lexer.lex

clean:
	rm lex.yy.c
	rm lexer

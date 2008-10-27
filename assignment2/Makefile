calc: lex.yy.o parser.tab.o
	gcc -lfl -lm -o calc lex.yy.o parser.tab.o

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

parser.tab.o: parser.tab.c
	gcc -c parser.tab.c

lex.yy.c: lexer.lex lexer.h
	flex lexer.lex 

parser.tab.c: parser.y
	bison -d parser.y

sym_test: sym_test.c lib/symbol_tbl.c lib/symbol_tbl.h
	gcc -ggdb -o sym_test sym_test.c lib/symbol_tbl.c

clean:
	rm -f *.o
	rm -f lex.yy.c
	rm -f parser.tab.c
	rm -f calc
	rm -f sym_test

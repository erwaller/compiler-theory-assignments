simple: parser.tab.c lex.yy.c symbol_tbl.o ast.o
	gcc -lm -o simple parser.tab.c lex.yy.c symbol_tbl.o ast.o

symbol_tbl.o: lib/symbol_tbl.c lib/symbol_tbl.h
	gcc -c lib/symbol_tbl.c

ast.o: lib/ast.h lib/ast.c
	gcc -c lib/ast.c

parser.tab.c: parser.y
	bison -r all parser.y

lex.yy.c: lexer.lex
	flex lexer.lex

sym_test: sym_test.c lib/symbol_tbl.c lib/symbol_tbl.h
	gcc -ggdb -o sym_test sym_test.c lib/symbol_tbl.c
	
tests: symbol_tbl.o ast.o tests/list_test.c
	gcc -ggdb -o tests/list_test tests/list_test.c symbol_tbl.o ast.o
	
clean:
	rm -f *.o
	rm -f lex.yy.c
	rm -f parser.tab.* parser.output
	rm -f calc simple
	rm -f sym_test

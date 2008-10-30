simple: parser.tab.c lex.yy.c lexer.h
	gcc -lm -o simple parser.tab.c lex.yy.c lib/symbol_tbl.c

parser.tab.c: parser.y
	bison -r all parser.y

lex.yy.c: lexer.lex
	flex lexer.lex

sym_test: sym_test.c lib/symbol_tbl.c lib/symbol_tbl.h
	gcc -ggdb -o sym_test sym_test.c lib/symbol_tbl.c

clean:
	rm -f *.o
	rm -f lex.yy.c
	rm -f parser.tab.* parser.output
	rm -f calc simple
	rm -f sym_test

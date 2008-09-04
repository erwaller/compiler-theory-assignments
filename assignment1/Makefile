use_lexer.exe: use_lexer.o lexer.o
	gcc -o lexer.exe use_lexer.o lexer.o

use_lexer.o: use_lexer.c
	gcc -c use_lexer.c

lexer.o: lexer.c lexer.h
	gcc -c lexer.c

clean:
	rm -f *~
	rm -f *.exe
	rm -f *.o
	rm -f *.stackdump
	rm -f *.gch

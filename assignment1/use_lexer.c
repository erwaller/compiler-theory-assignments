#include <stdio.h>
#include <stdlib.h>
#include "lexer.h"

int main () {
	Symbol sym;
	
	init_lexer("input.txt");
	
	do {
		sym = get_sym();
		printf("%-15s", item_read);
		printSym(sym);
		printf("\n");
	} while (sym != eof);
	
	return 0;
}

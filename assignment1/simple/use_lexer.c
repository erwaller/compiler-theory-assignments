#include <stdio.h>
#include <stdlib.h>
#include "lexer.h"

int main () {
	Symbol sym;
	
	if (!init_lexer("input.txt"))
		return 0;
	
	do {
		sym = get_sym();
		printf("%d\n", cur_line);
		printf("line %3d, col %3d: %-15s", cur_line, cur_col, item_read);
		printSym(sym);
		printf("\n");
	} while (sym != eof);
	
	return 0;
}

#include <stdio.h>
#include <stdlib.h>
#include "lexer.h"

int main () {
	Symbol sym;
	
	while ((sym = get_sym()) != TOKEOF)
		printf("%s\t%s\n", printSym(sym), item_read);
	
	return 0;
}

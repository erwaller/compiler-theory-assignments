#include <stdio.h>
#include "lexer.h"

int main () {
	Symbol sym;
	Token toks[100];
	int sym_count = 0;
	
	init_lexer("simple.css");
	
	do {	
		sym = get_sym();
		toks[sym_count].sym = sym;
		toks[sym_count].line = cur_line;
		toks[sym_count].col = cur_col;
		if (sym == identifier)
			strcpy(toks[sym_count].word,item_read);
		++sym_count;
	} while (sym != eof);
	
	printf("%s\n",toks[0].word);
	
	return 0;
}

#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include "lexer.h"

/* Reads a single char from the stream.
Maintains column and line counts.*/
static char read_ch() {
	char ch = fgetc(source);
	++cur_col;
	if (ch == '\n') {
		++cur_line;
		cur_col = 0;
	}
	return ch;
}

/* Puts a single char back on the stream.
Maintains column and line counts */
static void put_back(const char ch) {
	ungetc(ch, source);
	--cur_col;
	if (ch == '\n') --cur_line;
}

int init_lexer(const char input_file[]) {
	if ((source = fopen(input_file, "r")) == NULL) return 0;
	if ((item_read = malloc(BUFSIZ * sizeof(int))) == NULL)
		return 0;
	cur_line = 1;
	cur_col = 0;
	return 1;
}

Symbol get_sym() {
	char ch;
	int item_len = 0;
	
	while ((ch = read_ch()) != EOF && isspace(ch))
		/* Ignore whitespace */;
	err_line = cur_line;
	err_col = cur_col;
	
	switch (ch) {
		case EOF: return eof;
		case '+': 
			item_read[item_len] = ch;
			ch = read_ch();
			switch (ch) {
				case '+':
					return plusplus;
				case '=':
					return pluseq;
				default:
					put_back(ch);
					return plus;
			}
		default:
			if (isalpha(ch)) {
				item_len = 0;
				do {
					item_read[item_len] = ch;
					++item_len;
					ch = read_ch();
				} while (ch != EOF && isalnum(ch));
				item_read[item_len] = '\0';
				put_back(ch);
				return identifier;
			}
	}
}

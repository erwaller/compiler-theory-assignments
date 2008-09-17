#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include "lexer.h"

/* Reads a single char from the stream.
Maintains column and line counts.*/
static char read_ch() {
	char ch = fgetc(stdin);
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
	ungetc(ch, stdin);
	--cur_col;
	if (ch == '\n') --cur_line;
}

Symbol get_sym() {
	char ch, ch1, ch2;
	int item_len = 0;
	
	while ((ch = read_ch()) != EOF && isspace(ch))
		/* Ignore whitespace */;
	err_line = cur_line;
	err_col = cur_col;
	
	switch (ch) {
		case EOF: return TOKEOF;
		case '+': 
			item_read[item_len] = ch;
			ch = read_ch();
			switch (ch) {
				case '+':
					++item_len;
					item_read[item_len] = ch;
					item_read[item_len+1] = '\0';
					return PLUSPLUS;
				case '=':
					++item_len;
					item_read[item_len] = ch;
					item_read[item_len+1] = '\0';
					return PLUSEQ;
				default:
					item_read[item_len+1] = '\0';
					put_back(ch);
					return PLUS;
			}
		case '=':
			item_read[item_len] = ch;
			ch = read_ch();
			switch (ch) {
				case '=':
					++item_len;
					item_read[item_len] = ch;
					item_read[item_len+1] = '\0';
					return EQUALS;
				default:
					item_read[item_len+1] = '\0';
					put_back(ch);
					return ASSIGN;
			}
		case '0':
			item_len = 0;
			item_read[item_len] = ch;
			ch = read_ch();
			if (ch == 'X' || ch == 'x') {
				++item_len;
				item_read[item_len] = ch;
				ch1 = read_ch();
				if (isdigit(ch1)) {
					++item_len;
					do {
						item_read[item_len] = ch1;
						++item_len;
						ch1 = read_ch();
					} while (isdigit(ch1));
					item_read[item_len] = '\0';
					put_back(ch1);
					return NUMBER;
				}
				put_back(ch1);
			}
			/* Reset and fall through to default */
			put_back(ch);
			ch = '0';
		default:
			if (isdigit(ch)) {
				item_len = 0;
				do {
					item_read[item_len] = ch;
					++item_len;
					ch = read_ch();
				} while (isdigit(ch));
				item_read[item_len] = '\0';
				put_back(ch);
				return NUMBER;
			} else if (isalpha(ch)) {
				item_len = 0;
				do {
					item_read[item_len] = ch;
					++item_len;
					ch = read_ch();
				} while (isalnum(ch) || ch == '_');
				item_read[item_len] = '\0';
				put_back(ch);
				return IDENTIFIER;
			}
	}
}

/* Debug */
char* printSym(const Symbol sym) {
	switch (sym) {
		case NUMBER:
			return "NUMBER";
		case IDENTIFIER:
			return "IDENTIFIER";
		case PLUS:
			return "PLUS";
		case PLUSPLUS:
			return "PLUSPLUS";
		case ASSIGN:
			return "ASSIGN";
		case EQUALS:
			return "EQUALS";
		case PLUSEQ:
			return "PLUSEQ";
		case TOKEOF:
			return "TOKEOF";
		default:
			return "uh oh";
	}
}
#include <stdio.h>
#include <stdlib.h>

#ifndef lexer_H
#define lexer_H

static FILE *source;
static int cur_line;
static int cur_col;
static int err_line;
static int err_col;
char *item_read;

typedef enum {
	number,
	identifier,
	plus,
	plusplus,
	assign,
	equals,
	pluseq,
	eof
} Symbol;

struct token {
	Symbol sym;
	int line;
	int col;
	char word[BUFSIZ];
};
typedef struct token Token;

/* Interface */
int init_lexer(const char input_file[]);
Symbol get_sym();

/* Debug */
void printSym(const Symbol sym);

/* Internal Functions */
static char read_ch();
static void put_back(const char ch);

#endif

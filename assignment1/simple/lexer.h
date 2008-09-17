#include <stdio.h>
#include <stdlib.h>

#ifndef lexer_H
#define lexer_H

static FILE *source;
static int cur_line = 1;
static int cur_col = 0;
static int err_line;
static int err_col;
char item_read[BUFSIZ];

typedef enum {
	NUMBER,
	IDENTIFIER,
	PLUS,
	PLUSPLUS,
	ASSIGN,
	EQUALS,
	PLUSEQ,
	TOKEOF
} Symbol;

/* Interface */
Symbol get_sym();

/* Debug */
char* printSym(const Symbol sym);

/* Internal Functions */
static char read_ch();
static void put_back(const char ch);

#endif

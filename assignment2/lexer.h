#include <stdlib.h>

#ifndef lexer_H
#define lexer_H

typedef enum { i, u, l, ul, ll, ull, d, f, ld, s, c } type;

int line_number = 1;
char filename[BUFSIZ];

char* debug_token(int);
void install_num(void);
void print_num(void);

#endif

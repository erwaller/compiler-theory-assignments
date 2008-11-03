#include <stdlib.h>

#ifndef lexer_H
#define lexer_H

int line_number = 1;
char filename[BUFSIZ];

char* debug_token(int);
void install_ident(void);
void install_num(void);
void print_num(void);
void install_string(void);

#endif

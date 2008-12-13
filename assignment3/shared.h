#ifndef shared_H
#define shared_H

#include "lib/symbol_tbl.h"
#include "lib/ast.h"
#include "parser.tab.h"

extern char* yytext;
extern int yyleng;
int line_number;
char filename[BUFSIZ];

typedef enum { i, u, l, ul, ll, ull, d, f, ld, s, c, n, tok, list } type;

#endif

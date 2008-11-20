#include "lib/symbol_tbl.h"
#include "lib/ast.h"

#ifndef shared_H
#define shared_H

extern char* yytext;
extern int yyleng;
extern int line_number;
extern char filename[];

typedef enum { i, u, l, ul, ll, ull, d, f, ld, s, c, n, tok } type;

#endif

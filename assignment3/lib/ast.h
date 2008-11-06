#include <stdlib.h>

#ifndef ast_H
#define ast_H

typedef enum {
    AST_BINOP,
    AST_NUM
} ast_nodetype;

typedef struct AST {
    struct AST *left, *right;
    ast_nodetype type;
    char binop;
    int num;
} ast;

ast* ast_newnode(int nodetype);

#endif

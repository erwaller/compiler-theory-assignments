#include <stdlib.h>
#include <stdio.h>

#ifndef ast_H
#define ast_H

typedef enum {
    AST_BINOP,
    AST_NUM,
    AST_DECL,
    AST_STMT,
    AST_BLOCK,
    AST_FUNCDEF
} ast_nodetype;

typedef struct AST_NODE ast;
struct AST_NODE {
    ast_nodetype type;
    ast* stmt_list;
};

ast* ast_stmt();
ast* ast_block();
ast* ast_block_addstmt();
ast* ast_funcdef();
void ast_print();

#endif

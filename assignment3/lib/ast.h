#include <stdlib.h>

#ifndef ast_H
#define ast_H

typedef enum {
    AST_BINOP,
    AST_NUM,
    AST_STMT,
    AST_BLOCK_LIST
} ast_nodetype;

typedef struct AST_NODE ast;
struct AST_NODE {
    ast_nodetype type;
    ast* stmt_list;
};

ast* ast_stmt();
ast* ast_block();
ast* ast_block_addstmt();

#endif

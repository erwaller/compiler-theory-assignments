#include <stdlib.h>
#include <stdio.h>

#ifndef ast_H
#define ast_H

typedef enum {
    AST_BINOP,
    AST_NUM,
    AST_DECLN,  // Declaration
    AST_DECLR,  // Declarator
    AST_STMT,
    AST_BLOCK,
    AST_FUNCDEF
} ast_nodetype;

typedef union AST_NODE ast;
union AST_NODE {
    struct { ast_nodetype type; ast* next_stmt;                     };  // Stmt
    struct { ast_nodetype type; ast* declr; ast* block;             };  // Funcdef
    struct { ast_nodetype type; ast* next_stmt; ast* first_stmt;    };  // Block
};

ast* ast_stmt();
ast* ast_decln();
ast* ast_declr();
ast* ast_block();
ast* ast_block_addstmt();
ast* ast_funcdef();
void ast_print();

#endif

#include "ast.h"

ast* ast_newnode(int nodetype) {
    ast *node;
    node = malloc(sizeof(ast));
    node->type = nodetype;
    return node;
}

ast* ast_stmt() {
    ast* node = ast_newnode(AST_STMT);
    return node;
}

ast* ast_block() {
    ast* node = ast_newnode(AST_BLOCK_LIST);
    return node;
}

ast* ast_block_addstmt(ast* block, ast* stmt) {
    ast* insert = block->stmt_list;
    while(insert != NULL)
        insert = insert->stmt_list;
    insert = stmt;
    return block;
}

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

ast* ast_decl() {
    ast* node = ast_newnode(AST_DECL);
    return node;
}

ast* ast_block() {
    ast* node = ast_newnode(AST_BLOCK);
    return node;
}

ast* ast_block_addstmt(ast* block, ast* stmt) {
    ast** insert;
    insert = &block->stmt_list;
    while(*insert != NULL)
        insert = &(*insert)->stmt_list;
    *insert = stmt;
    return block;
}

ast* ast_funcdef(ast* funcblock) {
    ast* node = ast_newnode(AST_FUNCDEF);
    node->stmt_list = funcblock;
    return node;
}

void ast_print(ast* ast) {
    static int indent;
    int i = indent;
    
    while(i) {
        printf("\t");
        --i;
    } 
    switch(ast->type) {
        case AST_FUNCDEF:
            printf("ast_funcdef\n");
            if(ast->stmt_list) {
                ++indent;
                ast_print(ast->stmt_list);
            }
            if (indent > 0)
                --indent;
            break;
        case AST_BLOCK:
            printf("ast_block\n");
            if(ast->stmt_list) {
                ++indent;
                ast_print(ast->stmt_list);
            }
            if (indent > 0)
                --indent;
            break;
        case AST_DECL:
            printf("ast_decl\n");
            if(ast->stmt_list)
                ast_print(ast->stmt_list);
            else if (indent > 0)
                --indent;
            break;
        case AST_STMT:
            printf("ast_stmt\n");
            if(ast->stmt_list)
                ast_print(ast->stmt_list);
            else if (indent > 0)
                --indent;
            break;
        default:
            fprintf(stderr, "BUG: Unexpectedly reached the default label in ast_print's switch\n");
    }
}

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

ast* ast_decln() {
    ast* node = ast_newnode(AST_DECLN);
    return node;
}

ast* ast_declr() {
    ast* node = ast_newnode(AST_DECLR);
    return node;
}

ast* ast_block() {
    ast* node = ast_newnode(AST_BLOCK);
    return node;
}

ast* ast_block_addstmt(ast* block, ast* stmt) {
    ast** insert;
    insert = &block->first_stmt;
    while(*insert != NULL)
        insert = &(*insert)->next_stmt;
    *insert = stmt;
    return block;
}

ast* ast_funcdef(ast* declr, ast* block) {
    ast* node = ast_newnode(AST_FUNCDEF);
    node->declr = declr;
    node->block = block;
    return node;
}

void ast_print(ast* ast) {
    static int indent;
    int i = indent;
    
    // So that we don't have to check that node pointers
    // are not null before we try to print them 
    if (ast == NULL) return;
    
    while(i) {
        printf("\t");
        --i;
    } 
    switch(ast->type) {
        case AST_FUNCDEF:
            printf("ast_funcdef\n");
            ++indent;
            ast_print(ast->declr);
            ast_print(ast->block);
            --indent;
            break;
        case AST_BLOCK:
            printf("ast_block\n");
            ++indent;
            ast_print(ast->first_stmt);
            --indent;
            ast_print(ast->next_stmt);
            break;
        case AST_DECLN:
            printf("ast_decln\n");
            ast_print(ast->next_stmt);
            break;
        case AST_DECLR:
            printf("ast_declr\n");
            break;
        case AST_STMT:
            printf("ast_stmt\n");
            ast_print(ast->next_stmt);
            break;
        default:
            fprintf(stderr, "BUG: Unexpectedly reached the default label in ast_print's switch\n");
    }
    return;
}

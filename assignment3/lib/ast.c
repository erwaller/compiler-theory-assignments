#include "ast.h"

ast* ast_newnode(int nodetype) {
    ast *node;
    node = malloc(sizeof(ast));
    node->type = nodetype;
    return node;
}

ast* ast_binop(int binop, ast* left, ast* right) {
    ast* node = ast_newnode(AST_BINOP);
    node->binop = binop;
    node->left = left;
    node->right = right;
    return node;
}

ast* ast_num(int value) {
    ast* node = ast_newnode(AST_NUM);
    node->num = value;
    return node;
}

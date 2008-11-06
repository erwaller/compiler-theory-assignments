#include "ast.h"

ast* ast_newnode(int nodetype) {
    ast *node;
    node = malloc(sizeof(ast));
    node->type = nodetype;
    return node;
}


#include <stdio.h>
#include "lib/ast.h"

int 
main ()
{
    ast *node;
    node = ast_newnode(AST_BINOP);
    node->binop = '+';
    node->left = ast_newnode(AST_NUM);
    node->left->num = 5;
    node->right = ast_newnode(AST_NUM);
    node->right->num = 10;
    return 0;
}

#include <stdio.h>
#include "lib/ast.h"

int 
main ()
{
    ast *node;
    node = ast_binop('+', ast_num(5), ast_num(10));
    return 0;
}

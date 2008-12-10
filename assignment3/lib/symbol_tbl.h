#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#ifndef symbol_tbl_H
#define symbol_tbl_H

#define SYM_TBL_LEN 3959

// These typedefs need to happen before ast.h is included
typedef struct SYMBOL symbol;
typedef struct SCOPE scope;
typedef struct SYMBOL_TBL symbol_tbl;

#include "ast.h"

/*  Functions return integer success codes 
 *      1   - operation successful
 *      0   - symbol undefined (for write_sym and read_sym)
              or symbol already exists (for new_sym)
 */

int init_symbol_tbl();

int open_scope();
int close_scope();

int new_sym();

int write_sym();
int read_sym();


struct SYMBOL {
    symbol* next;
    char* ident;
    ast* ast_node;
    int value;
};
struct SCOPE {
    scope* prev;
    symbol* buckets[SYM_TBL_LEN];
    char* file_start;
    int line_start;
    int is_func;        // Is this a function scope?
};
struct SYMBOL_TBL {
    scope *current, *global;
};

// Helper Stuff
unsigned long hash(char *str);
char* my_strcpy(char **dest_ptr, char *src);

#endif

#include <stdlib.h>
#define SYM_TBL_LEN 3959

#ifndef symbol_tbl_H
#define symbol_tbl_H

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

struct symbol {
    struct symbol* next;
    char* ident;
    int value;
};
struct scope {
    struct scope* prev;
    struct symbol* buckets[SYM_TBL_LEN];
    char* file_start;
    int line_start;
};
typedef struct {
    struct scope *current, *global;
} symbol_tbl;

// Helper Stuff
unsigned long hash(char *str);
char* my_strcpy(char **dest_ptr, char *src);

#endif

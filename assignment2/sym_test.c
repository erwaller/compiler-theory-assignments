#include <stdlib.h>
#include <stdio.h>
#include "lib/symbol_tbl.h"

int main () {
    symbol_tbl *sym_tbl;
    int test_val1 = 36, test_val2 = 10, dest = 0;
    
    init_symbol_tbl(&sym_tbl);
    
    new_sym(sym_tbl, "hello");
    write_sym(sym_tbl, "hello", &test_val1);
    
    open_scope(sym_tbl);
    
    new_sym(sym_tbl, "hello");
    new_sym(sym_tbl, "hello");
    write_sym(sym_tbl, "hello", &test_val2);
    read_sym(sym_tbl, "hello", &dest);
    printf("hello: %d\n", dest);
    
    close_scope(sym_tbl);
    
    read_sym(sym_tbl, "hello", &dest);
    printf("hello: %d\n", dest);
    
	printf("Hello Lexer!\n");
	return 0;
}

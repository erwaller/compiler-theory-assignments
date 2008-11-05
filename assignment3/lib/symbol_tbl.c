#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "symbol_tbl.h"

extern char filename[];
extern int line_number;

void* my_malloc(unsigned int size) {
    void *ret;
    if((ret = calloc(1, size)) == NULL) {
        fprintf(stderr, "Unable to allocate memory... Exiting\n");
        exit(1);
    }
    return ret;
}

int init_symbol_tbl(symbol_tbl **sym_tbl) {
    struct scope *global;
    global = my_malloc(sizeof(struct scope));
    *sym_tbl = my_malloc(sizeof(symbol_tbl));
    (*sym_tbl)->global = (*sym_tbl)->current = global;
    return 1;
}

int open_scope(symbol_tbl *sym_tbl) {
    struct scope *cur, *new;
    cur = sym_tbl->current;
    new = my_malloc(sizeof(struct scope));
    new->prev = cur;
    sym_tbl->current = new;
    return 1;
}

int close_scope(symbol_tbl *sym_tbl) {
    // destroy sym_tbl->current
    sym_tbl->current = sym_tbl->current->prev;
    return 1;
}

int new_sym(symbol_tbl *sym_tbl, char *ident) {
    struct symbol **bucket, *new_sym;
    bucket = &sym_tbl->current->buckets[hash(ident)%SYM_TBL_LEN];
    while(*bucket != NULL) {
        if(strcmp((*bucket)->ident, ident) == 0) {
            fprintf(stderr, "%s:%d:Error:Identifier previously declared in this scope: %s\n", filename, line_number, ident);
            return 0;
        }
        *bucket = (*bucket)->next;
    }
    *bucket = my_malloc(sizeof(struct symbol));
    my_strcpy(&(*bucket)->ident, ident);
    return 1;
}

// Just pass the int by value for now to simplify embedded actions
int write_sym(symbol_tbl *sym_tbl, char *ident, int src_val) {
    struct symbol *sym;
    struct scope *scope;
    scope = sym_tbl->current;
    do {
        sym = scope->buckets[hash(ident)%SYM_TBL_LEN];
        while(sym != NULL) {
            if(strcmp(sym->ident, ident) == 0) {
                sym->value = src_val;
                return 1;
            } else {
                sym = sym->next;
            }
        }
    } while((scope = scope->prev) != NULL);
    fprintf(stderr, "%s:%d:Error:Undefined variable: %s\n", filename, line_number, ident);
    return 0;
}

int read_sym(symbol_tbl *sym_tbl, char *ident, int *dest_val) {
    struct symbol *bucket, *sym;
    struct scope *scope;
    scope = sym_tbl->current;
    do {
        sym = scope->buckets[hash(ident)%SYM_TBL_LEN];
        while(sym != NULL) {
            if(strcmp(sym->ident, ident) == 0) {
                *dest_val = sym->value;
                return 1;
            } else {
                sym = sym->next;
            }
        }
    } while((scope = scope->prev) != NULL);
    fprintf(stderr, "%s:%d:Error:Undefined variable: %s\n", filename, line_number, ident);
    return 0;
}

// Helper Stuff

unsigned long hash(char *str) {
    unsigned long hash = 5381;
    int c;
    while (c = *str++)
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */
    return hash;
}

char* my_strcpy(char **dest_ptr, char *src) {
    *dest_ptr = my_malloc(sizeof(char)*strlen(src)+1);
    strncpy(*dest_ptr, src, strlen(src)+1);
    return *dest_ptr;
}


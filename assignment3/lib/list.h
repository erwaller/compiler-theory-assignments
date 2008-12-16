#include <stdlib.h>
#include <stdio.h>

#ifndef list_H
#define list_H

// lisp style cons list
typedef struct CONS cons;
struct CONS {
    cons *next, *prev;
    void *thing;
};

cons* list_push();
void list_concat();
int list_length();
cons* list_new();

#endif

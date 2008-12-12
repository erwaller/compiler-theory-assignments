#include "list.h"

cons* new_cons(void* thing) {
    cons *new;
    new = malloc(sizeof(cons));
    new->thing = thing;
    return new;
}

cons* list_push(cons* list, void* thing) {
    cons* new = new_cons(thing);
    if (list == NULL)
        return new;
    while(list->next != NULL)
        list = list->next;
    list->next = new;
    list->next->prev = list;
    return list; // Maybe we should return an unmodified list..
}

void list_concat(cons* list1, cons* list2) {
    if (list1 == NULL || list2 == NULL)
        fprintf(stderr, "BUG: Passing a null cons pointer to list_concat\n");
    while(list1->next != NULL)
        list1 = list1->next;
    list1->next = list2;
    list2->prev = list1;
}

int list_length(cons* list) {
    if (list == NULL)
        return 0;
        
    int length = 1;
    while(list->next != NULL) {
        list = list->next;
        ++length;
    }
    return length;
}
       


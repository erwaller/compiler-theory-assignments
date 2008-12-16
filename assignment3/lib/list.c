#include "list.h"

cons* new_cons(void* thing) {
    cons *new;
    new = malloc(sizeof(cons));
    new->thing = thing;
    return new;
}

// An empty list is just a NULL cons pointer
//   $$ is not initialized to NULL
//   $$ = list_new() is preferable to $$ = NULL
cons* list_new() {
    return NULL;
}

// Returns pointer to beginning of the list
cons* list_push(cons** list, void* thing) {
    cons *new = new_cons(thing), *step = *list;
    if (list == NULL)
        fprintf(stderr, "BUG: Passing null pointer to pointer to cons to list_push\n");
    if (*list == NULL) {
        *list = new;
        return new;
    }
    while(step->next != NULL)
        step = step->next;
    step->next = new;
    step->next->prev = step;
    return *list;
}

void list_concat(cons** plist1, cons** plist2) {
    cons *list1, *list2;
    if (plist1 == NULL || plist2 == NULL)
        fprintf(stderr, "BUG: Passing null pointer to pointer to cons to list_concat\n");
    if (*plist1 == NULL) {
        *plist1 = *plist2;
        return;
    }
    if (*plist2 == NULL) {
        return;
    }
    list1 = *plist1;
    list2 = *plist2;
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

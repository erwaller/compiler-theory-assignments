#include <stdlib.h>
#include "../lib/list.h"

void print_list (cons* list) {
    if (list == NULL) return;
    printf("%d\n", *(int*)list->thing);
    print_list(list->next);
}

int main () {
    int a1 = 1, a2 = 2, a3 = 3, a4 = 4;
    cons *list1, *list2;
    
    list1 = list_push(NULL, &a1);
    list_push(list1, &a2);
    
    list2 = list_push(NULL, &a3);
    list_push(list2, &a4);
    
    printf("list1:\n");
    print_list(list1);
    
    printf("list2:\n");
    print_list(list2);
    
    cons* testtt = NULL;
    list_concat(&testtt, &list1);
    printf("NULL+list1:\n");
    print_list(list1);
    
    list_concat(&list1, &list2);
    printf("list1+list2:\n");
    print_list(list1);
    
    testtt = NULL;
    list_concat(&list1, &testtt);
    printf("list1+NULL:\n");
    print_list(list1);
    
    printf("length of list1:\n");
    printf("%d\n", list_length(list1));
}

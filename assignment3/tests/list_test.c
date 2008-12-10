#include "../shared.h"
#include "../lib/ast.h"

void print_list (list* list) {
    list_item *cur;
    cur = list->head;
    while (cur != NULL) {
        printf("%d\n", *(int*)cur->thing);
        cur = cur->next;
    }
}

int main () {
    int a1 = 1, a2 = 2, a3 = 3, a4 = 4;
    list* list;
    list = list_new();
    list_push(list, &a1);
    list_push(list, &a2);
    list_push(list, &a3);
    list_push(list, &a4);
    print_list(list);
    list_reverse(list);
    print_list(list);
}

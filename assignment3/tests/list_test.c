#include "../shared.h"
#include "../lib/list.h"

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
    list *list1, *list2;
    list1 = list_newlist();
    list2 = list_newlist();
    list_push(list1, &a1);
    list_push(list1, &a2);
    list_push(list2, &a3);
    list_push(list2, &a4);
    printf("list1:\n");
    print_list(list1);
    printf("list2:\n");
    print_list(list2);
    list_concat(list1, list2);
    printf("list1+list2:\n");
    print_list(list1);
    list_reverse(list1);
    printf("list1+list2 reversed:\n");
    print_list(list1);
}

#include "ast.h"
#include "symbol_tbl.h"
#include "../parser.tab.h"

ast* ast_newnode(int nodetype) {
    ast *node;
    node = malloc(sizeof(ast));
    node->type = nodetype;
    return node;
}

ast* ast_stmt() {
    ast* node = ast_newnode(AST_STMT);
    return node;
}

ast* ast_decln(ast* decl_specs, ast* decl_list) {
    ast* node = ast_newnode(AST_DECLN);

    return node;
}

ast* ast_declr() {
    ast* node = ast_newnode(AST_DECLR);
    return node;
}

ast* ast_ddecl() {
    ast* node = ast_newnode(AST_DDECL);
    return node;
}

ast* ast_declspecs() {
    ast* node = ast_newnode(AST_DECLSPECS);
    return node;
}

void ast_declspecs_addstoragespec(ast* declspecs, int storage_spec) {

}
void ast_declspecs_addtypespec(ast* declspecs, int type_spec) {

}
void ast_declspecs_addtypequal(ast* declspecs, int type_qual) {

}

ast* ast_decllist() {
    ast* node = ast_newnode(AST_DECLLIST);
    return node;
}

void ast_decllist_adddeclr(ast* decl_list, ast* declr) {
}


list* list_new() {
    list *list;
    list = malloc(sizeof(list));
    list->head = list->tail = NULL;
    return list;
}
list_item* list_newlistitem(void* thing) {
    list_item *list_item;
    list_item = malloc(sizeof(list_item));
    list_item->thing = thing;
    return list_item;
}
void list_push(list* list, void* thing) {
    // The "prev" member of the first list entry and the
    // "next" member of the last list entry will be NULL
    list_item *list_item = list_newlistitem(thing);
    if (list->head == NULL)  {
        // List is empty
        list->head = list->tail = list_item;
    } else {
        list_item->prev = list->tail;
        list->tail->next = list_item;
        list->tail = list_item;
    }
}
void list_reverse(list* list) {
    list_item *cur, *next, *swap;
    cur = list->head;
    while(cur != NULL) {
        next = cur->next;
        swap = cur->prev;
        cur->prev = cur->next;
        cur->next = swap;
        cur = next;
    }
    swap = list->head;
    list->head = list->tail;
    list->tail = swap;
}

ast* ast_block() {
    ast* node = ast_newnode(AST_BLOCK);
    return node;
}

void ast_block_addstmt(ast* block, ast* stmt) {
    ast** insert;
    insert = &block->first_stmt;
    while(*insert != NULL)
        insert = &(*insert)->next_stmt;
    *insert = stmt;
}

ast* ast_funcdef(ast* declr, ast* block) {
    ast* node = ast_newnode(AST_FUNCDEF);
    node->declr = declr;
    node->block = block;
    return node;
}

ast* ast_var(scope* scope, char* ident) {
    ast* node = ast_newnode(AST_VAR);
    new_sym(scope, ident, node);
    return node;
}

void ast_var_addtype(ast* var, ast* new_type) {
    ast** insert;
    insert = &var->ctype;
    while(*insert != NULL)
        insert = &(*insert)->ctype;
    *insert = new_type;
}

ast* ast_pointer() {
    ast* node = ast_newnode(AST_POINTER);
    return node;
}

ast* ast_array(int size) {
    ast* node = ast_newnode(AST_ARRAY);
    node->size = size;
    return node;
}

void ast_print(ast* ast) {
    static int indent;
    int i = indent;
    
    // So that we don't have to check that node pointers
    // are not null before we try to print them 
    if (ast == NULL) return;
    
    while(i) {
        printf("    ");
        --i;
    } 
    switch(ast->type) {
        case AST_FUNCDEF:
            printf("ast_funcdef\n");
            INDENT(ast_print(ast->declr));
            INDENT(ast_print(ast->block));
            break;
        case AST_BLOCK:
            printf("ast_block\n");
            INDENT(ast_print(ast->first_stmt));
            ast_print(ast->next_stmt);
            break;
        case AST_DECLN:
            printf("ast_decln\n");
            //INDENT(ast_print(ast->decl_list));
            ast_print(ast->next_stmt);
            break;
        case AST_DECLR:
            printf("ast_declr\n");
            //ast_print(ast->next_declr);
            break;
        case AST_DECLLIST:
            printf("ast_decllist\n");
            //INDENT(ast_print(ast->first_declr));
            break;
        case AST_STMT:
            printf("ast_stmt\n");
            ast_print(ast->next_stmt);
            break;
        case AST_VAR:
            //ast_print(ast->storage_specs);
            //ast_print(ast->type_specs);
            //ast_print(ast->type_quals);
            printf("ast_var\n");
            INDENT(ast_print(ast->ctype));
            break;
        /*case AST_INTLISTITEM:
            switch(ast->val) {
                case EXTERN:    printf("extern "); break;
                case STATIC:    printf("static "); break;
                case AUTO:      printf("auto "); break;
                case REGISTER:  printf("register "); break;
                case VOID:      printf("void "); break;
                case CHAR:      printf("char "); break;
                case SHORT:     printf("short "); break;
                case INT:       printf("int "); break;
                case LONG:      printf("long "); break;
                case FLOAT:     printf("float "); break;
                case DOUBLE:    printf("double "); break;
                case SIGNED:    printf("signed "); break;
                case UNSIGNED:  printf("unsigned "); break;
                case CONST:     printf("const "); break;
                case RESTRICT:  printf("restrict "); break;
                case VOLATILE:  printf("volatile "); break;
                default:
                    fprintf(stderr, "BUG: Unexpectedly reached the default label in ast_print's AST_INTLISTITEM's switch\n");
            }
            ast_print(ast->next);
            break;*/
        case AST_POINTER:
            printf("ast_pointer\n");
            INDENT(ast_print(ast->ctype));
            break;
        case AST_ARRAY:
            printf("ast_array of length: %d\n", ast->size);
            INDENT(ast_print(ast->ctype));
            break;
        default:
            fprintf(stderr, "BUG: Unexpectedly reached the default label in ast_print's switch\n");
    }
    return;
}

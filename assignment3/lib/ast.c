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

ast* ast_ddecl() {
    ast* node = ast_newnode(AST_DDECL);
    return node;
}

ast* ast_block(ast* stmts) {
    ast* node = ast_newnode(AST_BLOCK);
    node->stmts = stmts;
    return node;
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
    node->ctype = ast_list();
    return node;
}
ast* ast_storagespec(int storage_spec) {
    ast* node = ast_newnode(AST_STORAGESPEC);
    node->val = storage_spec;
    return node;
}
ast* ast_typespec(int type_spec) {
    ast* node = ast_newnode(AST_TYPESPEC);
    node->val = type_spec;
    return node;
}
ast* ast_typequal(int type_qual) {
    ast* node = ast_newnode(AST_TYPEQUAL);
    node->val = type_qual;
    return node;
}

ast* ast_declspecs() {
    ast* node = ast_newnode(AST_DECLSPECS);
    node->type_quals = ast_list();
    node->type_specs = ast_list();
    node->storage_specs = ast_list();
    return node;
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

// AST specfic wrappers for the generic list lib
ast* ast_list() {
	ast* node = ast_newnode(AST_LIST);
	node->list = list_newlist();
    return node;
}
ast* ast_list_push(ast* ast_list, void* thing) {
    list_push(ast_list->list, thing);
}
void ast_list_concat(ast* ast_list1, ast* ast_list2) {
    list_concat(ast_list1->list, ast_list2->list);
}


void ast_print(ast* node) {
    static int indent;
    int i = indent;
    
    // So that we don't have to check that node pointers
    // are not null before we try to print them 
    if (node == NULL) return;
    
    while(i) {
        printf("    ");
        --i;
    } 
    switch(node->type) {
        case AST_FUNCDEF:
            printf("ast_funcdef\n");
            INDENT(ast_print(node->declr));
            INDENT(ast_print(node->block));
            break;
        case AST_BLOCK:
            printf("ast_block\n");
            //INDENT(ast_print(node->first_stmt));
            //ast_print(node->next_stmt);
            break;
        case AST_DECLLIST:
            printf("ast_decllist\n");
            //INDENT(ast_print(node->first_declr));
            break;
        case AST_STMT:
            printf("ast_stmt\n");
            //ast_print(node->next_stmt);
            break;
        case AST_VAR:
            printf("ast_var: %s\n", node->sym->ident);
            ast_print(node->ctype);
            break;
        case AST_TYPESPEC:
            switch(node->val) {
                case VOID:      printf("void\n"); break;
                case CHAR:      printf("char\n"); break;
                case SHORT:     printf("short\n"); break;
                case INT:       printf("int\n"); break;
                case LONG:      printf("long\n"); break;
                case FLOAT:     printf("float\n"); break;
                case DOUBLE:    printf("double\n"); break;
                case SIGNED:    printf("signed\n"); break;
                case UNSIGNED:  printf("unsigned\n"); break;
                default:
                    fprintf(stderr, "BUG: Unexpectedly reached the default label in ast_print's AST_STORAGESPEC's switch\n");
            }
            break;
        case AST_LIST:
            {
                //printf("encountered an ast_list of %d items\n", node->list->length);
                int old_indent = indent;
                ast* item = ast_list_first(node);
                while (item != NULL) {
                    ++indent;
                    ast_print(item);
                    item = ast_list_next(node);
                }
                indent = old_indent;
            }
            break;
        /*case AST_INTLISTITEM:
            switch(node->val) {
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
            ast_print(node->next);
            break;*/
        case AST_POINTER:
            printf("pointer to\n");
            break;
        case AST_ARRAY:
            printf("array of %d elements of type\n", node->size);
            break;
        default:
            fprintf(stderr, "BUG: Unexpectedly reached the default label in ast_print's switch\n");
    }
    return;
}

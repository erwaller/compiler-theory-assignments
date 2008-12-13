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
    node->ctype = NULL;
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
    node->type_quals = node->type_specs = node->storage_specs = NULL;
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

void list_print(cons* list, int indent) {
    if (list == NULL) return;
    ast_print((ast*)list->thing, indent);
    list_print(list->next, indent);
}

void ast_print(ast* node, int indent) {
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
            INDENT(ast_print(node->declr, indent));
            INDENT(ast_print(node->block, indent));
            break;
        case AST_BLOCK:
            printf("ast_block\n");
            //INDENT(ast_print(node->first_stmt, indent));
            //ast_print(node->next_stmt, indent);
            break;
        case AST_DECLLIST:
            printf("ast_decllist\n");
            //INDENT(ast_print(node->first_declr, indent));
            break;
        case AST_STMT:
            printf("ast_stmt\n");
            //ast_print(node->next_stmt, indent);
            break;
        case AST_VAR:
            printf("ast_var: %s\n", node->sym->ident);
            list_print(node->ctype, indent);
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
                printf("encountered a list\n");
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
            ast_print(node->next, indent);
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

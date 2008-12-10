#include <stdlib.h>
#include <stdio.h>

#ifndef ast_H
#define ast_H

// General Purpose List
typedef struct LIST_ITEM list_item;
struct LIST_ITEM {
    list_item *next, *prev;
    void *thing;
};
typedef struct LIST list;
struct LIST {
    list_item *head, *tail;
};
list* list_new();
void list_push();
void list_reverse();

typedef enum {
    AST_BINOP,
    AST_NUM,
    AST_DECLN,  // Declaration
    AST_DECLR,  // Declarator
    AST_DDECL,  // Direct declarator
    AST_DECLSPECS,
    AST_DECLLIST,
    AST_STMT,
    AST_BLOCK,
    AST_FUNCDEF,
    AST_VAR,
    AST_ARRAY,
    AST_POINTER,
    AST_LIST        // Special ast_node type that wraps the general purpose list
} ast_nodetype;

typedef union AST_NODE ast;
union AST_NODE {
    struct { ast_nodetype type; ast* next_stmt;                     };  // stmt
    struct { ast_nodetype type; ast* next_stmt; ast* first_stmt;    };  // block
    struct { ast_nodetype type; ast* next_stmt; list* decls;        };  // declaration
    struct { ast_nodetype type; ast* declr; ast* block;             };  // funcdef
    struct { ast_nodetype type; list* declrs;                       };  // decl_list
    struct { ast_nodetype type; ast *ctype, *pctype, *decl_specs;   };  // var
    struct { ast_nodetype type; ast *ctype, *pctype; int size;      };  // array
    struct { ast_nodetype type; ast *ctype, *pctype;                };  // pointer
    struct { ast_nodetype type;                                         // declspecs
             list *type_quals, *storage_specs, *type_specs;         };
    struct { ast_nodetype type; list* list;                         };  // list
};

ast* ast_stmt();
ast* ast_decln();
ast* ast_declr();
ast* ast_declspecs();
void ast_declspecs_addstoragespec();
void ast_declspecs_addtypespec();
void ast_declspecs_addtypequal();
ast* ast_decllist();
void ast_decllist_adddeclr();
ast* ast_block();
void ast_block_addstmt();
ast* ast_funcdef();
ast* ast_var();
void ast_var_addtype();
ast* ast_pointer();
ast* ast_array();
void ast_print();

#define INDENT(x) {++indent; x; --indent;}

#endif

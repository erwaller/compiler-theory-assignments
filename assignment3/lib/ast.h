#include <stdlib.h>
#include <stdio.h>

#ifndef ast_H
#define ast_H

#include "list.h"

// This typedef needs to happen before symbol_tbl.h is included
typedef union AST_NODE ast;
#include "symbol_tbl.h"

typedef enum {
    AST_BINOP,
    AST_NUM,
    AST_DDECL,  // Direct declarator
    AST_DECLLIST,
    AST_DECLSPECS,
    AST_STMT,
    AST_BLOCK,
    AST_FUNCDEF,
    AST_VAR,
    AST_ARRAY,
    AST_POINTER,
    AST_STORAGESPEC,
    AST_TYPESPEC,
    AST_TYPEQUAL,
    AST_LIST        // Special ast_node type that wraps the general purpose list
} ast_nodetype;

union AST_NODE {
	struct { ast_nodetype type; list* list;							};	// list (wrapped in ast)
    struct { ast_nodetype type;	                     				};  // stmt
	struct { ast_nodetype type; ast* stmts;							};  // block
    struct { ast_nodetype type; ast* declr; ast* block;             };  // funcdef
    struct { ast_nodetype type; ast* declrs;                        };  // decl_list
    struct { ast_nodetype type; ast *ctype; symbol* sym;            };  // var
                                // ctype is a linked list of type-nodes
    struct { ast_nodetype type; int size;                           };  // array
    struct { ast_nodetype type;                                     };  // pointer
    struct { ast_nodetype type; int val;                            };  // storage spec, type spec, type qual
    struct { ast_nodetype type;                                         // declspecs
             ast *type_quals, *storage_specs, *type_specs;          };
    struct { ast_nodetype type; list* list;                         };  // list
};

ast* ast_stmt();
ast* ast_block();
void ast_block_addstmt();
ast* ast_funcdef();
ast* ast_var();
ast* ast_storagespec();
ast* ast_typespec();
ast* ast_typequal();
ast* ast_declspecs();
ast* ast_pointer();
ast* ast_array();
void ast_print();

// AST specfic wrappers for the generic list lib
ast* ast_list();
void ast_list_push();
void ast_list_concat();

#define INDENT(x) {++indent; x; --indent;}

/*
// Semantically valid type specifications
void
char
signed char
unsigned char
short, signed short, short int, signed short int
unsigned short, unsigned short int
int, signed, signed int
unsigned, unsigned int
long, signed long, long int, signed long int
unsigned long, unsigned long int
long long, signed long long, long long int, signed long long int
unsigned long long, unsigned long long int
float
double
long double
struct or union speciﬁer
*/

// Not implemented here
// _Bool
// float _Complex
// double _Complex
// long double _Complex
// enum speciﬁer 
// typedef name

#endif

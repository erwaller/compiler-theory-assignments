%{
    #include <math.h>
    #include <string.h>
    #include <stdio.h>
    #include <ctype.h>
    #include "shared.h"
    
    int yylex (void); 
    void yyerror (char const *);
    symbol_tbl *sym_tbl;
%}

%defines

%union {
    struct { int t; char* s; };
    struct { int t; char c; };
    struct { int t; int i; };
    struct { int t; unsigned int u; };
    struct { int t; long int l; };
    struct { int t; unsigned long int ul; };
    struct { int t; long long int ll; };
    struct { int t; unsigned long long int ull; };
    struct { int t; double d; };
    struct { int t; float f; };
    struct { int t; long double ld; };
    struct { int t; ast* n; };
    struct { int t; int tok; };
}

%token TOKEOF 0
%token <s> IDENT
%token <c> CHARLIT
%token <s> STRING
%token <i> NUMBER
%token INDSEL
%token PLUSPLUS
%token MINUSMINUS
%token SHL
%token SHR
%token LTEQ
%token GTEQ
%token EQEQ
%token NOTEQ
%token LOGAND
%token LOGOR
%token ELLIPSIS
%token TIMESEQ
%token DIVEQ
%token MODEQ
%token PLUSEQ
%token MINUSEQ
%token SHLEQ
%token SHREQ
%token ANDEQ
%token OREQ
%token XOREQ
%token <tok> AUTO
%token <tok> BREAK
%token <tok> CASE
%token <tok> CHAR
%token <tok> CONST
%token <tok> CONTINUE
%token <tok> DEFAULT
%token <tok> DO
%token <tok> DOUBLE
%token <tok> ELSE
%token <tok> ENUM
%token <tok> EXTERN
%token <tok> FLOAT
%token <tok> FOR
%token <tok> GOTO
%token <tok> IF
%token <tok> INLINE
%token <tok> INT
%token <tok> LONG
%token <tok> REGISTER
%token <tok> RESTRICT
%token <tok> RETURN
%token <tok> SHORT
%token <tok> SIGNED
%token <tok> SIZEOF
%token <tok> STATIC
%token <tok> STRUCT
%token <tok> SWITCH
%token <tok> TYPEDEF
%token <tok> UNION
%token <tok> UNSIGNED
%token <tok> VOID
%token <tok> VOLATILE
%token <tok> WHILE
%token _BOOL
%token _COMPLEX
%token _IMAGINARY

%type <n>   type_spec storage_spec type_qual
            stmt declaration block_list block function_def global_stmt
            decl_specs decl_list declarator direct_decl pointer decl_specs_opt
            type_qual_list type_qual_list_opt

%left ','
%right '=' PLUSEQ MINUSEQ TIMESEQ DIVEQ MODEQ SHLEQ SHREQ ANDEQ OREQ XOREQ
%left '?' ':'
%left '+' '-'
%left '*' '/' '%' SHL SHR '&' '|' '^' '~'
%left UNPM '!'
%nonassoc '<' '>' LTEQ GTEQ EQEQ NOTEQ LOGAND LOGOR

%% /* Grammar rules and actions follow. */ 

input:        global_stmt           {}
            | input global_stmt     {};
            
global_stmt:  declaration           { $$ = $1; }
            | function_def          { $$ = $1; };

block:        open block_list close { $$ = ast_block($2);                   };
open:         '{'                   { open_scope(sym_tbl);                  };
close:        '}'                   { close_scope(sym_tbl);                 };

block_list:   stmt                  { $$ = ast_list(); ast_list_push($$, $1);   }
            | block_list stmt       { $$ = $1; ast_list_push($$, $2);           };
            
stmt:         ';'                   { $$ = ast_stmt();  }
            | exp ';'               { $$ = ast_stmt();  }
            | declaration           { $$ = $1;          }
            | block                 { $$ = $1;          };
            
function_def:
          decl_specs declarator block   { $$ = ast_funcdef($2, $3); }; 

declaration:
          decl_specs decl_list ';'  { 
                                        ast* decl = ast_list_first($2);
                                        while(decl != NULL) {
                                            ast_list_push(decl->ctype, $1->type_specs);
                                            decl = ast_list_next($2);
                                        }
                                        ast_print($2);
                                    };

decl_specs:
          storage_spec decl_specs_opt   { $$ = $2; ast_list_push($2->storage_specs, $1); printf("pushing a storage spec\n");  }
        | type_spec decl_specs_opt      { $$ = $2; ast_list_push($2->type_specs, $1);  }
        | type_qual decl_specs_opt      { $$ = $2; ast_list_push($2->type_quals, $1);  }
        | INLINE decl_specs_opt         { $$ = $2; };   /* The only function-specifier */
decl_specs_opt:                         { $$ = ast_declspecs(); }
        | decl_specs                    { $$ = $1;              };
        
decl_list:
          declarator                { $$ = ast_list(); ast_list_push($$, $1);   }
        | decl_list ',' declarator  { $$ = $1; ast_list_push($$, $3);           };
        
// concat any type-nodes from the pointer list to the
// ast_var ctype list and pass the ast_var
declarator:
          direct_decl           { $$ = $1; }
        | pointer direct_decl   { $$ = $2; ast_list_concat($$->ctype, $1); };

direct_decl: 
          IDENT                             { $$ = ast_var(sym_tbl->current, $1);   }
        | '(' declarator ')'                { $$ = $2;                              }
        | direct_decl '[' ']'               {}
        | direct_decl '[' NUMBER ']'        { $$ = $1; ast_list_push($$->ctype, ast_array($3)); }
        | direct_decl '(' ')'               {}
        | direct_decl '(' ident_list ')'    {};

// Passing up an ast_list of type-nodes
pointer:
          '*' type_qual_list_opt            { $$ = ast_list(); ast_list_push($$, ast_pointer()); }
        | '*' type_qual_list_opt pointer    { $$ = $3; ast_list_push($$, ast_pointer()); };

type_qual_list:
          type_qual                 { $$ = ast_list(); ast_list_push($$, $1);   }
        | type_qual_list type_qual  { $$ = $1; ast_list_push($$, $2);           };
type_qual_list_opt:
        | type_qual_list            { $$ = $1; };

ident_list: 
          IDENT                     {}
        | ident_list ',' IDENT      {};
        
type_qual:
          CONST     { $$ = ast_typequal(CONST);       }
        | RESTRICT  { $$ = ast_typequal(RESTRICT);    }
        | VOLATILE  { $$ = ast_typequal(VOLATILE);    };
        
storage_spec:
          EXTERN    { $$ = ast_storagespec(EXTERN);      }
        | STATIC    { $$ = ast_storagespec(STATIC);      }
        | AUTO      { $$ = ast_storagespec(AUTO);        }
        | REGISTER  { $$ = ast_storagespec(REGISTER);    };

type_spec:
          VOID      { $$ = ast_typespec(VOID);        }
        | CHAR      { $$ = ast_typespec(CHAR);        }
        | SHORT     { $$ = ast_typespec(SHORT);       }
        | INT       { $$ = ast_typespec(INT);         }
        | LONG      { $$ = ast_typespec(LONG);        }
        | FLOAT     { $$ = ast_typespec(FLOAT);       }
        | DOUBLE    { $$ = ast_typespec(DOUBLE);      }
        | SIGNED    { $$ = ast_typespec(SIGNED);      }
        | UNSIGNED  { $$ = ast_typespec(UNSIGNED);    };

exp:        
          NUMBER                {}
        | una_post              {}
        | '(' exp ')'           {}
        | '+' exp %prec UNPM    {}
        | '-' exp %prec UNPM    {}
        | '~' exp %prec UNPM    {}
        | exp '+' exp           {}
        | exp '-' exp           {}
        | exp '*' exp           {}
        | exp '/' exp           {}
        | exp '%' exp           {}
        | exp SHL exp           {}
        | exp SHR exp           {}
        | exp '&' exp           {}
        | exp '|' exp           {}
        | exp '^' exp           {}
        | '!' exp               {}
        | exp '<' exp           {}
        | exp '>' exp           {}
        | exp LTEQ exp          {}
        | exp GTEQ exp          {}
        | exp EQEQ exp          {}
        | exp NOTEQ exp         {}
        | exp LOGAND exp        {}
        | exp LOGOR exp         {}
        | lval '(' ')'          {}
        | lval '=' exp          {}
        | lval PLUSEQ exp       {}
        | lval MINUSEQ exp      {}
        | lval TIMESEQ exp      {}
        | lval DIVEQ exp        {}
        | lval MODEQ exp        {}
        | lval SHLEQ exp        {}
        | lval SHREQ exp        {}
        | lval ANDEQ exp        {}
        | lval OREQ exp         {}
        | lval XOREQ exp        {}
        | exp ',' exp           {}
        | exp '?' exp ':' exp   {};

una_post:
          lval                  {}
        | lval PLUSPLUS         {}
        | lval MINUSMINUS       {}
        | PLUSPLUS lval         {}
        | MINUSMINUS lval       {};
                                      
lval:
          IDENT                 {}
        | lval '[' exp ']'      {}
        | lval '.' IDENT        {}
        | lval INDSEL IDENT     {};

%% 

int 
main (void) 
{
    strcpy(filename, "<stdin>");
    init_symbol_tbl(&sym_tbl);
    return yyparse(); 
}

void yyerror (char const *error)
{
    fprintf(stderr, "\nERROR: %s\n", error);
    fprintf(stderr, "at %s:%d\n", filename, line_number);
}

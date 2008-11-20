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

%type <tok> type_spec storage_spec type_qual
%type <n> stmt declaration block_list block function_def global_stmt

%left ','
%right '=' PLUSEQ MINUSEQ TIMESEQ DIVEQ MODEQ SHLEQ SHREQ ANDEQ OREQ XOREQ
%left '?' ':'
%left '+' '-'
%left '*' '/' '%' SHL SHR '&' '|' '^' '~'
%left UNPM '!'
%nonassoc '<' '>' LTEQ GTEQ EQEQ NOTEQ LOGAND LOGOR

%% /* Grammar rules and actions follow. */ 

input:        global_stmt                   {}
            | input global_stmt             {};
            
global_stmt:  declaration           { $$ = $1; ast_print($$); }
            | function_def          { $$ = $1; ast_print($$); };

block:        open block_list close { $$ = $2;                              };
open:         '{'                   { open_scope(sym_tbl);                  };
close:        '}'                   { close_scope(sym_tbl);                 };

block_list:   stmt                  { $$ = ast_block(); ast_block_addstmt($$, $1);  }
            | block_list stmt       { $$ = $1; ast_block_addstmt($$, $2);           };
            
stmt:         ';'                   { $$ = ast_stmt();  }
            | exp ';'               { $$ = ast_stmt();  }
            | declaration           { $$ = $1;          }
            | block                 { $$ = $1;          };
            
function_def:
          decl_specs declarator block   { $$ = ast_funcdef($3); }; 

declaration:
          decl_specs init_decl_list ';' { $$ = ast_decl(); };

decl_specs:
          storage_spec decl_specs_opt   {}
        | type_spec decl_specs_opt      {}
        | type_qual decl_specs_opt      {}
        | INLINE decl_specs_opt         {};     /* The only function-specifier */
decl_specs_opt:
        | decl_specs                    {};
        
init_decl_list:
          declarator                    {}
        | init_decl_list ',' declarator {};
        
declarator:
          direct_decl           {}
        | pointer direct_decl   {};

direct_decl: 
          IDENT                             {}
        | '(' declarator ')'                {}
        | direct_decl '[' ']'               {}
        | direct_decl '[' NUMBER ']'        {}
        | direct_decl '(' ')'               {}
        | direct_decl '(' ident_list ')'    {};

pointer:
          '*' type_qual_list_opt            {}
        | '*' type_qual_list_opt pointer    {};

type_qual_list:
          type_qual                 {}
        | type_qual_list type_qual  {};
type_qual_list_opt:
        | type_qual_list            {};

ident_list: 
          IDENT                     {}
        | ident_list ',' IDENT      {};
        
type_qual:
          CONST     { $$ = $1; }
        | RESTRICT  { $$ = $1; }
        | VOLATILE  { $$ = $1; };
        
storage_spec:
          EXTERN    { $$ = $1; }
        | STATIC    { $$ = $1; }
        | AUTO      { $$ = $1; }
        | REGISTER  { $$ = $1; };

type_spec:
          VOID      { $$ = $1; }
        | CHAR      { $$ = $1; }
        | SHORT     { $$ = $1; }
        | INT       { $$ = $1; }
        | LONG      { $$ = $1; }
        | FLOAT     { $$ = $1; }
        | DOUBLE    { $$ = $1; }
        | SIGNED    { $$ = $1; }
        | UNSIGNED  { $$ = $1; };

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
    init_symbol_tbl(&sym_tbl);
    strcpy(filename, "<stdin>");
    return yyparse(); 
}

void yyerror (char const *error)
{
    fprintf(stderr, "\nERROR: %s\n", error);
    fprintf(stderr, "at %s:%d\n", filename, line_number);
}

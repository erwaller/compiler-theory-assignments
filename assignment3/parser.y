%{
    #include <math.h>
    #include <string.h>
    #include <stdio.h>
    #include <ctype.h>
    #include "shared.h"
    #include "lib/symbol_tbl.h"
    extern char* yytext;
    extern int yyleng;
    extern int line_number;
    extern char filename[];
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
%token AUTO
%token BREAK
%token CASE
%token CHAR
%token CONST
%token CONTINUE
%token DEFAULT
%token DO
%token DOUBLE
%token ELSE
%token ENUM
%token EXTERN
%token FLOAT
%token FOR
%token GOTO
%token IF
%token INLINE
%token INT
%token LONG
%token REGISTER
%token RESTRICT
%token RETURN
%token SHORT
%token SIGNED
%token SIZEOF
%token STATIC
%token STRUCT
%token SWITCH
%token TYPEDEF
%token UNION
%token UNSIGNED
%token VOID
%token VOLATILE
%token WHILE
%token _BOOL
%token _COMPLEX
%token _IMAGINARY

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
            
global_stmt:  declaration           {}
            | function_def          {};

block:        open block_list close {};
open:         '{'                   { open_scope(sym_tbl);                  };
close:        '}'                   { close_scope(sym_tbl);                 };

block_list:   stmt                  {}
            | block_list stmt       {};
            
stmt:         ';'
            | exp ';'               {}
            | declaration           {}
            | block                 {};
            
function_def:
          decl_specs declarator block   {}; 

declaration:
          decl_specs init_decl_list ';' {};

decl_specs:
          storage_spec decl_specs_opt   {}
        | type_spec decl_specs_opt      {}
        | type_qual decl_specs_opt      {}
        | INLINE decl_specs_opt         {};     /* The only function-specifier */
decl_specs_opt:
        | decl_specs    {};
        
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
          '*'                           {}
        | '*' pointer                   {}
        | '*' type_qual_list            {}
        | '*' type_qual_list pointer    {};

type_qual_list:
          type_qual                 {}
        | type_qual_list type_qual  {};

ident_list: 
          IDENT                     {}
        | ident_list ',' IDENT      {};
        
type_qual:
          CONST     {}
        | RESTRICT  {}
        | VOLATILE  {};
        
storage_spec:
          EXTERN    {}
        | STATIC    {}
        | AUTO      {}
        | REGISTER  {};

type_spec:
          VOID      {}
        | CHAR      {}
        | SHORT     {}
        | INT       {}
        | LONG      {}
        | FLOAT     {}
        | DOUBLE    {}
        | SIGNED    {}
        | UNSIGNED  {};

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

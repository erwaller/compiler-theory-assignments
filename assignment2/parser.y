/* Reverse polish notation calculator. */ 

%{
    #include <math.h>
    #include <stdio.h>
    #include <ctype.h>
    #include "lib/symbol_tbl.h"
    extern char* yytext;
    extern int yyleng;
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

%type <i> exp

%left '='
%left '+' '-' '*' '/'

%% /* Grammar rules and actions follow. */ 

input: /* empty */ 
    | input line 
;

line:         ';'
            | exp ';'               { printf ("\t%d\n", $1);                }
            | INT dec_list ';'      { ;                                     }
;

exp:          NUMBER                { $$ = $1;                              }
            | IDENT                 { read_sym(sym_tbl, $1, &$$);           }
            | exp '+' exp           { $$ = $1 + $3;                         }
            | exp '-' exp           { $$ = $1 - $3;                         }
            | exp '*' exp           { $$ = $1 * $3;                         }
            | exp '/' exp           { $$ = $1 / $3;                         }
            | '(' exp ')'           { $$ = $2;                              }
            | IDENT '=' exp         { $$ = $3; write_sym(sym_tbl, $1, &$3); }
;

dec_list:     IDENT                 { new_sym(sym_tbl, $1);                 }
            | dec_list ',' IDENT    { new_sym(sym_tbl, $3);                 }
;

%% 

int 
main (void) 
{
    init_symbol_tbl(&sym_tbl);
    return yyparse(); 
}

void yyerror (char const *error)
{
    fprintf(stderr, "ERROR:\n%s\n", error);
}

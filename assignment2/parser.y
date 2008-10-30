/* Reverse polish notation calculator. */ 

%{
    #include <math.h>
    #include <stdio.h>
    #include <ctype.h>
    #include "lib/symbol_tbl.h"
    extern char* yytext;
    extern int yyleng;
    extern char* filename;
    extern int line_number;
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
%left '+' '-'
%left '*' '/'
%right '^'

%initial-action
{
    
};

%% /* Grammar rules and actions follow. */ 

input: /* empty */ 
    | block_list                            {  }
    | open_scope block_list close_scope     { printf("open/close scope\n"); }
;

open_scope:   '{'                   { open_scope(sym_tbl);                  }
;

close_scope:  '}'                   { close_scope(sym_tbl);                 }
;

block_list:   line                  {}
            | block_list line       {}
;

line:         ';'
            | exp ';'               { printf("%s:%d: %d\n", filename, line_number, $1); }
            | INT dec_list ';'      { ;                                     }
;

exp:          NUMBER                { $$ = $1;                              }
            | IDENT                 
                {
                    if (!read_sym(sym_tbl, $1, &$$)) {
                        $$ = 1;
                        fprintf (stderr, "%d.%d-%d.%d: undefined variable",
                                        @1.first_line, @1.first_column,
                                        @1.last_line, @1.last_column);
                    }
                }
            | exp '+' exp           { $$ = $1 + $3;                         }
            | exp '-' exp           { $$ = $1 - $3;                         }
            | exp '*' exp           { $$ = $1 * $3;                         }
            | exp '/' exp
                {
                    if ($3)
                        $$ = $1 / $3;
                    else
                    {
                        $$ = 0;
                        fprintf (stderr, "%d.%d-%d.%d: division by zero",
                                        @3.first_line, @3.first_column,
                                        @3.last_line, @3.last_column);
                    }
                }
            | exp '^' exp           { $$ = pow($1, $3);                     }
            | '(' exp ')'           { $$ = $2;                              }
            | IDENT '=' exp
            {
                if (write_sym(sym_tbl, $1, &$3))
                    $$ = $3;
                else
                {
                    $$ = 0;
                    fprintf (stderr, "%d.%d-%d.%d: undefined variable",
                                    @1.first_line, @1.first_column,
                                    @1.last_line, @1.last_column);
                }
            }
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
    fprintf(stderr, "\nERROR: %s\n", error);
}

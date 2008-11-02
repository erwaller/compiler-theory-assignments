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

%left '=' PLUSEQ MINUSEQ TIMESEQ DIVEQ MODEQ SHLEQ SHREQ ANDEQ OREQ XOREQ
%left '?' ':'
%left '+' '-'
%left '*' '/' '%' SHL SHR '&' '|' '^'

%initial-action
{
    
};

%% /* Grammar rules and actions follow. */ 

input:        global_stmt                   {}
            | input global_stmt             {};
            
global_stmt:  decl                  {}
            | IDENT '(' ')' block   { new_sym(sym_tbl, $1); };
            
block:      open block_list close   {};

open:         '{'                   { open_scope(sym_tbl);                  };

close:        '}'                   { close_scope(sym_tbl);                 };

block_list:   stmt                  {}
            | block_list stmt       {};
            
stmt:         ';'
            | exp ';'               { printf("%s:%d: %d\n", filename, line_number, $1); }
            | decl                  {}
            | block                 {};
            
decl:         INT dec_list ';'      {  };

exp:          NUMBER                { $$ = $1;                              }
            | IDENT                 
                {
                    if (!read_sym(sym_tbl, $1, &$$)) {
                        $$ = 0;
                        fprintf (stderr, "%d.%d-%d.%d: undefined variable\n",
                                        @1.first_line, @1.first_column,
                                        @1.last_line, @1.last_column);
                    }
                }
            | '+' exp               { $$ = $2;                              }
            | '-' exp               { $$ = $2 * -1;                         }
            | exp '+' exp           { $$ = $1 + $3;                         }
            | exp '-' exp           { $$ = $1 - $3;                         }
            | exp '*' exp           { $$ = $1 * $3;                         }
            | exp '/' exp           {
                    if ($3)
                        $$ = $1 / $3;
                    else {
                        $$ = 0;
                        fprintf (stderr, "Division by zero\n");
                    }
                }
            | exp '%' exp           { $$ = $1 % $3;                         }
            | exp SHL exp           { $$ = $1 << $3;                        }
            | exp SHR exp           { $$ = $1 >> $3;                        }
            | exp '&' exp           { $$ = $1 & $3;                         }
            | exp '|' exp           { $$ = $1 | $3;                         }
            | exp '^' exp           { $$ = $1 ^ $3;                         }
            | PLUSPLUS IDENT        { int t1; read_sym(sym_tbl, $2, &t1);
                                      t1 = t1 + 1; $$ = t1;
                                      write_sym(sym_tbl, $2, t1);           }
            | IDENT PLUSPLUS        { int t1; read_sym(sym_tbl, $1, &t1);
                                      $$ = t1; t1 = t1 + 1;
                                      write_sym(sym_tbl, $1, t1);           }
            | MINUSMINUS IDENT      { int t1; read_sym(sym_tbl, $2, &t1);
                                      t1 = t1 - 1; $$ = t1;
                                      write_sym(sym_tbl, $2, t1);           }
            | IDENT MINUSMINUS      { int t1; read_sym(sym_tbl, $1, &t1);
                                      $$ = t1; t1 = t1 - 1;
                                      write_sym(sym_tbl, $1, t1);           }
            | '(' exp ')'           { $$ = $2;                              }
            | IDENT '=' exp         { $$ = write_sym(sym_tbl, $1, $3) ? $3 : 0 }
            | IDENT PLUSEQ exp      { int t; read_sym(sym_tbl, $1, &t);
                                      $$ = t+$3;
                                      write_sym(sym_tbl, $1, $$);           }
            | IDENT MINUSEQ exp     { int t; read_sym(sym_tbl, $1, &t);
                                      $$ = t-$3;
                                      write_sym(sym_tbl, $1, $$);           }
            | IDENT TIMESEQ exp     { int t; read_sym(sym_tbl, $1, &t);
                                      $$ = t*$3;
                                      write_sym(sym_tbl, $1, $$);           }
            | IDENT DIVEQ exp       { int t; read_sym(sym_tbl, $1, &t);
                                      $$ = t/$3;
                                      write_sym(sym_tbl, $1, $$);           }
            | IDENT MODEQ exp       { int t; read_sym(sym_tbl, $1, &t);
                                      $$ = t%$3;
                                      write_sym(sym_tbl, $1, $$);           }
            | IDENT SHLEQ exp       { int t; read_sym(sym_tbl, $1, &t);
                                      $$ = t<<$3;
                                      write_sym(sym_tbl, $1, $$);           }
            | IDENT SHREQ exp       { int t; read_sym(sym_tbl, $1, &t);
                                      $$ = t>>$3;
                                      write_sym(sym_tbl, $1, $$);           }
            | IDENT ANDEQ exp       { int t; read_sym(sym_tbl, $1, &t);
                                      $$ = t&$3;
                                      write_sym(sym_tbl, $1, $$);           }
            | IDENT OREQ exp        { int t; read_sym(sym_tbl, $1, &t);
                                      $$ = t|$3;
                                      write_sym(sym_tbl, $1, $$);           }
            | IDENT XOREQ exp       { int t; read_sym(sym_tbl, $1, &t);
                                      $$ = t^$3;
                                      write_sym(sym_tbl, $1, $$);           }
            | exp '?' exp ':' exp   { $$ = $1 ? $3 : $5                     };
            

dec_list:     IDENT                 { new_sym(sym_tbl, $1);                 }
            | dec_list ',' IDENT    { new_sym(sym_tbl, $3);                 };

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

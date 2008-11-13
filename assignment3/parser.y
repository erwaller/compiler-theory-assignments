%{
    #include <math.h>
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

%type <s> lval
%type <i> exp
%type <i> una_post
%type <s> function

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
            
global_stmt:  decl                  {}
            | function              { new_sym(sym_tbl, $1); };
            
function:     IDENT '(' ')' block   { $$ = $1;                              }
            | INT IDENT '(' ')' block  { $$ = $2;                           }
            | INT '*' IDENT '(' ')' block   { $$ = $3;                      };
            
block:        open block_list close {};

open:         '{'                   { open_scope(sym_tbl);                  };

close:        '}'                   { close_scope(sym_tbl);                 };

block_list:   stmt                  {}
            | block_list stmt       {};
            
stmt:         ';'
            | exp ';'               { printf("%s:%d: exprval=%d\n", filename, line_number, $1); }
            | decl                  {}
            | block                 {};
            
decl:         INT dec_list ';'      {};




        

declaration:
          decl_specs init_decl_list ';'
          
decl_specs:
          storage_spec
        | storage_spec decl_specs
        | type_spec
        | type_spec decl_specs
        | type_qual
        | type_qual decl_specs
        | INLINE    /* The only function-specifier */
        | INLINE decl_specs
        
init_decl_list:
          declarator
        | init_decl_list ',' declarator
        
declarator:
          direct_decl
        | pointer direct_decl

direct_decl: 
          IDENT
        | '(' declarator ')'
        | direct_decl '[' ']'
        | direct_decl '[' NUMBER ']'
        | direct_decl '(' ')'
        | direct_decl '(' ident_list ')'

pointer:
          '*'
        | '*' pointer
        | '*' type_qual_list
        | '*' type_qual_list pointer

type_qual_list:
          type_qual
        | type_qual_list type_qual

ident_list: 
          IDENT 
        | ident_list ',' IDENT
        
type_qual:
          CONST
        | RESTRICT
        | VOLATILE
        
store_spec:
          EXTERN
        | STATIC
        | AUTO
        | REGISTER

type_spec:
          VOID
        | CHAR
        | SHORT
        | INT
        | LONG
        | FLOAT
        | DOUBLE
        | SIGNED
        | UNSIGNED
        | su_spec





exp:          NUMBER                { if ($<t>1 == f || $<t>1 == ld || $<t>1 == d)
                                        fprintf(stderr, "%s:%d:Warning:Truncating real number to integer\n", filename, line_number);
                                      switch ($<t>1) {
                                        case f:
                                            $$ = (int)$<f>1;
                                            break;
                                        case ld:
                                            $$ = (int)$<ld>1;
                                            break;
                                        case d:
                                            $$ = (int)$<d>1;
                                            break;
                                        default:
                                            $$ = $1;
                                      } }
            | una_post              { $$ = $1;                              }
            | '(' exp ')'           { $$ = $2;                              }
            | '+' exp %prec UNPM    { $$ = $2;                              }
            | '-' exp %prec UNPM    { $$ = $2 * -1;                         }
            | '~' exp %prec UNPM    { $$ = ~$2;                             }
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
            | '!' exp               { $$ = !$2;                             }
            | exp '<' exp             { $$ = $1 < $3;                         }
            | exp '>' exp             { $$ = $1 > $3;                         }
            | exp LTEQ exp          { $$ = $1 <= $3;                        }
            | exp GTEQ exp          { $$ = $1 >= $3;                        }
            | exp EQEQ exp          { $$ = $1 == $3;                        }
            | exp NOTEQ exp         { $$ = $1 != $3;                        }
            | exp LOGAND exp        { $$ = $1 && $3;                        }
            | exp LOGOR exp         { $$ = $1 || $3;                        }
            | lval '(' ')'          { $$ = 0; fprintf(stderr, "%s:%d:Warning:Function calls not implemented\n", filename, line_number); }
            | lval '=' exp          { $$ = $3; write_sym(sym_tbl, $1, $3);  }
            | lval PLUSEQ exp       { int t; read_sym(sym_tbl, $1, &t);
                                      $$ = t+$3;
                                      write_sym(sym_tbl, $1, $$);           }
            | lval MINUSEQ exp      { int t; read_sym(sym_tbl, $1, &t);
                                      $$ = t-$3;
                                      write_sym(sym_tbl, $1, $$);           }
            | lval TIMESEQ exp      { int t; read_sym(sym_tbl, $1, &t);
                                      $$ = t*$3;
                                      write_sym(sym_tbl, $1, $$);           }
            | lval DIVEQ exp        { int t; read_sym(sym_tbl, $1, &t);
                                      $$ = t/$3;
                                      write_sym(sym_tbl, $1, $$);           }
            | lval MODEQ exp        { int t; read_sym(sym_tbl, $1, &t);
                                      $$ = t%$3;
                                      write_sym(sym_tbl, $1, $$);           }
            | lval SHLEQ exp        { int t; read_sym(sym_tbl, $1, &t);
                                      $$ = t<<$3;
                                      write_sym(sym_tbl, $1, $$);           }
            | lval SHREQ exp        { int t; read_sym(sym_tbl, $1, &t);
                                      $$ = t>>$3;
                                      write_sym(sym_tbl, $1, $$);           }
            | lval ANDEQ exp        { int t; read_sym(sym_tbl, $1, &t);
                                      $$ = t&$3;
                                      write_sym(sym_tbl, $1, $$);           }
            | lval OREQ exp         { int t; read_sym(sym_tbl, $1, &t);
                                      $$ = t|$3;
                                      write_sym(sym_tbl, $1, $$);           }
            | lval XOREQ exp        { int t; read_sym(sym_tbl, $1, &t);
                                      $$ = t^$3;
                                      write_sym(sym_tbl, $1, $$);           }
            | exp ',' exp           { $$ = $3;                              }
            | exp '?' exp ':' exp   { $$ = $1 ? $3 : $5                     };

una_post:     lval                  { if (!read_sym(sym_tbl, $1, &$$)) $$ = 0; }
            | lval PLUSPLUS         { int t1; read_sym(sym_tbl, $1, &t1);
                                      $$ = t1; t1 = t1 + 1;
                                      write_sym(sym_tbl, $1, t1);           }
            | lval MINUSMINUS       { int t1; read_sym(sym_tbl, $1, &t1);
                                      $$ = t1; t1 = t1 - 1;
                                      write_sym(sym_tbl, $1, t1);           }
            | PLUSPLUS lval         { int t1; read_sym(sym_tbl, $2, &t1);
                                      t1 = t1 + 1; $$ = t1;
                                      write_sym(sym_tbl, $2, t1);           }
            | MINUSMINUS lval       { int t1; read_sym(sym_tbl, $2, &t1);
                                      t1 = t1 - 1; $$ = t1;
                                      write_sym(sym_tbl, $2, t1);           };
                                      
lval:         IDENT                 { $$ = $1;                              }
            | lval '[' exp ']'      { fprintf(stderr, "%s:%d:Warning:Arrays not implemented\n", filename, line_number); }
            | lval '.' IDENT        { fprintf(stderr, "%s:%d:Warning:Struct/union not implemented\n", filename, line_number); }
            | lval INDSEL IDENT     { fprintf(stderr, "%s:%d:Warning:Struct/union not implemented\n", filename, line_number); };

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

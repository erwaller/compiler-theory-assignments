/* Reverse polish notation calculator. */ 

%{
    #include <math.h>
    #include <stdio.h>
    #include <ctype.h>
    int yylex (void); 
    void yyerror (char const *);
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
%token IDENT
%token <c> CHARLIT
%token <text> STRING
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

%% /* Grammar rules and actions follow. */ 

input: /* empty */ 
    | input line 
;

line: '\n'
    | exp '\n' { printf ("\t%d\n", $1); } 
;

exp: NUMBER { $$ = $1; } 
    | exp exp '+' { $$ = $1 + $2; } 
    | exp exp '-' { $$ = $1 - $2; } 
    | exp exp '*' { $$ = $1 * $2; } 
    | exp exp '/' { $$ = $1 / $2; } 
    /* Exponentiation */ 
    | exp exp '^' { $$ = pow ($1, $2); } 
    /* Unary minus */ 
    | exp 'n' { $$ = -$1; } 
;

%% 

int 
main (void) 
{ 
    return yyparse(); 
}

void yyerror (char const *error)
{
    fprintf(stderr, "ERROR:\n%s\n", error);
}

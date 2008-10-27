/* Reverse polish notation calculator. */ 

%{
    #include <math.h>
    #include <stdio.h>
    int yylex(); 
    void yyerror();
%}

%token NUMBER
%token IDENT

%% /* Grammar rules and actions follow. */ 

input: /* empty */ 
    | input line 
;

line: '\n'
    | exp '\n' { printf ("\t%.10g\n", $1); } 
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


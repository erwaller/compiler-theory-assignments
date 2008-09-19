#include <stdlib.h>

#ifndef lexer_H
#define lexer_H

typedef struct {
    int int_value, is_unsigned, is_long, is_longlong;
    long int l_val;
    unsigned int u_val;
    long unsigned int lu_val;
    long long int ll_val;
    long long unsigned llu_val;
} sint;

typedef struct {
    int is_float, is_longdouble;
    double d_val;
    float f_val;
    long double ld_val;
} sreal;

typedef union {
	char *text;
	sint* pint;
	sreal* pfloat;
} YYSTYPE;

extern YYSTYPE yylval;

// Just save the current real and int for now
// don't worry about the whole YYSTYPE union
sint cur_int;
sreal cur_real;

char* debug_token(int);
void install_int(void);
void install_real(void);

// Helpers for checking real/int stuff
int is_int_unsigned(char* lexeme) {
    return (strchr(lexeme, 'u')>0 || strchr(lexeme, 'U')>0) ? 1 : 0;
}
int is_int_long(char* lexeme) {
    return (is_int_longlong(lexeme)==0 && 
            (strchr(lexeme, 'l')>0 || strchr(lexeme, 'L')>0)) ?
            1 : 0;
}
int is_int_longlong(char* lexeme) {
    return (strstr(lexeme,"ll")>0 || strstr(lexeme,"LL")>0) ? 1 : 0;
}
int is_real_float(char* lexeme) {
    return (strchr(lexeme, 'f')>0 || strchr(lexeme, 'F')>0) ? 1 : 0;
}
int is_real_longdouble(char* lexeme) {
    return (strchr(lexeme, 'l')>0 || strchr(lexeme, 'L')>0) ? 1 : 0;
}

int num_type;

enum numbers {
	REAL,
	INTEGER
};

enum tokens {
	TOKEOF=0,
	IDENT=257,	/* This is where yacc will put it */
	CHARLIT,
	STRING,
	NUMBER,
	INDSEL,
	PLUSPLUS,
	MINUSMINUS,
	SHL,
	SHR,
	LTEQ,
	GTEQ,
	EQEQ,
	NOTEQ,
	LOGAND,
	LOGOR,
	ELLIPSIS,
	TIMESEQ,
	DIVEQ,
	MODEQ,
	PLUSEQ,
	MINUSEQ,
	SHLEQ,
	SHREQ,
	ANDEQ,
	OREQ,
	XOREQ,
	AUTO,
	BREAK,
	CASE,
	CHAR,
	CONST,
	CONTINUE,
	DEFAULT,
	DO,
	DOUBLE,
	ELSE,
	ENUM,
	EXTERN,
	FLOAT,
	FOR,
	GOTO,
	IF,
	INLINE,
	INT,
	LONG,
	REGISTER,
	RESTRICT,
	RETURN,
	SHORT,
	SIGNED,
	SIZEOF,
	STATIC,
	STRUCT,
	SWITCH,
	TYPEDEF,
	UNION,
	UNSIGNED,
	VOID,
	VOLATILE,
	WHILE,
	_BOOL,
	_COMPLEX,
	_IMAGINARY
};

#endif

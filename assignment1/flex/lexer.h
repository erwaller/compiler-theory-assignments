
#ifndef lexer_H
#define lexer_H

typedef union {
	char *text;
	int integer;
	float floating_point;
} YYSTYPE;

extern YYSTYPE yylval;

char* debug_token(int);
void install_id(void);

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
#include <stdio.h>

typedef enum {
	NUMBER,
	IDENTIFIER,
	PLUS,
	PLUSPLUS,
	ASSIGN,
	EQUALS,
	PLUSEQ
}  tokens;

int yylex() {
	char cur;
	
	while (1) {
		break;
	}
	
	printf("Hello world!\n");
}

int main () {
	tokens token;
	yylex();
}

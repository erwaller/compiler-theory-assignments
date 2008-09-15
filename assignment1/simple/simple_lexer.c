#include <stdio.h>
#include <ctype.h>

int yylex() {
	char cur;
	
	while (1) {
		cur = getc(stdin);
		if (isdigit(cur)) {
			printf("It's a digit!\n");
		}
		if (isalpha(cur)) {
			
		}
		if (isalnum(cur)) {
			
		}
		break;
	}
	
	printf("Hello world!\n");
}

int main () {
	tokens token;
	yylex();
}

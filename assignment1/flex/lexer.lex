    
    #include "lexer.h"
    
    int line_number = 1;
    int number_type;
    int pre_file_len = 0;
    char filename[BUFSIZ];

/* Definitions */
ws          [ \t\n\r]

digit       [0-9]
nonzero     [1-9]
hexdigit    [0-9A-Fa-f]
octaldigit  [0-7]
nondigit    [a-zA-Z_]
digitseq    {digit}+
hexdigitseq {hexdigit}+

hexpre      0[xX]

decint      ({nonzero}{digit}*{int_suffix}?|0{int_suffix}?)
octalint    0{octaldigit}+{int_suffix}?
hexint      {hexpre}{hexdigit}+{int_suffix}?
unsigned    [uU]
long        [lL]
longlong    (ll|LL)
int_suffix  ({unsigned}({longlong}|{long})?|({longlong}|{long}){unsigned}?)

fracconst   ({digitseq}?[.]{digitseq}|{digitseq}[.])
hexfrac     ({hexdigitseq}?[.]{hexdigitseq}|{hexdigitseq}[.])
sign        [+-]
exponent    [eE]{sign}?{digitseq}
binexp      [pP]{sign}?{digitseq}
floatsuf    [fFlL]
decfloat    ({fracconst}{exponent}?{floatsuf}?|{digitseq}{exponent}{floatsuf}?)
hexfloat    {hexpre}({hexfrac}{binexp}{floatsuf}?|{hexdigitseq}{binexp}{floatsuf}?)

hexescape   \\x{hexdigitseq}
octescape   \\{octaldigit}{octaldigit}?{octaldigit}?
simescape   \\['"?\\abfnrtv]
escapeseq   ({simescape}|{octescape}|{hexescape})

cchar       ([^\'\n\\]|{escapeseq})
ccharseq    {cchar}+
charlit     L?\'{ccharseq}\'

schar       ([^\"\n\\]|{escapeseq})
scharseq    {schar}+
strlit      L?\"{scharseq}\"

id          {nondigit}({nondigit}|{digit})*

/* Preprocessor output */
gccline     #[ ]{digitseq}[ ]
gccout      {gccline}{strlit}

%%

            /* Ignore */
"\n"        {++line_number;}
{ws}        {}

            /* Handle preprocessor output */
{gccout}    {line_number = atoi(yytext+2)-1; yytext[yyleng-1] = '\0'; strcpy(filename, strchr(yytext, '"')+1);}

            /* Keywords */
auto        {return(AUTO);}
break       {return(BREAK);}
case        {return(CASE);}
char        {return(CHAR);}
const       {return(CONST);}
continue    {return(CONTINUE);}
default     {return(DEFAULT);}
do          {return(DO);}
double      {return(DOUBLE);}
else        {return(ELSE);}
enum        {return(ENUM);}
extern      {return(EXTERN);}
float       {return(FLOAT);}
for         {return(FOR);}
goto        {return(GOTO);}
if          {return(IF);}
inline      {return(INLINE);}
int         {return(INT);}
long        {return(LONG);}
register    {return(REGISTER);}
restrict    {return(RESTRICT);}
return      {return(RETURN);}
short       {return(SHORT);}
signed      {return(SIGNED);}
sizeof      {return(SIZEOF);}
static      {return(STATIC);}
struct      {return(STRUCT);}
switch      {return(SWITCH);}
typedef     {return(TYPEDEF);}
union       {return(UNION);}
unsigned    {return(UNSIGNED);}
void        {return(VOID);}
volatile    {return(VOLATILE);}
while       {return(WHILE);}
_Bool       {return(_BOOL);}
_Complex    {return(_COMPLEX);}
_Imaginary  {return(_IMAGINARY);}

            /* Identifiers */
{id}        {install_id(); return(IDENT);}

            /* Char Constants */
{charlit}   {return(CHARLIT);}
{strlit}    {return(STRING);}

            /* Numbers */
{decfloat}  {number_type = REAL; return(NUMBER);}
{hexfloat}  {number_type = REAL; return(NUMBER);}

{hexint}    {number_type = INTEGER; return(NUMBER);}
{octalint}  {number_type = INTEGER; return(NUMBER);}
{decint}    {number_type = INTEGER; return(NUMBER);}

            /* Operators */
"["         {return '[';}
"]"         {return ']';}
"("         {return '(';}
")"         {return ')';}
"{"         {return '{';}
"}"         {return '}';}
"."         {return '.';}
"->"        {return(INDSEL);}
"++"        {return(PLUSPLUS);}
"--"        {return(MINUSMINUS);}
"&"         {return '&';}
"*"         {return '*';}
"+"         {return '+';}
"-"         {return '-';}
"~"         {return '~';}
"!"         {return '!';}
"/"         {return '/';}
"%"         {return '%';}
"<<"        {return(SHL);}
">>"        {return(SHR);}
"<"         {return '<';}
">"         {return '>';}
"<="        {return(LTEQ);}
">="        {return(GTEQ);}
"=="        {return(EQEQ);}
"!="        {return(NOTEQ);}
"^"         {return '^';}
"|"         {return '|';}
"&&"        {return(LOGAND);}
"||"        {return(LOGOR);}
"?"         {return '?';}
":"         {return ':';}
";"         {return ';';}
"..."       {return(ELLIPSIS);}
"="         {return '=';}
"*="        {return(TIMESEQ);}
"/="        {return(DIVEQ);}
"%="        {return(MODEQ);}
"+="        {return(PLUSEQ);}
"-="        {return(MINUSEQ);}
"<<="       {return(SHLEQ);}
">>="       {return(SHREQ);}
"&="        {return(ANDEQ);}
"^="        {return(XOREQ);}
"|="        {return(OREQ);}
","         {return ',';}
            /* Preprocessor "#" */
            /* Preprocessor "##" */        
"<:"        {return '[';}
":>"        {return ']';}
"<%"        {return '{';}
"%>"        {return '}';}
            /* Preprocessor "%:" */
            /* Preprocessor "%:%:" */
            
            /* Syntax Error */
.           {fprintf(stderr, "Unmatched input at line number: %d, in file: %s\nExiting...\n", line_number, filename); exit(0);}

%%

char* debug_token(int token_code) {
    switch(token_code) {
        case TOKEOF:return "TOKEOF"; case IDENT:return "IDENT"; case CHARLIT:return "CHARLIT"; case STRING:return "STRING"; case NUMBER:return "NUMBER"; case INDSEL:return "INDSEL"; case PLUSPLUS:return "PLUSPLUS"; case MINUSMINUS:return "MINUSMINUS"; case SHL:return "SHL"; case SHR:return "SHR"; case LTEQ:return "LTEQ"; case GTEQ:return "GTEQ"; case EQEQ:return "EQEQ"; case NOTEQ:return "NOTEQ"; case LOGAND:return "LOGAND"; case LOGOR:return "LOGOR"; case ELLIPSIS:return "ELLIPSIS"; case TIMESEQ:return "TIMESEQ"; case DIVEQ:return "DIVEQ"; case MODEQ:return "MODEQ"; case PLUSEQ:return "PLUSEQ"; case MINUSEQ:return "MINUSEQ"; case SHLEQ:return "SHLEQ"; case SHREQ:return "SHREQ"; case ANDEQ:return "ANDEQ"; case OREQ:return "OREQ"; case XOREQ:return "XOREQ"; case AUTO:return "AUTO"; case BREAK:return "BREAK"; case CASE:return "CASE"; case CHAR:return "CHAR"; case CONST:return "CONST"; case CONTINUE:return "CONTINUE"; case DEFAULT:return "DEFAULT"; case DO:return "DO"; case DOUBLE:return "DOUBLE"; case ELSE:return "ELSE"; case ENUM:return "ENUM"; case EXTERN:return "EXTERN"; case FLOAT:return "FLOAT"; case FOR:return "FOR"; case GOTO:return "GOTO"; case IF:return "IF"; case INLINE:return "INLINE"; case INT:return "INT"; case LONG:return "LONG"; case REGISTER:return "REGISTER"; case RESTRICT:return "RESTRICT"; case RETURN:return "RETURN"; case SHORT:return "SHORT"; case SIGNED:return "SIGNED"; case SIZEOF:return "SIZEOF"; case STATIC:return "STATIC"; case STRUCT:return "STRUCT"; case SWITCH:return "SWITCH"; case TYPEDEF:return "TYPEDEF"; case UNION:return "UNION"; case UNSIGNED:return "UNSIGNED"; case VOID:return "VOID"; case VOLATILE:return "VOLATILE"; case WHILE:return "WHILE"; case _BOOL: return "_BOOL"; case _COMPLEX:return "_COMPLEX"; case _IMAGINARY:return "_IMAGINARY"; case '[':return "["; case ']':return "]"; case '(':return "("; case ')':return ")"; case '{':return "{"; case '}':return "}"; case '.':return "."; case '&':return "&"; case '*':return "*"; case '+':return "+"; case '-':return "-"; case '~':return "~"; case '!':return "!"; case '/':return "/"; case '%':return "%"; case '<':return "<"; case '>':return ">"; case '^':return "^"; case '|':return "|"; case '?':return "?"; case ':':return ":"; case ';':return ";"; case '=':return "="; case ',':return ",";
    }
}

main()
{
	int ret;
	char ident[BUFSIZ];
	
	while ((ret = yylex()) != TOKEOF) {
	    printf("%s\t%d\t%s", filename, line_number, debug_token(ret));
	    switch (ret) {
	        case IDENT:
    	        printf("\t%s", yytext);
    	        break;
    	    case NUMBER:
    	        if (number_type == INTEGER)
    	            printf("\tINTEGER");
    	        else
    	            printf("\tREAL");
    	        printf("\t%s", yytext);
    	        break;
    	    case CHARLIT:
    	        if(yytext[1] == '\\')
    	            yytext[3] = '\0';
    	        else
    	            yytext[2] = '\0';
    	        printf("\t%s", yytext+1);
    	        break;
    	    case STRING:
        	    yytext[yyleng-1] = '\0';
    	        printf("\t%s", yytext+1);
    	        break;
    	}
	    printf("\n");
	};
}

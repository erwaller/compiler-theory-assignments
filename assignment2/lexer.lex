
    #include "shared.h"
    #include "parser.tab.h"
    
    char* debug_token(int);
    void install_ident(void);
    void install_num(void);
    void print_num(void);
    void install_string(void);
    
    int line_number = 1;
    char filename[BUFSIZ];

%option noyywrap

/* Definitions */
ws              [ \t\n\r]

digit           [0-9]
nonzero         [1-9]
hexdigit        [0-9A-Fa-f]
octaldigit      [0-7]
nondigit        [a-zA-Z_]
digitseq        {digit}+
hexdigitseq     {hexdigit}+

hexpre          0[xX]

decint          ({nonzero}{digit}*|0)
octalint        0{octaldigit}+
hexint          {hexpre}{hexdigit}+
int             ({decint}|{octalint}|{hexint})
unsigned        [uU]
long            [lL]
longlong        (ll|LL)

fracconst       ({digitseq}?[.]{digitseq}|{digitseq}[.])
hexfrac         ({hexdigitseq}?[.]{hexdigitseq}|{hexdigitseq}[.])
sign            [+-]
exponent        [eE]{sign}?{digitseq}
binexp          [pP]{sign}?{digitseq}
decfloat        ({fracconst}{exponent}?|{digitseq}{exponent})
hexfloat        {hexpre}({hexfrac}{binexp}|{hexdigitseq}{binexp})
float           ({decfloat}|{hexfloat})

hexescape       \\x{hexdigitseq}
octescape       \\{octaldigit}{octaldigit}?{octaldigit}?
simescape       \\['"?\\abfnrtv]
escapeseq       ({simescape}|{octescape}|{hexescape})

cchar           ([^\'\n\\]|{escapeseq})
ccharseq        {cchar}+
charlit         L?\'{ccharseq}\'

schar           ([^\"\n\\]|{escapeseq})
scharseq        {schar}+
strlit          L?\"{scharseq}\"

id              {nondigit}({nondigit}|{digit})*

comment         "//".*

/* Preprocessor output */
gccline         "# "{digitseq}" "
gccout          {gccline}{strlit}

%%

                /* Ignore */
"\n"            {++line_number;}
{ws}            {}
{comment}       {}

                /* Handle preprocessor output */
{gccout}        {line_number = atoi(yytext+2)-1; yytext[yyleng-1] = '\0'; strcpy(filename, strchr(yytext, '"')+1);}

                /* Keywords */
auto            {return(AUTO);}
break           {return(BREAK);}
case            {return(CASE);}
char            {return(CHAR);}
const           {return(CONST);}
continue        {return(CONTINUE);}
default         {return(DEFAULT);}
do              {return(DO);}
double          {return(DOUBLE);}
else            {return(ELSE);}
enum            {return(ENUM);}
extern          {return(EXTERN);}
float           {return(FLOAT);}
for             {return(FOR);}
goto            {return(GOTO);}
if              {return(IF);}
inline          {return(INLINE);}
int             {return(INT);}
long            {return(LONG);}
register        {return(REGISTER);}
restrict        {return(RESTRICT);}
return          {return(RETURN);}
short           {return(SHORT);}
signed          {return(SIGNED);}
sizeof          {return(SIZEOF);}
static          {return(STATIC);}
struct          {return(STRUCT);}
switch          {return(SWITCH);}
typedef         {return(TYPEDEF);}
union           {return(UNION);}
unsigned        {return(UNSIGNED);}
void            {return(VOID);}
volatile        {return(VOLATILE);}
while           {return(WHILE);}
_Bool           {return(_BOOL);}
_Complex        {return(_COMPLEX);}
_Imaginary      {return(_IMAGINARY);}

                /* Identifiers */
{id}            {yylval.t = s; install_ident(); return(IDENT);}

                /* Char Constants */
{charlit}       {return(CHARLIT);}
{strlit}        {yylval.t = s; install_string(); return(STRING);}

                /* Numbers */
{decfloat}[fF]  {yylval.t = f; install_num(); return(NUMBER);}
{decfloat}[lL]  {yylval.t = ld; install_num(); return(NUMBER);}
{decfloat}      {yylval.t = d; install_num(); return(NUMBER);}
{hexfloat}[fF]  {yylval.t = f; install_num(); return(NUMBER);}
{hexfloat}[lL]  {yylval.t = ld; install_num(); return(NUMBER);}
{hexfloat}      {yylval.t = d; install_num(); return(NUMBER);}

{int}({unsigned}{longlong}|{longlong}{unsigned})    {yylval.t = ull; install_num(); return(NUMBER);}
{int}({unsigned}{long}|{long}{unsigned})            {yylval.t = ul; install_num(); return(NUMBER);}
{int}{unsigned}                                     {yylval.t = u; install_num(); return(NUMBER);}
{int}{longlong}                                     {yylval.t = ll; install_num(); return(NUMBER);}
{int}{long}                                         {yylval.t = l; install_num(); return(NUMBER);}
{int}                                               {yylval.t = i; install_num(); return(NUMBER);}

                /* Operators */
"["             {return '[';}
"]"             {return ']';}
"("             {return '(';}
")"             {return ')';}
"{"             {return '{';}
"}"             {return '}';}
"."             {return '.';}
"->"            {return(INDSEL);}
"++"            {return(PLUSPLUS);}
"--"            {return(MINUSMINUS);}
"&"             {return '&';}
"*"             {return '*';}
"+"             {return '+';}
"-"             {return '-';}
"~"             {return '~';}
"!"             {return '!';}
"/"             {return '/';}
"%"             {return '%';}
"<<"            {return(SHL);}
">>"            {return(SHR);}
"<"             {return '<';}
">"             {return '>';}
"<="            {return(LTEQ);}
">="            {return(GTEQ);}
"=="            {return(EQEQ);}
"!="            {return(NOTEQ);}
"^"             {return '^';}
"|"             {return '|';}
"&&"            {return(LOGAND);}
"||"            {return(LOGOR);}
"?"             {return '?';}
":"             {return ':';}
";"             {return ';';}
"..."           {return(ELLIPSIS);}
"="             {return '=';}
"*="            {return(TIMESEQ);}
"/="            {return(DIVEQ);}
"%="            {return(MODEQ);}
"+="            {return(PLUSEQ);}
"-="            {return(MINUSEQ);}
"<<="           {return(SHLEQ);}
">>="           {return(SHREQ);}
"&="            {return(ANDEQ);}
"^="            {return(XOREQ);}
"|="            {return(OREQ);}
","             {return ',';}
                /* Preprocessor "#" */
                /* Preprocessor "##" */        
"<:"            {return '[';}
":>"            {return ']';}
"<%"            {return '{';}
"%>"            {return '}';}
                /* Preprocessor "%:" */
                /* Preprocessor "%:%:" */
            
                /* Syntax Error */
.               {fprintf(stderr, "Unmatched input at line number: %d, in file: %s\nExiting...\n", line_number, filename); exit(1);}

%%

char* debug_token(int tok_code) {
    switch(tok_code) {
        case TOKEOF:return "TOKEOF"; case IDENT:return "IDENT"; case CHARLIT:return "CHARLIT"; case STRING:return "STRING"; case NUMBER:return "NUMBER"; case INDSEL:return "INDSEL"; case PLUSPLUS:return "PLUSPLUS"; case MINUSMINUS:return "MINUSMINUS"; case SHL:return "SHL"; case SHR:return "SHR"; case LTEQ:return "LTEQ"; case GTEQ:return "GTEQ"; case EQEQ:return "EQEQ"; case NOTEQ:return "NOTEQ"; case LOGAND:return "LOGAND"; case LOGOR:return "LOGOR"; case ELLIPSIS:return "ELLIPSIS"; case TIMESEQ:return "TIMESEQ"; case DIVEQ:return "DIVEQ"; case MODEQ:return "MODEQ"; case PLUSEQ:return "PLUSEQ"; case MINUSEQ:return "MINUSEQ"; case SHLEQ:return "SHLEQ"; case SHREQ:return "SHREQ"; case ANDEQ:return "ANDEQ"; case OREQ:return "OREQ"; case XOREQ:return "XOREQ"; case AUTO:return "AUTO"; case BREAK:return "BREAK"; case CASE:return "CASE"; case CHAR:return "CHAR"; case CONST:return "CONST"; case CONTINUE:return "CONTINUE"; case DEFAULT:return "DEFAULT"; case DO:return "DO"; case DOUBLE:return "DOUBLE"; case ELSE:return "ELSE"; case ENUM:return "ENUM"; case EXTERN:return "EXTERN"; case FLOAT:return "FLOAT"; case FOR:return "FOR"; case GOTO:return "GOTO"; case IF:return "IF"; case INLINE:return "INLINE"; case INT:return "INT"; case LONG:return "LONG"; case REGISTER:return "REGISTER"; case RESTRICT:return "RESTRICT"; case RETURN:return "RETURN"; case SHORT:return "SHORT"; case SIGNED:return "SIGNED"; case SIZEOF:return "SIZEOF"; case STATIC:return "STATIC"; case STRUCT:return "STRUCT"; case SWITCH:return "SWITCH"; case TYPEDEF:return "TYPEDEF"; case UNION:return "UNION"; case UNSIGNED:return "UNSIGNED"; case VOID:return "VOID"; case VOLATILE:return "VOLATILE"; case WHILE:return "WHILE"; case _BOOL: return "_BOOL"; case _COMPLEX:return "_COMPLEX"; case _IMAGINARY:return "_IMAGINARY"; case '[':return "["; case ']':return "]"; case '(':return "("; case ')':return ")"; case '{':return "{"; case '}':return "}"; case '.':return "."; case '&':return "&"; case '*':return "*"; case '+':return "+"; case '-':return "-"; case '~':return "~"; case '!':return "!"; case '/':return "/"; case '%':return "%"; case '<':return "<"; case '>':return ">"; case '^':return "^"; case '|':return "|"; case '?':return "?"; case ':':return ":"; case ';':return ";"; case '=':return "="; case ',':return ",";
    }
}

void install_ident(void) {
    yylval.s = (char*)my_malloc(sizeof(char)*(yyleng+1));
    strncpy(yylval.s, yytext, yyleng+1);
}

void install_string(void) {
    yylval.s = (char*)my_malloc(sizeof(char)*(yyleng-1));
    strncpy(yylval.s+1, yytext, yyleng-1); // Removing the "" chars
}

void install_num(void) {
    char *invalid = 0;
    switch (yylval.t) {
        case i:     yylval.i = (int)strtol(yytext, &invalid, 0); break;
        case u:     yylval.u = (unsigned int)strtoul(yytext, &invalid, 0); break;
        case l:     yylval.l = strtol(yytext, &invalid, 0); break;
        case ll:    yylval.ll = strtoll(yytext, &invalid, 0); break;
        case ul:    yylval.ul = strtoul(yytext, &invalid, 0); break;
        case ull:   yylval.ull = strtoull(yytext, &invalid, 0); break;
        case d:     yylval.d = strtod(yytext, &invalid); break;
        case f:     yylval.f = strtof(yytext, &invalid); break;
        case ld:    yylval.ld = strtold(yytext, &invalid); break;
        default:
            fprintf(stderr, "Error storing number value at line number: %d, in file: %s\nExiting...\n", line_number, filename);
            exit(1);
    }
}

void print_num(void) {
    switch (yylval.t) {
        case d:
        case f:
        case ld:
            printf("\tREAL");
            break;
        default:
            printf("\tINTEGER");
    }
    switch (yylval.t) {
        case i:     printf("\t%d\t", yylval.i); printf("INT"); break;
        case u:     printf("\t%d\t", yylval.u); printf("UNSIGNED,INT"); break;
        case l:     printf("\t%ld\t", yylval.l); printf("LONG"); break;
        case ll:    printf("\t%lld\t", yylval.ll); printf("LONGLONG"); break;
        case ul:    printf("\t%ld\t", yylval.ul); printf("UNSIGNED,LONG"); break;
        case ull:   printf("\t%lld\t", yylval.ull); printf("UNSIGNED,LONGLONG"); break;
        case d:     printf("\t%lg\t", yylval.d); printf("DOUBLE"); break;
        case f:     printf("\t%lg\t", yylval.f); printf("FLOAT"); break;
        case ld:    printf("\t%Lg\t", yylval.ld); printf("LONGDOUBLE"); break;
        default:
            fprintf(stderr, "Error printing number value at line number: %d, in file: %s\nExiting...\n", line_number, filename);
            exit(1);
    }
}

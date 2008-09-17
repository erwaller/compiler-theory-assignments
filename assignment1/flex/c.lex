%{
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
%}

/* Definitions */
ws          [ \t\n\r]

digit       [0-9]
nonzero     [1-9]
hexdigit    [0-9A-Fa-f]
octaldigit  [0-7]
nondigit    [a-zA-Z_]
decint      {nonzero}{digit}*
octalint    0{octaldigit}+
hexint      0[xX]{hexdigit}+

id          {nondigit}({nondigit}|{digit})*

%%
            /* Ignore */
{ws}        {}

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
{id}        {return(IDENT);}

            /* Numbers */
{hexint}    {return(NUMBER);}
{octalint}  {return(NUMBER);}
{decint}    {return(NUMBER);}

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

%%

main()
{
    printf("IF is %d\n", IF);
    printf("IDENT is %d\n", IDENT);
	printf("we just read %d\n", yylex());
}

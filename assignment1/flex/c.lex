/* Definitions */
ws          [ \t\n\r]
digit       [0-9]
nondigit    [a-zA-Z_]

%%

{ws}        {/* do nothing */}

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



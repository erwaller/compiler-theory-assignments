#ifndef type_spec_H
#define type_spec_H

/*
// Semantically valid type specifications
void
char
signed char
unsigned char
short, signed short, short int, signed short int
unsigned short, unsigned short int
int, signed, signed int
unsigned, unsigned int
long, signed long, long int, signed long int
unsigned long, unsigned long int
long long, signed long long, long long int, signed long long int
unsigned long long, unsigned long long int
float
double
long double
struct or union speciﬁer
*/

typedef enum ALLOWED_TYPE allowed_type;
enum ALLOWED_TYPE {
    t_void,
    t_char,
    t_signed_char,
    t_unsigned_char,
    t_signed_short_int,
    t_unsigned_short_int,
    t_signed_int,
    t_unsigned_int,
    t_signed_long,
    t_unsigned_long,
    t_signed_long_long,
    t_unsigned_long_long,
    t_float,
    t_double,
    t_long_double
};

typedef struct {
    int key;
    char* debug_str;
    allowed_type type;
} t_lookup_entry;

typedef struct {
    int _void, _char, _short, _int, _long, _float, _double, _signed, _unsigned;
} t_type_table;

t_lookup_entry* get_type();
int type_signature();

// Not implemented here
// _Bool
// float _Complex
// double _Complex
// long double _Complex
// enum speciﬁer 
// typedef name

#endif

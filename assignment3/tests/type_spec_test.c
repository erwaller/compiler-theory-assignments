#include <stdio.h>
#include "../type_spec.h"

#define POSSIBLE_TYPES_LEN 29

t_lookup_entry possible_types[POSSIBLE_TYPES_LEN] = {
    {6561,  "void",                     t_void},
    {2187,  "char",                     t_char},
    {2190,  "signed char",	            t_signed_char},
    {2188,  "unsigned char",    	    t_unsigned_char},
    {729,   "short",            	    t_signed_short_int},
    {732,	"signed short", 	        t_signed_short_int},
    {972,	"short int",    	        t_signed_short_int},
    {975,	"signed short int",	        t_signed_short_int},
    {730,	"unsigned short",	        t_unsigned_short_int},
    {973,	"unsigned short int",   	t_unsigned_short_int},
    {243,	"int",                  	t_signed_int},
    {3,	    "signed",               	t_signed_int},
    {246,	"signed int",           	t_signed_int},
    {1,	    "unsigned",             	t_unsigned_int},
    {244,	"unsigned int",         	t_unsigned_int},
    {81,	"long",             	    t_signed_long},
    {84,	"signed long",      	    t_signed_long},
    {324,	"long int",         	    t_signed_long},
    {327,	"signed long int",          t_signed_long},
    {82,	"unsigned long",    	    t_unsigned_long},
    {325,	"unsigned long int",    	t_unsigned_long},
    {162,	"long long",            	t_signed_long_long},
    {165,	"signed long long", 	    t_signed_long_long},
    {405,	"signed long long int", 	t_signed_long_long},
    {163,	"unsigned long long",   	t_unsigned_long_long},
    {406,	"unsigned long long int",	t_unsigned_long_long},
    {27,	"float",                	t_float},
    {9,	    "double",                	t_double},
    {90,	"long double",          	t_long_double}
};

int check_type(unsigned int key) {
    int i;
    for (i = 0; i < POSSIBLE_TYPES_LEN; ++i)
        if(possible_types[i].key == key)
            return 1;
    return 0;
}

int main () {
    printf("10 is an entry in the table: %s\n", (check_type(10)) ? "yes" : "no");
}

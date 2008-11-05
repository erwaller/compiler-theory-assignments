int g1;
int g2,g3,g4;

int*
f()
{
        int f1;
        f1=3;
        g2=3;
        {		//Here comes a new, nested scope
                int ff1;
                ff1=10;
                f1=4;
                g2=200;
        }
        --f1;			//Old value restored
        f1=g2,55;		//Oh no, a comma operator
        f1;			
        ff1;			// This is out of scope now
        g3=g1->bad;		// Note recovery from this
        11.33;
        +99;			//Yeah, a unary + operator
        foo=9;			//Hey, no core dump here either
        -1>>3;			//Don't worry about signed/unsigned
        g1=g2?g3:g4;		//Ternary operator
}

int
g()
{
    (10 > 9) ? 15 : 14;
}

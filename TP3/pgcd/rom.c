#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef ADDRWDMAX   /* number of bits of rom address*/
#define ADDRWDMAX   16
#endif

void usage(char *message) {
    fprintf( stderr, "\nERROR : %s\n\n", message);
    fprintf( stderr, "USAGE rom <addrwd> <valwd>\n");
    fprintf( stderr, "  <addrwd>: number of bits of the rom address (max is %d)\n", ADDRWDMAX);
    fprintf( stderr, "            the number of triplets [opa,opb,pgcd(opa,opb)]\n");
    fprintf( stderr, "            is then the maximum number possible in 2**addrwd\n");
    fprintf( stderr, "  <valwd> : range of aperandes are between 1 to 2**valwd\n\n");
    fprintf( stderr, "Ex: rom 5 8 -> gives 10 triplets with operands from 1 to 2**8-1 (255)\n\n");
    exit (1);
}

// value returns a number from 1 to range
unsigned value( unsigned valrange) {
    return 1 + (rand()%(valrange-1));
} 

// return the pgcd of opa and opb
unsigned pgcd( unsigned opa,  unsigned opb) {
    while (opa != opb) {
             if (opa > opb) opa -= opb;
        else if (opa < opb) opb -= opa;
    }
    return opa;
} 

unsigned twopow(unsigned n) {
    unsigned res = 1;
    while (n--) res *= 2;
    return res;
}

int main( int argc, char * argv[]) {

    if (argc < 3) usage("Too few arguments");
    if (argc > 3) usage("Too much arguments");
    unsigned addrwd = atoi(argv[1]); 
    unsigned valwd  = atoi(argv[2]); 
    if (addrwd > ADDRWDMAX) usage("<addrwd> too big (change ADDRWDMAX in source code)");

    unsigned valrange = twopow(valwd)-1; 
    unsigned valuenb = twopow(addrwd)/3;

    char *name = "value";
    unsigned namelen = strlen(name);
    unsigned rangelen = 1+(valwd-1)/4;
    
    for(int i=0; i < valuenb; i++) {
        unsigned opa = value(valrange);
        unsigned opb = value(valrange);
        unsigned res = pgcd(opa, opb);
        if (i==0) 
            printf ("%*s <= x\"%0*x\" when pt = %d\n", namelen, name, rangelen, opa, i);
        else
            printf ("%*s x\"%0*x\" when pt = %d\n", namelen+3, "else", rangelen, opa, 3*i);
        printf ("%*s x\"%0*x\" when pt = %d\n", namelen+3, "else", rangelen, opb, 3*i+1);
        printf ("%*s x\"%0*x\" when pt = %d\n", namelen+3, "else", rangelen, res, 3*i+2);
    }
    printf ("%*s x\"%0*x\";\n", namelen+3, "else", rangelen, 0);

    fprintf (stderr, "rom generated with %d triplets (opa, opb, res)\n", valuenb);
    return 0;
}

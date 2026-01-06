#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846 
#endif

#ifndef ADDRWDMAX   /* number of bits of rom address*/
#define ADDRWDMAX   16
#endif

void cossin(double a_p, char x_p, char y_p, char *nx_p, char *ny_p)
{
    *nx_p = (char) round(x_p * cos(a_p) - y_p * sin(a_p));
    *ny_p = (char) round(x_p * sin(a_p) + y_p * cos(a_p));
}


short F_PI = (short)((M_PI) * (1<<7));
short ATAN[8] = {
    0x65,                 // ATAN(2^-0)
    0x3B,                 // ATAN(2^-1)
    0x1F,                 // ATAN(2^-2)
    0x10,                 // ATAN(2^-3)
    0x08,                 // ATAN(2^-4)
    0x04,                 // ATAN(2^-5)
    0x02,                 // ATAN(2^-6)
    0x01,                 // ATAN(2^-7)
};

void cordic(short a_p, char x_p, char y_p, char *nx_p, char *ny_p)
{
    unsigned char i, q;
    short a, x, y, dx, dy;   
    
    // conversion en virgule fixe : 7 chiffres après la virgule
    a = a_p & 0b1111111100;
    x = x_p << 7;         
    y = y_p << 7;

    // normalisation de l'angle pour être dans le premier quadrant
    q = 0; 
    while (a >= F_PI/2) {
        a = a - F_PI/2; 
        q = (q + 1) & 3;
    }

    // rotation 
    for (i = 0; i <= 7; i++) {
        dx = x >> i;
        dy = y >> i;
        if (a >= 0) {
            x -= dy;
            y += dx;
            a -= ATAN[i];
        } else {
            x += dy;
            y -= dx;
            a += ATAN[i];
        }
    }

    // produit du résultat par les cosinus des angles : K=0x4E=1001110
    x = ((x>>6) + (x>>5) + (x>>4) + (x>>1))>>7;
    y = ((y>>6) + (y>>5) + (y>>4) + (y>>1))>>7;
    
    // placement du points dans le quadrant d'origine
    switch (q) {
    case 0:
        dx = x;
        dy = y;
        break;
    case 1:
        dx = -y;
        dy = x;
        break;
    case 2:
        dx = -x;
        dy = -y;
        break;
    case 3:
        dx = y;
        dy = -x;
        break;
    }
    *nx_p = dx;
    *ny_p = dy;
    // printf("nx = %d,ny = %d", dx, dy);
}

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
    unsigned valuenb = twopow(addrwd)/1;

    unsigned a_tab[1 << ADDRWDMAX];
    char nx_tab[1 << ADDRWDMAX];
    char ny_tab[1 << ADDRWDMAX];

    unsigned rangelen = 1+(valwd-1)/4;
    char *name = "a_in";
    unsigned namelen = strlen(name);
    char *name2 = "nx_in";
    unsigned namelen2 = strlen(name2);
    char *name3 = "ny_in";
    unsigned namelen3 = strlen(name3);
    
    for(int i=0; i < valuenb; i++) {
        unsigned a = value(valrange);
        unsigned x = 127;
        unsigned y = 0;
        char resnx, resny;
        cordic(a, x, y, &resnx, &resny);
        a_tab[i] = a;
        nx_tab[i] = resnx;
        ny_tab[i] = resny;
    }

    for(int i=0; i < valuenb; i++) {
        if (i==0) 
            printf ("%*s <= x\"%0*x\" when pt = %d\n", namelen, name, rangelen, a_tab[i], i);
        else
            printf ("%*s x\"%0*x\" when pt = %d\n", namelen+3, "else", rangelen, a_tab[i], i);
    }
    printf ("%*s x\"%0*x\";\n", namelen+3, "else", rangelen, 0);

    printf("\n");
    for(int i=0; i < valuenb; i++) {
        if (i==0) 
            printf ("%*s <= x\"%0*x\" when pt = %d\n", namelen2, name2, rangelen, nx_tab[i], i);
        else
            printf ("%*s x\"%0*x\" when pt = %d\n", namelen2+3, "else", rangelen, nx_tab[i], i);
    }
    printf ("%*s x\"%0*x\";\n", namelen2+3, "else", rangelen, 0);

    printf("\n");
    for(int i=0; i < valuenb; i++) {
        if (i==0) 
            printf ("%*s <= x\"%0*x\" when pt = %d\n", namelen3, name3, rangelen, ny_tab[i], i);
        else
            printf ("%*s x\"%0*x\" when pt = %d\n", namelen3+3, "else", rangelen, ny_tab[i], i);
    }
    printf ("%*s x\"%0*x\";\n", namelen3+3, "else", rangelen, 0);

    return 0;
}
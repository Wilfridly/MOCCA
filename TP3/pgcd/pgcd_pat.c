#include <stdio.h>
#include <math.h>
#include <assert.h>
#include "genpat.h"
#include "alloca.h"
#include "mut.h"

// Constante générales
const PERIOD = 2;

//--------------------------------------------------------------------------------------------------
// rend la date du cycle n°i ou du cycle n°i + 1 demi-cycle 
//--------------------------------------------------------------------------------------------------
#define cycle(i)        inttostr(i*PERIOD)
#define next_cycle(i)   inttostr(i*PERIOD + PERIOD/2)

//--------------------------------------------------------------------------------------------------
// Fabriquer une chaine de caractères à partir d'un entier
//
// namealloc fait l'équivalent de strdup() mais en plus il teste que la chaine 
//           en paramètre n'a pas déjà été allouée, si oui, namealloc rend
//           le pointeur sur la chaine déjà allouée, cette opération utilise
//           un dictionnaire (table de hachage)
//
// inttostr(42)         rend un pointeur sur "42"
// inttostr(42)         rend LE MÊME pointeur sur "42"
// inttostrx(0x42,4)    rend "0x0042"
// inttostrx(0x42,1)    rend "0x2"
// inttostrx(0x42,8)    rend "0x00000042"
// vector(A,B)          rend "A downto B" or "A to B" selon la valeur de A et de B
//--------------------------------------------------------------------------------------------------
static inline char *inttostr (int entier)
{
    char *str = (char *) alloca (32 * sizeof (char));   // allocation dans la pile

    sprintf (str, "%d", entier);
    return namealloc (str);     // utilise un dictionnaire
}

static inline char *inttostrX (int entier, int size)
{
    int mask;

    for (mask = 0; size; mask = (mask << 1) | 1, size--);
    char *str = (char *) alloca (32 * sizeof (char));   // allocation dans la pile

    sprintf (str, "0x%0*x", size, entier & mask);
    return namealloc (str);     // utilise un dictionnaire
}

static inline char *vector (int from, int to)
{
    char *str = (char *) alloca (32 * sizeof (char));   // allocation dans la pile
    if (from > to)
        sprintf (str, "%d downto %d", from, to);
    else
        sprintf (str, "%d to %d", to, from);
    return namealloc (str);     // utilise un dictionnaire
}

//--------------------------------------------------------------------------------------------------

int main ()
{

// since it is not possible to get arguments with genpat, 
// we use environment variables. The GETENV() macro try to get
// the variable env value and we can choose a default value for each 
#   define GETENV(var,def) getenv(var)?getenv(var):def

    char*    PATNAME= GETENV("PATNAME","default"); 
    unsigned VALWD  = atoi(GETENV("VALWD" ,"1"));
    unsigned ADDRWD = atoi(GETENV("ADDRWD","1"));
    unsigned CYCLES = atoi(GETENV("CYCLES","100"));

    DEF_GENPAT (PATNAME);

    // interface 
    // the 1st port must be "ko" port which is true in case of error
    DECLAR ("ko_p",     ":2", "B", OUT, "", "");

    DECLAR ("vdd",      ":2", "B", IN,  "", "");
    DECLAR ("vss",      ":2", "B", IN,  "", "");
    DECLAR ("ck",       ":2", "B", IN,  "", "");
    DECLAR ("nreset",   ":2", "B", IN,  "", "");

    // It is possible to see internal signals
    DECLAR ("wr_arg",   ":2", "B", SIGNAL, "", "");
    DECLAR ("argd",     ":2", "X", SIGNAL, vector(VALWD-1,0), "");
    DECLAR ("rd_arg",   ":2", "B", SIGNAL, "", "");
    DECLAR ("rd_res",   ":2", "B", SIGNAL, "", "");
    DECLAR ("res",      ":2", "X", SIGNAL, vector(VALWD-1,0), "");
    DECLAR ("wr_res",   ":2", "B", SIGNAL, "", "");

    DECLAR ("data.pt", ":1", "x", REGISTER, vector(ADDRWD-1,0), "");
    DECLAR ("data.opa", ":1", "B", REGISTER, "", "");
    DECLAR ("data.opb", ":1", "B", REGISTER, "", "");
    DECLAR ("data.res", ":1", "B", REGISTER, "", "");
    DECLAR ("data.stop", ":1", "B", REGISTER, "", "");
    DECLAR ("data.lastpt", ":1", "B", SIGNAL, "", "");

    DECLAR ("core.read_opa", ":1", "B", REGISTER, "", "");
    DECLAR ("core.read_opb", ":1", "B", REGISTER, "", "");
    DECLAR ("core.compare",  ":1", "B", REGISTER, "", "");
    DECLAR ("core.decr_a",   ":1", "B", REGISTER, "", "");
    DECLAR ("core.decr_b",   ":1", "B", REGISTER, "", "");

    AFFECT (cycle (0), "vdd", "1");
    AFFECT (cycle (0), "vss", "0");
    AFFECT (cycle (0), "nreset", "0");
    AFFECT (cycle (1), "nreset", "1");

    // la génération du signal d'horloge
    int c;
    for (c = 0; c <= CYCLES; c++) {
        AFFECT (cycle (c), "ck", inttostr (0));
        AFFECT (next_cycle (c), "ck", inttostr (1));
    }
    AFFECT (cycle (0), "nreset", "0");

    SAV_GENPAT ();
    return 0;
}

//--------------------------------------------------------------------------------------------------
// Pattern Generator for the Clicker
//--------------------------------------------------------------------------------------------------

#include "mygenpat.h"

int main ()
{

/// Get Environment Variables As Arguments

    char*    MODEL  = GETENV("MODEL","default"); 
    unsigned CYCLES = atoi(GETENV("CYCLES","100"));
    char*    TYPE   = GETENV("TYPE","BEH");

/// Define Filename 
    
    if (strcmp(TYPE,"BEH") == 0)
        DEF_GENPAT (toa("%s_gen",MODEL));
    else
        DEF_GENPAT (toa("%s_genx",MODEL));

/// External Signals (mandatory)

    DECLAR ("ck",       ":2", "B", IN,  "", "");
    DECLAR ("raz",      ":2", "B", IN,  "", "");
    DECLAR ("plus",     ":2", "B", IN,  "", "");
    DECLAR ("vdd",      ":2", "B", IN,  "", "");
    DECLAR ("vss",      ":2", "B", IN,  "", "");
    DECLAR ("led",      ":2", "B", OUT, vector(0,6), "");

/// Internal Signals (optionnal)

    if (strcmp(TYPE,"BEH") == 0)
        DECLAR (toa("%s_v.%s",MODEL,"val"), ":2", "X", REGISTER, vector(3,0), "");
    else
        DECLAR (toa("%s","val"), ":2", "X", SIGNAL, vector(3,0), "");

/// Signal Values
   
    AFFECT (cycle (0), "vdd", "1");
    AFFECT (cycle (0), "vss", "0");

    AFFECT (cycle (0), "raz", "1"); // Only first cycle
    AFFECT (cycle (1), "raz", "0");

    AFFECT (cycle (0), "plus", "1");

/// Clock Generator

    int c;
    for (c = 0; c <= CYCLES; c++) {
        AFFECT (cycle (c), "ck", itoa (0));
        AFFECT (next_cycle (c), "ck", itoa (1));
    }

/// Save The Generated Patterns

    SAV_GENPAT ();
    return 0;
}

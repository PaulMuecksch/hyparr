/* picoenum.c -- bounded model enumeration on top of the PicoSAT C API.
 *
 * Companion to the GAP file satproblems.gi (HypArr).  Reads a DIMACS CNF
 * from stdin and writes the models in the output format of "picosat
 * --all", so that ParseSATSolutions can read it unchanged.
 *
 *   usage: picoenum [<k> [<p>]]
 *     k : maximal number of models  (0 or absent = unbounded)
 *     p : block and print only the variables 1..p, i.e. enumerate the
 *         projection of the solution set onto them, each fibre once
 *         (absent = all variables)
 *
 *   exit status: 20  the solution set was exhausted
 *                10  stopped at the threshold, further models may exist
 *                 1  malformed input
 *
 *   build: cc -O2 -o picoenum picoenum.c libpicosat.a
 *
 * To switch to CaDiCaL replace the five solver calls as follows and link
 * with a C++ driver (-lstdc++):
 *   picosat_init/add/sat/deref/reset  ->
 *   ccadical_init/add/solve/val/release          (#include "ccadical.h")
 * The return codes agree; ccadical_val returns +-lit instead of +-1, but
 * only its sign is used below.
 */

#include <stdio.h>
#include <stdlib.h>
#include "picosat.h"

int main (int argc, char ** argv)
{
  long long maxsols = (argc > 1) ? atoll (argv[1]) : 0;   /* 0 = unbounded */
  int nrel          = (argc > 2) ? atoi  (argv[2]) : 0;   /* 0 = all vars   */
  long long sols = 0;
  int i, lit, nvars = 0, nclauses = 0, ch, res = PICOSAT_UNKNOWN;
  int * val;
  PicoSAT * ps = picosat_init ();

  /* minimal DIMACS reader; clauses may span lines, comments may not */
  while ((ch = getchar ()) != EOF)
    if (ch == 'c') { while ((ch = getchar ()) != EOF && ch != '\n') ; }
    else if (ch == 'p')
      { if (scanf (" cnf %d %d", &nvars, &nclauses) != 2)
          { fprintf (stderr, "picoenum: malformed header\n"); return 1; }
        picosat_adjust (ps, nvars); }
    else if (ch == '-' || ('0' <= ch && ch <= '9'))
      { ungetc (ch, stdin);
        if (scanf ("%d", &lit) != 1)
          { fprintf (stderr, "picoenum: malformed literal\n"); return 1; }
        picosat_add (ps, lit); }

  if (nrel <= 0 || nrel > nvars) nrel = nvars;
  val = malloc ((nvars + 1) * sizeof (int));
  if (!val) { fprintf (stderr, "picoenum: out of memory\n"); return 1; }

  while ((res = picosat_sat (ps, -1)) == PICOSAT_SATISFIABLE)
    {
      /* the assignment must be read out before any literal is added:
         picosat_add resets it (see picosat.h) */
      for (i = 1; i <= nrel; i++)
        val[i] = (picosat_deref (ps, i) > 0) ? 1 : -1;

      sols++;
      fputs ("s SATISFIABLE\nv", stdout);
      for (i = 1; i <= nrel; i++) printf (" %d", val[i] * i);
      fputs (" 0\n", stdout);

      if (maxsols && sols >= maxsols) break;

      for (i = 1; i <= nrel; i++) picosat_add (ps, -val[i] * i);
      picosat_add (ps, 0);                          /* blocking clause */
    }

  if (res == PICOSAT_UNSATISFIABLE) printf ("s SOLUTIONS %lld\n", sols);
  fflush (stdout);

  free (val);
  picosat_reset (ps);

  return (res == PICOSAT_UNSATISFIABLE) ? 20 : 10;
}

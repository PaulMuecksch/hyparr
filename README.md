# GAP 4 package `HypArr'

## Overview

Hyperplane arrangements appear in many different areas of mathematics, 
such as discrete and algebraic geometry, topology, combinatorics, etc..

[The package manual](https://paulmuecksch.github.io/HypArr/doc/chap0_mj.html) 
[pdf](https://paulmuecksch.github.io/HypArr/doc/manual.pdf)

Some things you can do with this package:

  * Determine freeness properties of arrangements.

  * Determine invariants of oriented matroids.
  
  * Construct the Milnor fiber complex of a real hyperplane arrangement and compute homotopy invariants.

  * Draw nice pictures (as tikz-code) of real arrangements in 3-space.

  * Compute the realization space of a geometric lattice.

  * Construct new arrangements satisfying certain properties via a greedy search algorithm over finite field.

## Installation

Clone the git repository to your pkg folder

 * From within GAP load the package with:

    gap> LoadPackage("hyparr");

    true

 * The documentation is in the `doc` subdirectory. 

## Documentation
To create the documentation:
    
    gap makedoc.g

<!-- To run the test files

    gap tst/testall.g -->
    
## License

HypArr is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 3 of the License, or (at your option) any later
version.

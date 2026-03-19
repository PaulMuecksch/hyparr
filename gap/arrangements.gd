#
# HypArr: Computations with hyperplane arrangements 
#
#! @Chapter Introduction
#!
#! HypArr is a package for computations with hyperplane arrangements,
#! oriented matroids, and their topological invariants, in particular Milnor fibers and complements.
#!
#! @Chapter Hyperplane arrangements
##
#############################################################################

#################################
##
## Global variables
##
#################################

# Declare the category
DeclareCategory("IsHyperplaneArrangement", IsComponentObjectRep and IsAttributeStoringRep );

# Declare the representation and its attribute accessor functions
DeclareRepresentation(
    "IsHyperplaneArrangementRep", 
    IsHyperplaneArrangement,
    ["roots","dimension","lattice","charpoly","salcpx"]
);

#################################
##
#! @Section Attributes
##
#################################

#! @Arguments A
#! @Returns a non-negative integer.
#! @Description
#! Returns the dimension of the ambient vector space in which the
#! hyperplane arrangement <A>A</A> is defined.
DeclareAttribute("Dimension", IsHyperplaneArrangement);

#! @Arguments A
#! @Returns A list of vectors defining the hyperplanes of <A>A</A>.
#! @Description
#! Returns the list of defining linear forms (also called
#! <E>roots</E>) of the hyperplanes in the arrangement <A>A</A>.
#! Each vector represents a hyperplane by the linear equation
#! <Display>
#!    r_1 x_1 + \cdots + r_n x_n = 0.
#! </Display>
DeclareAttribute("Roots", IsHyperplaneArrangement);

#! @Arguments A
#! @Returns A list of lists describing the intersections of <A>A</A>.
#! @Description
#! Computes the intersection lattice of the hyperplane arrangement <A>A</A>.
#!
#! The lattice is represented level-by-level.  The entry <M>L[k]</M>
#! contains all intersections of <M>k-1</M> hyperplanes.
#!
#! Each lattice element is stored as a list of indices referring to
#! hyperplanes in <C>Roots(A)</C>.
#!
#! For example, the list <C>[1,3]</C> represents the intersection of the
#! first and third hyperplane of the arrangement.
#!
#! The algorithm incrementally constructs the lattice by adding
#! hyperplanes one by one.
#!
#! @BeginExampleSession
#! gap> A := HyperplaneArrangement([[1,0],[0,1],[1,1]]);
#!  gap> IntersectionLattice(A);
#!  [ [ [ 1 ], [ 2 ], [ 3 ] ],
#!    [ [ 1, 2 ], [ 1, 3 ], [ 2, 3 ] ],
#!    [ [ 1, 2, 3 ] ] ]
#! @EndExampleSession
DeclareAttribute("IntersectionLattice", IsHyperplaneArrangement );

#! @Arguments A
#! @Returns a univariate polynomial with integral coefficients.
#! @Description
#! Returns <A>\chi</A> the <E>characterisitc polynomial</E> of the arrangement.
DeclareAttribute("CharPoly", IsHyperplaneArrangement);

#! @Arguments A
#! @Returns A list encoding multiset invariants of the intersection lattice.
#! @Description
#! Computes multiset invariants of the intersection lattice of the
#! hyperplane arrangement <A>A</A>.
#!
#! For each level of the lattice, the function records how many
#! intersections occur with a given number of defining hyperplanes.
#!
#! These invariants can be used to compare arrangements or detect
#! combinatorial similarities between intersection lattices.
DeclareAttribute("MSetInvL", IsHyperplaneArrangement );

#! @Arguments A
#! @Returns true or false.
#! @Description
#! Determines, if the hyperplane arrangement is defined over the reals, i.e.,
#! if the entries of the defining linear forms are real.
DeclareProperty("IsReal", IsHyperplaneArrangement );

#! @Arguments A
#! @Returns FacePoset
#! @Description Constructs the Salvetti Complex
#! 
DeclareAttribute("SalvettiComplex", IsHyperplaneArrangement);

#################################
##
## @Section Global methods
##
#################################

# some auxillary functions
DeclareGlobalFunction( "HypArr_PWLinInd" );
DeclareGlobalFunction( "HypArr_wg" );
DeclareGlobalFunction( "HypArr_wg3" );
DeclareGlobalFunction( "HypArr_AddHToL" );
DeclareGlobalFunction( "tnow");
DeclareGlobalFunction("cj");

DeclareGlobalFunction("RotTozMat");
DeclareGlobalFunction("ctf");

#! @Arguments A
#! @Returns A string.
#! @Description
#! Generates tikz-code 
#! for a nice projective picture of the real 3-arrangement.
DeclareGlobalFunction("DrawLatex3Arr");

#! @Arguments Intgers p,q,l
#! @Returns A hyperplane arrangement.
#! @Description
#!  Constructs the reflection arrangement associated to the monomial
#!  complex reflection group <M>G(p,q,l)</M>.
#!  The hyperplanes are defined by equations of the form
#!  <Display>
#!     x_i = \zeta^k x_j
#!  </Display>
#!  where <M>\zeta</M> is a primitive <M>p</M>-th root of unity.
#! @BeginExampleSession
#! gap> A := AGpql(2,1,3);
#!  <HyperplaneArrangement: 9 hyperplanes in 3-space>
#! gap> Roots(A);
#! [ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 0, 0, 1 ], 
#!   [ 1, 1, 0 ], [ 1, -1, 0 ], [ 1, 0, 1 ], 
#!   [ 1, 0, -1 ], [ 0, 1, 1 ], [ 0, 1, -1 ] ]
#! 
#! @EndExampleSession
DeclareGlobalFunction( "AGpql" );

DeclareGlobalFunction( "HArrResHvec" );

#! @Arguments A
#! @Returns A hyperplane arrangement.
#! @Description
#! Computes the <E>restriction</E> of the arrangement <A>A</A> to the
#!  <A>k</A>-th hyperplane of <C>Roots(A)</C>.
DeclareGlobalFunction( "HArrResHind" );

#! @Arguments A, S
#! @Returns A hyperplane arrangement.
#! @Description
#! Computes the <E>restriction</E> of the arrangement <A>A</A> to the
#! subspace spanned by the vectors in <C>S</C>.
DeclareGlobalFunction( "HArrResX" );

#! @Arguments A
#! @Returns A hyperplane arrangement.
#! @Description
#! Computes the <E>essentialization</E> of the hyperplane arrangement
## <A>A</A>.
#! An arrangement is called essential if the intersection of all its
#! hyperplanes is the origin.  If this is not the case, the function
#! restricts the arrangement to a complementary subspace so that the
#! resulting arrangement becomes essential.
DeclareGlobalFunction( "Essentialization");

#################################
##
#! @Section Constructors
##
#################################

#! @Arguments r
#! @Returns A hyperplane arrangement
#! @Description
#!  Constructs a hyperplane arrangement from a list <A>R</A> of vectors
#!  representing defining linear forms of hyperplanes.
#!
#!  Each vector <M>r = [r_1,\dots,r_n]</M> corresponds to the hyperplane
#!  <Display>
#!     r_1 x_1 + \cdots + r_n x_n = 0.
#!  </Display>
#!  The vectors must lie in the same vector space.
#!
#!  Linearly dependent defining forms are removed automatically, so the
#!  resulting arrangement only stores pairwise linearly independent
#!  hyperplanes.
#!
#! @BeginExampleSession
#! gap> A := HyperplaneArrangement([[1,0,0],[0,1,0],[0,0,1]]);
#! <HyperplaneArrangement: 3 hyperplanes in 3-space>
#! gap> Roots(A);
#! [ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 0, 0, 1 ] ]
#! @EndExampleSession
DeclareOperation("HyperplaneArrangement", [ IsList ]);


#################################
##
#! @Section Display
##
#################################
# Declare display function for HyperplaneArrangement objects
DeclareOperation("ViewObject", [ IsHyperplaneArrangement ]);

##
##  This program is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program.  If not, see <http://www.gnu.org/licenses/>.
##

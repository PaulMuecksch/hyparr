#
# HypArr: Computations with hyperplane arrangements
#
#! @Chapter Introduction
#!
#! <B>HypArr</B> is a <B>GAP 4</B> package for computations with hyperplane arrangements (see <Cite Key="OrTer92_Arr"/>),
#! oriented matroids (see <Cite Key="BLSWZ1999_OrientedMatroids"/>), their combinatorial and topological invariants, in particular 
#! geometric lattices, face posets, Milnor fibers and complements.
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

DeclareCategory("IsGeomLattice", IsComponentObjectRep and IsAttributeStoringRep );

# Declare the representation and its attribute accessor functions
DeclareRepresentation(
    "IsHyperplaneArrangementRep",
    IsHyperplaneArrangement,
    ["roots","dimension","lattice","charpoly","salcpx","exp"]
);

DeclareRepresentation(
    "IsGeomLatticeRep",
    IsGeomLattice,
    ["grGroundSet", "rank", "kFlats", "atoms"]
);

#################################
##
#! @Section Attributes
##
#################################

#! @Subsection Attributes of arrangements
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
#! <E>roots</E>) of the hyperplanes in the arrangement <M>\mathcal{A}</M>.
#! Each vector represents a hyperplane by the linear equation
#! <Display>
#!    r_1 x_1 + \cdots + r_n x_n = 0.
#! </Display>
DeclareAttribute("Roots", IsHyperplaneArrangement);

#! @Arguments A
#! @Returns An object of type <C>IsGeomLattice</C>.
#! @Description
#! Computes the intersection lattice of the hyperplane arrangement <M>\mathcal{A}</M>.
#!
#! The lattice is represented level-by-level.  The entry <M>L[k]</M>
#! contains all intersections of rank <M>k</M>.
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
#! gap> IntersectionLattice(A);
#! <Geometric lattice: 3 atoms, rank 2>
#! @EndExampleSession
DeclareAttribute("IntersectionLattice", IsHyperplaneArrangement );

#! @Arguments A
#! @Returns a univariate polynomial with integral coefficients.
#! @Description
#! Returns $\chi_{\mathcal{A}}$ the <E>characterisitc polynomial</E> of the arrangement $\mathcal{A}$.
#! @BeginExampleSession
#! gap> A:=AGpql(2,2,3);
#! <HyperplaneArrangement: 6 hyperplanes in 3-space>
#! gap> CharPoly(A);
#! t^3-6*t^2+11*t-6
#! @EndExampleSession
DeclareAttribute("CharPoly", IsHyperplaneArrangement);


#! @Arguments A
#! @Returns a list of integers or fail
#! @Description
#! Returns <E>exponents</E> of the arrangement $\mathcal{A}$ if
#! all the characteristic polynomial factors over the integers.
#! @BeginExampleSession
#! gap> A:=HyperplaneArrangement([[1,0],[0,1],[1,1]]);
#! <HyperplaneArrangement: 3 hyperplanes in 2-space>
#! gap> ExpArr(A);
#! [ 1, 2 ]
#! @EndExampleSession
DeclareAttribute("ExpArr", IsHyperplaneArrangement);


#! @Arguments A
#! @Returns An object of type IsGeomLattice.
#! @Description
#! Computes multiset invariants of the intersection lattice of the
#! hyperplane arrangement <A>A</A>.
#!
#! For each level of the lattice, the function records how many
#! intersections occur with a given number of defining hyperplanes.
#!
#! These invariants can be used to compare arrangements or detect
#! combinatorial similarities between intersection lattices.
#! @BeginExampleSession
#! gap> A:=HyperplaneArrangement([[1,0,0,],[0,1,0],[0,0,1],[1,1,1]]);
#! <HyperplaneArrangement: 4 hyperplanes in 3-space>
#! gap> MSetInvL(A);
#! [ [ [ 1, 4 ] ], [ [ 2, 6 ] ], [ [ 4, 1 ] ] ]
#! @EndExampleSession
DeclareAttribute("MSetInvL", IsHyperplaneArrangement );

#! @Arguments A
#! @Returns true or false.
#! @Description
#! Determines, if the hyperplane arrangement is defined over the reals, i.e.,
#! if the entries of the defining linear forms are real.
DeclareProperty("IsReal", IsHyperplaneArrangement );

#! @Arguments A
#! @Returns FacePoset
#! @Description
#! Constructs the Salvetti Complex <Cite Key="Salvetti1987_SalCpx"/>.
#! If <C>IsReal(A)</C> is false, then it returns <C>fail</C>.
#! @BeginExampleSession
#! gap> A:=HyperplaneArrangement([[1,0],[0,1],[1,1]]);
#! <HyperplaneArrangement: 3 hyperplanes in 2-space>
#! gap> SalvettiComplex(A);
#! <FacePoset of dimension 2 with f-vector [ 6, 12, 6 ]>
#! @EndExampleSession
DeclareAttribute("SalvettiComplex", IsHyperplaneArrangement);



#! @Subsection Attributes of geometric lattices
#################################

#! @Arguments L
#! @Returns list of lists
#! @Description
#! Returns the ground set of the geometric lattice <A>L</A>.
DeclareAttribute("GLGroundSet", IsGeomLattice);

#! @Arguments L
#! @Returns list
#! @Description
#! Returns the set of atoms of <A>L</A>.
DeclareAttribute("GLAtoms", IsGeomLattice);

#! @Arguments L
#! @Returns a non-negative integer
#! @Description
#! Returns the rank of <A>L</A>.
DeclareAttribute("GLRank", IsGeomLattice);

#! @Arguments L
#! @Returns a function
#! @Description
#! Returns a function extracting the flats of rank $k$ in <A>L</A>.
DeclareAttribute("GLkFlats", IsGeomLattice);

#################################
##
#! @Section Global methods
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

DeclareGlobalFunction("FloatStringCutoff");

#! @Arguments A,[ps,[ip,[Hind,[disthv,[MarkHs]]]]]
#! @Returns A string.
#! @Description
#! Generates tikz-code
#! for a nice projective picture of the real 3-arrangement.
#!
#! The example below will look as follows (only in pdf).
#!
#! @BeginExampleSession
#! gap> A:=AGpql(2,2,3);
#! <HyperplaneArrangement: 6 hyperplanes in 3-space>
#! gap> Print(DrawLatex3Arr(A));
#! \begin{tikzpicture}[scale=1.0]
#! \draw (-2.828,2.828) -- (2.828,-2.828);  % H_1
#! \draw (2.828,2.828) -- (-2.828,-2.828);  % H_2
#! \draw (-1.,3.872) -- (-1.,-3.872);  % H_3
#! \draw (1.,3.872) -- (1.,-3.872);  % H_4
#! \draw (3.872,-1.) -- (-3.872,-1.);  % H_5
#! \draw (3.872,1.) -- (-3.872,1.);  % H_6
#!
#! \end{tikzpicture}
#! @EndExampleSession
#! 
#! @BeginLatexOnly
#! \includegraphics{./other/DrawLatex3Arr_Example.pdf}
#! @EndLatexOnly
#! 
DeclareGlobalFunction("DrawLatex3Arr");

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

BindGlobal("Arr",HyperplaneArrangement);

#################################
##
#! @Section Display
##
#################################
# Declare display function for HyperplaneArrangement objects
DeclareOperation("ViewObject", [ IsHyperplaneArrangement ]);


# Declare display function for GeomLattice objects
DeclareOperation("ViewObject", [ IsGeomLattice ]);

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

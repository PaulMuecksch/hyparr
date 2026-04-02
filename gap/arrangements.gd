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
#!
#! Let $\mathbb{K}$ be a field.
#! A hyperplane arrangment is a finite set $\mathcal{A} = \{H_1,\ldots,H_n\}$
#! of hyperplanes in a finite dimensional $\mathbb{K}$-vector space $V$.  
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
    ["grGroundSet", "rank", "kFlats", "atoms", "charpoly", "moebius"]
);

#################################
##
#! @Section Construction of arrangements of hyperplanes 
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

DeclareSynonym("Arr",HyperplaneArrangement);

#################################
##
#! @Section Attributes of arrangements
##
#################################

#! @Arguments A
#! @Returns A non-negative integer.
#! @Description
#! Returns the dimension of the ambient vector space in which the
#! hyperplane arrangement <A>A</A> is defined.
#! @BeginExampleSession
#! gap> A:=HyperplaneArrangement([[1,0,0],[0,1,0]]); Dimension(A);
#! <HyperplaneArrangement: 2 hyperplanes in 3-space>
#! 3
#! @EndExampleSession
DeclareAttribute("Dimension", IsHyperplaneArrangement);

#! @Arguments A
#! @Returns A list of vectors.
#! @Description
#! Returns the list of vectors giving defining linear forms (also called
#! <E>roots</E>) of the hyperplanes in the arrangement <A>A</A>.
#! @BeginExampleSession
#! gap> A:=AGpql(3,3,2); Roots(A);
#! <HyperplaneArrangement: 3 hyperplanes in 2-space>
#! [ [ 1, -E(3) ], [ 1, -E(3)^2 ], [ 1, -1 ] ]
#! @EndExampleSession
DeclareAttribute("Roots", IsHyperplaneArrangement);

# @Description Synonym for <C>Roots</C>.
DeclareSynonym( "LForms" ,Roots);

#! @Arguments A
#! @Returns An object of type <C>IsGeomLattice</C>.
#! @Description
#! Computes the intersection lattice of the hyperplane arrangement <A>A</A>.
#!
#! The ground set <C>L</C> (see <Ref Attr="LGroundSet" Label="for IsGeomLattice" Style="Text"/>) 
#! of the lattice is represented level-by-level.  
#! The entry <C>L[k]</C> contains all intersections of rank $k$.
#!
#! Each lattice element is stored as a list of indices referring to
#! hyperplanes in <C>Roots(A)</C>.
#!
#! For example, the list <C>[1,3]</C> represents the intersection of the
#! first and third hyperplane of the arrangement.
#!
#! @BeginExampleSession
#! gap> A := HyperplaneArrangement([[1,0,0],[0,1,0],[0,0,0],[1,1,1]]);
#! <HyperplaneArrangement: 3 hyperplanes in 3-space>
#! gap> L:=IntersectionLattice(A); LGroundSet(L);
#! <Geometric lattice: 3 atoms, rank 3>
#! [ [ [ 1 ], [ 2 ], [ 3 ] ], 
#!   [ [ 1, 2 ], [ 1, 3 ], [ 2, 3 ] ], 
#!   [ [ 1, 2, 3 ] ] ]
#! @EndExampleSession
DeclareAttribute("IntersectionLattice", IsHyperplaneArrangement );

#! @Arguments A
#! @Returns a univariate polynomial with integral coefficients.
#! @Description
#! Returns $\chi_{\mathcal{A}}$ the <E>characterisitc polynomial</E> of the arrangement <A>A</A>.
#! @BeginExampleSession
#! gap> A:=AGpql(2,2,3);
#! <HyperplaneArrangement: 6 hyperplanes in 3-space>
#! gap> CharPoly(A);
#! t^3-6*t^2+11*t-6
#! @EndExampleSession
DeclareAttribute("CharPoly", IsHyperplaneArrangement);


#! @Arguments A
#! @Returns a list of integers, or fail
#! @Description
#! Returns <E>exponents</E> of the arrangement $\mathcal{A}$ if
#! the characteristic polynomial factors over the integers.
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
#! Computes multiset invariants of the intersection lattice 
#! (see <Ref Attr="IntersectionLattice" Label="for IsHyperplaneArrangement" Style="Text"/>)
#! of the
#! hyperplane arrangement <A>A</A>.
#!
#! For each level of the lattice, the function records how many
#! intersections occur with a given number of defining hyperplanes.
#!
#! @BeginExampleSession
#! gap> A:=HyperplaneArrangement([[1,0,0,],[0,1,0],[0,0,1],[1,1,1]]);
#! <HyperplaneArrangement: 4 hyperplanes in 3-space>
#! gap> MSetInvL(A);
#! [ [ [ 1, 4 ] ], [ [ 2, 6 ] ], [ [ 4, 1 ] ] ]
#! @EndExampleSession
DeclareAttribute("MSetInvL", IsHyperplaneArrangement );

#################################
##
#! @Section Properties of arrangements
##
#################################


#! @Arguments A
#! @Returns true or false.
#! @Description
#! Determines, if the hyperplane arrangement is defined over the reals, i.e.,
#! if the entries of the defining linear forms are real.
DeclareProperty("IsReal", IsHyperplaneArrangement );


#! @Arguments A
#! @Returns true or false.
#! @Description
#! Determines, if the hyperplane arrangement is irreducible.
DeclareProperty("HArrIsIrreducible", IsHyperplaneArrangement );


#! @Arguments A
#! @Returns true or false.
#! @Description
#! Determines, if the hyperplane arrangement is generic.
#! See also <Ref Prop="LIsGeneric" Label="for IsGeomLattice" Style="Text"/>.
#! @BeginExampleSession
#! gap> A := HyperplaneArrangement([[1,0,0],[0,1,0],[0,0,1],[1,1,0],[1,1,1]]);
#! <HyperplaneArrangement: 5 hyperplanes in 3-space>
#! gap> HArrIsGeneric(A);
#! false
#! gap> A := HyperplaneArrangement([[1,0,0],[0,1,0],[0,0,1],[1,1,1]]);
#! <HyperplaneArrangement: 4 hyperplanes in 3-space>
#! gap> HArrIsGeneric(A);
#! true
#! @EndExampleSession
DeclareProperty("HArrIsGeneric", IsHyperplaneArrangement );

#################################
##
#! @Section Attributes of geometric lattices
##
#################################

#! @Arguments L
#! @Returns list of lists
#! @Description
#! Returns the ground set of the geometric lattice <A>L</A>.
DeclareAttribute("LGroundSet", IsGeomLattice);

#! @Arguments L
#! @Returns list
#! @Description
#! Returns the set of atoms of <A>L</A>.
DeclareAttribute("LAtoms", IsGeomLattice);

#! @Arguments L
#! @Returns a non-negative integer
#! @Description
#! Returns the rank of <A>L</A>.
DeclareAttribute("LRank", IsGeomLattice);

#! @Arguments L
#! @Returns a function
#! @Description
#! Returns a function extracting the flats of rank $k$ in <A>L</A>.
DeclareAttribute("LkFlats", IsGeomLattice);

#! @Arguments L
#! @Returns A function
#! @Description
#! Returns the rank function of the geometric lattice <A>L</A>.
DeclareAttribute("LRankFunction", IsGeomLattice);;

#! @Arguments L
#! @Returns a graph
#! @Description
#! Constructs the directed graph of the Hasse diagram of L.
DeclareAttribute("LGraph", IsGeomLattice);;

#! @Arguments L
#! @Returns a group
#! @Description
#! Computes the autmorphism group of L
#! as a subgroup of <C>Sym(LAtoms(L))</C>.
DeclareAttribute("LAutGroup", IsGeomLattice);;

#! @Arguments L
#! @Returns function
#! @Description
#! Returns the Moebius function of <A>L</A>.
DeclareAttribute("LMoebius", IsGeomLattice);


#! @Arguments L
#! @Returns function
#! @Description
#!  Computes the characteristic polynomial of <A>L</A>.
DeclareAttribute("LCharPoly", IsGeomLattice);


#################################
##
#! @Section Properties of geometric lattices
##
#################################



#! @Arguments L
#! @Returns true or false.
#! @Description
#! Determines, if L is irreducible.
DeclareProperty("LIsIrreducible", IsGeomLattice );


#! @Arguments L
#! @Returns true or false.
#! @Description
#! Determines, if L is a boolean lattice.
#! @BeginExampleSession
#! gap> L:=IntersectionLattice(HyperplaneArrangement([[1,0],[1,1]]));
#! <Geometric lattice: 2 atoms, rank 2>
#! gap> LIsBoolean(L);
#! true
#! gap> L:=IntersectionLattice(HyperplaneArrangement([[1,0],[0,1],[1,1]]));
#! <Geometric lattice: 3 atoms, rank 2>
#! gap> LIsBoolean(L);
#! false
#! @EndExampleSession
DeclareProperty("LIsBoolean", IsGeomLattice );


#! @Arguments L
#! @Returns true or false.
#! @Description
#! Determines, if L is generic, i.e. if L is irreducible 
#! and all proper intervals are boolean.
#! @BeginExampleSession
#! gap> A := HyperplaneArrangement([[1,0,0],[0,1,0],[0,0,1],[1,1,1]]);
#! <HyperplaneArrangement: 4 hyperplanes in 3-space>
#! gap> L:=IntersectionLattice(A);
#! <Geometric lattice: 4 atoms, rank 3>
#! gap> LIsGeneric(L);
#! true
#! gap> A := HyperplaneArrangement([[1,0,0],[0,1,0],[0,0,1],[1,1,0],[1,1,1]]);
#! <HyperplaneArrangement: 5 hyperplanes in 3-space>
#! gap> L:=IntersectionLattice(A);
#! <Geometric lattice: 5 atoms, rank 3>
#! gap> LIsGeneric(L);
#! false
#! @EndExampleSession
DeclareProperty("LIsGeneric", IsGeomLattice );

#################################
##
#! @Section Operations
##
#################################

#! @Arguments A, B
#! @Returns true or false
#! @Description
#! Determines if the arrangements <A>A</A> and <A>B</A> 
#! have isomorphic intersection lattices.
#!
#! @BeginExampleSession
#! gap> A:=Arr([[1,0,0],[0,1,0],[0,0,1],[1,1,0],[0,1,1],[1,1,3]]);
#! <HyperplaneArrangement: 6 hyperplanes in 3-space>
#! gap> B:=AGpql(2,2,3);
#! <HyperplaneArrangement: 6 hyperplanes in 3-space>
#! gap> IsLEquiv(A,B);
#! false
#! gap> A:=Arr([[1,0,0],[0,1,0],[0,0,1],[1,1,0],[0,1,1],[1,1,1]]);
#! <HyperplaneArrangement: 6 hyperplanes in 3-space>
#! gap> IsLEquiv(A,B);
#! true
#! @EndExampleSession
DeclareOperation("IsLEquiv", [IsHyperplaneArrangement,IsHyperplaneArrangement]);


#! @Arguments A
#! @Returns A hyperplane arrangement.
#! @Description
#! Computes the <E>essentialization</E> of the hyperplane arrangement
#! <A>A</A>.
#! An arrangement is called essential if the intersection of all its
#! hyperplanes is the origin.  If this is not the case, the function
#! restricts the arrangement to a complementary subspace so that the
#! resulting arrangement becomes essential.
#! @BeginExampleSession
#! gap> A:=Arr([[1,0,0],[0,1,0],[1,1,0]]);
#! <HyperplaneArrangement: 3 hyperplanes in 3-space>
#! gap> B:=Essentialization(A); Roots(B);
#! <HyperplaneArrangement: 3 hyperplanes in 2-space>
#! [ [ 1, 0 ], [ 0, 1 ], [ 1, 1 ] ]
#! @EndExampleSession
DeclareOperation( "Essentialization", [IsHyperplaneArrangement]);

DeclareOperation( "LLocalizationRk", [IsGeomLattice, IsList, IsInt]);

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

# DeclareGlobalFunction("");;

DeclareGlobalFunction( "HArrResHvec" );

#! @Arguments A, i
#! @Returns A hyperplane arrangement.
#! @Description
#! Computes the <E>restriction</E> of the arrangement <A>A</A> to the
#!  <A>i</A>-th hyperplane of <C>Roots(A)</C>.
DeclareGlobalFunction( "HArrResHind" );

#! @Arguments A, S
#! @Returns A hyperplane arrangement.
#! @Description
#! Computes the <E>restriction</E> of the arrangement <A>A</A> to the
#! subspace orthogonal to the vectors in <C>S</C>.
DeclareGlobalFunction( "HArrResX" );


#! @Arguments A,[ps,[ip,[Hind,[disthv,[MarkHs]]]]]
#! @Returns A string.
#! @Description
#! Generates LaTeX tikz-code
#! for a nice projective picture of the real 3-arrangement.
#! If $x,y,z$ are the coordinates, by default, 
#! this is the 2-dim affine arrangement
#! obtained by intersecting <A>A</A> with the plane $z=1$.
#! 
#! The optional parameters are:
#!  * <A>ps</A> a scaling factor,
#!  * <A>ip</A> intersection points are drawn,
#!  * <A>Hind</A> labels for the hyperplanes are added,
#!  * <A>disthv</A> a vector giving the normal of the plane whith which to intersect <A>A</A>,
#!  * <A>MarkHs</A> a list of indices of hyperplanes of <A>A</A>, these are drawn in another color.
#!
#! The example below will look as follows (only in pdf).
#!
#! @BeginExampleSession
#! gap> A:=AGpql(2,2,3);
#! <HyperplaneArrangement: 6 hyperplanes in 3-space>
#! gap> Print(DrawLatex3Arr(A));
#! \begin{tikzpicture}[scale=1.0]
#! \draw (-2.827,2.827) -- (2.827,-2.827);  % H_1 
#! \draw (2.827,2.827) -- (-2.827,-2.827);  % H_2 
#! \draw (-1.,3.873) -- (-1.,-3.873);  % H_3 
#! \draw (1.,3.873) -- (1.,-3.873);  % H_4 
#! \draw (3.873,-1.) -- (-3.873,-1.);  % H_5 
#! \draw (3.873,1.) -- (-3.873,1.);  % H_6 
#! \end{tikzpicture}
#! gap> Print(DrawLatex3Arr(A,1/2,true,true,[1,1,1],[1,2]));
#! \begin{tikzpicture}[scale=1.0]
#! \draw[color=red] (-3.559,1.827) -- (1.827,-3.559);  % H_1 
#! \node at (1.975,-3.707) {\small $1$}; 
#! \draw[color=red] (2.827,2.827) -- (-2.827,-2.827);  % H_2 
#! \node at (-2.970,-2.970) {\small $2$}; 
#! \draw (3.361,2.169) -- (-3.995,0.197);  % H_3 
#! \node at (-4.198,0.143) {\small $3$}; 
#! \draw (-1.034,3.863) -- (1.034,-3.863);  % H_4 
#! \node at (1.087,-4.057) {\small $4$}; 
#! \draw (2.169,3.361) -- (0.197,-3.995);  % H_5 
#! \node at (0.143,-4.198) {\small $5$}; 
#! \draw (-3.863,1.034) -- (3.863,-1.034);  % H_6 
#! \node at (4.057,-1.087) {\small $6$}; 
#! 
#! \fill[red] (-0.865,-0.865) circle[radius=2pt];  % P[ 1, 2 ] 
#! \fill[red] (-2.366,0.634) circle[radius=2pt];  % P[ 1, 3, 6 ] 
#! \fill[red] (1.732,1.732) circle[radius=2pt];  % P[ 2, 3, 5 ] 
#! \fill[red] (0.634,-2.366) circle[radius=2pt];  % P[ 1, 4, 5 ] 
#! \fill[red] (0.0,0.0) circle[radius=2pt];  % P[ 2, 4, 6 ] 
#! \fill[red] (-0.317,1.183) circle[radius=2pt];  % P[ 3, 4 ] 
#! \fill[red] (1.183,-0.317) circle[radius=2pt];  % P[ 5, 6 ] 
#! 
#! \end{tikzpicture}
#! 
#! @EndExampleSession
#! 
#! @BeginLatexOnly
#! \includegraphics{./other/DrawLatex3Arr_Example.pdf}
#! @EndLatexOnly
#! 
DeclareGlobalFunction("DrawLatex3Arr");

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

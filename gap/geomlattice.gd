#
# HypArr: Computations with hyperplane arrangements
#
#! @Chapter Geometric lattices and matroids
#! 
##
#############################################################################

#################################
##
## Global variables
##
#################################


DeclareCategory("IsGeomLattice", IsComponentObjectRep and IsAttributeStoringRep );


DeclareRepresentation(
    "IsGeomLatticeRep",
    IsGeomLattice,
    ["grGroundSet", "rank", "kFlats", "atoms", "charpoly", "moebius", "islinear", "linspaces"]
);


#################################
##
#! @Section Construction of geometric lattices
##
#################################

#! @Arguments gs
#! @Returns An object of type <C>IsGeomLattice</C>.
#! @Description
#!  Constructs a geometric lattice from a list <A>gs</A> of lists of lists
#!  giving its ground set (see <Ref Attr="LGroundSet" Label="for IsGeomLattice" Style="Text"/>).
#!
#!  The entry <C>gs[k]</C> contains all flats of rank $k$, where each flat is
#!  given by the list of the indices of the atoms below it.
#!
#!  The flats are converted into sets of positive integers, the rank of the
#!  lattice is the number of levels <C>Length(gs)</C> and the atoms are read
#!  off from the first level <C>gs[1]</C>.
#!
#!  No check is performed whether <A>gs</A> really defines a geometric lattice.
#!
#! @BeginExampleSession
#! gap> L:=GeomLattice([[[1],[2],[3]],[[1,2],[1,3],[2,3]],[[1,2,3]]]);
#! <Geometric lattice: 3 atoms, rank 3>
#! gap> LGroundSet(L);
#! [ [ [ 1 ], [ 2 ], [ 3 ] ],
#!   [ [ 1, 2 ], [ 1, 3 ], [ 2, 3 ] ],
#!   [ [ 1, 2, 3 ] ] ]
#! gap> LCharPoly(L);
#! t^3-3*t^2+3*t-1
#! @EndExampleSession
DeclareOperation("GeomLattice", [ IsList ]);

DeclareOperation("GeomLattice", [ IsList, IsInt, IsString ]);
DeclareOperation("GeomLattice", [ IsList, IsString ]);

#################################
##
#! @Section Attributes of geometric lattices
##
#################################

#! @Arguments L
#! @Returns list of lists
#! @Description
#! Returns the ground set, i.e. the flats of the geometric lattice <A>L</A> as subsets of <C>LAtoms(L)</C>.
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
#! @Returns a list of lists
#! @Description
#! Gives the circuits of <A>L</A>.
DeclareAttribute("LCircuits", IsGeomLattice);

#! @Arguments L
#! @Returns A function
#! @Description
#! Returns the rank function of the geometric lattice <A>L</A>.
DeclareAttribute("LRankFunction", IsGeomLattice);

#! @Arguments L
#! @Returns a graph
#! @Description
#! Constructs the directed graph of the Hasse diagram of L.
DeclareAttribute("LGraph", IsGeomLattice);

#! @Arguments L
#! @Returns a group
#! @Description
#! Computes the autmorphism group of L
#! as a subgroup of <C>Sym(LAtoms(L))</C>.
DeclareAttribute("LAutGroup", IsGeomLattice);

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


#! @Arguments L
#! @Returns list of bases
#! @Description
#! Determines the subsets of <C>LAtoms(L)</C> which are bases.
#! @BeginExampleSession
#! @EndExampleSession
DeclareAttribute("LBases", IsGeomLattice);

#! @Arguments L
#! @Returns An List of Lists of Lists.
#! @Description
#! Computes multiset invariants of the geometric lattice <A>L</A>.
#!
#! For each level of the lattice, the function records how many
#! intersections occur with a given number of defining hyperplanes.
#!
#! @BeginExampleSession
#! @EndExampleSession
DeclareAttribute("LMSetInv", IsGeomLattice );

#! @Arguments L
#! @Returns true or false.
#! @Description
#! Determines, if L is linear, i.e. is the intersection lattice of a hyperplane arrangement over some field.
DeclareProperty("LIsLinear", IsGeomLattice );

#! @Arguments L
#! @Returns list of lists
#! @Description
#! Returns the subspaces given by a some bases corresponding to the flats of <A>L</A>.
DeclareAttribute("LLinSpaces", IsGeomLattice and LIsLinear);


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


#! @Arguments L
#! @Returns true or false.
#! @Description
#! Determines, if L has a generic atom,
#! that is, an element of the ground set such that all hyperplanes containing it are boolean.
#! @BeginExampleSession
#! @EndExampleSession
DeclareProperty("LHasGenericAtom", IsGeomLattice );

#################################
##
#! @Section Operations
##
#################################

#! @Arguments L, m
#! @Returns list of bases of m
#! @Description
#! Computes the bases of <A>m</A> in <A>L</A>.
#! @BeginExampleSession
#! @EndExampleSession
DeclareOperation("LBsOfFlat",[IsGeomLattice, IsList]);

#! @Arguments L,B,e
#! @Returns list
#! @Description
#! Determines the circuit contained in <C>Union(B,[e])</C>.
#! @BeginExampleSession
#! @EndExampleSession
DeclareOperation("LBaseCircuit", [IsGeomLattice,IsList,IsInt]);


#! @Arguments LA, LB
#! @Returns true or false
#! @Description
#! Determines if the geometric lattices <A>LA</A> and <A>LB</A> 
#! are isomorphic.
#!
#! @BeginExampleSession
#! gap> A:=HyperplaneArrangement([[1,0],[0,1],[1,1]]); B:=HyperplaneArrangement([[1,0],[1,1],[1,2]]);
#! <HyperplaneArrangement: 3 hyperplanes in 2-space>
#! <HyperplaneArrangement: 3 hyperplanes in 2-space>
#! gap> LA:=IntersectionLattice(A); LB:=IntersectionLattice(B);
#! <Geometric lattice: 3 atoms, rank 2>
#! <Geometric lattice: 3 atoms, rank 2>
#! gap> LIsIsomorphic(LA,LB);
#! true
#! @EndExampleSession
DeclareOperation("LIsIsomorphic", [IsGeomLattice,IsGeomLattice]);




DeclareOperation( "LLocalizationRk", [IsGeomLattice, IsList, IsInt]);


DeclareOperation("CandidatesLinesPointsNewH",[IsGeomLattice]);


DeclareGlobalFunction( "LDelH" );



# Declare display and print function for GeomLattice objects
DeclareOperation("ViewObject", [ IsGeomLattice ]);

DeclareOperation("PrintObject", [ IsGeomLattice ]);

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

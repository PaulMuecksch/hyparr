#
# HypArr: Functions to analyse further arrangement properties
#
#! @Chapter Further properties of arrangements, geometric lattices, and oriented matroids
#!
#! The following describes functions to analyse further
#! properties of arrangements such as <E>formality</E>, <E>supersolvability</E>, <E>simpliciality</E>,
#! <E>factoredness</E>, <E>inductive factoredness</E> ...
#!

#################################
##
#! @Section Supersolvable arrangements
##
#################################


#! @Arguments L, m1, m2
#! @Returns true or false
#! @Description
#!  Determines if <A>m1</A> and <A>m2</A> form a modular pair
#!  in L.
#! @BeginExampleSession
#! gap> A:=AGpql(2,2,3);
#! <HyperplaneArrangement: 6 hyperplanes in 3-space>
#! gap> L:=IntersectionLattice(A);
#! <Geometric lattice: 6 atoms, rank 3>
#! gap> LGroundSet(L);
#! [ [ [ 1 ], [ 2 ], [ 3 ], [ 4 ], [ 5 ], [ 6 ] ], 
#!  [ [ 1, 2 ], [ 1, 3, 6 ], [ 2, 3, 5 ], [ 1, 4, 5 ], 
#!    [ 2, 4, 6 ], [ 3, 4 ], [ 5, 6 ] ], 
#!   [ [ 1, 2, 3, 4, 5, 6 ] ] ]
#! gap> m1:=[1,2];; m2:= [5,6];; LIsModularPair(L,m1,m2);
#! false
#! gap> m1:=[1,2];; m2:= [2,4,6];; LIsModularPair(L,m1,m2);
#! true
#! @EndExampleSession
DeclareOperation( "LIsModularPair", [IsGeomLattice, IsList, IsList]);

#! @Arguments L, m
#! @Returns true or false
#! @Description
#!  Determines if <A>m</A> is a modular flat
#!  in L.
#! @BeginExampleSession
#! gap> A:=AGpql(2,2,3); L:=IntersectionLattice(A); LGroundSet(L);
#! <HyperplaneArrangement: 6 hyperplanes in 3-space>
#! <Geometric lattice: 6 atoms, rank 3>
#! [ [ [ 1 ], [ 2 ], [ 3 ], [ 4 ], [ 5 ], [ 6 ] ], 
#!  [ [ 1, 2 ], [ 1, 3, 6 ], [ 2, 3, 5 ], [ 1, 4, 5 ], 
#!    [ 2, 4, 6 ], [ 3, 4 ], [ 5, 6 ] ], 
#!   [ [ 1, 2, 3, 4, 5, 6 ] ] ]
#! gap> m1:=[1,2];; m2:= [2,4,6];; LIsModularFlat(L,m1); LIsModularFlat(L,m2);
#! false
#! true
#! @EndExampleSession
DeclareOperation( "LIsModularFlat", [IsGeomLattice, IsList]);


#! @Arguments L, k
#! @Returns list
#! @Description
#!  Determines the modular flats in <A>L</A> of rank <A>k</A>.
#! @BeginExampleSession
#! gap> L:=IntersectionLattice(AGpql(2,1,4));
#! <Geometric lattice: 16 atoms, rank 4>
#! gap> LModularFlatsRk(L,3);
#! [ [ 1, 2, 3, 5, 6, 7, 8, 11, 12 ], 
#!   [ 1, 2, 4, 5, 6, 9, 10, 13, 14 ], 
#!   [ 1, 3, 4, 7, 8, 9, 10, 15, 16 ], 
#!   [ 2, 3, 4, 11, 12, 13, 14, 15, 16 ] ]
#! @EndExampleSession
DeclareOperation( "LModularFlatsRk", [IsGeomLattice, IsInt]);

#! @Arguments L
#! @Returns true or false.
#! @Description
#! Determines whether the geometric lattice <A>L</A> is <E>supersolvable</E>.
#! @BeginExampleSession
#! gap> L:=IntersectionLattice(AGpql(2,1,4));
#! <Geometric lattice: 16 atoms, rank 4>
#! gap> LIsSupersolvable(L);
#! true
#! gap> L:=IntersectionLattice(AGpql(2,2,4));
#! <Geometric lattice: 12 atoms, rank 4>
#! gap> LIsSupersolvable(L);
#! false
#! @EndExampleSession
DeclareProperty("LIsSupersolvable", IsGeomLattice);

#! @Arguments A
#! @Returns true or false.
#! @Description
#! Determines whether the arrangement <A>A</A> is <E>supersolvable</E>.
#! @BeginExampleSession
#! gap> A:=AGpql(2,1,4);
#! <HyperplaneArrangement: 16 hyperplanes in 4-space>
#! gap> HArrIsSupersolvable(A);
#! true
#! gap> A:=AGpql(2,2,4); 
#! <HyperplaneArrangement: 12 hyperplanes in 4-space>
#! gap> HArrIsSupersolvable(A);
#! false
#! @EndExampleSession
DeclareProperty("HArrIsSupersolvable", IsHyperplaneArrangement);

#! @Arguments OM
#! @Returns true or false.
#! @Description
#! Determines whether the oriented matroid <A>OM</A> is <E>supersolvable</E>.
#! @BeginExampleSession
#! gap> O:=OrientedMatroid(3,4,[1,1,1,1]);
#! <OrientedMatroid: 4 elements, rank 3>
#! gap> OMIsSupersolvable(O);
#! false
#! gap> C:=List(Combinations(Roots(AGpql(2,2,3)),3),x->pos(Determinant(x)));
#! [ 1, 1, 1, 1, 0, -1, -1, -1, -1, 0, 1, 0, 1, -1, 0, 1, 1, 1, -1, -1 ]
#! gap> O:=OrientedMatroid(3,6,C);
#! <OrientedMatroid: 6 elements, rank 3>
#! gap> OMIsSupersolvable(O);
#! true
#! @EndExampleSession
DeclareProperty("OMIsSupersolvable", IsOrientedMatroid);

#################################
##
#! @Section Formal arrangements
##
#################################

#! @Arguments A
#! @Returns true or false.
#! @Description
#! Determines whether the arrangement is <E>formal</E>
#! in the sense of Falk-Randell <Cite Key="FalkRandell87_HomotopyArr"/>.
#! @BeginExampleSession
#! gap> A1 := Arr([
#! >     [1,0,0],
#! >     [0,1,0],
#! >     [0,0,1],
#! >     [1,1,1],
#! >     [2,1,1],
#! >     [2,3,1],
#! >     [2,3,4],
#! >     [3,0,5],
#! >     [3,4,5]
#! > ]);;
#! gap> 
#! gap> A2 := Arr([
#! >     [1,0,0],
#! >     [0,1,0],
#! >     [0,0,1],
#! >     [1,1,1],
#! >     [2,1,1],
#! >     [2,3,1],
#! >     [2,3,4],
#! >     [1,0,3],
#! >     [1,2,3]
#! > ]);;
#! gap> IsLEquiv(A1,A2);
#! true
#! gap> IsFormal(A1);
#! true
#! gap> IsFormal(A2);
#! false
#! @EndExampleSession
DeclareProperty("IsFormal", IsHyperplaneArrangement);

# some auxillary functions
DeclareGlobalFunction("HArr_FSpace");;
DeclareGlobalFunction("HArr_EMatS");;
DeclareGlobalFunction("HArr_SpaceSFx");;


#################################
##
#! @Section Simplicial arrangements
##
#################################


#! @Arguments A
#! @Returns true or false.
#! @Description
#! Determines whether the real arrangement <A>A</A> is <E>simplicial</E>,
#! i.e. if all chambers are simplicial.
#! @BeginExampleSession
#! gap> A:=HyperplaneArrangement([[1,0,0],[0,1,0],[0,0,1],[1,1,0],[0,1,1]]); HArrIsSimplicial(A);
#! <HyperplaneArrangement: 5 hyperplanes in 3-space>
#! false
#! gap> A:=HyperplaneArrangement([[1,0,0],[0,1,0],[0,0,1],[1,1,0],[0,1,1],[1,1,1]]); HArrIsSimplicial(A);
#! <HyperplaneArrangement: 6 hyperplanes in 3-space>
#! true
#! @EndExampleSession
DeclareProperty("HArrIsSimplicial", IsHyperplaneArrangement and IsReal);

# DeclareProperty("OMIsSimplicial", IsOrientedMatroid);


#################################
##
#! @Section Falk's weight test
##
#################################

#! The following still needs to be tested further...

#! @Arguments OM, g
#! @Returns list of list of sign vectors.
#! @Description
#!  Constructs the complex of bounded cells of the affine part 
#!  of the oriented matroid <A>OM</A> with respect to the element <A>g</A>.
#! @BeginExampleSession
#! 
#! @EndExampleSession
DeclareOperation("OMBoundedCpx", [IsOrientedMatroid, IsInt]);

#! @Arguments OM, g
#! @Returns list or fail
#! @Description
#!  Only for oriented matroids of rank 3.
#!  Determines, whether <A>OM</A> supports a system of weights as described
#!  by M. Falk in <Cite Key="Falk1995_Kpi1Arrs"/>.
#!  This implies, that the Salvetti complex (see <Ref Attr="SalvettiComplex" Label="for IsOrientedMatroid" Style="Text"/>)
#!  is apsherical.
#!  The functionality of the <B>cddinterface</B> package is used, 
#!  to determine solotions of a system of linear inequalities.
#!  
#!  If the algorithm determines a suitable weight system for <A>OM</A>,
#!  each list element consists of a weight, and a corner, i.e. a pair of
#!  a 2-cell and an adjacent vertex in the bounded complex, given as sign vectors.
#! @BeginExampleSession
#! gap> O:=OrientedMatroid(
#! >       [[1,1,0],[1,-1,0],[1,0,1],[1,0,-1],[0,1,1],[0,1,-1],[0,0,1]]
#! > );;
#! <OrientedMatroid: 7 elements, rank 3>
#! gap> OMIsSupersolvable(O);
#! false
#! gap> OMSupportsFalkWeights(O,3);
#! fail
#! gap> OMSupportsFalkWeights(O,1);
#! [ [ 1/2, [ [ 1, 1, 1, 1, 1, 1, 1 ], [ 1, 0, 1, 0, 1, 0, 1 ] ] ], 
#!   [ 0, [ [ 1, 1, 1, 1, 1, 1, 1 ], [ 1, 1, 1, 1, 0, 0, 0 ] ] ], 
#!   [ 1/2, [ [ 1, 1, 1, 1, 1, 1, 1 ], [ 1, 0, 1, 1, 1, 1, 0 ] ] ], 
#!   [ 0, [ [ 1, 1, 1, 1, 1, 1, -1 ], [ 1, 0, 0, 1, 0, 1, -1 ] ] ], 
#!   [ 1/2, [ [ 1, 1, 1, 1, 1, 1, -1 ], [ 1, 1, 1, 1, 0, 0, 0 ] ] ], 
#!   [ 1/2, [ [ 1, 1, 1, 1, 1, 1, -1 ], [ 1, 0, 1, 1, 1, 1, 0 ] ] ], 
#!   [ 0, [ [ 1, -1, 1, 1, 1, 1, 1 ], [ 1, 0, 1, 0, 1, 0, 1 ] ] ], 
#!   [ 1/2, [ [ 1, -1, 1, 1, 1, 1, 1 ], [ 1, -1, 0, 0, 1, 1, 0 ] ] ], 
#!   [ 1/2, [ [ 1, -1, 1, 1, 1, 1, 1 ], [ 1, 0, 1, 1, 1, 1, 0 ] ] ], 
#!   [ 1/2, [ [ 1, -1, 1, 1, 1, 1, -1 ], [ 1, 0, 0, 1, 0, 1, -1 ] ] ], 
#!   [ 0, [ [ 1, -1, 1, 1, 1, 1, -1 ], [ 1, -1, 0, 0, 1, 1, 0 ] ] ], 
#!   [ 1/2, [ [ 1, -1, 1, 1, 1, 1, -1 ], [ 1, 0, 1, 1, 1, 1, 0 ] ] ] ] 
#! @EndExampleSession
DeclareOperation("OMSupportsFalkWeights",[IsOrientedMatroid, IsInt]);;

#################################
##
#! @Section Factored arrangements
##
#################################


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

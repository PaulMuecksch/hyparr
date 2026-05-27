#
# HypArr: Complements
#
#! @Chapter Complements of complex arrangements
#!
#! For a hyperplane arrangement $\mathcal{A}$ in $\mathbb{C}^\ell$, the following provides functions to
#! compute complexes which have the homotopy type of the complement manifold $\mathbb{C}^\ell \setminus \bigcup_{H \in \mathcal{A}}H$.


# Declare the category
DeclareCategory("IsFacePoset", IsComponentObjectRep and IsAttributeStoringRep );

# Declare the representation
DeclareRepresentation(
    "IsFacePosetRep", 
    IsFacePoset,
    ["grGroundSet","orderfunction"]
);

# Declare display function for FacePoset objects
DeclareOperation("ViewObject", [IsFacePoset]);

#! @Section Complexes and face posets


#! @Arguments OM or A
#! @Returns A <C>FacePoset</C>
#! @Description
#! Constructs the Salvetti complex <Cite Key="Salvetti1987_SalCpx"/> associated with the oriented matroid OM
#! or the real hyperplane arrangement <A>A</A>.
#! @BeginExampleSession
#! gap> O := OrientedMatroid([[1,0],[0,1],[1,1]]);
#! <OrientedMatroid: 3 elements, rank 2>
#! gap> SalvettiComplex(O);
#! <FacePoset of dimension 2 with f-vector [ 6, 12, 6 ]>
#! gap> A:=HyperplaneArrangement([[1,0],[0,1],[1,1]]);
#! <HyperplaneArrangement: 3 hyperplanes in 2-space>
#! gap> SalvettiComplex(A);
#! <FacePoset of dimension 2 with f-vector [ 6, 12, 6 ]>
#! @EndExampleSession
DeclareAttribute("SalvettiComplex", IsOrientedMatroid);

#! @Arguments A
#! @Description 
#! See <Ref Attr="SalvettiComplex" Label="for IsOrientedMatroid" Style="Text"/>.
DeclareAttribute("SalvettiComplex", IsHyperplaneArrangement);

#! @Arguments FP
#! @Returns A list
#! @Description
#! Returns the ground set of the face poset FP.
#! @BeginExampleSession
#! gap> S := SalvettiComplex(O);
#! <FacePoset of dimension 2 with f-vector [ 6, 12, 6 ]>
#! gap> FPGroundSet(S);
#! [
#!   [ 
#!     [ [ -1, 1, -1 ], [ -1, 1, -1 ] ], 
#!     [ [ 1, -1, 1 ], [ 1, -1, 1 ] ], 
#!     [ [ -1, -1, -1 ], [ -1, -1, -1 ] ], 
#!     [ [ 1, 1, 1 ], [ 1, 1, 1 ] ], 
#!     [ [ -1, 1, 1 ], [ -1, 1, 1 ] ], 
#!     [ [ 1, -1, -1 ], [ 1, -1, -1 ] ]
#!   ],
#!   [
#!     [ [ -1, 0, -1 ], [ -1, 1, -1 ] ], 
#!     [ [ -1, 1, 0 ], [ -1, 1, -1 ] ], 
#!     [ [ 1, 0, 1 ], [ 1, -1, 1 ] ], 
#!     [ [ 1, -1, 0 ], [ 1, -1, 1 ] ], 
#!     [ [ 0, -1, -1 ], [ -1, -1, -1 ] ], 
#!     [ [ -1, 0, -1 ], [ -1, -1, -1 ] ], 
#!     [ [ 0, 1, 1 ], [ 1, 1, 1 ] ], 
#!     [ [ 1, 0, 1 ], [ 1, 1, 1 ] ], 
#!     [ [ 0, 1, 1 ], [ -1, 1, 1 ] ], 
#!     [ [ -1, 1, 0 ], [ -1, 1, 1 ] ], 
#!     [ [ 0, -1, -1 ], [ 1, -1, -1 ] ], 
#!     [ [ 1, -1, 0 ], [ 1, -1, -1 ] ]
#!   ],
#!   [
#!     [ [ 0, 0, 0 ], [ -1, 1, -1 ] ], 
#!     [ [ 0, 0, 0 ], [ 1, -1, 1 ] ], 
#!     [ [ 0, 0, 0 ], [ -1, -1, -1 ] ], 
#!     [ [ 0, 0, 0 ], [ 1, 1, 1 ] ], 
#!     [ [ 0, 0, 0 ], [ -1, 1, 1 ] ], 
#!     [ [ 0, 0, 0 ], [ 1, -1, -1 ] ]
#!   ]
#! ]
#! @EndExampleSession
DeclareAttribute("FPGroundSet", IsFacePoset);

#! @Arguments FP
#! @Returns A function
#! @Description
#! Returns the order function of the face poset FP.
DeclareAttribute("FPOrder", IsFacePoset);



DeclareOperation("CCToRR2Arr",[IsHyperplaneArrangement]);
DeclareOperation("CCLinToRRPair",[IsList]);

DeclareAttribute("s1Strat",IsHyperplaneArrangement);
DeclareAttribute("s2Strat",IsHyperplaneArrangement);
DeclareGlobalFunction("s2Tos1");

#! @Arguments A
#! @Returns A <C>FacePoset</C>
#! @Description
#! Constructs the complex described by Bjoener and Ziegler in <Cite Key="BjoeZie1992_CombStrat"/>
#! oibtained from the $s^{(1)}$-stratification
#! of a complex hyperplane arrangement <A>A</A> which has the homotopy type of the complement. 
#! @BeginExampleSession
#! gap> A:=AGpql(3,3,3);
#! <HyperplaneArrangement: 9 hyperplanes in 3-space>
#! gap> Cs1:=BZs1Complex(A);
#! <FacePoset of dimension 4 with f-vector [ 194, 1004, 1560, 812, 62 ]>
#! gap> Cs1CW := FPtoCWCpx(Cs1);
#! Regular CW-complex of dimension 4
#! gap> List([0..4],x->Length(Homology(Cs1CW,x)));
#! [ 1, 9, 24, 16, 0 ]
#! gap> CharPoly(A);
#! t^3-9*t^2+24*t-16
#! @EndExampleSession
DeclareAttribute("BZs1Complex", IsHyperplaneArrangement);


#! @Arguments A
#! @Returns A <C>FacePoset</C>
#! @Description
#! Constructs the complex described by Bjoener and Ziegler in <Cite Key="BjoeZie1992_CombStrat"/>
#! oibtained from the $s^{(2)}$-stratification
#! of a complex hyperplane arrangement <A>A</A> which has the homotopy type of the complement. 
#! @BeginExampleSession
#! gap> A:=AGpql(3,3,2);
#! <HyperplaneArrangement: 3 hyperplanes in 2-space>
#! gap> Cs2:=BZs2Complex(A);
#! <FacePoset of dimension 4 with f-vector [ 52, 132, 96, 16, 0 ]>
#! @EndExampleSession
DeclareAttribute("BZs2Complex", IsHyperplaneArrangement);

#! Be aware that
#! both functions <C>BZs1Complex</C> and <C>BZs2Complex</C> may take a considerable amount of time
#! computing the complex for non-real arrangements since oriented matroid complexes in double dimension 
#! and double number of hyperplanes need to be computed. 
#! For a real arrangement, the $s^{(1)}$-complex is isomorphic to the Salvetti complex.

#! @Section Non-$K(\pi,1)$ arrangements

#! @Arguments A
#! @Returns true or false
#! @Description
#! Tests if there is a convex open subset of the ambient space, such that 
#! the arrangement restricted to this convex open subset is a "simple triangle",
#! see also <Ref Attr="HasSimpleTriangle" Label="for IsOrientedMatroid" Style="Text"/>.
#! This implies that the arrangement is not $K(\pi,1)$.
#! @BeginExampleSession
#! gap> A:=Arr([ [ E(4), E(4), E(4) ], [ 0, E(4), 1 ], [ 1, 0, 1 ], [ 1, 0, 0 ] ]);
#! <HyperplaneArrangement: 4 hyperplanes in 3-space>
#! gap> CCSimpleTriangle(A);
#! [ 1, 2, 3 ]
#! true
#! @EndExampleSession
DeclareOperation("CCSimpleTriangle",[IsHyperplaneArrangement]);



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

#
# HypArr: Computations with oriented matroids
#
#! @Chapter Oriented Matroids
#!
#! Oriented matroids are a abstraction of real hyperplane arrangements.
#! The following describes functions to handle oriented matroids and compute associated cell complexes
#! and invariants. See <Cite Key="BLSWZ1999_OrientedMatroids"/>


# Declare the category
DeclareCategory("IsOrientedMatroid", IsComponentObjectRep and IsAttributeStoringRep );

# Declare the representation
DeclareRepresentation(
    "IsOrientedMatroidRep", 
    IsOrientedMatroid,
    ["rank","GroundSet","lforms","chirotype",
    "chirocore","cocircuits","covectors","rkfct",
    "lattice","topegraph","salcpx"]
);

# Declare the category
DeclareCategory("IsFacePoset", IsComponentObjectRep and IsAttributeStoringRep );

# Declare the representation
DeclareRepresentation(
    "IsFacePosetRep", 
    IsFacePoset,
    ["grGroundSet","orderfunction"]
);

#################################
##
#! @Section Attributes
##
#################################

#! @Arguments OM
#! @Arguments OM
#! @Returns An integer
#! @Description
#! Returns the rank of the oriented matroid <A>OM</A>.
#! @BeginExampleSession
#! gap> A := AGpql(2,2,3); OM := OrientedMatroid(A);
#! <OrientedMatroid: 6 elements, rank 3>
#! gap> OMRank(OM);
#! 3
#! @EndExampleSession
DeclareAttribute("OMRank", IsOrientedMatroid);

#! @Arguments OM
#! @Returns A list
#! @Description
#! Returns the ground set of the oriented matroid OM.
#! @BeginExampleSession
#! gap> A := AGpql(2,2,3); OM := OrientedMatroid(A);
#! <OrientedMatroid: 6 elements, rank 3>
#! gap> OMGroundSet(OM);
#! [ 1, 2, 3, 4, 5, 6 ]
#! @EndExampleSession
DeclareAttribute("OMGroundSet", IsOrientedMatroid);

#! @Arguments OM
#! @Returns A list of linear forms or <C>fail</C>
#! @Description
#! Returns the list of linear forms associated with the oriented matroid OM.
#! If the internal component <C>OM!.lforms</C> is not bound, <C>fail</C> is returned.
#! @BeginExampleSession
#! gap> A := AGpql(2,2,3); OM := OrientedMatroid(A);
#! <OrientedMatroid: 6 elements, rank 3>
#! gap> OMLForms(O);
#! [ [ 1, 1, 0 ], [ 1, -1, 0 ], [ 1, 0, 1 ], 
#!   [ 1, 0, -1 ], [ 0, 1, 1 ], [ 0, 1, -1 ] ]
#! @EndExampleSession
DeclareAttribute("OMLForms", IsOrientedMatroid);

#! @Arguments OM
#! @Returns An object of type <C>IsGeomLattice</C> or <C>fail</C> 
#! @Description
#! Computes the geometric lattice associated with the oriented matroid OM.
#! If OM is linear (as determined by <C>OMIsLinear(OM)</C>), the lattice is
#! computed as the intersection lattice of the hyperplane arrangement given by <C>OMLForms(OM)</C>,
#! stored in the internal component <C>OM!.lattice</C>, and returned.
#! If OM is not linear, <C>fail</C> is returned.
#! @BeginExampleSession
#! gap> A := AGpql(2,2,3); OM := OrientedMatroid(A);
#! <OrientedMatroid: 6 elements, rank 3>
#! gap> OMGeomLattice(OM);
#! [ [ [ 1 ], [ 2 ], [ 3 ], [ 4 ], [ 5 ], [ 6 ] ], 
#! [ [ 1, 2 ], [ 1, 3, 6 ], [ 2, 3, 5 ], [ 1, 4, 5 ], 
#!   [ 2, 4, 6 ], [ 3, 4 ], [ 5, 6 ] ], 
#!   [ [ 1, 2, 3, 4, 5, 6 ] ] ]
#! @EndExampleSession
DeclareAttribute("OMGeomLattice", IsOrientedMatroid);

#! @Arguments OM
#! @Returns A list
#! @Description
#! Computes the (signed) cocircuits of the oriented matroid OM.
#! The cocircuits are derived from the geometric lattice of OM (via <C>OMGeomLattice(OM)</C>)
#! and the linear forms (from <C>OMLForms(OM)</C>).
#! The result is a list of signed vectors representing all cocircuits of OM.
#!
#! @BeginExampleSession
#! gap> O:=OrientedMatroid([[1,0],[0,1],[1,1]]); OMCocircuits(O);
#! <OrientedMatroid: 3 elements, rank 2>
#! [ [ 0, 1, 1 ], [ 0, -1, -1 ], [ 1, 0, 1 ], 
#!   [ -1, 0, -1 ], [ -1, 1, 0 ], [ 1, -1, 0 ] ]
#! @EndExampleSession
DeclareAttribute("OMCocircuits", IsOrientedMatroid);

#! @Arguments OM
#! @Returns A graph
#! @Description
#! Computes the tope graph of the oriented matroid OM.
#! The topes are obtained as the first set of covectors from <C>OMCovectors(OM)</C>.
#! Two topes are connected by an edge if their separating set has at most one element.
#! @BeginExampleSession
#! gap> O := OrientedMatroid([[1,0],[0,1],[1,1]]);
#! <OrientedMatroid: 3 elements, rank 2>
#! gap> G := ShallowCopy(TopeGraph(O));;
#! gap> Vertices(G);
#! [ 1 .. 6 ]
#! gap> IsSimpleGraph(G);
#! true
#! gap> UndirectedEdges(G);
#! [ [ 1, 3 ], [ 1, 5 ], [ 2, 4 ], [ 2, 6 ], [ 3, 6 ], [ 4, 5 ] ]
#! @EndExampleSession
DeclareAttribute("TopeGraph", IsOrientedMatroid);

#! @Arguments OM
#! @Returns A list of lists
#! @Description
#! Computes all covectors of the oriented matroid OM.
#! The result is returned as a reversed list of lists, where each inner list is a covector represented as a signed vector.
#! @BeginExampleSession
#! gap> O := OrientedMatroid([[1,0],[0,1],[1,1]]);
#! <OrientedMatroid: 3 elements, rank 2>
#! gap> OMCovectors(O);
#! [ [ [ -1, 1, -1 ], [ 1, -1, 1 ], [ -1, -1, -1 ], 
#!     [ 1, 1, 1 ], [ -1, 1, 1 ], [ 1, -1, -1 ] ],
#!   [ [ 0, 1, 1 ], [ 0, -1, -1 ], [ 1, 0, 1 ], 
#!     [ -1, 0, -1 ], [ -1, 1, 0 ], [ 1, -1, 0 ] ],
#!   [ [ 0, 0, 0 ] ] ]
#! @EndExampleSession
DeclareAttribute("OMCovectors", IsOrientedMatroid);

#! @Arguments OM
#! @Returns A <C>FacePoset</C>
#! @Description
#! Constructs the Salvetti complex <Cite Key="Salvetti1987_SalCpx"/> associated with the oriented matroid OM.
#!
#! The construction proceeds as follows:
#!
#! 1. Computes the covectors of OM via <C>OMCovectors(OM)</C>.
#!
#! 2. Uses the topes and the lower order ideals of the covector poset to form the cells of the complex.
#!
#! 3. Defines an order function on the cells to capture the face poset structure, using <C>OMOperation</C> and <C>OrderCovec</C>.
#!
#! 4. Returns an object of type <C>FacePosetFamily</C> representing the Salvetti complex, with its ground set stored in 
#!   <C>grGroundSet</C> and the order function in <C>orderfunction</C>.
#!
#! @BeginExampleSession
#! gap> O := OrientedMatroid([[1,0],[0,1],[1,1]]);
#! <OrientedMatroid: 3 elements, rank 2>
#! gap> SalvettiComplex(O);
#! <FacePoset of dimension 2 with f-vector [ 6, 12, 6 ]>
#! @EndExampleSession
DeclareAttribute("SalvettiComplex", IsOrientedMatroid);


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


#! @Arguments OM
#! @Returns A function
#! @Description
#! Returns the chirotype giving as a function from $\binomial{E}{r} \to \{0,\pm 1\}$,
#! where $E$ is the groundset of $OM$ and $r$ is the rank of <A>OM</A>.
DeclareAttribute("OMChirotype", IsOrientedMatroid);


#! @Arguments OM
#! @Returns A function
#! @Description
#! Returns the rank function of the oriented matroid <A>OM</A>
DeclareAttribute("OMRankFunction", IsOrientedMatroid);

#################################
##
#! @Section Properties
##
#################################

#! @Arguments OM
#! @Returns true or false
#! @Description
#! Returns whether the oriented matroid OM is linear.
#! This is the case if the internal component <C>OM!.lforms</C> is bound.
#! @BeginExampleSession
#! gap> A := AGpql(2,2,3); OM := OrientedMatroid(A);
#! <OrientedMatroid: 6 elements, rank 3>
#! gap> OMIsLinear(OM);
#! true
#! @EndExampleSession
DeclareProperty("OMIsLinear", IsOrientedMatroid);

#################################
##
#! @Section Global methods
##
#################################

# @Arguments n, k
# @Returns A floating-point number
# @Description
# Computes the cosine of the angle <C>2*Pi*k/n</C>.
# Returns <C>Cos(2*Pi*k/n)</C> as a floating-point value.
DeclareGlobalFunction("cosn");

# @Arguments z
# @Returns a float 
# @Description
# Compute the float representation of the real part of a cyclotomic (complex) number 
DeclareGlobalFunction("CCToFloat");

# @Arguments 
# @Returns 
# @Description
# Computes 
DeclareGlobalFunction("pos");

#! @Arguments sv1, sv2
#! @Returns A list
#! @Description
#! Performs the oriented matroid operation 
#! on two signed vectors <C>sv1</C> and <C>sv2</C>.
#! For each position <C>i</C>, 
#! if <C>sv1[i]</C> is nonzero, it is used; 
#! otherwise <C>sv2[i]</C> is used.
#! Returns a new signed vector 
#! representing the result of the operation.
#! @BeginExampleSession
#! gap> CVs:=OMCovectors(O)[2];
#! [ [ 0, 1, 1 ], [ 0, -1, -1 ], [ 1, 0, 1 ], 
#!   [ -1, 0, -1 ], [ -1, 1, 0 ], [ 1, -1, 0 ] ]
#! gap> sv1 := CVs[3]; sv2 := CVs[5];
#! [ 1, 0, 1 ]
#! [ -1, 1, 0 ]
#! gap> OMOperation(sv1, sv2);
#! [ 1, 1, 1 ]
#! gap> OMOperation(sv2, sv1);
#! [ -1, 1, 1 ]
#! @EndExampleSession
DeclareGlobalFunction("OMOperation");

# @Arguments 
# @Returns 
#! @Description
#! Order function for sign vectors. 
DeclareGlobalFunction("OrderCovec");

# @Arguments 
# @Returns 
# @Description
# Computes 
DeclareGlobalFunction("LowerOrderIdeal");

#! @Arguments OM1, OM2
#! @Returns true or false
#! @Description
#! Determines, if the oriented matroids <A>OM1</A> and <A>OM2</A> are isomorphic.
DeclareGlobalFunction("IsOMEquiv");

# @Arguments 
# @Returns 
#! @Description
#! The separating set of two sign vectors. 
DeclareGlobalFunction("SeparatingSet");

DeclareGlobalFunction("ChirotypeFromChiroCore");

#################################
##
#! @Section Constructors
##
#################################

#! @Arguments r or A or [n,r,ChiroCoreList]
#! @Returns An oriented matroid OM.
#! @Description
#!  Constructs am oriented matroid from a list <A>r</A> of vectors
#!  representing defining linear forms of real hyperplanes
#!  or a real hyperplane arrangement <A>A</A>
#!  or a intergers <A>n,r</A> giving the size of the groundset and the rank and
#!  a list <A>ChiroCoreList</A> $\subseteq \{0,1,-1\}^m (m = \binom{n}{r})$ presenting the chirotype
#!  of the oriented matroid.
#! @BeginExampleSession
#! gap> A:=AGpql(2,2,3); OM:=OrientedMatroid(Roots(A));
#! <OrientedMatroid: 6 elements, rank 3>
#! gap> A:=AGpql(2,2,3); OM:=OrientedMatroid(A);
#! <OrientedMatroid: 6 elements, rank 3>
#! @EndExampleSession
DeclareOperation("OrientedMatroid", [IsList]);
DeclareOperation("OrientedMatroid", [IsHyperplaneArrangement]);

DeclareOperation("OrientedMatroid", [IsInt, IsInt, IsList]);



BindGlobal("OM",OrientedMatroid);


# Declare display function for OrientedMatroid objects
DeclareOperation("ViewObject", [IsOrientedMatroid]);

# Declare display function for FacePoset objects
DeclareOperation("ViewObject", [IsFacePoset]);

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

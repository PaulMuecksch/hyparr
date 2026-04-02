#
# HypArr: Computations with oriented matroids
#
#! @Chapter Oriented Matroids
#!
#! Oriented matroids are abstractions of real hyperplane arrangements.
#! The following describes functions to handle oriented matroids and compute associated cell complexes
#! and invariants. See <Cite Key="BLSWZ1999_OrientedMatroids"/>.


# Declare the category
DeclareCategory("IsOrientedMatroid", IsComponentObjectRep and IsAttributeStoringRep );

# Declare the representation
DeclareRepresentation(
    "IsOrientedMatroidRep", 
    IsOrientedMatroid,
    ["rank","GroundSet","lforms","chirotope",
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
#! @Section Construction of oriented matroids
##
#################################

#! @Arguments R or A or [CCs,c] or [n,r,ChiroCoreList]
#! @Returns An oriented matroid OM.
#! @Description
#!  Constructs am oriented matroid from 
#!  * a list <A>R</A> of vectors
#!      representing defining linear forms of real hyperplanes,
#!  * a real hyperplane arrangement <A>A</A>,
#  * a list <A>CCs</A> of signed cocircuits and a string <C>c="cc"</C>,
#!  * a list of lists <A>CVs</A> of signed covectors and a string <C>c="cv"</C>,
#!  * intergers <A>n,r</A> giving the size of the groundset and the rank and
#!      a list <A>ChiroCoreList</A> $\subseteq \{0,1,-1\}^m (m = \binom{n}{r})$ 
#!      presenting the chirotope
#! 
#!  of the oriented matroid.
#! @BeginExampleSession
#! gap> A:=AGpql(2,2,3); OM:=OrientedMatroid(Roots(A));
#! <OrientedMatroid: 6 elements, rank 3>
#! gap> A:=AGpql(2,2,3); OM:=OrientedMatroid(A);
#! <OrientedMatroid: 6 elements, rank 3>
#! gap> OrientedMatroid([[[1,1],[-1,1],[1,-1],[-1,-1]],[[0,1],[0,-1],[1,0],[-1,0]],[[0,0]]],"cv");
#! <OrientedMatroid: 2 elements, rank 2>
#! gap> OrientedMatroid(2,3,[1,1,1]);
#! <OrientedMatroid: 3 elements, rank 2>
#! @EndExampleSession
DeclareOperation("OrientedMatroid", [IsList]);

DeclareOperation("OrientedMatroid", [IsHyperplaneArrangement]);
DeclareOperation("OrientedMatroid", [IsList, IsString]);
DeclareOperation("OrientedMatroid", [IsInt, IsInt, IsList]);

DeclareSynonym("OM",OrientedMatroid);

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
#! Constructs the geometric lattice associated with the oriented matroid OM.
#! If OM is linear (as determined by <C>OMIsLinear(OM)</C>), the lattice is
#! computed as the intersection lattice of the hyperplane arrangement given by <C>OMLForms(OM)</C>,
#! stored in the internal component <C>OM!.lattice</C>, and returned.
#! @BeginExampleSession
#! gap> O := OrientedMatroid([[1,0,0],[0,1,0],[0,0,1],[1,1,1]]);
#! <OrientedMatroid: 4 elements, rank 3>
#! gap> L:=OMGeomLattice(O); LGroundSet(L);
#! <Geometric lattice: 4 atoms, rank 3>
#! [ [ [ 1 ], [ 2 ], [ 3 ], [ 4 ] ], 
#!   [ [ 1, 2 ], [ 1, 3 ], [ 2, 3 ], 
#!       [ 1, 4 ], [ 2, 4 ], [ 3, 4 ] ], 
#!   [ [ 1, 2, 3, 4 ] ] ]
#! gap> O := OrientedMatroid(3,4,[1,1,1,1]);
#! <OrientedMatroid: 4 elements, rank 3>
#! gap> L:=OMGeomLattice(O); LGroundSet(L);
#! <Geometric lattice: 4 atoms, rank 3>
#! [ [ [ 1 ], [ 2 ], [ 3 ], [ 4 ] ], 
#!   [ [ 1, 2 ], [ 1, 3 ], [ 2, 3 ], 
#!       [ 1, 4 ], [ 2, 4 ], [ 3, 4 ] ], 
#!   [ [ 1, 2, 3, 4 ] ] ]
#! @EndExampleSession
DeclareAttribute("OMGeomLattice", IsOrientedMatroid);

#! @Arguments OM
#! @Returns A list
#! @Description
#! Computes the (signed) cocircuits of the oriented matroid OM.
#! 
#! The result is a list of sign vectors.
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
#! Constructs the tope graph of the oriented matroid <A>OM</A>.
#! The topes are obtained as the maximal covectors from <C>OMCovectors(OM)</C>.
#! Two topes are connected by an edge if their separating set consists of one element.
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
#! The result is returned as a list of lists, 
#! where the $k$-th inner list is a list of covectors corresponding to faces of dimension $k-1$.
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


#! @Arguments OM
#! @Returns A function
#! @Description
#! Returns the chirotope given as a function from $\binom{E}{r} \to \{0,\pm 1\}$,
#! where $E$ is the groundset of $OM$ and $r$ is the rank of <A>OM</A>.
#! @BeginExampleSession
#! gap> O:=OrientedMatroid(2,3,[1,1,1]); c:=OMChirotope(O);
#! <OrientedMatroid: 3 elements, rank 2>
#! function( S ) ... end
#! gap> List(Combinations([1..3],2),x->c(x));
#! [ 1, 1, 1 ]
#! @EndExampleSession
DeclareAttribute("OMChirotope", IsOrientedMatroid);


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
#! Determines whether the oriented matroid <A>OM</A> is linear.
#! This is the case if the internal component <C>OM!.lforms</C> is bound.
#! @BeginExampleSession
#! gap> A := AGpql(2,2,3); OM := OrientedMatroid(A);
#! <OrientedMatroid: 6 elements, rank 3>
#! gap> OMIsLinear(OM);
#! true
#! gap> O := OrientedMatroid(3,4,[1,1,1,1]);
#!<OrientedMatroid: 4 elements, rank 3>
#! gap> OMIsLinear(O);
#! false
#! @EndExampleSession
DeclareProperty("OMIsLinear", IsOrientedMatroid);

#! @Arguments OM
#! @Returns true or false
#! @Description
#! Returns whether the oriented matroid <A>OM</A>
#! has a simple simplex, i.e. a simplicial Tope $T$
#! such that the localizations at its vertices are boolean
#! and there is another rank 1 covector not adjacent to $T$.
#! If <C>Rank(OM)</C> $\geq 3$ and this is true 
#! then its Salvetti complex can not be $K(\pi,1)$.
#! @BeginExampleSession
#! gap> O:=OrientedMatroid([[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1],[1,1,1,1]]);
#! <OrientedMatroid: 5 elements, rank 4>
#! gap> HasSimpleSimplex(O);
#!   - tope: [ -1, -1, -1, -1, -1 ]
#!   - vertices: [ [ 0, 0, 0, -1, -1 ], [ 0, 0, -1, 0, -1 ], 
#!   [ 0, -1, 0, 0, -1 ], [ -1, 0, 0, 0, -1 ] ]
#! true
#! 
#! @EndExampleSession
DeclareProperty("HasSimpleSimplex", IsOrientedMatroid);


#! @Arguments OM
#! @Returns true or false.
#! @Description
#!  Checks all rank $3$ localizations for a simple simplex, i.e.
#!  a simple triangle.
#! @BeginExampleSession
#!
#! @EndExampleSession
DeclareProperty("HasSimpleTriangle", IsOrientedMatroid);


#################################
##
#! @Section Operations
##
#################################


#! @Arguments OM1, OM2
#! @Returns true or false
#! @Description
#! Determines if the oriented matroids <A>OM1</A> and <A>OM2</A> 
#! have isomorphic geometric lattices.
#! @BeginExampleSession
#! gap> O1:=OrientedMatroid(3,4,[1,1,1,1]);
#! <OrientedMatroid: 4 elements, rank 3>
#! gap> O2:=OrientedMatroid([[1,0,0],[0,1,0],[0,0,1],[1,1,1]]);
#! <OrientedMatroid: 4 elements, rank 3>
#! gap> IsLEquiv(O1,O2);
#! true
#! gap> O2:=OrientedMatroid([[1,0,0],[0,1,0],[0,0,1],[1,1,0]]);
#! <OrientedMatroid: 4 elements, rank 3>
#! gap> IsLEquiv(O1,O2);
#! false
#! @EndExampleSession
DeclareOperation("IsLEquiv", [IsOrientedMatroid,IsOrientedMatroid]);



#! @Arguments OM, k
#! @Returns true or false
#! @Description
#! Returns whether the oriented matroid <A>OM</A>
#! has a localiazion of rank <A>k</A> with a simple Simplex.
#! If this is true for $k \geq 3$ then its Salvetti complex can not be $K(\pi,1)$.
#!
#! @BeginExampleSession
#! gap> O:=OrientedMatroid([[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1],[1,1,1,0]]);
#! <OrientedMatroid: 5 elements, rank 4>
#! gap> HasSimpleSimplex(O);
#! false
#! gap> HasSimpleSimplexRk(O,3);
#! true
#! @EndExampleSession
DeclareOperation("HasSimpleSimplexRk", [IsOrientedMatroid, IsInt]);

#! @Arguments OM, F, k
#! @Returns An oriented matroid
#! @Description
#! Returns the rank <A>k</A> localization of <A>OM</A> at
#! the flat <A>F</A>.
#!
#! @BeginExampleSession
#! gap> O:=OrientedMatroid([[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1],[1,1,1,0]]);
#! <OrientedMatroid: 5 elements, rank 4>
#! gap> L:=OMGeomLattice(O);
#! <Geometric lattice: 5 atoms, rank 4>
#! gap> LkFlats(L)(3);
#! [ [ 1, 2, 3, 5 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 4 ], [ 1, 4, 5 ], [ 2, 4, 5 ], [ 3, 4, 5 ] ]
#! gap> OMLocalizationRk(O,[1,2,3,5],3);
#! <OrientedMatroid: 4 elements, rank 3>
#! 
#! @EndExampleSession
DeclareOperation("OMLocalizationRk", [IsOrientedMatroid, IsList, IsInt]);





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

# @Arguments 
# @Returns 
# @Description
# Computes
DeclareGlobalFunction("SVZeroSet");

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

DeclareGlobalFunction("ChirotopeFromChiroCore");



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

#
# HypArr: Complements
#
#! @Chapter Complements of complex arrangements
#!
#! For a hyperplane arrangements $\mathcal{A}$ in $\mathbb{C}^\ell$, the following provides functions to
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
#! 
#! @EndExampleSession
DeclareAttribute("BZs1Complex", IsHyperplaneArrangement);


#! @Arguments A
#! @Returns A <C>FacePoset</C>
#! @Description
#! Constructs the complex described by Bjoener and Ziegler in <Cite Key="BjoeZie1992_CombStrat"/>
#! oibtained from the $s^{(2)}$-stratification
#! of a complex hyperplane arrangement <A>A</A> which has the homotopy type of the complement. 
#! @BeginExampleSession
#! 
#! @EndExampleSession
DeclareAttribute("BZs2Complex", IsHyperplaneArrangement);
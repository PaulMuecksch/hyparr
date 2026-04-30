#
# HypArr: Greedy search for special arrangements
#
#! @Chapter Greedy search for arrangements

#! This is an implementation of a basic greedy algorithm to construct arrangements
#! satisfying a certain property, based on <Cite Key="Cuntz2022_Greedy"/>.
#! A variant was used in <Cite Key="MMR2024_CombFormality"/> to
#! construct an arrangement which is $4$-formal with a restriction which is not $3$-formal.

# Declare the category
DeclareCategory("IsHArrGreedySearch", IsComponentObjectRep and IsAttributeStoringRep );
DeclareCategory("IsHArrGreedySearchPair", IsComponentObjectRep and IsAttributeStoringRep );

# Declare the representation
DeclareRepresentation(
    "IsHArrGreedySearchRep", 
    IsHArrGreedySearch,
    ["gf","dim","nhs","targetfct","maxiter","runsearch"]
);

# Declare the representation
DeclareRepresentation(
    "IsHArrGreedySearchPairRep", 
    IsHArrGreedySearchPair,
    ["gf","dim","nhs","targetfct_same","targetfct_diff","maxiter","runsearch"]
);

# Declare display function for HArrGreedySearch objects
DeclareOperation("ViewObject", [IsHArrGreedySearch]);
DeclareOperation("ViewObject", [IsHArrGreedySearchPair]);



#################################################
##
#! @Section Constructions
##
#################################################

DeclareOperation("RandomArrOverGF",[IsInt,IsInt,IsField]);
DeclareOperation("CandidatesLinesPointsNewH",[IsGeomLattice]);
DeclareOperation("RandomNewHThroughPoints",[IsHyperplaneArrangement]);
DeclareOperation("RandomNewHThroughIntersections",[IsHyperplaneArrangement]);
DeclareOperation("RandomNewH",[IsHyperplaneArrangement]);
DeclareOperation("ExchangeRandomH",[IsHyperplaneArrangement]);
DeclareOperation("ExchangeRandomH2",[IsHyperplaneArrangement]);

#! @Arguments NumberOfHs, dim, GField, PropTargetFct, MaxNoIterations
#! @Returns A hyperplane arrangement
#! @Description
#!  Constructs a greedy search for arrangements over <A>GField</A> with <A>NumberOfHs</A>
#!  hyperplanes in dimension <A>dim</A>.
#!  * <A>PropTargetFct</A> should be a function taking a hyperplane arragement as argument,
#!      returning a non-negative real number, which the search tries to minimize,
#!      and such that value=0 means the arrangement satisfies the desired property.
#!  * <A>MaxNoIterations</A> is the maximal number of steps to be carried out in the search 
#!      (one step = exchanging a hyperplane).
#! @BeginExampleSession
#! gap> HArrGreedySearch(13,3,GF(17),ChiSplits,400);
#! GreedySearch over GF(17) for arrangements:
#!  - of rank 3
#!  - with 13 hyperplanes.
#! @EndExampleSession
DeclareOperation("HArrGreedySearch",[IsInt,IsInt,IsField,IsFunction,IsInt]);

DeclareOperation("HArrGreedySearchPair",[IsInt,IsInt,IsField,IsFunction,IsFunction,IsInt]);

DeclareOperation("RandArrOverGF",[IsInt,IsInt,IsField]);

#! @Arguments A
#! @Description
#!  A target/score function for splitting of the characteristic polynomial of <A>A</A> over $\mathbb{Z}$.
DeclareGlobalFunction("ChiSplits");


#################################
##
#! @Section Attributes
##
#################################

#! @Arguments GS
#! @Returns a function
#! @Description
#!  The function to run the search which will return an arrangement or <C>fail</C>.
#! @BeginExampleSession
#! gap> GS:=HArrGreedySearch(13,3,GF(17),ChiSplits,400);
#! GreedySearch over GF(17) for arrangements:
#!  - of rank 3
#!  - with 13 hyperplanes.
#! gap> A:=GreedySearchRun(GSChiSplits_13_3)();
#! 227 Iterations - <HyperplaneArrangement: 13 hyperplanes in 3-space>
#! gap> ExpArr(A);
#! [ 1, 6, 6 ]
#! gap> HArrIsSupersolvable(A);
#! true
#! gap> A:=GreedySearchRun(GSChiSplits_13_3)();
#! 358 Iterations - <HyperplaneArrangement: 13 hyperplanes in 3-space>
#! gap> ExpArr(A);
#! [ 1, 6, 6 ]
#! gap> HArrIsSupersolvable(A);
#! false
#! gap> HArrIsFree(A);
#! true
#! @EndExampleSession
DeclareAttribute("GreedySearchRun",IsHArrGreedySearch);

#! @Arguments GS
#! @Returns a field
#! @Description
#!  The Galois field over which to search for arrangements.
#! @BeginExampleSession
#! @EndExampleSession
DeclareAttribute("GreedySearchGF",IsHArrGreedySearch);

#! @Arguments GS
#! @Returns 
#! @Description
#!  
#! @BeginExampleSession
#! @EndExampleSession
DeclareAttribute("GreedySearchDimension",IsHArrGreedySearch);

#! @Arguments GS
#! @Returns 
#! @Description
#!  
#! @BeginExampleSession
#! @EndExampleSession
DeclareAttribute("GreedySearchNOfHs",IsHArrGreedySearch);

#! @Arguments GS
#! @Returns 
#! @Description
#!  
#! @BeginExampleSession
#! @EndExampleSession
DeclareAttribute("GreedySearchTargetFct",IsHArrGreedySearch);

#! @Arguments GS
#! @Returns 
#! @Description
#!  
#! @BeginExampleSession
#! @EndExampleSession
DeclareAttribute("GreedySearchMaxIterations",IsHArrGreedySearch);

DeclareAttribute("GreedySearchGF",IsHArrGreedySearchPair);
DeclareAttribute("GreedySearchDimension",IsHArrGreedySearchPair);
DeclareAttribute("GreedySearchNOfHs",IsHArrGreedySearchPair);
DeclareAttribute("GreedySearchTargetFctSame",IsHArrGreedySearchPair);
DeclareAttribute("GreedySearchTargetFctDiff",IsHArrGreedySearchPair);
DeclareAttribute("GreedySearchMaxIterations",IsHArrGreedySearchPair);
DeclareAttribute("GreedySearchRun",IsHArrGreedySearchPair);


# # Declare the category
# DeclareCategory("IsHArrPropTargetFct", IsComponentObjectRep and IsAttributeStoringRep );

# # Declare the representation
# DeclareRepresentation(
#     "IsHArrPropTargetFctRep", 
#     IsHArrPropTargetFct,
#     ["prop","fct"]
# );

# # Declare display function for HArrPropTargetFct objects
# DeclareOperation("ViewObject", [IsHArrPropTargetFct]);


##############



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
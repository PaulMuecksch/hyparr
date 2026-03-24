#
# HypArr: Functions to analyse freeness properties
#
#! @Chapter Free arrangements
#!
#! The following describes functions to analyse freeness
#! properties of arrangements such as  <E>inductive freeness</E> due to
#! H. Terao <Cite Key="Terao1980_FreeI"/> and  <E>divisionell freeness</E> due to T. Abe <Cite Key="Abe16_DivFree"/>.
#!

#################################
##
#! @Section Freeness properties
##
#################################


#! @Arguments A
#! @Returns true or false.
#! @Description
#! Determines whether the arrangement <A>A</A> is <E>inductively free</E>.
#! @BeginExampleSession
#! gap> A:=HyperplaneArrangement([[1,0,0],[0,1,0],[0,0,1],[1,1,0],[1,1,1]]);
#! <HyperplaneArrangement: 5 hyperplanes in 3-space>
#! gap> IsInductivelyFree(A);
#! true
#! @EndExampleSession
DeclareProperty("IsInductivelyFree", IsHyperplaneArrangement);

BindGlobal("IsIF",IsInductivelyFree);;

#! @Arguments A
#! @Returns true or false.
#! @Description
#! Determines whether the arrangement <A>A</A> is <E>divisionally free</E>.
#! @BeginExampleSession
#! gap> A:=HyperplaneArrangement([[1,0,0],[0,1,0],[0,0,1],[1,1,0],[1,1,1]]);
#! <HyperplaneArrangement: 5 hyperplanes in 3-space>
#! gap> IsDivisionallyFree(A);
#! true
#! gap> A:=AGpql(3,3,3);
#! <HyperplaneArrangement: 9 hyperplanes in 3-space>
#! gap> IsDivisionallyFree(A);
#! false
#! @EndExampleSession
DeclareProperty("IsDivisionallyFree", IsHyperplaneArrangement);

BindGlobal("IsDF",IsDivisionallyFree);;



#################################
# some auxillary functions
#################################
DeclareGlobalFunction("IsSubMultiSet");;

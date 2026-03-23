#
# HypArr: Functions to analyse freeness properties
#
#! @Chapter Free arrangements
#!
#! The following describes functions to analyse freeness
#! properties of arrangements such as  <E>inductively freeness</E> due to
#! H.\ Terao <Cite Key="Terao1980_FreeI"/> and  <E>inductively freeness</E> due to T.\ Abe <Cite Key="Abe16_DivFree"/>.
#!

#################################
##
#! @Section Freeness properties
##
#################################


#! @Arguments A
#! @Returns true or false.
#! @Description
#! Determines whether the arrangement <A>A</A> is <E>inductively free</E> in the sense of Terao.
#! @BeginExampleSession
#! 
#! @EndExampleSession
DeclareProperty("IsInductivelyFree", IsHyperplaneArrangement);

BindGlobal("IsIF",IsInductivelyFree);;

#! @Arguments A
#! @Returns true or false.
#! @Description
#! Determines whether the arrangement <A>A</A> is <E>divisionally free</E> in the sense of Terao.
#! @BeginExampleSession
#! 
#! @EndExampleSession
DeclareProperty("IsDivisionallyFree", IsHyperplaneArrangement);

BindGlobal("IsDF",IsDivisionallyFree);;

# some auxillary functions
DeclareGlobalFunction("IsSubMultiSet");;
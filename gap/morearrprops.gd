#
# HypArr: Functions to analyse further arrangement properties
#
#! @Chapter Further arrangement properties
#!
#! The following describes functions to analyse further
#! properties of arrangements such as <E>formality</E>, <E>supersolvability</E>, <E>simpliciality</E>,
#! <E>factoredness</E>, <E>inductive factoredness</E> ...
#!


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
#! @Section Supersolvable arrangements
##
#################################


#################################
##
#! @Section Simplicial arrangements
##
#################################



#################################
##
#! @Section Factored arrangements
##
#################################
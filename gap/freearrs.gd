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
#! @Section Module of logarithmic vector fields
##
#################################

#! The functions in this section all use the <B>singular</B> package
#! to call functions from <B>Singular</B> for commutative algebra calculations <Cite Key="DGPS_Singular4"/>

DeclareCategory("IsDerivationModule", IsComponentObjectRep and IsAttributeStoringRep );

DeclareRepresentation(
    "IsDerivationModuleRep",
    IsDerivationModule,
    ["pring", "gens", "degseq", "projdim"]
);

#! @Arguments A [, mult]
#! @Returns Derivation module
#! @Description
#!  Computes the <E>(multi) derivation module</E> of the arrangement <A>A</A>
#!  (with multiplicities given as a list by <A>mult</A>).
#! @BeginExampleSession
#! gap> A:=HyperplaneArrangement([[1,0,0],[0,1,0],[0,0,1],[1,1,1]]);
#! <HyperplaneArrangement: 4 hyperplanes in 3-space>
#! gap> D:=DerModule(A);
#! <Derivation module
#!   over PolynomialRing( Rationals, ["x_1", "x_2", "x_3"] )
#!   with 4 generators>
#! gap> D:=DerModule(A,[2,1,3,4]);
#! <Derivation module
#!   over PolynomialRing( Rationals, ["x_1", "x_2", "x_3"] )
#!   with 4 generators>
#! @EndExampleSession
DeclareOperation("DerModule",[IsHyperplaneArrangement]);

DeclareOperation("DerModule",[IsHyperplaneArrangement, IsList]);

# DeclareAttribute("HArrDerModule", IsHyperplaneArrangement);

#! @Arguments D
#! @Returns list
#! @Description
#! Returns the (minimal) generators 
#! of the module <A>D</A>.
#! @BeginExampleSession
#! gap> A:=HyperplaneArrangement([[1,0,0],[0,1,0],[0,0,1],[1,1,1]]);
#! <HyperplaneArrangement: 4 hyperplanes in 3-space>
#! gap> D:=DerModule(A);
#! <Derivation module
#!   over PolynomialRing( Rationals, ["x_1", "x_2", "x_3"] )
#!   with 4 generators>
#! gap> DerModGenerators(D);
#! [ [ x_1, x_2, x_3 ], 
#!   [ 0, -x_2*x_3, x_2*x_3 ], 
#!   [ 0, x_2*x_3, x_1*x_3+x_3^2 ], 
#!   [ 0, x_1*x_2+x_2^2+x_2*x_3, 0 ] ]
#! @EndExampleSession
DeclareAttribute("DerModGenerators",IsDerivationModule);

#! @Arguments D
#! @Returns Polynomial ring
#! @Description
#! Returns the defining polynomial ring of <A>D</A>.
#! @BeginExampleSession
#! gap> D:=DerModule(AGpql(3,3,2));; DerModPRing(D);
#! <field in characteristic 0>[x_1,x_2]
#! @EndExampleSession
DeclareAttribute("DerModPRing",IsDerivationModule);

#! @Arguments D
#! @Returns list
#! @Description
#! Returns the sequence of degrees of (minimal) generators 
#! of the graded module <A>D</A>.
#! @BeginExampleSession
#! gap> A:=HyperplaneArrangement([[1,0,0],[0,1,0],[0,0,1],[1,1,0],[1,1,1]]);
#! <HyperplaneArrangement: 5 hyperplanes in 3-space>
#! gap> DerModDegreeSequence(DerModule(A));
#! [ 1, 2, 2 ]
#! @EndExampleSession
DeclareAttribute("DerModDegreeSequence",IsDerivationModule);

#! @Arguments D
#! @Returns A non-negative integer
#! @Description
#!  Computes the projective dimension of the module <A>D</A>.
#! @BeginExampleSession
#! gap> A:=HyperplaneArrangement([[1,0,0],[0,1,0],[0,0,1],[1,1,1]]);
#! <HyperplaneArrangement: 4 hyperplanes in 3-space>
#! gap> D:=DerModule(A);
#! <Derivation module
#!   over PolynomialRing( Rationals, ["x_1", "x_2", "x_3"] )
#!   with 4 generators>
#! gap> DerModProjDim(D);
#! 1
#! @EndExampleSession
DeclareAttribute("DerModProjDim", IsDerivationModule);

#! @Arguments D
#! @Returns true or false
#! @Description
#!  Determines, if <A>D</A>
#!  is a free module over <C>DerModPRing(D)</C>.
#! @BeginExampleSession
#! gap> A:=HyperplaneArrangement([[1,0,0],[0,1,0],[0,0,1],[1,1,0],[1,1,1]]);
#! <HyperplaneArrangement: 5 hyperplanes in 3-space>
#! gap> D:=DerModule(A);; DerModIsFree(D);
#! true
#! gap> A:=HyperplaneArrangement([[1,0,0],[0,1,0],[0,0,1],[1,1,1]]);
#! <HyperplaneArrangement: 4 hyperplanes in 3-space>
#! gap> D:=DerModule(A);; DerModIsFree(D);
#! false
#! @EndExampleSession
DeclareAttribute("DerModIsFree", IsDerivationModule);

#! @Arguments A
#! @Returns true or false
#! @Description
#!  Determines, if <A>A</A> is free, i.e. if the derivation module
#!  is a free module over the coordinate ring of the ambient space.
#! @BeginExampleSession
#! gap> A:=HyperplaneArrangement([[1,0,0],[0,1,0],[0,0,1],[1,1,0],[1,1,1]]);
#! <HyperplaneArrangement: 5 hyperplanes in 3-space>
#! gap> HArrIsFree(A);
#! true
#! gap> A:=HyperplaneArrangement([[1,0,0],[0,1,0],[0,0,1],[1,1,1]]);
#! <HyperplaneArrangement: 4 hyperplanes in 3-space>
#! gap> HArrIsFree(A);
#! false
#! @EndExampleSession
DeclareAttribute("HArrIsFree", IsHyperplaneArrangement);

# DeclareSynonym("DerMod",DAModule);


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

DeclareSynonym("IsIF",IsInductivelyFree);;

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

DeclareSynonym("IsDF",IsDivisionallyFree);;



#################################
# some auxillary functions
#################################
DeclareGlobalFunction("IsSubMultiSet");;



#################################
##
#! @Section Display
##
#################################
# Declare display function for DerivationModule objects
DeclareOperation("ViewObject", [ IsDerivationModule ]);

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

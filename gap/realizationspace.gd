#
# HypArr: Relization spaces of geometric lattices
#
#! @Chapter Realization spaces of geometric lattices
#!
#! The computation of the realization space uses the <B>singular</B> package
#! to call functions from <B>Singular</B> <Cite Key="DGPS_Singular4"/>.

# Declare the category
DeclareCategory("IsRealizationSpaceOfGeomLattice", IsComponentObjectRep and IsAttributeStoringRep );

# Declare the representation
DeclareRepresentation(
    "IsRealizationSpaceOfGeomLatticeRep", 
    IsRealizationSpaceOfGeomLattice,
    ["lattice","char","deffield","coeffmat",
    "isrep","dimension",
    "pring","idealminors","idealnonminors"]
);


# Declare display function for RealizationSpaceOfGeomLattice objects
DeclareOperation("ViewObject", [IsRealizationSpaceOfGeomLattice]);


#################################
##
#! @Section Construction
##
#################################

#! @Arguments L, char[, GenSetL]
#! @Returns RealizationSpaceOfGeometricLattice
#! @Description
#!  Computes the realization space of the geometric lattice <A>L</A> in characteristic <A>char</A>.
#!  Optionally, a generating set of <A>L</A> (as a subset of <C>LAtoms(L)</C>) can be given. 
#!  Otherwise, the algorithm tries to find a small one.
#! @BeginExampleSession
#! gap> L:=IntersectionLattice(AGpql(3,3,3));
#! <Geometric lattice: 9 atoms, rank 3>
#! gap> RS:=LRealizationSpace(L,0);
#! <RealizationSpaceOfGeomLattice: in characteristic 0, non-empty: true>
#! gap> S:=LGenSet(L);
#! [ 2, 3, 4, 6, 8 ]
#! gap> RS:=LRealizationSpace(L,0,S);
#! <RealizationSpaceOfGeomLattice: in characteristic 0, non-empty: true
#! @EndExampleSession
DeclareOperation("LRealizationSpace", [IsGeomLattice, IsInt]);

DeclareOperation("LRealizationSpace", [IsGeomLattice, IsInt, IsList]);


#################################
##
#! @Section Attributes
##
#################################

#! @Arguments L
#! @Returns a set
#! @Description
#!  Computes some generating set of <A>L</A>.
#! @BeginExampleSession
#! gap> L:=IntersectionLattice(AGpql(3,3,3));
#! <Geometric lattice: 9 atoms, rank 3>
#! gap> LGenSet(L);
#! [ 2, 3, 4, 6, 8 ]
#! @EndExampleSession
DeclareAttribute("LGenSet",IsGeomLattice);

#! @Arguments RS
#! @Returns a geometric lattice
#! @Description
#!  Returns the geometric lattice of the realization space <A>RS</A>.
#! @BeginExampleSession
#! gap> RSLattice(RS);
#! <Geometric lattice: 9 atoms, rank 3>
#! @EndExampleSession
DeclareAttribute("RSLattice",IsRealizationSpaceOfGeomLattice);

#! @Arguments RS
#! @Returns 0 or a prime number
#! @Description
#!  Returns the characteristic of the reliation space <A>RS</A>.
#! @BeginExampleSession
#! gap> RSCharacteristic(RS);
#! 0
#! @EndExampleSession
DeclareAttribute("RSCharacteristic",IsRealizationSpaceOfGeomLattice);

#! @Arguments RS
#! @Returns a field
#! @Description
#!  Returns the field over which the realization space <A>RS</A> is defined.
#! @BeginExampleSession
#! gap> RSDefField(RS);
#! Rationals
#! @EndExampleSession
DeclareAttribute("RSDefField",IsRealizationSpaceOfGeomLattice);

#! @Arguments RS
#! @Returns a matrix
#! @Description
#!  Returns the coefficient matrix of <A>RS</A> with entries in <C>RSPRing(RS)</C>.
#! @BeginExampleSession
#! gap> RSCoeffMat(RS);
#! [ [ a1-1, a1, 0 ], [ 1, 0, 0 ], [ 0, 1, 0 ], [ 0, 0, 1 ], 
#!   [ 1, 1, a1 ], [ 1, 1, 1 ], [ 0, 1, -a1^2+a1 ], 
#!   [ 1, 0, a1 ], [ -a1+1, -a1, -a1^2 ] ]
#! @EndExampleSession
DeclareAttribute("RSCoeffMat",IsRealizationSpaceOfGeomLattice);

#! @Arguments RS
#! @Returns a non-negative integer
#! @Description
#!  Returns the dimension of <A>RS</A>.
#! @BeginExampleSession
#! gap> RSDimension(RS);
#! 0
#! @EndExampleSession
DeclareAttribute("RSDimension",IsRealizationSpaceOfGeomLattice);

#! @Arguments RS
#! @Returns a polynomial ring
#! @Description
#!  The polynomial ring over which the representing coefficient matrix
#!  <C>RSCoeffMat(RS)</C> of <A>RS</A> is defined.
#! @BeginExampleSession
#! gap> RSPRing(RS);
#! Rationals[a1]
#! @EndExampleSession
DeclareAttribute("RSPRing",IsRealizationSpaceOfGeomLattice);

#! @Arguments RS
#! @Returns an ideal
#! @Description
#!  Returns the ideal of equations which have to satisfied due to the dependcy of atoms
#!  in <C>RSLattice(RS)</C> over <C>RSDefField(RS)</C>.
#! @BeginExampleSession
#! gap> I:=RSIdealMinors(RS); GeneratorsOfIdeal(I);
#! <two-sided ideal in Rationals[a1], (1 generator)>
#! [ a1^2-a1+1 ]
#! @EndExampleSession
DeclareAttribute("RSIdealMinors",IsRealizationSpaceOfGeomLattice);

#! @Arguments RS
#! @Returns a list of polynomials
#! @Description
#!  Gives a list of polynomials which should not vanish due to 
#!  independent subsets of atoms
#!  in <C>RSLattice(RS)</C> over <C>RSDefField(RS)</C>.
#! @BeginExampleSession
#! gap> RSNonMinors(RS);
#! [ a1^3-a1^2, a1^3, -a1^3+2*a1^2-a1, -2*a1^2+2*a1-1 ]
#! @EndExampleSession
DeclareAttribute("RSNonMinors",IsRealizationSpaceOfGeomLattice);


###############################
##
#! @Section Properties
##
###############################

#! @Arguments RS
DeclareProperty("RSIsNonEmpty",IsRealizationSpaceOfGeomLattice);



#################################################
##
#! @Section Further (auxillary) Operations
##
#################################################

#! @Arguments L,S
DeclareOperation("LSubsetGeneratedByS",[IsGeomLattice,IsList]);

#! @Arguments L,S
DeclareOperation("LIsGenSet",[IsGeomLattice,IsList]);

DeclareOperation("LDependentSubsets", [IsGeomLattice, IsInt]);

DeclareOperation("LIsIndependentSubset", [IsGeomLattice, IsList]);

DeclareOperation("LBasisCircuitInMat", [IsGeomLattice, IsList]);

DeclareOperation("LGenSetIndeterminateMat", [IsGeomLattice, IsList, IsField]);

DeclareGlobalFunction("PolyIsProdOfDivisors");
DeclareGlobalFunction("MaximalElementsWrtDivisibility");

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
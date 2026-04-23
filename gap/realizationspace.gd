#
# HypArr: Relization spaces of geometric lattices
#
#! @Chapter Realization spaces of geometric lattices


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

#! @Arguments 
#! @Returns 
#! @Description
#!  
#! @BeginExampleSession
#! 
#! @EndExampleSession
DeclareAttribute("RSLattice",IsRealizationSpaceOfGeomLattice);

#! @Arguments 
#! @Returns 
#! @Description
#!  
#! @BeginExampleSession
#! 
#! @EndExampleSession
DeclareAttribute("RSCharacteristic",IsRealizationSpaceOfGeomLattice);

#! @Arguments 
#! @Returns 
#! @Description
#!  
#! @BeginExampleSession
#! 
#! @EndExampleSession
DeclareAttribute("RSDefField",IsRealizationSpaceOfGeomLattice);

#! @Arguments 
#! @Returns 
#! @Description
#!  
#! @BeginExampleSession
#! 
#! @EndExampleSession
DeclareAttribute("RSCoeffMat",IsRealizationSpaceOfGeomLattice);

#! @Arguments 
#! @Returns 
#! @Description
#!  
#! @BeginExampleSession
#! 
#! @EndExampleSession
DeclareAttribute("RSDimension",IsRealizationSpaceOfGeomLattice);

#! @Arguments 
#! @Returns 
#! @Description
#!  
#! @BeginExampleSession
#! 
#! @EndExampleSession
DeclareAttribute("RSPRing",IsRealizationSpaceOfGeomLattice);

#! @Arguments 
#! @Returns 
#! @Description
#!  
#! @BeginExampleSession
#! 
#! @EndExampleSession
DeclareAttribute("RSIdealMinors",IsRealizationSpaceOfGeomLattice);

#! @Arguments 
#! @Returns 
#! @Description
#!  
#! @BeginExampleSession
#! 
#! @EndExampleSession
DeclareAttribute("RSNonMinors",IsRealizationSpaceOfGeomLattice);


###############################
##
#! @Section Properties
##
###############################

#! @Arguments 
#! @Returns 
#! @Description
#!  
#! @BeginExampleSession
#! 
#! @EndExampleSession
DeclareProperty("RSIsNonEmpty",IsRealizationSpaceOfGeomLattice);



#################################################
##
#! @Section Further (auxillary) Operations
##
#################################################

#! @Arguments 
#! @Returns 
#! @Description
#!  
#! @BeginExampleSession
#! 
#! @EndExampleSession
DeclareOperation("LSubsetGeneratedByS",[IsGeomLattice,IsList]);

#! @Arguments 
#! @Returns 
#! @Description
#!  
#! @BeginExampleSession
#! 
#! @EndExampleSession
DeclareOperation("LIsGenSet",[IsGeomLattice,IsList]);

#! @Arguments 
#! @Returns 
#! @Description
#!  
#! @BeginExampleSession
#! 
#! @EndExampleSession
DeclareOperation("LDependentSubsets", [IsGeomLattice, IsInt]);

#! @Arguments 
#! @Returns 
#! @Description
#!  
#! @BeginExampleSession
#! 
#! @EndExampleSession
DeclareOperation("LIsIndependentSubset", [IsGeomLattice, IsList]);

#! @Arguments 
#! @Returns 
#! @Description
#!  
#! @BeginExampleSession
#! 
#! @EndExampleSession
DeclareOperation("LBasisCircuitInMat", [IsGeomLattice, IsList]);

#! @Arguments 
#! @Returns 
#! @Description
#!  
#! @BeginExampleSession
#! 
#! @EndExampleSession
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
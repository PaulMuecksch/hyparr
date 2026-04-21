#
# HypArr: Relization spaces of geometric lattices
#
#! @Chapter Realization spaces of geometric lattices


# Declare the category
DeclareCategory("IsRealizationSpaceOfGeomLattice", IsComponentObjectRep and IsAttributeStoringRep );

# Declare the representation
DeclareRepresentation(
    "IsRealizationSpaceOfGeomLatticeRep", 
    IsOrientedMatroid,
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

#! @Arguments 
#! @Returns 
#! @Description
#!  
#! @BeginExampleSession
#! 
#! @EndExampleSession
DeclareOperation("RealizationSpaceOfGeomLattice", [IsGeomLattice, IsInt]);


#################################
##
#! @Section Attributes
##
#################################

#! @Arguments 
#! @Returns 
#! @Description
#!  
#! @BeginExampleSession
#! 
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
DeclareAttribute("RSIdealNonMinors",IsRealizationSpaceOfGeomLattice);


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

DeclareOperation("LSubsetGeneratedByS",[IsGeomLattice,IsList]);
DeclareOperation("LIsGenSet",[IsGeomLattice,IsList]);

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
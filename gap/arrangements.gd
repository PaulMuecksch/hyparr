#
# HypArr: Computations with hyperplane arrangements 
#
#! @Chapter Introduction
#!
#! HypArr is a package for computations with hyperplane arrangements,
#! oriented matroids, and their topological invariants, in particular Milnor fibers and complements.
#!
#! @Chapter Functionality
#!
#!
#! @Section Example Methods
#!
#! This section will describe the example
#! methods of HypArr

#! @Description
#!   Insert documentation for your function here
# DeclareGlobalFunction( "HypARr_Example" );

# Declare the category
DeclareCategory("IsHyperplaneArrangement", IsComponentObjectRep and IsAttributeStoringRep );

# Declare the representation and its attribute accessor functions
DeclareRepresentation(
    "IsHyperplaneArrangementRep", 
    IsHyperplaneArrangement,
    ["roots","dimension","lattice"]
);

DeclareAttribute("Dimension", IsHyperplaneArrangement);
DeclareAttribute("Roots", IsHyperplaneArrangement);
DeclareAttribute("IntersectionLattice",IsHyperplaneArrangement);
DeclareAttribute("MSetInvL",IsHyperplaneArrangement);

# Declare constructor
DeclareOperation("HyperplaneArrangement", [IsList]);

# Declare display function for HyperplaneArrangement objects
DeclareOperation("ViewObject", [IsHyperplaneArrangement]);

# some auxillary functions
DeclareGlobalFunction( "HypArr_PWLinInd" );
DeclareGlobalFunction( "HypArr_wg" );
DeclareGlobalFunction( "HypArr_wg3" );
DeclareGlobalFunction( "HypArr_AddHToL" );
DeclareGlobalFunction( "tnow");
DeclareGlobalFunction( "AGpql" );

DeclareGlobalFunction( "HArrResHvec" );
DeclareGlobalFunction( "HArrResHind" );
DeclareGlobalFunction( "HArrResX" );
DeclareGlobalFunction( "Essentialization");;

##
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

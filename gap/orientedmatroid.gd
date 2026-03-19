#
# HypArr: Computations with oriented matroids
#
#! @Chapter Oriented Matroids
#!
#! Oriented matroids are a abstraction of real hyperplane arrangements.
#! The following describes functions to handle oriented matroids and compute associated cell complexes
#! and invariants.


# Declare the category
DeclareCategory("IsOrientedMatroid", IsComponentObjectRep and IsAttributeStoringRep );

# Declare the representation
DeclareRepresentation(
    "IsOrientedMatroidRep", 
    IsOrientedMatroid,
    ["rank","groundset","lforms","cocircuits","covectors","lattice","topegraph","salcpx"]
);

# Declare the category
DeclareCategory("IsFacePoset", IsComponentObjectRep and IsAttributeStoringRep );

# Declare the representation
DeclareRepresentation(
    "IsFacePosetRep", 
    IsFacePoset,
    ["grgroundset","orderfunction"]
);

#################################
##
#! @Section Attributes
##
#################################

#! @Arguments 
#! @Returns 
#! @Description
#! Computes 
DeclareAttribute("OMRank", IsOrientedMatroid);

#! @Arguments 
#! @Returns 
#! @Description
#! Computes 
DeclareAttribute("OMGroundset", IsOrientedMatroid);

#! @Arguments 
#! @Returns 
#! @Description
#! Computes 
DeclareAttribute("OMLForms", IsOrientedMatroid);

#! @Arguments 
#! @Returns 
#! @Description
#! Computes 
DeclareAttribute("OMGeomLattice", IsOrientedMatroid);

#! @Arguments 
#! @Returns 
#! @Description
#! Computes 
DeclareAttribute("OMCocircuits", IsOrientedMatroid);

#! @Arguments 
#! @Returns 
#! @Description
#! Computes 
DeclareAttribute("TopeGraph", IsOrientedMatroid);

#! @Arguments 
#! @Returns 
#! @Description
#! Computes 
DeclareAttribute("OMCovectors", IsOrientedMatroid);

#! @Arguments 
#! @Returns 
#! @Description
#! Computes 
DeclareAttribute("SalvettiComplex", IsOrientedMatroid);


#! @Arguments 
#! @Returns 
#! @Description
#! Computes 
DeclareAttribute("FPGroundset", IsFacePoset);

#! @Arguments 
#! @Returns 
#! @Description
#! Computes 
DeclareAttribute("FPOrder", IsFacePoset);

#################################
##
#! @Section Properties
##
#################################

DeclareProperty("OMIsLinear", IsOrientedMatroid);

#################################
##
#! @Section Global methods
##
#################################

#! @Arguments 
#! @Returns 
#! @Description
#! Computes 
DeclareGlobalFunction("cosn");

#! @Arguments z
#! @Returns a float 
#! @Description
#! Compute the float representation of the real part of a cyclotomic (complex) number 
DeclareGlobalFunction("CCToFloat");

#! @Arguments 
#! @Returns 
#! @Description
#! Computes 
DeclareGlobalFunction("pos");

#! @Arguments 
#! @Returns 
#! @Description
#! Computes 
DeclareGlobalFunction("OMOperation");

#! @Arguments 
#! @Returns 
#! @Description
#! Computes 
DeclareGlobalFunction("OrderCovec");

#! @Arguments 
#! @Returns 
#! @Description
#! Computes 
DeclareGlobalFunction("LowerOrderIdeal");

#! @Arguments 
#! @Returns 
#! @Description
#! Computes 
DeclareGlobalFunction("IsOMEquiv");

#! @Arguments 
#! @Returns 
#! @Description
#! Computes 
DeclareGlobalFunction("SeparatingSet");

#################################
##
#! @Section Constructors
##
#################################

#! @Arguments r or A
#! @Returns An oriented matroid OM.
#! @Description
#!  Constructs am oriented matroid from a list <A>r</A> of vectors
#!  representing defining linear forms of real hyperplanes
#!  or a real hyperplane arrangement <A>A</A>.
#!
#!  Each vector <M>r = [r_1,\dots,r_n]</M> corresponds to the linear form
#!  <Display>
#!     r_1 x_1 + \cdots + r_n x_n = 0.
#!  </Display>
#!  The vectors must lie in the same real vector space.
#!
#! @BeginExampleSession
#! gap> A:=AGpql(2,2,3); OM:=OrientedMatroid(Roots(A));
#! <OrientedMatroid: 6 elements, rank 3>
#! gap> A:=AGpql(2,2,3); OM:=OrientedMatroid(A);
#! <OrientedMatroid: 6 elements, rank 3>
#! @EndExampleSession
DeclareOperation("OrientedMatroid", [IsList]);

# Declare display function for HyperplaneArrangement objects
DeclareOperation("ViewObject", [IsOrientedMatroid]);

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

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

# Declare the representation and its attribute accessor functions
DeclareRepresentation(
    "IsOrientedMatroidRep", 
    IsOrientedMatroid,
    ["cocircuits","covectors","lattice","rank","groundset","lforms"]
);

#################################
##
#! @Section Attributes
##
#################################

DeclareAttribute("OMRank", IsOrientedMatroid);
DeclareAttribute("OMGroundset", IsOrientedMatroid);
DeclareAttribute("OMIntersectionLattice", IsOrientedMatroid);
DeclareAttribute("OMCocircuits", IsOrientedMatroid);
DeclareAttribute("OMCovectors", IsOrientedMatroid);
# DeclareAttribute("IntersectionLattice",IsHyperplaneArrangement);
# DeclareAttribute("MSetInvL",IsHyperplaneArrangement);

#! @Arguments l
#! @Returns An oriented matroid OM.
#! @Description
#!  Constructs am oriented matroid from a list <A>R</A> of vectors
#!  representing defining linear forms of real hyperplanes.
#!
#!  Each vector <M>r = [r_1,\dots,r_n]</M> corresponds to the linear form
#!  <Display>
#!     r_1 x_1 + \cdots + r_n x_n = 0.
#!  </Display>
#!  The vectors must lie in the same real vector space.
#!
#!  Linearly dependent defining forms are removed automatically, so the
#!  resulting arrangement only stores pairwise linearly independent
#!  hyperplanes.
#!
#! @BeginExampleSession
#! gap> A := HyperplaneArrangement([[1,0,0],[0,1,0],[0,0,1]]);
#! <HyperplaneArrangement: 3 hyperplanes in 3-space>
#! gap> Roots(A);
#! [ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 0, 0, 1 ] ]
#! @EndExampleSession]
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

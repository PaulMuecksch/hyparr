#
# HypArr: Functions for tope posets
#
#! @Chapter Tope posets

# Declare the category
DeclareCategory("IsTopePoset", IsComponentObjectRep and IsAttributeStoringRep );

# Declare the representation
DeclareRepresentation(
    "IsTopePosetRep", 
    IsTopePoset,
    ["grgroundset","bt"]
);


#################################
##
#! @Section Operations
##
#################################


#! @Arguments OM,BTope
#! @Returns A TopePoset object
#! @Description
#! Constructs the tope poset of the oriented matroid <A>OM</A>
#! with respect to the base tope <A>BTope</A> (given as sign vector).
#!
#! @BeginExampleSession
#! gap> O:=OM([[1,0],[0,1]]); Ts:=OMCovectors(O)[1]; T:=Ts[1];
#! <OrientedMatroid: 2 elements, rank 2>
#! [ [ -1, -1 ], [ 1, 1 ], [ -1, 1 ], [ 1, -1 ] ]
#! [ -1, -1 ]
#! gap> TP:=TopePoset(O,T);
#! <TopePoset with 3 topes>
#! @EndExampleSession
DeclareOperation("TopePoset", [IsOrientedMatroid, IsList]);



#################################
##
#! @Section Attributes
##
#################################


#! @Arguments TP
#! @Returns A list of lists.
#! @Description
#!  The ground set of the tope poset <A>TP</A>.
#!  It is a list of list, recording the separating elements
#!  of the given tope from the base tope.
#! @BeginExampleSession
#! gap> TPGroundSet(TP);
#! [ [ [  ] ], [ [ 1 ], [ 2 ] ], [ [ 1, 2 ] ] ]
#! @EndExampleSession
DeclareAttribute("TPGroundSet", IsTopePoset);


#! @Arguments TP
#! @Returns A sign vector.
#! @Description
#!   Returns the bast tope of the tope poset <A>TP</A>.
#! @BeginExampleSession
#! gap> TPBaseTope(TP);
#! [ -1, -1 ]
#! @EndExampleSession
DeclareAttribute("TPBaseTope", IsTopePoset);

#! @Arguments TP
#! @Returns A polynomial.
#! @Description
#!   Returns the rank generating polynomial of the tope poset <A>TP</A>.
#! @BeginExampleSession
#! gap> TPRankPoly(TP);
#! t^2+2*t+1
#! @EndExampleSession
DeclareAttribute("TPRankPoly",IsTopePoset);


#################################
##
#! @Section Properties
##
#################################


#################################
##
# @Section Operations
##
#################################


##################################################################

# Declare display function for FacePoset objects
DeclareOperation("ViewObject", [IsTopePoset]);

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

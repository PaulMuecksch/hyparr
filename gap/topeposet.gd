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
    ["grgroundset","btope"]
);


#################################
##
#! @Section Operation
##
#################################


#! @Arguments OM,BTope
#! @Returns A TopePoset object
#! @Description
#! Constructs the tope poset of the oriented matroid <A>OM</A>
#! with respect to the base tope <A>BTope</A> (given as sign vector).
#!
#! @BeginExampleSession
#! gap> O:=OrientedMatroid([[1,0],[0,1],[1,1]]); 
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
DeclareAttribute("TPGroundSet", IsTopePoset);


#! @Arguments TP
#! @Returns A sign vector.
#! @Description
#!   Returns the bast tope of the tope poset <A>TP</A>.
#!
DeclareAttribute("TPBaseTope", IsTopePoset);


#################################
##
#! @Section Properties
##
#################################


##################################################################

# Declare display function for FacePoset objects
DeclareOperation("ViewObject", [IsFacePoset]);

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

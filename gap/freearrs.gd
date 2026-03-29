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

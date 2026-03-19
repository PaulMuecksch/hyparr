#
# HypArr: Computations with milnor fibers
#
#! @Chapter Milnor fibers
#!
#! Milnor fiber is the fiber over 1 of the Milnor fibration of the hyperplane arrangement.
#! The following describes functions to construct regular cell complex having the homotopy type of
#! the Milnor fiber and thus enables computation of homotopy invaraints using e.g. the HAP package.


#################################
##
#! @Section Attributes
##
#################################

#! @Arguments 
#! @Returns 
#! @Description
#! Computes 
DeclareAttribute("MilnorFiberComplex", IsOrientedMatroid);

#! @Arguments 
#! @Returns 
#! @Description
#! Computes 
DeclareAttribute("MilnorFiberComplex", IsHyperplaneArrangement);

#################################
##
#! @Section Global methods
##
#################################

#! @Arguments 
#! @Returns 
#! @Description
#! Computes 
DeclareGlobalFunction("rkSubDivCodim1");

#! @Arguments 
#! @Returns 
#! @Description
#! Computes 
DeclareGlobalFunction("RUp");

#! @Arguments 
#! @Returns 
#! @Description
#! Computes 
DeclareGlobalFunction("MCpxOF");



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

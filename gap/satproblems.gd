#
# HypArr: SAT-problems
#
#! @Chapter SAT-problems


#################################
##
#! @Section Construction
##
#################################


# Declare the category
DeclareCategory("IsSATProblem", IsComponentObjectRep and IsAttributeStoringRep );

# Declare the representation
DeclareRepresentation(
    "IsSATProblemRep", 
    IsSATProblem,
    ["nvars","clauseslist","cnfstr", "sols", "allsols"]
);


DeclareOperation("ViewObject", [IsSATProblem]);


#! @Arguments nvar,clauseslist, allsols
#! @Returns 
#! @Description
DeclareOperation("SATProblem",[IsInt,IsList, IsBool]);

#################################
##
#! @Section Attributes
##
#################################

#! @Arguments SP
#! @Returns an integer
#! @Description
#! @BeginExampleSession
#! @EndExampleSession
DeclareAttribute("SATnvariables",IsSATProblem);

#! @Arguments SP
#! @Returns a list
#! @Description
#! @BeginExampleSession
#! @EndExampleSession
DeclareAttribute("SATClauses",IsSATProblem);


#! @Arguments SP
#! @Returns a list
#! @Description
#! @BeginExampleSession
#! @EndExampleSession
DeclareAttribute("SATallSolutions",IsSATProblem, "mutable");

#! @Arguments SP
#! @Returns a string
#! @Description
#! @BeginExampleSession
#! @EndExampleSession
DeclareAttribute("SATCNFStr",IsSATProblem);

#! @Arguments SP
#! @Returns a list
#! @Description
#! @BeginExampleSession
#! @EndExampleSession
DeclareAttribute("SATSolutions",IsSATProblem, "mutable");



#################################
##
#! @Section Operations
##
#################################

#! @Arguments SP, all
#! @Returns 
#! @Description
DeclareOperation("SATSolve",[IsSATProblem]);


DeclareGlobalFunction("SATOrientations");
DeclareGlobalFunction("ClausesToCNFStr");
DeclareGlobalFunction("SolveSAT");
DeclareGlobalFunction("ParseSATSolutions");



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
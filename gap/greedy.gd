#
# HypArr: Greedy search for special arrangements
#
#! @Chapter Greedy search for special arrangements



# Declare the category
DeclareCategory("IsHArrGreedySearch", IsComponentObjectRep and IsAttributeStoringRep );

# Declare the representation
DeclareRepresentation(
    "IsHArrGreedySearchRep", 
    IsHArrGreedySearch,
    ["gf","dim","nhs","targetfct","maxiter","runsearch"]
);

# Declare display function for HArrGreedySearch objects
DeclareOperation("ViewObject", [IsHArrGreedySearch]);

DeclareAttribute("GreedySearchGF",IsHArrGreedySearch);
DeclareAttribute("GreedySearchDimension",IsHArrGreedySearch);
DeclareAttribute("GreedySearchNOfHs",IsHArrGreedySearch);
DeclareAttribute("GreedySearchTargetFct",IsHArrGreedySearch);
DeclareAttribute("GreedySearchMaxIterations",IsHArrGreedySearch);

DeclareAttribute("GreedySearchRun",IsHArrGreedySearch);


# Declare the category
DeclareCategory("IsHArrPropTargetFct", IsComponentObjectRep and IsAttributeStoringRep );

# Declare the representation
DeclareRepresentation(
    "IsHArrPropTargetFctRep", 
    IsHArrPropTargetFct,
    ["prop","fct"]
);

# Declare display function for HArrPropTargetFct objects
DeclareOperation("ViewObject", [IsHArrPropTargetFct]);

DeclareOperation("HArrGreedySearch",[IsInt,IsInt,IsField,HArrPropTargetFct,IsInt]);

DeclareOperation("RandArrOverGF",[IsInt,IsInt,IsField]);

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
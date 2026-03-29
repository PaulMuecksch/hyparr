#
# HypArr: Functions to analyse further arrangement properties
#
# Implementations
#
############################################################


####################################################################################################
## Test if an Arrangement is formal
####################################################################################################

InstallGlobalFunction(HArr_FSpace,
function(A)
local NS;;
    NS := NullspaceMat(Roots(A));;
    if NS=[] then
        NS := [0*[1..Length(Roots(A))]];;
    fi;;
    return NS;;
end);

InstallGlobalFunction(HArr_EMatS,
function(n,S)
local E,i;;
    E:=NullMat(Length(S),n);;
    for i in [1..Length(S)] do
        E[i][S[i]] := 1;;
    od;;
    return E;;
end);

InstallGlobalFunction(HArr_SpaceSFx,
function(A)
local LA2,LA2ns,m,Fm,SFx,n,Am;;
    n:=Length(Roots(A));;
    LA2:=GLkFlats(IntersectionLattice(A))(2);;
    LA2ns := LA2{Positions(List(LA2,x->Length(x)>2),true)};;
    SFx:=NullMat(1,n);;
    for m in LA2ns do
        Am:=Arr(Roots(A){m});;
        SFx:=Concatenation(SFx,HArr_FSpace(Am)*HArr_EMatS(n,m));;
    od;;
    
    return SFx;;
end);

InstallMethod(IsFormal,
	[ IsHyperplaneArrangement ],
function(A)
    if Rank(Roots(A)) <= 1 then
        return true;;
    else
        return Rank(HArr_FSpace(A)) = Rank(HArr_SpaceSFx(A));;
    fi;;
end);


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

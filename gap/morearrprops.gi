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

InstallMethod(GLIsModularPair, 
    [IsGeomLattice, IsList, IsList],
function(L, m1, m2)
local d, rfct;
    rfct := GLRankFunction(L);;
    if rfct(m1) + rfct(m2) = rfct(Union(m1,m2)) +  rfct(IntersectionSet(m1,m2)) then
        return true;
    fi;;
    return false;
end);

InstallMethod(GLIsModularFlat,
    [IsGeomLattice, IsList],
function(L,m)
local mt,M,j;
	M:=Reversed(ShallowCopy(GLGroundSet(L)){[1..GLRank(L)-1]});
	for j in [1..GLRank(L)-1] do
		for mt in M[j] do			
			if not(GLIsModularPair(L,m,mt)) then
				return false;
			fi;
		od;
	od;
	return true;
end);

InstallMethod(GLModularFlatsRk,
    [IsGeomLattice, IsInt],
function(L,k)
    return GLkFlats(L)(k){Positions(List(GLkFlats(L)(k),m->GLIsModularFlat(L,m)),true)};;
end);;

InstallMethod(GLIsSupersolvable,
    [IsGeomLattice],
function(L)
local LLoc, r, m;
    r := GLRank(L);
    if r <= 2 then
        return true;;
    fi;;
    for m in GLkFlats(L)(r-1) do
        if GLIsModularFlat(L,m) then
            LLoc := GLLocalizationRk(L,m,r-1);
            return GLIsSupersolvable(LLoc);
        fi;;
    od;;
    return false;;
end);

InstallMethod(HArrIsSupersolvable,
    [IsHyperplaneArrangement],
function(A)
    return GLIsSupersolvable(IntersectionLattice(A));
end);

InstallMethod(OMIsSupersolvable,
    [IsOrientedMatroid],
function(OM)
    return GLIsSupersolvable(OMGeomLattice(OM));
end);


InstallMethod(HArrIsSimplicial,
    [IsHyperplaneArrangement],
function(A)
local l,t;#,rk;
    if not(IsReal(A)) then
        Print("Arrangement is not real!\n");
        return fail;
    fi;;
	l:=Dimension(A);
	t:=X(Rationals,"t");
	#rk:=Rank(A.roots);;
	
	return l*Value(CharPoly(A),[t],[-1])
		+2*Sum(List([1..Length(Roots(A))],y->Value(CharPoly(HArrResHind(A,y)),[t],[-1])))
		= 0;
end);


# InstallMethod(OMIsSimplicial,
#     [IsOrientedMatroid],
# function(OM)
# local l,t,f;
# 	l:=OMRank(OM);
#     f :=GLCharPoly(OMGeomLattice(OM));
# 	t := IndeterminateOfUnivariateRationalFunction(f);;
# 	return l*Value(CharPoly(A),[t],[-1])
# 		+2*Sum(List([1..Length(OMGroundSet(OM))],y->Value(CharPoly(HArrResHind(A,y)),[t],[-1])))
# 		= 0;
# end);

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

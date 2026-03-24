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
    return NullspaceMat(Roots(A));;
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
    return Rank(HArr_FSpace(A)) = Rank(HArr_SpaceSFx(A));;
end);
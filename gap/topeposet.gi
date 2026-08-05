#
# HypArr: Computations with tope posets
#
# Implementations
# #


BindGlobal("TopePosetFamily",
    NewFamily("TopePosetFamily"));

InstallMethod(ViewObj,
    [ IsTopePoset ],
function(TP)
local GSet;
    GSet := TPGroundSet(TP);
    Print("<TopePoset with ",
          Length(GSet)," topes>");
end);


InstallMethod(TPGroundSet,
    [ IsTopePoset ],
    TP -> TP!.grgroundset);

InstallMethod(TPBaseTope,
    [ IsTopePoset ],
    TP -> TP!.bt);

InstallMethod(TopePoset,
    [ IsOrientedMatroid, IsList ],
function(OM,BTope)
local Ps, gset, OF, type, Topes, n;
    Topes := OMTopes(OM);
    n := Length(BTope);
    Ps := List(Topes,T->SeparatingSet(BTope,T));
    Sort(Ps);
    gset:=List([0..n],x->Ps{Positions(List(Ps,y->Length(y)),x)});
    
    type := NewType(TopePosetFamily,IsTopePosetRep);

    return Objectify(type,
        rec(
            grgroundset := gset,
			bt := BTope
        )
    );
end);

InstallMethod(TPRankPoly,
    [IsTopePoset],
function(TP)
local gset,t;
    t:=X(Rationals,"t");
    gset := TPGroundSet(TP);
    return Sum(List([1..Length(gset)],k->Length(gset[k])*t^(k-1)));
end);


InstallGlobalFunction(PTerm,
function(k)
local t;
    t:=X(Rationals,"t");
    if k<0 then
        return t^k*PTerm(-k);;
    fi;;
    if k=0 then
        return 1;
    else 
        return t^k + PTerm(k-1);
    fi;
end);

InstallMethod(IsFactTPRankPolyExp,
[IsTopePoset, IsList],
function(TP,Exp)
local p1,p2;;
    if Exp=fail then
        return false;
    fi;;
    p1:=TPRankPoly(TP);;
    p2:=Product(List(Exp,x->PTerm(x)));;
    return p1=p2;;
end);

InstallMethod(TopesFactTPRankPoly,
[IsOrientedMatroid],
function(O)
local Bs, KP, B, Ts, Exp, G;
    Exp:=OMExp(O);
    if Exp=fail then
        return fail;
    fi;

    Ts:=OMTopes(O);;
    G:=AutGroupGraph(ShallowCopy(TopeGraph(O)));
    Ts:=Ts{List(Orbits(G,[1..Length(Ts)]),O->O[1])};
    # Ts:=Ts{List([0..Length(Ts)/2-1],x->1+2*x)};;
    Bs:=[];;
    for B in Ts do
        if IsFactTPRankPolyExp(TopePoset(O,B),Exp) then
            Add(Bs,B);
            # Print(B,"\n");;
        fi;;
    od;;

    return Bs;;
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

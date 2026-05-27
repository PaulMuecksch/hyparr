#
# HypArr: Complements
#
# Implementations
#


BindGlobal("FacePosetFamily",
    NewFamily("FacePosetFamily"));

InstallMethod(ViewObj,
    [ IsFacePoset ],
function(FP)
local GSet;
    GSet := FPGroundSet(FP);
    Print("<FacePoset of dimension ",
          Length(GSet)-1," with f-vector ",List(GSet,x->Length(x)),">");
end);

InstallMethod(FPGroundSet,
    [ IsFacePoset ],
    FP -> FP!.grGroundSet);

InstallMethod(FPOrder,
    [ IsFacePoset ],
    FP -> FP!.orderfunction);



####################################################################################################

InstallMethod(SalvettiComplex,
    "for an oriented matroid",
    [ IsOrientedMatroid ],
function(OM)
local SalCpx,SalOF, FCpx,Topes,d,T, k,type;
    FCpx:=OMCovectors(OM);
    Topes:=FCpx[1];
    d:=Length(FCpx);
    SalCpx:=List([1..d],x->[]);
    for T in Topes do
        for k in [1..d] do
            SalCpx[k] := Concatenation(SalCpx[k], List(LowerOrderIdeal(FCpx,[T],OrderCovec)[k],x->[x,T]) );
        od;
    od;

    # return SalCpx;
    SalOF := function(SalCell1,SalCell2)
    local T,R,sigma,tau;
        sigma:=SalCell1[1];
        tau:=SalCell2[1];
        T:=SalCell1[2];
        R:=SalCell2[2];

        if OrderCovec(tau,sigma)=true then
            if OMOperation(sigma,R)=T then
                return true;
            fi;
        fi; 
        return false;
    end;

    type := NewType(FacePosetFamily,
                    IsFacePosetRep);

    return Objectify(type,
        rec(
            grGroundSet := SalCpx,
            orderfunction := SalOF
        )
    );
end);


####################################################################################################


InstallMethod(SalvettiComplex,
    "for a real arrangement",
    [ IsHyperplaneArrangement],
function(A)
local OM,SalCpx,SalOF, FCpx,Topes,d,T, k,type;
    if not(IsReal(A)) then
        Print("Not a real arrangement!\n");
        return fail;
    fi;
    OM := OrientedMatroid(A);
    FCpx:=OMCovectors(OM);
    Topes:=FCpx[1];
    d:=Length(FCpx);
    SalCpx:=List([1..d],x->[]);
    for T in Topes do
        for k in [1..d] do
            SalCpx[k] := Concatenation(SalCpx[k], List(LowerOrderIdeal(FCpx,[T],OrderCovec)[k],x->[x,T]) );
        od;
    od;

    # return SalCpx;
    SalOF := function(SalCell1,SalCell2)
    local T,R,sigma,tau;
        sigma:=SalCell1[1];
        tau:=SalCell2[1];
        T:=SalCell1[2];
        R:=SalCell2[2];

        if OrderCovec(tau,sigma)=true then
            if OMOperation(sigma,R)=T then
                return true;
            fi;
        fi; 
        return false;
    end;

    type := NewType(FacePosetFamily,
                    IsFacePosetRep);

    return Objectify(type,
        rec(
            grGroundSet := SalCpx,
            orderfunction := SalOF
        )
    );
end);

##

####################################################################################################


InstallMethod( CCLinToRRPair,
    [IsList],
function(r)
local rr,ri,ra,rb,d;
    d:=Length(r);
    rr := 1/2*(r+cj(r));
    ri := 1/(2*E(4))*(r-cj(r));
    ra := Concatenation(rr,0*[1..d])-Concatenation(0*[1..d],ri);
    rb := Concatenation(0*[1..d],rr)+Concatenation(ri,0*[1..d]);
    return [ra,rb];
end);


InstallMethod( CCToRR2Arr,
    [IsHyperplaneArrangement],
function(A)
local Ps,R1,R2,R;
    Ps:= List(Roots(A),r->CCLinToRRPair(r));
    R1 := List(Ps,x->x[1]);
    R2 := List(Ps,x->x[2]);
    R := Concatenation(R1,R2);
    return Arr(R);
    # return Arr(Concatenation(List(Roots(A),r->CCLinToRRPair(r))));
end);



InstallMethod( s2Strat,
    [IsHyperplaneArrangement],
function(A)
local s2Cpx,s2OF, type, ACs, CT;

    if cj(Roots(A))=Roots(A) then
        ACs := OMCovectors(OM(A));
        CT := Tuples([1..Length(ACs)],2);
        CT := List([2..2*Length(ACs)],x->CT{Positions(List(CT,y->Sum(y)),x)});
        ACs := List(CT,a->Concatenation(List(a,x->List(Cartesian(ACs[x[1]],ACs[x[2]]),y->Concatenation(y)))));
    else
        ACs := OMCovectors(OM(CCToRR2Arr(A)));
    fi;
    
    s2Cpx := ACs;

    s2OF := OrderCovec;

    type := NewType(FacePosetFamily,
                    IsFacePosetRep);

    return Objectify(type,
        rec(
            grGroundSet := s2Cpx,
            orderfunction := s2OF
        )
    );
end);

InstallGlobalFunction(s2Tos1,
function(c)
local cn,e;
    cn:=0*[1..Length(c)];
    for e in [1..Length(c)] do
        if c[e][2]<>0 then
            cn[e]:=c[e][2]*E(4);
        else
            cn[e] := c[e][1];
        fi;
    od;
    return cn;
end);

InstallMethod( s1Strat,
    [IsHyperplaneArrangement],
function(A)
local s1Cpx,s1OF, type, ACs,ACs2,ACs2red,Cs,c,cr,k,CT;

    if cj(Roots(A))=Roots(A) then
        ACs := OMCovectors(OM(A));
        CT := Tuples([1..Length(ACs)],2);
        CT := List([2..2*Length(ACs)],x->CT{Positions(List(CT,y->Sum(y)),x)});
        ACs := List(CT,a->Concatenation(List(a,x->List(Cartesian(ACs[x[1]],ACs[x[2]]),y->Concatenation(y)))));
    else
        ACs := OMCovectors(OM(CCToRR2Arr(A)));
    fi;
    ACs2 := List(ACs,Cs->List(Cs,c->TransposedMat([c{[1..Length(c)/2]},c{[Length(c)/2+1..Length(c)]}])));
    ACs2red := [];
    k:=0;
    for Cs in ACs2 do
        k:=k+1;
        Add(ACs2red,[]);
        for c in Cs do
            cr := s2Tos1(c);
            if not(cr in Concatenation(ACs2red{[1..k]})) then
                Add(ACs2red[k],cr);
            fi;
        od;
    od;
    
    s1Cpx := ACs2red;
    

    s1OF := function(sv1,sv2)
    local t,i, Os1;
        Os1 := function(x,y)
        local im;
            im := E(4);
            if (x=0 and y<>0) or [x,y] in [[1,im],[1,-im],[-1,im],[-1,-im]] or x=y then
                return true;
            else
                return false;
            fi;
        end;

        if Length(sv1)<>Length(sv2) then
            return fail;
        fi;
        if sv1=sv2 then
            return false;
        fi;
        for i in [1..Length(sv1)] do
            if Os1(sv1[i],sv2[i])=false then
                return false;
            fi;
        od;
        return true;
    end;

    type := NewType(FacePosetFamily,
                    IsFacePosetRep);

    return Objectify(type,
        rec(
            grGroundSet := s1Cpx,
            orderfunction := s1OF
        )
    );
end);


InstallMethod( BZs1Complex,
    [IsHyperplaneArrangement],
function(A)
local Strat1,St,Csk,S1Comp,BZs1Cpx,BZs1OF, type;

    Strat1 := s1Strat(A);
    S1Comp := [];
    for St in FPGroundSet(Strat1) do
        Csk := St{Positions(List(St,x->not(0 in x)),true)};
        if Csk<>[] then
            Add(S1Comp , Csk);
        fi;
    od;

    type := NewType(FacePosetFamily,
                    IsFacePosetRep);

    BZs1Cpx := S1Comp;
    BZs1OF := function(c1,c2) 
        return FPOrder(Strat1)(c2,c1); 
    end;

    return Objectify(type,
        rec(
            grGroundSet := BZs1Cpx,
            orderfunction := BZs1OF
        )
    );
end);


InstallMethod( BZs2Complex,
    [IsHyperplaneArrangement],
function(A)
local Strat2,S2Comp,St,BZs2Cpx,BZs2OF, FCpx, type;
    Strat2 := s2Strat(A); 
    S2Comp:=[];
    for St in FPGroundSet(Strat2) do
        Add(S2Comp ,St{Positions(List(St,x->not(true in List([1..Length(x)/2],y->x{[y,y+Length(x)/2]}=[0,0])) ),true)});
    od;

    type := NewType(FacePosetFamily,
                    IsFacePosetRep);

    BZs2Cpx := S2Comp;
    BZs2OF := function(c1,c2) 
        return FPOrder(Strat2)(c2,c1); 
    end;

    return Objectify(type,
        rec(
            grGroundSet := BZs2Cpx,
            orderfunction := BZs2OF
        )
    );
end);

InstallMethod(CCSimpleTriangle,
    [IsHyperplaneArrangement],
function(A)
local A2, L, OA2, PotSimpTs, B, Bi1, Bi2, Bi3, CVs5, CsBi1, CsBi2, CsBi3, CsB, OCsB, n, HsNotInB, HNotInB;
    n := Length(Roots(A));
    if Rank(Roots(A))<>3 or Rank(Roots(A))=n then
        return false;
    fi;
    L:=IntersectionLattice(A);;
    PotSimpTs:=LBases(L){Positions(List(LBases(L),B->not(false in List(Combinations(B,2),x->x in LkFlats(L)(2)))),true)};
    A2 := CCToRR2Arr(A);
    OA2 := OM(A2);
    for B in PotSimpTs do
        HsNotInB := Difference([1..n],B);
        HNotInB := HsNotInB[1];
        Bi1 := [B[1],B[2],B[1]+n,B[2]+n];
        Bi2 := [B[1],B[3],B[1]+n,B[3]+n];
        Bi3 := [B[2],B[3],B[2]+n,B[3]+n];
        CVs5:=OMCovectors(OA2)[6];; 
        CsBi1 := CVs5{Positions(List(CVs5,x->x{Bi1}=[0,0,0,0] and x{[HNotInB,HNotInB+n]}=[1,0]),true)};
        CsBi2 := CVs5{Positions(List(CVs5,x->x{Bi2}=[0,0,0,0] and x{[HNotInB,HNotInB+n]}=[1,0]),true)};
        CsBi3 := CVs5{Positions(List(CVs5,x->x{Bi3}=[0,0,0,0] and x{[HNotInB,HNotInB+n]}=[1,0]),true)};
        for CsB in Cartesian(CsBi1,CsBi2,CsBi3) do
            OCsB := OMTConvexClosureOpenSubcomplex(OA2, OMTopes(OA2){Positions(List(OMTopes(OA2),T->true in List(CsB,c->OrderCovec(c,T))),true)});
            if not( ForAny( OCsB[5],
                    c-> c{Bi1}<>[0,0,0,0] 
                        and 
                        c{Bi2}<>[0,0,0,0] 
                        and 
                        c{Bi3}<>[0,0,0,0] 
                        and 
                        c{[HNotInB,HNotInB+n]}=[1,0]
                        and 
                        ForAny( HsNotInB, h->c{[h,h+n]}=[0,0] ) 
                        ) ) then
                Print(B,"\n");
                return true;
            fi;
        od;
    od;
    return false;
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

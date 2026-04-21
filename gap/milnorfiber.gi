#
# HypArr: Computations with milnor fibers
#
# Implementations
# #


####################################################################################################

InstallMethod(MilnorFiberComplex,
    "for an oriented matroid",
    [ IsOrientedMatroid ],
function(OM)
local SCpx, MCpx, MCpx2, Topes, TopesP,d, k, type, MCpxOF;
    Topes:=OMCovectors(OM)[1];
    TopesP:=Topes{Positions(List(Topes,T->Product(T)=1),true)};
    SCpx:=FPGroundSet(SalvettiComplex(OM));
    d:=Length(SCpx);

    MCpx:=List([1..d-1],x->[]);
    MCpx[1]:=List(TopesP,x->[[x],x,x]);
    # MCpx2[1] := List(MCpx[1],x->[1,0]);

    for k in [3..d] do
        MCpx[k-1] := Concatenation(List(SCpx[k],x->rkSubDivCodim1(x,Topes)));
    od;
    
    MCpxOF := function(F1,F2)
    local Ts1,Ts2,T1,T2,sigma1,sigma2;
        Ts1:=F1[1];
        Ts2:=F2[1];
        T1:=F1[2];
        T2:=F2[2];
        sigma1 := F1[3];
        sigma2 := F2[3];

        if IsSubset(Ts2,Ts1)=true then
            if OMOperation(sigma1,T2)=T1 then
                return true;
            fi;
        fi; 
        return false;
    end;

    type := NewType(FacePosetFamily,
                    IsFacePosetRep);

    return Objectify(type,
        rec(
            grGroundSet := MCpx,
            orderfunction := MCpxOF
        )
    );
end);

InstallMethod(MilnorFiberComplex,
    "for a real hyperplane arrangement",
    [ IsHyperplaneArrangement ],
function(A)
local SCpx, MCpx, MCpx2, Topes, TopesP,d, k, OM, type, MCpxOF;
    OM := OrientedMatroid(A);
    Topes:=OMCovectors(OM)[1];
    TopesP:=Topes{Positions(List(Topes,T->Product(T)=1),true)};
    SCpx:=FPGroundSet(SalvettiComplex(OM));
    d:=Length(SCpx);

    MCpx:=List([1..d-1],x->[]);
    MCpx[1]:=List(TopesP,x->[[x],x,x]);
    # MCpx2[1] := List(MCpx[1],x->[1,0]);

    for k in [3..d] do
        MCpx[k-1] := Concatenation(List(SCpx[k],x->rkSubDivCodim1(x,Topes)));
    od;

    MCpxOF := function(F1,F2)
    local Ts1,Ts2,T1,T2,sigma1,sigma2;
        Ts1:=F1[1];
        Ts2:=F2[1];
        T1:=F1[2];
        T2:=F2[2];
        sigma1 := F1[3];
        sigma2 := F2[3];

        if IsSubset(Ts2,Ts1)=true then
            if OMOperation(sigma1,T2)=T1 then
                return true;
            fi;
        fi; 
        return false;
    end;

    type := NewType(FacePosetFamily,
                    IsFacePosetRep);

    return Objectify(type,
        rec(
            grGroundSet := MCpx,
            orderfunction := MCpxOF
        )
    );
end);





####################################################################################################
# Global auxillary functions
####################################################################################################

InstallGlobalFunction(RUp,
function(a)
    if Int(a)=a then
        return a;
    else
        return Int(a)+1;
    fi;
end);

InstallGlobalFunction(rkSubDivCodim1,
function(SalCell,Topes)
local ks,sigma, ns, T, QT, TopesSigma;
    sigma:=SalCell[1];
    T:=SalCell[2];
    QT:=Product(T);
    ns:=Length(Positions(sigma,0));
    if QT=-1 then
        ks := List([1..Int(ns/2)],x->2*x-1);
    else
        ks:=2*[1..(RUp(ns/2)-1)]; 
    fi;
    TopesSigma := Topes{Positions(List(Topes,R->OrderCovec(sigma,R)),true)};

    return List(ks,k->[TopesSigma{Positions(List(TopesSigma,R->Length(SeparatingSet(T,R))=k),true)},T,sigma]);
end);

InstallGlobalFunction(FPtoCWCpx,
function(FP)
local PSet,OF,FaceCpxC, MFCpx, d, IncFs, F, CWFCpx;
    PSet := FPGroundSet(FP);
    OF := FPOrder(FP);
    FaceCpxC := [];
    FaceCpxC[1] := List(PSet[1],x->[1,0]);
    for d in [2..Length(PSet)] do
        Add(FaceCpxC,[]);
        # FacCpxC[d]:=[];
        for F in PSet[d] do
            IncFs:=Positions(List(PSet[d-1],x->OF(x,F)),true);
            Add(FaceCpxC[d],Concatenation([Length(IncFs)],IncFs));
        od;
    od;

    Add(FaceCpxC,[]);

    CWFCpx:=RegularCWComplex(FaceCpxC);

    return CWFCpx;
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

#
# HypArr: Relization spaces of geometric lattices
#
#$ Implementations


BindGlobal("RealizationSpaceOfGeomLatticeFamily",
    NewFamily("IsRealizationSpaceOfGeomLatticeFamily"));

InstallMethod(ViewObj,
    [ IsRealizationSpaceOfGeomLattice ],
function(RS)
    Print("<RealizationSpaceOfGeomLattice: in characteristic ",
           RSCharacteristic(RS), ", non-empty: ",RSIsNonEmpty(RS),">");
end);

InstallMethod(RSLattice,
    [ IsRealizationSpaceOfGeomLattice ],
    RS -> RS!.lattice);

InstallMethod(RSCharacteristic,
    [ IsRealizationSpaceOfGeomLattice ],
    RS -> RS!.char);

InstallMethod(RSDefField,
    [ IsRealizationSpaceOfGeomLattice ],
    RS -> RS!.deffield);

InstallMethod(RSCoeffMat,
    [ IsRealizationSpaceOfGeomLattice ],
    RS -> RS!.coeffmat);

InstallMethod(RSDimension,
    [ IsRealizationSpaceOfGeomLattice ],
    RS -> RS!.dimension);

InstallMethod(RSPRing,
    [ IsRealizationSpaceOfGeomLattice ],
    RS -> RS!.pring);

InstallMethod(RSIdealMinors,
    [ IsRealizationSpaceOfGeomLattice ],
    RS -> RS!.idealminors);

InstallMethod(RSNonMinors,
    [ IsRealizationSpaceOfGeomLattice ],
    RS -> RS!.nonminors);

InstallMethod(RSIsNonEmpty,
    [ IsRealizationSpaceOfGeomLattice ],
    RS -> RS!.isrep);


#######################################################
##
## Computation of realization space 
##
#######################################################

BindGlobal("GenPointAndLineOfEltFromGenSet",
function(L,GenSet,e)
local rkFkt,rL,PsOverElt,LsOverElt,GenPs,pos, PLPairOverElt,POverElt,LOverElt;
    rkFkt := LRankFunction(L);
    rL := LRank(L);
    PsOverElt := LkFlats(L)(rL-1){Positions(List(LkFlats(L)(rL-1),p->e in p and rkFkt(Intersection(GenSet,p))=rL-1 ),true)};
    LsOverElt := LkFlats(L)(2){Positions(List(LkFlats(L)(2),l->e in l and rkFkt(Intersection(GenSet,l))=2 ),true)};
    PLPairOverElt := Cartesian(PsOverElt,LsOverElt);
    pos := Position(List(PLPairOverElt,pl -> Length(Intersection(pl))=1),true);
    if pos<>fail then
        PLPairOverElt := PLPairOverElt[pos];
        POverElt := PLPairOverElt[1];
        LOverElt := Intersection(PLPairOverElt[2],GenSet){[1,2]};
        POverElt := Combinations(Intersection(POverElt,GenSet),rL-1);
        POverElt := POverElt[Position(List(POverElt,p->rkFkt(p)=rL-1),true)];
        return [POverElt,LOverElt];
    fi;
    return fail;
end);


InstallMethod(LSubsetGeneratedByS,
    [IsGeomLattice,IsList],
function(L,S)
local Sn1,Sn2, EltsLeft, newElts, e, Atoms;
    newElts := true;
    Sn1 := ShallowCopy(S);
    Atoms := LAtoms(L);
    while newElts=true do
        EltsLeft := Difference(Atoms,Sn1);
        Sn2 := ShallowCopy(Sn1);
        for e in EltsLeft do
            if GenPointAndLineOfEltFromGenSet(L,Sn2,e)<>fail then
                Add(Sn2,e);
            fi;
        od;
        if Length(Sn2)=Length(Sn1) then
            newElts := false;
        else
            Sn1 := Sn2;
        fi;
    od;
    return Sn2;
end);

InstallMethod(LIsGenSet,
    [IsGeomLattice,IsList],
function(L,S)
    if Length(LSubsetGeneratedByS(L,S))=Length(LAtoms(L)) then
        return true;
    fi;
    return false;
end);

BindGlobal("LFindGenSet",
function(L)
local GenSs,MaxLenGenSs, isGenSet,GenSet,GenSetNew, NewGenSets, ls, ml,l,Atoms,RankFktnL,
    # GenericSubsets,
    rL;
    
    rL:=LRank(L);;
    Atoms := LAtoms(L);
    RankFktnL := LRankFunction(L);
    # GenericSubsets := Combinations(Atoms,rL+1);;
    # Print(Length(GenericSubsets),"\n");;
    # GenericSubsets := GenericSubsets{Positions(List(GenericSubsets,S->not(ForAny(Combinations(S,rL),T->RankFktnL(T)<rL))),true)};;
    # Print(Length(GenericSubsets),"\n");;
    # ls := List(GenericSubsets,S->Length(LSubsetGeneratedByS(L,S)));;
    # ml := Maximum(ls);;
    # GenericSubsets := GenericSubsets{Positions(List(GenericSubsets,S->Length(LSubsetGeneratedByS(L,S))),ml)};        
    # Print(Length(GenericSubsets),"\n");;
    # GenSet := Random(GenericSubsets);
    # if LIsGenSet(L,GenSet) then
    #     return GenSet;
    # fi;;
    GenSet := Random(LBases(L));
    isGenSet := false;
    while isGenSet=false do
        NewGenSets := List(Difference(Atoms,GenSet),l->Union(GenSet,[l]) );
        ls := List(NewGenSets,x->Length(LSubsetGeneratedByS(L,x)));
        ml := Maximum(ls);
        GenSetNew := NewGenSets[Position(ls,ml)];
        if LIsGenSet(L,GenSetNew) then
            isGenSet := true;
            return GenSetNew;
        elif Length(LSubsetGeneratedByS(L,GenSetNew)) > Length(LSubsetGeneratedByS(L,GenSet)) then
            GenSet := GenSetNew;
        fi;;
    od;;
    
    return fail;
end);

InstallMethod(LGenSet,
    [IsGeomLattice],
function(L)
local GenSet,ml;
    GenSet := List([1..20],x->LFindGenSet(L));
    ml := Minimum(List(GenSet,x->Length(x)));
    GenSet := Random(GenSet{Positions(List(GenSet,x->Length(x)),ml)});
    L!.genset := GenSet;
    return(L!.genset);
end);

InstallMethod(LDependentSubsets,
    [IsGeomLattice, IsInt],
function(L,d)
local DepSs,S;
    DepSs := [];
    for S in LkFlats(L)(d-1) do
        DepSs := Union(DepSs,Combinations(S,d));
    od;;    
    return DepSs;
end);

InstallMethod(LIsIndependentSubset,
    [IsGeomLattice, IsList],
function(L,S)
local rkFkt;
    rkFkt := LRankFunction(L);;
    return Length(S)=rkFkt(S);;
end);

InstallMethod(LBasisCircuitInMat,
    [IsGeomLattice, IsList],
function(L,B)
local rL, k, InMat, Atoms, S, BasisCircuitInVec;

    BasisCircuitInVec := function(L,B,k)
    local IncVec, e, rL, T, i;
        rL := LRank(L);;
        IncVec := 0*[1..rL];;
        for i in [1..rL] do
            e := B[i];;
            T := Union(Difference(B,[e]),[k]);;
            if LIsIndependentSubset(L,T)=true then
                IncVec[i] := 1;;
            fi;;
        od;;
        return IncVec;;
    end;

    rL := LRank(L);
    Atoms := LAtoms(L);
    S := Difference(Atoms,B);;
    InMat := NullMat(Length(Atoms),rL);;
    InMat{B} := IdentityMat(rL);;
    for k in S do
        InMat[k] := BasisCircuitInVec(L,B,k);;
    od;;
    
    return InMat;;
end);


InstallMethod(LGenSetIndeterminateMat,
    [IsGeomLattice, IsList, IsField],
function(L,GenSet,K)
local rkFkt, e, EMat,rL ,B, A, S,D, D1,D2, Atoms, Vars, R, eR, IndPair, m, var, Det, PL, Pe, Le,i;

    rL := LRank(L);;
    rkFkt := LRankFunction(L);;

    B := Combinations(GenSet,rL);;
    B := B[Position(List(B,x->rkFkt(x)=rL),true)];;
    
    Atoms := LAtoms(L);
    A := LBasisCircuitInMat(L,B);;  
    S := Difference(GenSet,B);;
    D1 := A{S};;
    m:=0;;
    Vars := [];;

    for IndPair in Cartesian([1..Length(D1)],[1..Length(D1[1])]) do
        if D1[IndPair[1]][IndPair[2]] = 1 and 
            (1 in D1[IndPair[1]]{[1..IndPair[2]-1]}) and 
            (1 in D1{[1..IndPair[1]-1]}[IndPair[2]]) then
            m:=m+1;;
            var := X(K, Concatenation("a",String(m)));
            Add(Vars,var);;
            D1[IndPair[1]][IndPair[2]] := var;;
        fi;;
    od;;
    R:=PolynomialRing(K,Vars);;
    # EMat:=IdentityMat(rL, R);;
    eR := One(R);;
    # eR := EMat[1][1];;
    
    Det := DeterminantMatDivFree;;
    
    S:=Difference(Atoms,GenSet);;
    i:=1;;
    while S<>[] do
        e:=S[i];;
        PL := GenPointAndLineOfEltFromGenSet(L,GenSet,e);;
        if PL<>fail then
            Pe := PL[1];;
            Le := PL[2];;
#             
            A[e] := Det(Concatenation([eR*A[Le[2]]],eR*A{Pe}))*A[Le[1]] - Det(Concatenation([eR*A[Le[1]]],eR*A{Pe}))*A[Le[2]];;
            S:=Difference(S,[e]);;
            GenSet := Union(GenSet,[e]);;
            i:=1;;
        else
            i := i+1;;
        fi;;
    od;;
    
    return rec(IndMat := eR*A, PRing := R);;
end);


# Remove all polys which are units or divisors of other members in a list of polys
BindGlobal("ReduceListOfPolys",
function(LOfPs, PRing)
    local redLOfPs, IsProd, others, p, i, j, is_div;
        
    redLOfPs := ShallowCopy(LOfPs);
    i := 1;
    
    while i <= Length(redLOfPs) do
        p := redLOfPs[i];

        is_div := false;
        
        if IsUnit(PRing, p) then
            # If p is a unit, we remove it
            Remove(redLOfPs, i);
        else
            # Collect all non-unit polynomials currently in the list (excluding p itself)
            others := [];
            for j in [1..Length(redLOfPs)] do
                if i <> j and not IsUnit(PRing, redLOfPs[j]) then
                    Add(others, redLOfPs[j]);
                fi;
            od;
            
            is_div := ForAny(others, q-> q mod p = Zero(PRing));
        fi;
        
        if is_div then
            # Remove redundant polynomial and shift (do not increment i)
            Remove(redLOfPs, i);
        else
            i := i + 1;
        fi;
    od;
    
    return redLOfPs;
end);

InstallGlobalFunction(MaximalElementsWrtDivisibility,
function(LOfPs, PRing)
    local res, i, j, p, q, is_max;
    res := [];
    for i in [1..Length(LOfPs)] do
        is_max := true;
        p := LOfPs[i];
        for j in[1..Length(LOfPs)] do
            q := LOfPs[j];
            # If p divides q, p is not maximal (unless they are associate)
            if i <> j and Quotient(PRing, q, p) <> fail then
                if Quotient(PRing, p, q) = fail or i > j then
                    is_max := false;
                    break;
                fi;
            fi;
        od;
        if is_max then Add(res, p); fi;
    od;
    return res;
end);

InstallMethod(LRealizationSpace,
    "for a geometric lattice and a characteristic",
    [IsGeomLattice, IsInt],
function(L,char)
local type, ml, fI, eR,sI,rI, rkL, rkFkt, Bs, DepSs, 
    VarRing, VarRingExt, IMat, A, Det, GenSet, 
    IdealVanishingMinors, NonVanishingMinors, IdealNonVanishingMinors, f, ff, GenMinors,g, b, DefIdeal,
    K, IsRepresentable, AssPrimesDefIdeal, dim, fr, B;
    # local L, dfield, gset, cmat, isrep, dim, PRing,IMinors,INMinors;
    # "lattice","char","deffield","coeffmat",
    # "isrep","dimension",
    # "pring","idealminors","idealnonminors"

    if char=0 then
        K:=Rationals;
    elif IsPrime(char) then
        K:=GF(char);
    else
        Print("Second argument 'char' must be a prime!\n");
        return fail;
    fi;

    GenSet := LGenSet(L);;
    # GenSet := List([1..20],x->LFindGenSet(L));;
    # ml := Minimum(List(GenSet,x->Length(x)));;
    # GenSet := GenSet[Position(List(GenSet,x->Length(x)),ml)];;

    rkL := LRank(L);
    A := LGenSetIndeterminateMat(L,GenSet,K);
    VarRing := A.PRing;
    IMat := A.IndMat;
    eR := One(VarRing);
    Det := Determinant;
    Bs := LBases(L);
    DepSs := LDependentSubsets(L,LRank(L));;

    GenMinors := List(DepSs,S->Det(IMat{S}));;
    Add(GenMinors, Zero(A.PRing));
    IdealVanishingMinors := Ideal(VarRing,GenMinors);

    SetTermOrdering(VarRing,"dp");;
    SingularSetBaseRing( VarRing );
    SingularLibrary( "primdec.lib" );
    IdealVanishingMinors := SingularInterface("std",[IdealVanishingMinors],"ideal");;
    IdealVanishingMinors := SingularInterface("radical",[IdealVanishingMinors],"ideal");;
    sI := SingularInterface("std",[IdealVanishingMinors],"ideal");

    if GeneratorsOfIdeal(sI) = [eR] then
        IsRepresentable := false;;
    else
        IsRepresentable := true;;
    fi;;

    ff := [];;
    for B in Bs do
        f := Det(IMat{B});
        if not(IsUnit(VarRing,f)) then
            Add(ff,f);
        fi;
    od;
    # ff := ReduceListOfPolys(ff);
    ff := MaximalElementsWrtDivisibility(ff,VarRing);
    # Print(ff,"\n");

    for f in ff do
        if SingularInterface("reduce",[f,sI],"poly")=0*eR then
            IsRepresentable := false;
        fi;;
    od;;
    NonVanishingMinors := ff;
    IdealNonVanishingMinors := Ideal(VarRing,[eR*Product(ff)]);
    IdealNonVanishingMinors := SingularInterface("std",[IdealNonVanishingMinors],"ideal");

    SingularLibrary("elim.lib");
    IdealVanishingMinors := SingularInterface("sat",[IdealVanishingMinors,IdealNonVanishingMinors],"ideal");

    if X(K,"a1") in IndeterminatesOfPolynomialRing(VarRing) then
        dim := SingularInterface("dim",[sI],"int");
    else
        dim := 0;;
    fi;;
    if IsRepresentable=false then
        IMat := [];;
    fi;;

    type := NewType(RealizationSpaceOfGeomLatticeFamily,
                    IsRealizationSpaceOfGeomLatticeRep);

    return Objectify(type,
        rec(
            lattice := L,
            char := char,
            deffield := K, # add a computation from IdealVanishingMinor for the smallest (in char=0 cyclotomic?) field of definition?
            coeffmat := IMat,
            isrep := IsRepresentable,
            dimension := dim,
            pring := VarRing,
            idealminors := IdealVanishingMinors,
            nonminors := NonVanishingMinors
        )
    );
end);


InstallMethod(LRealizationSpace,
    "for a geometric lattice and a characteristic",
    [IsGeomLattice, IsInt, IsList],
function(L,char,GenSet)
local type, ml, fI, eR,sI,rI, rkL, rkFkt, Bs, DepSs, 
    VarRing, VarRingExt, IMat, A, Det, 
    IdealVanishingMinors, NonVanishingMinors, IdealNonVanishingMinors, f, ff, GenMinors,g, b, DefIdeal,
    K, IsRepresentable, AssPrimesDefIdeal, dim, fr, B;


    if char=0 then
        K:=Rationals;
    elif IsPrime(char) then
        K:=GF(char);
    else
        Print("Second argument 'char' must be a prime!\n");
        return fail;
    fi;

    rkL := LRank(L);
    A := LGenSetIndeterminateMat(L,GenSet,K);
    VarRing := A.PRing;
    IMat := A.IndMat;
    eR := One(VarRing);
    Det := Determinant;
    Bs := LBases(L);
    DepSs := LDependentSubsets(L,LRank(L));;
    GenMinors := List(DepSs,S->Det(IMat{S}));;
    Add(GenMinors, Zero(A.PRing));
    IdealVanishingMinors := Ideal(VarRing,GenMinors);

    SetTermOrdering(VarRing,"dp");;
    SingularSetBaseRing( VarRing );
    SingularLibrary( "primdec.lib" );
    IdealVanishingMinors := SingularInterface("std",[IdealVanishingMinors],"ideal");;
    IdealVanishingMinors := SingularInterface("radical",[IdealVanishingMinors],"ideal");;
    sI := SingularInterface("std",[IdealVanishingMinors],"ideal");

    if GeneratorsOfIdeal(sI) = [eR] then
        IsRepresentable := false;;
    else
        IsRepresentable := true;;
    fi;;

    ff := [];;
    for B in Bs do
        f := Det(IMat{B});
        if not(IsUnit(VarRing,f)) then
            Add(ff,f);
        fi;
    od;
    # ff := ReduceListOfPolys(ff);
    ff := MaximalElementsWrtDivisibility(ff,VarRing);
    # Print(ff,"\n");
    
    for f in ff do
        if SingularInterface("reduce",[f,sI],"poly")=0*eR then
            IsRepresentable := false;
        fi;;
    od;;
    NonVanishingMinors := ff;
    IdealNonVanishingMinors := Ideal(VarRing,[Product(ff)]);
    IdealNonVanishingMinors := SingularInterface("std",[IdealNonVanishingMinors],"ideal");

    SingularLibrary("elim.lib");
    IdealVanishingMinors := SingularInterface("sat",[IdealVanishingMinors,IdealNonVanishingMinors],"ideal");

    if X(K,"a1") in IndeterminatesOfPolynomialRing(VarRing) then
        dim := SingularInterface("dim",[sI],"int");
    else
        dim := 0;;
    fi;;
    if IsRepresentable=false then
        IMat := [];;
    fi;;

    type := NewType(RealizationSpaceOfGeomLatticeFamily,
                    IsRealizationSpaceOfGeomLatticeRep);

    return Objectify(type,
        rec(
            lattice := L,
            char := char,
            deffield := K, # add a computation from IdealVanishingMinor for the smallest (in char=0 cyclotomic?) field of definition?
            coeffmat := IMat,
            isrep := IsRepresentable,
            dimension := dim,
            pring := VarRing,
            idealminors := IdealVanishingMinors,
            nonminors := NonVanishingMinors
        )
    );
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
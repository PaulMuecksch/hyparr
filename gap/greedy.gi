#
# HypArr: Greedy search for arrangements
#
## Implementations

## for single arrangement

BindGlobal("HArrGreedySearchFamily",
    NewFamily("IsHArrGreedySearchFamily"));

InstallMethod(ViewObj,
    [ IsHArrGreedySearch ],
function(GS)
    Print("GreedySearch over ",
           GreedySearchGF(GS), " for arrangements:\n", 
           " - of rank ",GreedySearchDimension(GS),"\n",
           " - with ",GreedySearchNOfHs(GS)," hyperplanes.");
end);

InstallMethod(GreedySearchGF,
    [ IsHArrGreedySearch ],
    GS -> GS!.gf);

InstallMethod(GreedySearchDimension,
    [ IsHArrGreedySearch ],
    GS -> GS!.dim);

InstallMethod(GreedySearchNOfHs,
    [ IsHArrGreedySearch ],
    GS -> GS!.nhs);

InstallMethod(GreedySearchTargetFct,
    [ IsHArrGreedySearch ],
    GS -> GS!.targetfct);

InstallMethod(GreedySearchRun,
    [ IsHArrGreedySearch ],
    GS -> GS!.runsearch);

## for arrangement pairs

BindGlobal("HArrGreedySearchPairFamily",
    NewFamily("IsHArrGreedySearchPairFamily"));

InstallMethod(ViewObj,
    [ IsHArrGreedySearchPair ],
function(GS)
    Print("GreedySearch over ",
           GreedySearchGF(GS), " for arrangement pairs:\n", 
           " - of rank ",GreedySearchDimension(GS),"\n",
           " - with ",GreedySearchNOfHs(GS)," hyperplanes.");
end);

InstallMethod(GreedySearchGF,
    [ IsHArrGreedySearchPair ],
    GS -> GS!.gf);

InstallMethod(GreedySearchDimension,
    [ IsHArrGreedySearchPair ],
    GS -> GS!.dim);

InstallMethod(GreedySearchNOfHs,
    [ IsHArrGreedySearchPair ],
    GS -> GS!.nhs);

InstallMethod(GreedySearchTargetFctSame,
    [ IsHArrGreedySearchPair ],
    GS -> GS!.targetfct_same);

InstallMethod(GreedySearchTargetFctDiff,
    [ IsHArrGreedySearchPair ],
    GS -> GS!.targetfct_diff);

InstallMethod(GreedySearchRun,
    [ IsHArrGreedySearchPair ],
    GS -> GS!.runsearch);

## Greedy search algo single

InstallMethod(RandomArrOverGF,
    [IsInt,IsInt,IsField, IsList],
function(dim,NumberOfHs,GField,RAs)
local Hs,i,R,h;
    Hs := Points(PG(dim-1,GField));
    if RAs<>[] then
        R:=ShallowCopy(RAs);
    else
        R:=Concatenation(One(GField)*IdentityMat(dim),[List([1..dim],x->One(GField))]);
    fi;
    while Length(R)<NumberOfHs do
        h:=Coordinates(Random(Hs));
        if not(true in List(R,ht->Rank([h,ht])=1)) then
            Add(R,h);
        fi;
    od;
    
    return Arr(R);
end);

InstallMethod(RandomNewHThroughPoints,
    [IsHyperplaneArrangement],
function(A)
local L,d,Pts,Cs1,G,CsO,NewH;
    L:=IntersectionLattice(A);
    d:=LRank(L);
    Pts:=ShallowCopy(LkFlats(L)(d-1));
    Cs1 := Combinations(Pts,d-1);
    Cs1 := Cs1{Positions(List(Cs1,c->Intersection(c)=[]),true)};
    if Cs1=[] then
        return fail;
    fi;
    
    NewH:=NullspaceMat( TransposedMat(Concatenation(List(Random(Cs1),y->NullspaceMat(TransposedMat(Roots(A){y}))))))[1];
    
    return NewH;
end);


InstallMethod(RandomNewHThroughIntersections,
    [IsHyperplaneArrangement],
function(A)
local L,Cs1,G,CsO,NewH, PLPair, Point, Line;
    if Rank(Roots(A))=3 then
        return RandomNewHThroughPoints(A);
    fi;
    L := IntersectionLattice(A);
    Cs1 := Set(CandidatesLinesPointsNewH(L),x->Set(x,y->Set(y)));

    if Cs1=[] then
        return fail;
    fi;
    
    NewH:=NullspaceMat( TransposedMat(Concatenation(List(Random(Cs1),y->NullspaceMat(TransposedMat(Roots(A){y}))))))[1];
    return NewH;
end);

InstallMethod(RandomNewH,
    [IsHyperplaneArrangement],
function(A)
local IsNewH, NewH, d, F, i,q;
    d := Dimension(A);
    F := HArrDefField(A);
    q := Size(F);
    IsNewH := false;
    i:=1;
    while not(IsNewH) or i<10 do
        NewH := List([1..d],x->Random([0..q-1])*Z(q));
        if not(ForAny(Roots(A),v->Rank([v,NewH])=1)) then
            IsNewH:=true;
            return NewH;
        fi;
        i:=i+1;
    od;
    return fail;
end);

InstallMethod(ExchangeRandomH,
    [IsHyperplaneArrangement,IsList],
function(A,fixS)
local ANew,PossibleNewHs,OldH,NewH,Ln, Rn, n, h;
    n := Length(Roots(A));
    # if n>=Dimension(A)+1 then
    #     h := Random([Dimension(A)+1..n]);
    # else
        h := Random(Difference([1..n],fixS));
    # fi;
    NewH := RandomNewHThroughIntersections(A);
    if NewH = fail then
        return fail;
    fi;
    ANew:=HArrAddition(HArrDeletion(A,h),NewH);
    # Rn := Roots(A){Difference([1..n],[h])};
    # ANew := Arr(Concatenation(Rn,[NewH]));       
    return ANew;
end);

InstallMethod(ExchangeRandomH2,
    [IsHyperplaneArrangement,IsList],
function(A,fixS)
local ANew,NewH,Ln, Rn, n, h;
    n := Length(Roots(A));
    # if n>=Dimension(A)+1 then
    #     h := Random([Dimension(A)+1..n]);
    # else
        h := Random(Difference([1..n],fixS));
    # fi;
    NewH := RandomNewH(A);
    if NewH = fail then
        return fail;
    fi;
    ANew:=HArrAddition(HArrDeletion(A,h),NewH);
    # Rn := Roots(A){Difference([1..n],[h])};
    # ANew := Arr(Concatenation(Rn,[NewH]));        
    return ANew;
end);


InstallMethod(HArrGreedySearch,
    [IsInt,IsInt,IsField,IsFunction,IsInt,IsRat],
function(NumberOfHs,dim,GField,PropTargetFct,MaxNoIterations, tmp)
local RunSearch,PropP, type;

    PropP := PropTargetFct;

    RunSearch := function()
    local k,AOld,ANew,i;
        AOld := RandomArrOverGF(dim,NumberOfHs,GField,[]);
        k:=1;
        for i in [1..MaxNoIterations] do
            ANew := ExchangeRandomH(AOld,[]);
            if ANew=fail then
                ANew := ExchangeRandomH2(AOld,[]);
                if ANew=fail then
                    Print(i," Iterations - ");
                    Print("Target function value: ",PropP(AOld),"\n");
                    return fail;
                fi;
            fi;
            if PropP(ANew)=0 then
                Print(i," Iterations - ");
                return ANew;
            # elif PropP(ANew)<PropP(AOld)+tmp then
            elif PropP(ANew)/PropP(AOld) < 1-tmp then
                AOld := ANew;
                k:=1;
            # else
            #     k:=k+1;
            fi;
            # if k>=MaxNoIterations/4 then
            # if k>=50 then
            #     k:=1;
            #     AOld := ANew;
            # fi;
        od;
        Print("Target function value: ",PropP(ANew),"\n");
        return fail;

    end;

    type := NewType(HArrGreedySearchFamily,
                    IsHArrGreedySearchRep);

    return Objectify(type,
        rec(
            gf := GField,
            dim := dim,
            nhs := NumberOfHs,
            tagetfct := PropTargetFct,
            maxiter := MaxNoIterations,
            runsearch := RunSearch
        )
    );

end);

InstallMethod(HArrGreedySearchSubArr,
    [IsRecord],
    # [IsInt,IsInt,IsField,IsFunction,IsInt,IsRat,IsHyperplaneArrangement, IsList],
# function(NumberOfHs,dim,GField,PropTargetFct,MaxNoIterations, tmp, StartArr, FixSubArr)
function(opts)
local RunSearch,PropP, type, ns;

    if HArrDefField(opts.StartArr)<>opts.GField then
        Print("Def field of Start arrangement different from search field!");
        return fail;
    fi;

    ns := Length(Roots(opts.StartArr));
    if opts.NumberOfHs < ns or Dimension(opts.StartArr)<>opts.dim then
        Print("Dimension or number of hyperplanes of Start arrangment so not fit!");
        return fail;
    fi;

    PropP := opts.PropTargetFct;

    RunSearch := function()
    local k,AOld,ANew,i;
        AOld := RandomArrOverGF(opts.dim,opts.NumberOfHs,opts.GField,Roots(opts.StartArr));
        k:=1;
        for i in [1..opts.MaxNoIterations] do
            ANew := ExchangeRandomH(AOld,opts.FixSubArr);
            if ANew=fail then
                ANew := ExchangeRandomH2(AOld,opts.FixSubArr);
                if ANew=fail then
                    Print(i," Iterations - ");
                    Print("Target function value: ",PropP(AOld),"\n");
                    return fail;
                fi;
            fi;
            if PropP(ANew)=0 then
                Print(i," Iterations - ");
                return ANew;
            # elif PropP(ANew)<PropP(AOld)+tmp then
            elif PropP(ANew)/PropP(AOld) < 1-opts.tmp then
                AOld := ANew;
                k:=1;
            # else
            #     k:=k+1;
            fi;
            # if k>=MaxNoIterations/4 then
            # if k>=50 then
            #     k:=1;
            #     AOld := ANew;
            # fi;
        od;
        Print("Target function value: ",PropP(ANew),"\n");
        return fail;

    end;

    type := NewType(HArrGreedySearchFamily,
                    IsHArrGreedySearchRep);

    return Objectify(type,
        rec(
            gf := opts.GField,
            dim := opts.dim,
            nhs := opts.NumberOfHs,
            tagetfct := opts.PropTargetFct,
            maxiter := opts.MaxNoIterations,
            runsearch := RunSearch,
            startA := opts.StartArr,
            fixSA := opts.FixSubArr
        )
    );

end);

InstallGlobalFunction(CharPolySplits,
function(A)
local t,f,ChiRed,DiscChiRed;
    f := CharPoly(A);
    t := IndeterminateOfUnivariateRationalFunction(f);
       
    ChiRed := f/(t-1);
    DiscChiRed := Discriminant(ChiRed);
    if DiscChiRed < 0 then
        return -DiscChiRed;
    else
        if ExpArr(A)<>fail then
                return 0;
        else
            return 1;
        fi;
    fi;
end);

InstallGlobalFunction(DistMSetInvL,
function(A,B)
local MSetA, MSetB, mA, mB, m, vA, vB;
    MSetA:=MSetInvL(A);
    MSetB:=MSetInvL(B);
    mA:=Maximum(List(MSetA[2],x->x[1]));
    mB:=Maximum(List(MSetB[2],x->x[1]));
    m:=Maximum(mA,mB);

    vA:=0*[1..m];
    vB:=0*[1..m];

    vA{List(MSetA[2],x->x[1])} := List(MSetA[2],x->x[2]);
    vB{List(MSetB[2],x->x[1])} := List(MSetB[2],x->x[2]);

    return (vA-vB)^2;
end);

InstallGlobalFunction(NotLEquiv,
function(A,B) 
    if IsLEquiv(A,B) then 
        return 1/2; 
    else 
        return 0; 
    fi; 
end);

InstallGlobalFunction(CoeffDistCharPolyExp,
function(A,Exp)
local CVExp, t,f,ChiRed, CVChiRed, n, DsCVs;

    n := Length(Roots(A));
    f := CharPoly(A);
    t := IndeterminateOfUnivariateRationalFunction(f);
    ChiRed := f/(t-1);
    CVChiRed := CoefficientsOfUnivariatePolynomial(ChiRed);
    CVChiRed := Concatenation(CVChiRed,List([Length(CVChiRed)+1..3],x->0));
    
    CVExp := CoefficientsOfUnivariatePolynomial(Product(List(Exp,e->(t-e))));
    return (CVExp-CVChiRed)^2;
end);

## For arrangement pairs
# ToDo...

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
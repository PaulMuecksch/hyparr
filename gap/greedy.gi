#
# HypArr: Greedy search for arrangements
#
#$ Implementations

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
    [IsInt,IsInt,IsField],
function(dim,NumberOfHs,GField)
local Hs,i,R,h;
    Hs := Points(PG(dim-1,GField));;
    R:=[];;
    while Length(R)<NumberOfHs do
        h:=Coordinates(Random(Hs));;
        if not(true in List(R,ht->Rank([h,ht])=1)) then
            Add(R,h);;
        fi;;
    od;;
    
    return Arr(R);;
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
    fi;;
    
    NewH:=NullspaceMat( TransposedMat(Concatenation(List(Random(Cs1),y->NullspaceMat(TransposedMat(Roots(A){y}))))))[1];
    
    return NewH;;
end);

## Combinations of coatoms and lines giving new hyperplanes
InstallMethod(CandidatesLinesPointsNewH,
    [IsGeomLattice],
function(L)
local d, SpPs, Cs, c, Lts, Pts;;
    d := LRank(L);
    Pts := ShallowCopy(LkFlats(L)(d-1)); 
    Lts := ShallowCopy(LkFlats(L)(2)); 
    SpPs :=[];;
    # Cs:=Concatenation(List(ShallowCopy(Pts),x->List(ShallowCopy(Lts),y->[x,y])));;
    Cs := Cartesian(Pts,Lts);
    for c in Cs do
        if Intersection(c)=[] then
            Add(SpPs,c);
        fi;;
    od;;
    
    return SpPs;;
end);

InstallMethod(RandomNewHThroughIntersections,
    [IsHyperplaneArrangement],
function(A)
local L,Cs1,G,CsO,NewH, PLPair, Point, Line;
    L := IntersectionLattice(A);;
    Cs1 := Set(CandidatesLinesPointsNewH(L),x->Set(x,y->Set(y)));;

    if Cs1=[] then
        return fail;
    fi;;
    
    NewH:=NullspaceMat( TransposedMat(Concatenation(List(Random(Cs1),y->NullspaceMat(TransposedMat(Roots(A){y}))))))[1];;
    return NewH;;
end);

InstallMethod(RandomNewH,
    [IsHyperplaneArrangement],
function(A)
local IsNewH, NewH, d, F, i,q;
    d := Dimension(A);
    F := HArrDefField(A);
    q := Size(F);
    IsNewH := false;;
    i:=1;
    while not(IsNewH) or i<10 do
        NewH := List([1..d],x->Random([0..q-1])*Z(q));
        if not(true in List(Roots(A),v->Rank([v,NewH])=1)) then
            IsNewH:=true;
            return NewH;;
        fi;;
        i:=i+1;
    od;
    return fail;
end);

InstallMethod(ExchangeRandomH,
    [IsHyperplaneArrangement],
function(A)
local ANew,PossibleNewHs,OldH,NewH,Ln, Rn, n, h;
    n := Length(Roots(A));;
    h := Random([1..n]);;
    NewH := RandomNewHThroughIntersections(A);;
    if NewH = fail then
        return fail;;
    fi;;
    Rn := Roots(A){Difference([1..n],[h])};;
    ANew := Arr(Concatenation(Rn,[NewH]));;        
    return ANew;;
end);

InstallMethod(ExchangeRandomH2,
    [IsHyperplaneArrangement],
function(A)
local ANew,NewH,Ln, Rn, n, h;
    n := Length(Roots(A));;
    h := Random([1..n]);;
    NewH := RandomNewH(A);;
    if NewH = fail then
        return fail;;
    fi;;
    Rn := Roots(A){Difference([1..n],[h])};;
    ANew := Arr(Concatenation(Rn,[NewH]));;        
    return ANew;;
end);


InstallMethod(HArrGreedySearch,
    [IsInt,IsInt,IsField,IsFunction,IsInt],
function(NumberOfHs,dim,GField,PropTargetFct,MaxNoIterations)
local RunSearch,PropP, type;

    PropP := PropTargetFct;

    RunSearch := function()
    local k,AOld,ANew,i;
        AOld := RandomArrOverGF(dim,NumberOfHs,GField);
        k:=1;
        for i in [1..MaxNoIterations] do
            ANew := ExchangeRandomH(AOld);;
            if ANew=fail then
                ANew := ExchangeRandomH2(AOld);;
                if ANew=fail then
                    Print(i," Iterations - ");;
                    Print("Target function value: ",PropP(AOld),"\n");
                    return fail;
                fi;;
            fi;;
            if PropP(ANew)=0 then
                Print(i," Iterations - ");;
                return ANew;;
            elif PropP(ANew)<PropP(AOld) then
                AOld := ANew;;
                k:=1;
            # else
            #     k:=k+1;
            fi;;
            # if k>=MaxNoIterations/4 then
            # if k>=50 then
            #     k:=1;
            #     AOld := ANew;;
            # fi;;
        od;;
        Print("Target function value: ",PropP(ANew),"\n");
        return fail;;

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

InstallGlobalFunction(CharPolySplits,
function(A)
local t,f,ChiRed,DiscChiRed;
    f := CharPoly(A);
    t := IndeterminateOfUnivariateRationalFunction(f);
       
    ChiRed := f/(t-1);;
    DiscChiRed := Discriminant(ChiRed);;
    if DiscChiRed < 0 then
        return -DiscChiRed;
    else
        if ExpArr(A)<>fail then
                return 0;;
        else
            return 1;
        fi;;
    fi;;
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
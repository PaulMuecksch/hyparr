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
    LA2:=LkFlats(IntersectionLattice(A))(2);;
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

InstallMethod(LIsModularPair, 
    [IsGeomLattice, IsList, IsList],
function(L, m1, m2)
local d, rfct;
    rfct := LRankFunction(L);;
    if rfct(m1) + rfct(m2) = rfct(Union(m1,m2)) +  rfct(IntersectionSet(m1,m2)) then
        return true;
    fi;;
    return false;
end);

InstallMethod(LIsModularFlat,
    [IsGeomLattice, IsList],
function(L,m)
local mt,M,j;
	M:=Reversed(ShallowCopy(LGroundSet(L)){[1..LRank(L)-1]});
	for j in [1..LRank(L)-1] do
		for mt in M[j] do			
			if not(LIsModularPair(L,m,mt)) then
				return false;
			fi;
		od;
	od;
	return true;
end);

InstallMethod(LModularFlatsRk,
    [IsGeomLattice, IsInt],
function(L,k)
    return LkFlats(L)(k){Positions(List(LkFlats(L)(k),m->LIsModularFlat(L,m)),true)};;
end);;

InstallMethod(LIsSupersolvable,
    [IsGeomLattice],
function(L)
local LLoc, r, m;
    r := LRank(L);
    if r <= 2 then
        return true;;
    fi;;
    for m in LkFlats(L)(r-1) do
        if LIsModularFlat(L,m) then
            LLoc := LLocalizationRk(L,m,r-1);
            return LIsSupersolvable(LLoc);
        fi;;
    od;;
    return false;;
end);

InstallMethod(HArrIsSupersolvable,
    [IsHyperplaneArrangement],
function(A)
    return LIsSupersolvable(IntersectionLattice(A));
end);

InstallMethod(OMIsSupersolvable,
    [IsOrientedMatroid],
function(OM)
    return LIsSupersolvable(OMGeomLattice(OM));
end);


InstallMethod(HArrIsSimplicial,
    [IsHyperplaneArrangement and IsReal],
function(A)
local l,t;#,rk;
    # if not(IsReal(A)) then
    #     Print("Arrangement is not real!\n");
    #     return fail;
    # fi;;
	l:=Dimension(A);
	t:=X(Rationals,"t");
	#rk:=Rank(A.roots);;
	
	return l*Value(CharPoly(A),[t],[-1])
		+2*Sum(List([1..Length(Roots(A))],y->Value(CharPoly(HArrRestriction(A,y)),[t],[-1])))
		= 0;
end);


# InstallMethod(OMIsSimplicial,
#     [IsOrientedMatroid],
# function(OM)
# local l,t,f;
# 	l:=OMRank(OM);
#     f :=LCharPoly(OMGeomLattice(OM));
# 	t := IndeterminateOfUnivariateRationalFunction(f);;
# 	return l*Value(CharPoly(A),[t],[-1])
# 		+2*Sum(List([1..Length(OMGroundSet(OM))],y->Value(CharPoly(HArrResHind(A,y)),[t],[-1])))
# 		= 0;
# end);  -> TODO: Restriction (aka contraction) of OMs or geom lattices

######################################
# Mike Falk's weight test
######################################

# Determine the bounded complex of the affine part of the oriented matroid w.r.t. the element g
InstallMethod(OMBoundedCpx,
    [IsOrientedMatroid, IsInt],
function(OM,g)
local ACs,BCs,BCpx_g,f,Bc;
    ACs:=OMCovectors(OM);;
    BCs:=[];;
    for f in ACs[1] do
        Bc := ACs[2]{Positions(List(ACs[2],e->OrderCovec(e,f)),true)};
        Bc := Concatenation(Bc,ACs[3]{Positions(List(ACs[3],v->OrderCovec(v,f)),true)});
        if f[g]=1 and not(true in List(Bc,ff->ff[g]=0)) then
            Add(BCs,f);
        fi;;
    od;;

    BCpx_g := LowerOrderIdeal(ACs,BCs,OrderCovec);
    return BCpx_g;;
end);

# Determine the minimal full circuits of the labled vertex graph G_v as a list giving coeffs for the inequalities
BindGlobal("MinFullCircuits_v",
function(G_v,ECs,SizeA_v,AnzCorners)
local EsG,ineq,b,InEqList,IGP,ComponentG_v,EndsG,PEsEnd,e,EsP,P,Ps;
    EsG := UndirectedEdges(G_v);;
    # Print(List(EsG,e->ECs(e)),"\n");
    InEqList:=[];;
    # if Length(VsG)=Length(EsG) then
    if IsConnectedGraph(G_v) and Length(EsG)>=SizeA_v then 
        Ps:=Combinations(EsG,SizeA_v);
        for EsP in Ps do
            IGP:=InducedSubgraph(G_v,Set(Concatenation(EsP)));
            if IsConnectedGraph(IGP) and Length(EsP)=Length(UndirectedEdges(IGP)) then
                ineq := 0*[1..AnzCorners];
                ineq{List(EsP,e->ECs(e))}:=List(EsP,x->-2);;
                b:=-2;;
                Add(InEqList,[ineq,b]);
            fi;;
        od;;
        if Length(EsG)=2*SizeA_v then
            ineq := 0*[1..AnzCorners];
            ineq{List(EsG,e->ECs(e))}:=List(EsG,x->-1);;
            b:=-2;;
            Add(InEqList,[ineq,b]);;
        fi;;
        Ps:=Combinations(EsG,SizeA_v-1);
        for EsP in Ps do
            IGP:=InducedSubgraph(G_v,Set(Concatenation(EsP)));
            if IsConnectedGraph(IGP) and Length(EsP)=Length(UndirectedEdges(IGP)) then
                ineq := 0*[1..AnzCorners];
                ineq{List(EsP,e->ECs(e))}:=List(EsP,x->-4);;
                b:=-2;;
                Add(InEqList,[ineq,b]);
            fi;;
        od;;
    else
        for ComponentG_v in ConnectedComponents(G_v) do
            # Print(ComponentG_v);;
            if Length(ComponentG_v)>=SizeA_v then
                if Length(ComponentG_v)=2 then
                    EsP:=UndirectedEdges(G_v){Positions(List(UndirectedEdges(G_v),e->IsSubset(ComponentG_v,e)),true)};;
                    # Print(List(EsP,e->ECs(e)),"\n");
                    ineq := 0*[1..AnzCorners];
                    ineq{List(EsP,e->ECs(e))}:=List(EsP,x->-4);;
                    b:=-2;;
                    Add(InEqList,[ineq,b]);
                else
                    EndsG:=ComponentG_v{Positions(List(ComponentG_v,vv->VertexDegree(G_v,vv)=1),true)};;
                    EsP:=UndirectedEdges(G_v){Positions(List(UndirectedEdges(G_v),e->IsSubset(ComponentG_v,e)),true)};;
                    # Print(EsP,List(EsP,e->ECs(e)),"\n");
                    PEsEnd:=EsP{Positions(List(EsP,x->IntersectionSet(x,EndsG)<>[]),true)};;
                    # Print(List(PEsEnd,e->ECs(e)),"\n");
                    # Print(PEsEnd);
                    # for e in PEsEnd do
                    #     # Print(List(Difference(EsP,[e]),ee->ECs(ee)),ECs(e),"\n");;
                    #     ineq := 0*[1..AnzCorners];
                    #     ineq{List(Difference(EsP,[e]),e->ECs(e))}:=List(Difference(EsP,[e]),x->-2);;
                    #     ineq[ECs(e)]:=-4;;
                    #     b:=-2;;
                    #     Add(InEqList,[ineq,b]);
                    # od;;
                    ineq := 0*[1..AnzCorners];
                    ineq{List(EsP,e->ECs(e))}:=List(EsP,x->-2);;
                    ineq{List(PEsEnd,e->ECs(e))}:=List(PEsEnd,x->-4);;
                    b:=-2;;
                    Add(InEqList,[ineq,b]);
                fi;;
            fi;;
        od;;
    fi;
    return InEqList;;
end);


InstallMethod(OMSupportsFalkWeights,
    [IsOrientedMatroid, IsInt],
function(OM,g)
local BCpx_g,InEqualities,VsBCpx,v,Bc,c,f,
    Corners,Corners_v,Corners_f,Es_v,eqv,b,n,At,P,corner,lp,
    DisplayCorners,i,SolveLP,E_v,Ec_v,V_v,G_v,Ps_v,EsP,mv,CE_v,e1,e2,e,
    PInEq,GCycle,EndVs,ECsG_v,AnzCorners;

    n:=Length(OMGroundSet(OM));;
    BCpx_g:=OMBoundedCpx(OM,g);;

    Corners := [];;
    for f in BCpx_g[1] do
        for v in BCpx_g[3] do
            if OrderCovec(v,f) then
                Add(Corners,[f,v]);;
            fi;;
        od;
    od;;

    AnzCorners := Length(Corners);;

    DisplayCorners := List(Corners,c->
        [List( BCpx_g[2]{Positions(List(BCpx_g[2],e->OrderCovec(e,c[1])),true)},e->Position(e,0)), 
        Positions(c[2],0)]);;
    # for c in DisplayCorners do
    #     Print(c,"\\newline\n");;
    # od;;
    # Print(Corners,"\n");;
    # Print(
    #     List(Corners,c->
    #     [List( BCpx_g[2]{Positions(List(BCpx_g[2],e->OrderCovec(e,c[1])),true)},e->Position(e,0)), 
    #     # List( BCpx_g[2]{Positions(List(BCpx_g[2],e->OrderCovec(c[2],e)),true)},e->Position(e,0))
    #     Positions(c[2],0)]) ,"\n");;

    InEqualities:=[];;
    b:=[];;
    for v in BCpx_g[3] do
        # Print(v,"\n");;
        Es_v := BCpx_g[2]{Positions(List(BCpx_g[2],e->OrderCovec(v,e)),true)};
        Corners_v := Positions(List(Corners,c->c[2]=v),true);
        mv:=Length(Positions(v,0));;
        V_v:=[1..Length(Es_v)];
        E_v:=[];;
        for e in Combinations(V_v,2) do
            for c in Corners_v do
                corner := Corners[c];;
                e1:=Es_v[e[1]];
                e2:=Es_v[e[2]];;
                if OrderCovec(e1,corner[1]) and OrderCovec(e2,corner[1]) then
                    Add(E_v,e);;
                fi;;
            od;;
        od;;
        G_v:=SimpGraphFromEdgeSet(E_v);;

        ECsG_v:=function(e) 
        local e1,e2,corner;;
            e1:=Es_v[e[1]];
            e2:=Es_v[e[2]];;
            for c in Corners_v do
                corner := Corners[c];;
                if OrderCovec(e1,corner[1]) and OrderCovec(e2,corner[1]) then
                    return c;;
                fi;
            od;;
            return fail;;
        end;;

        for eqv in MinFullCircuits_v(G_v,ECsG_v,mv,AnzCorners) do
            InEqualities := Concatenation(InEqualities,[eqv[1]]);;
            b := Concatenation(b,[eqv[2]]);;
            # Print(eqv,"\n");;
        od;;
    od;;

    for f in BCpx_g[1] do
        eqv:=0*[1..Length(Corners)];;
        Corners_f := Positions(List(Corners,c->c[1]=f),true);;
        eqv{Corners_f}:=List(Corners_f,x->1);;
        InEqualities := Concatenation(InEqualities,[eqv]);;
        b := Concatenation(b,[Length(Positions(List(BCpx_g[2],e->OrderCovec(e,f)),true))-2]);;
        # Add(b,Length(Positions(List(BCpx_g[2],e->OrderCovec(e,f)),true))-2);;
    od;;
    # PrintArray(InEqualities);;
    # Print("\n",b,"\n");;

    At:=TransposedMat(Concatenation([b],TransposedMat(-InEqualities)));;
    At:=Concatenation(At,IdentityMat(Length(Corners)+1){[2..Length(Corners)+1]});;
    PInEq := Cdd_PolyhedronByInequalities(At);;

    # return Cdd_InteriorPoint(P);;


    lp := Cdd_LinearProgram(PInEq,"max",List([1..Length(Corners)+1],x->1));;

    SolveLP := Cdd_SolveLinearProgram(lp);;
    if SolveLP<>fail then
        # for i in [1..Length(Corners)] do
        #     c:=DisplayCorners[i];;
        # # c in DisplayCorners do
        #     Print(i,": ", SolveLP[1][i],"  ", c,"\\newline\n");;
        # od;;

        # return List([1..Length(Corners)],i->[i,SolveLP[1][i],DisplayCorners[i]]);;
        return List([1..Length(Corners)],i->[SolveLP[1][i],Corners[i]]);;
    else
        return fail;;
    fi;;

    # return LPSimplexIsSolvable(InEqualities,b);;
    # return FourierMotzkinSolve(InEqualities,b);

    # At:=Concatenation(At,IdentityMat(Length(At[1])));;

    # return LPSimplex(At,List([1..Length(At)],x->0),List([1..Length(At[1])],x->1));;
    # return List([1..Length(At)],x->1) in ACsFromChiroA(Arr(At));;
    # return SimplexFeasible(InEqualities,b);;
end);


######################################
# Factored Arrangements
######################################

InstallGlobalFunction(PartsL2XsH,
function(L2,h,lred)
local L2XsH,ListParts,PP;
	L2XsH := List(L2{Positions(List(L2,x->h in x),true)},x->Difference(x,[h]));
	ListParts:=[];
	for PP in PartitionsSet(Set(L2XsH),lred) do
		Add(ListParts,List(PP,x->Union(x)));
	od;;
	# ListSubParts:=List(Cartesian(List([1..Length(L2XsH)],x->[1..lred])),c->List([1..Length(L2XsH)],i->OneBlockPart(L2XsH[i],c[i],lred)));;
	return ListParts;
end);

InstallGlobalFunction(FindAllL2Parts,
function(A)
local L2,n,h,Parts,SubParts,SubPart,P,lred,expA,expP;
	L2:=LkFlats(IntersectionLattice(A))(2);
	n:=Length(Roots(A));
	expA:=ExpArr(A);
	if expA=fail then
		return fail;
	fi;;
	lred := Length(expA)-1;
	Parts := [];;
	for h in [1..n] do
		for SubPart in PartsL2XsH(L2,h,lred) do
			P:=Concatenation([[h]],SubPart);
		# for SubParts in AllSubPartsL2XsH(L2,h,lred) do
		# 	P:=Concatenation([[h]],UnionOfSubParts(SubParts));;
			expP:=List(P,x->Length(x));
			Sort(expP);
			if expP=expA then
				Add(Parts,P);
			fi;
		od;
	od;

	return Parts;
end);

InstallGlobalFunction(SectionsPart,
function(Pr)
	return Cartesian(Pr);;
end);

InstallGlobalFunction(InducedPartLoc,
function(m,P)
	return Difference(List(P,B->IntersectionSet(B,m)),[[]]);
end);

InstallGlobalFunction(IsIndependentPart,
function(PH)
local S;
	for S in SectionsPart(PH) do
		if Rank(S)<>Length(S) then
			return false;;
		fi;;
	od;;
	return true;;
end);

InstallGlobalFunction(IsFactPart,
function(A,P)
local Pr,B,Hs,i,L,m;
	if not(1 in List(P,B->Length(B))) then
		return false;
	fi;
	
# 	Test independent condition
	Pr:=List(P,B->List(B,h->Roots(A)[h]));
	for Hs in SectionsPart(Pr) do
		if Rank(Hs)<>Length(Hs) then
#             Print(List(Hs,x->Positions(A.roots,x))," section not independent.\n");;
			return false;
		fi;;
	od;;
	
# 	Test singletion condition
	L:=LGroundSet(IntersectionLattice(A));;
	for m in Concatenation(L{[2..Length(L)-1]}) do
		if not(1 in List(InducedPartLoc(m,P),B->Length(B))) then
#             Print(m," violates singleton condition.\n");;
			return false;
		fi;;
	od;;
	return true;
end);

InstallMethod(HArrFactorizations,
    [IsHyperplaneArrangement],
function(A)
local n, expA,P,FPs;;
	expA := ExpArr(A);;
	if expA=fail then
		return false;
	fi;;
	
	n:=Length(Roots(A));;
	FPs:=[];;
	# return true in List(EnumeratePartitions([1..n],expA),P->IsFactPart(A,P));;
	for P in FindAllL2Parts(A) do
		if IsFactPart(A,P) then
			# return [P,true];
			Add(FPs,P);
		fi;
	od;

	return FPs;;
end);

InstallMethod(HArrIsFactored,
    [IsHyperplaneArrangement],
function(A)
local n, expA,P,FPs;;
	expA := ExpArr(A);;
	if expA=fail then
		return false;
	fi;;
	
	n:=Length(Roots(A));;
	FPs:=[];;
	# return true in List(EnumeratePartitions([1..n],expA),P->IsFactPart(A,P));;
	for P in FindAllL2Parts(A) do
		if IsFactPart(A,P) then
			return P;
		fi;
	od;

	return fail;;
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

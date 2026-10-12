#
# HypArr: Geometric lattices
#
# Implementations
# #


BindGlobal("GeomLatticeFamily",
    NewFamily("GeomLatticeFamily"));

# Implement the geometric lattice constructor

InstallMethod(GeomLattice,
    "for a list of lists of lists giving the ground set",
    [IsList],
function(gs)

    local Ls, k, type;

    if ForAny(gs, x -> not(IsList(x)) or ForAny(x, y -> not(IsList(y)))) then
        Print("Argument must be a list of lists of lists!\n");
        return fail;
    fi;

    # normalize the flats: each flat is a set of indices of atoms
    Ls := List(gs, Lk -> List(Lk, Set));

    if ForAny(Ls, Lk -> ForAny(Lk, m -> ForAny(m, e -> not(IsPosInt(e))))) then
        Print("The flats must be given by lists of positive integers!\n");
        return fail;
    fi;

    type := NewType(GeomLatticeFamily,
                    IsGeomLatticeRep);

    if Ls = [] then
        return Objectify(type,
            rec(
                grGroundSet := Ls,
                rank := 0,
                atoms := []
            )
        );
    fi;

    return Objectify(type,
        rec(
            grGroundSet := Ls,
            rank := Length(Ls),
            atoms := Set(Concatenation(Ls[1]))
        )
    );
end);

# InstallMethod(GeomLattice,
#     "for a list of circuits",s
#     [IsList, IsString],
# function(gs, c)

#     local Ls, k, type;

#     if ForAny(gs, x -> not(IsList(x)) and c="circ" then
#         Print("Arguments must be a list of list and a String!\n");
#         return fail;
#     fi;
    
#     # add here the code to compute the flats from the list of circuits

#     type := NewType(GeomLatticeFamily,
#                     IsGeomLatticeRep);

#     if Ls = [] then
#         return Objectify(type,
#             rec(
#                 grGroundSet := Ls,
#                 rank := 0,
#                 atoms := []
#             )
#         );
#     fi;

#     return Objectify(type,
#         rec(
#             grGroundSet := Ls,
#             rank := Length(Ls),
#             atoms := Set(Concatenation(Ls[1]))
#         )
#     );
# end);

InstallMethod(GeomLattice,
    "for a list of circuits, number of atoms and string",
    [IsList, IsInt, IsString],
function(circs, n, c)

    local circuits, E, closure, Ls, current, next, F, e, L;

    if c <> "circ" or not IsDenseList(circs)
       or ForAny( circs, C -> not IsDenseList(C)) then
        Print("Expected a list of circuits and the string \"circ\"!\n");
        return fail;
    fi;

    if ForAny(circs, C -> ForAny(C, x -> not IsPosInt(x))) then
        Print("Circuits must be lists of positive integers!\n");
        return fail;
    fi;

    circuits := Set(List(circs, Set));

    E := [1..n];

    # cl(S) = S union {e : some circuit C satisfies C \ S = {e}}.
    # With the complete circuit list, one pass suffices.
    closure := function(S)
        local T, C, missing;
        T := ShallowCopy(S);
        for C in circuits do
            missing := Difference(C, S);
            if Length(missing) = 1 then
                AddSet(T, missing[1]);
            fi;
        od;
        return T;
    end;

    # Starting at the bottom flat, generate successive rank levels.
    # For a flat F and e outside F, cl(F union {e}) covers F.
    Ls := [];
    current := [ [] ];

    while current <> [E] do
        next := [];
        for F in current do
            for e in Difference(E, F) do
                AddSet(next, closure(Union(F, [e])));
            od;
        od;
        Add(Ls, next);
        current := next;
    od;

    L:= GeomLattice(Ls);
    SetLCircuits(L,circuits);
    return L;
end);

InstallMethod(GeomLattice,
    "for a list of bases",
    [IsList, IsString],
function(bs, c)

    local bases, E, r, closure, Ls, current, next, F, e, L;

    if c <> "bases" then
        TryNextMethod();
    fi;

    if not IsDenseList(bs)
       or ForAny(bs, B -> not IsDenseList(B)) then
        Print("Bases must be given as a list of lists!\n");
        return fail;
    fi;

    if bs = [] then
        Print("The list of bases must be nonempty!\n");
        return fail;
    fi;

    if ForAny(bs, B -> ForAny(B, x -> not IsPosInt(x))) then
        Print("Bases must be lists of positive integers!\n");
        return fail;
    fi;

    bases := Set(List(bs, Set));
    r := Length(bases[1]);

    if ForAny(bases, B -> Length(B) <> r) then
        Print("All bases must have the same cardinality!\n");
        return fail;
    fi;

    E := Set(Concatenation(bases));

    # r(S) = Maximum(List(bases, B -> Length(Intersection(B,S)))).
    #
    # For e outside S, adjoining e increases the rank precisely when
    # some basis attaining this maximum contains e.
    closure := function(S)
        local sizes, rS, outside, i;

        sizes := List(bases, B -> Length(Intersection(B, S)));
        rS := Maximum(sizes);

        outside := [];
        for i in [1..Length(bases)] do
            if sizes[i] = rS then
                UniteSet(outside, Difference(bases[i], S));
            fi;
        od;

        return Difference(E, outside);
    end;

    # The existing representation treats element labels as atoms.
    if ForAny(E, e -> closure([e]) <> [e]) then
        Print("Expected bases of a simple matroid: ",
              "parallel elements are not supported!\n");
        return fail;
    fi;

    # Generate flats by rank, omitting the bottom flat.
    Ls := [];
    current := [ [] ];

    while current <> [E] do
        next := [];
        for F in current do
            for e in Difference(E, F) do
                AddSet(next, closure(Union(F, [e])));
            od;
        od;
        Add(Ls, next);
        current := next;
    od;

    L:= GeomLattice(Ls);
    SetLBases(L,bases);
    return L;
end);


InstallMethod(ViewObj,
    "for geometric lattices",
    [IsGeomLattice],
function(L)
    Print("<Geometric lattice: ",
          Length(LAtoms(L)), " atoms, rank ",
          LRank(L), ">");
end);

InstallMethod(PrintObj,
    "for geometric lattices",
    [IsGeomLattice],
function(L)
local k;
    # Print("Geometric lattice\n",
    Print("[ ",LkFlats(L)(1),",\n");
    for k in [2..LRank(L)-1] do
        Print("  ",LkFlats(L)(k),",\n");
    od;
    Print("  ",LkFlats(L)(LRank(L))," ]");
end);


# Some basic attributes of geometric lattices

InstallMethod(LGroundSet,
    [IsGeomLattice],
    L -> L!.grGroundSet);

InstallMethod(LAtoms,
    [IsGeomLattice],
    L -> L!.atoms);

InstallMethod(LRank,
    [IsGeomLattice],
    L -> L!.rank);

InstallMethod(LkFlats,
    [IsGeomLattice],
function(L)
local kFlatsFct, gset;
	gset := LGroundSet(L);
	kFlatsFct := function(k)
		return gset[k];
	end;
	return kFlatsFct;
end);

InstallMethod(LRankFunction,
	[IsGeomLattice],
function(L)
local RkFct;
    RkFct := function(m)
    local r;
        if m=[] then return 0; fi;
        for r in [1..LRank(L)] do
            if true in List(LkFlats(L)(r),x->IsSubset(x,m)) then
                return r;
            fi;
        od;
        return fail;
    end;
    return RkFct;
end);


InstallMethod(LBsOfFlat,
    [ IsGeomLattice, IsList ],
function(L,m)
local Bs, B,e,r,rkL;
    rkL:=LRankFunction(L);
    r:=rkL(m);
    Bs:=Combinations(m,r);
    Bs:=Bs{Positions(List(Bs,B->rkL(B)=r),true)};;
    return Bs;
end);

InstallMethod(LBaseCircuit,
    [IsGeomLattice,IsList,IsInt],
function(L,B,e)
local i,ig,ct,ctn,rkL;
    rkL:=LRankFunction(L);
    ct:=Union(B,[e]);
    for i in [1..Length(B)-1] do
        ig:=Position(List(B,g->rkL(Difference(ct,[g]))<rkL(ct)),true);
        # Print(ct," ",ig,"\n");
        if ig<>fail then
            ct:=Difference(ct,B{[ig]});
        else
            return ct;
        fi;
    od;
end);

InstallMethod(LCircuits,
    [IsGeomLattice],
function(L)
local rkL, Circs, Bs, B, e, c;
    rkL:=LRankFunction(L);
    Circs := [];
    Bs := LBases(L);
    for B in Bs do
        for e in Difference(LAtoms(L),B) do
            c:=LBaseCircuit(L,B,e);
            if not(c in Circs) then
                Add(Circs,c);
            fi;;
        od;
    od;
    return Circs;
end);

InstallMethod(LGraph,
    [IsGeomLattice],
function(L)
local GSet,B,n,G,i,j,k,GraphMat,GraphL,x,y;
    GSet := LGroundSet(L);
    B:=Concatenation(GSet);
	n:=Concatenation([0],List([1..Length(GSet)],y->Sum(List(GSet{[1..y]},x->Length(x)))));
	GraphMat:=NullMat(n[Length(GSet)+1],n[Length(GSet)+1])	;
	for i in [1..(Length(GSet)-1)] do
		for j in [(n[i]+1)..n[i+1]] do
			for k in [(n[i+1]+1)..n[i+2]] do
				if IsSubset(B[k],B[j]) then
				    GraphMat[j][k]:=1;
				    GraphMat[k][j]:=1;
				fi;
		    	od;
		od;
	od;

	GraphL := Graph(Group( () ), [1..n[Length(GSet)+1]], OnPoints,function(x,y) return GraphMat[x][y]=1; end, true);

	return GraphL;
end);

InstallMethod(LAutGroup,
    [IsGeomLattice],
function(L)
local G,GraphL,GSet,n, cCls;
    GSet := LGroundSet(L);
	n:=Concatenation([0],List([1..Length(GSet)],y->Sum(List(GSet{[1..y]},x->Length(x)))));
	cCls := List([1..Length(GSet)],i->[n[i]+1..n[i+1]]);
    GraphL:=ShallowCopy(LGraph(L));
	G := AutGroupGraph(GraphL,cCls);
	G := Image(ActionHomomorphism(G,LAtoms(L)));
	return G;
end);


InstallMethod(LBases,
    [IsGeomLattice],
function(L)
local rkFkt, atoms, Bs, rL;
    rkFkt := LRankFunction(L);
    rL := LRank(L);
    atoms := LAtoms(L);
    Bs := Combinations(atoms,rL);
    Bs := Bs{Positions(List(Bs,B->rkFkt(B)=rL),true)};
    return Bs;
end);

InstallMethod( LMSetInv,
    [ IsGeomLattice ] ,
function(L)
    local Ls,I,i;

    Ls:=LGroundSet(L);
	I:=[];
	for i in [1..Length(Ls)] do
		Add(I,List(Set(List(Ls[i],x->Length(x))),x->[x,Length(Positions(List(Ls[i],x->Length(x)),x))]));
	od;
	return I;
end);

####################################################################################################
## The Moebius-Function for a Lattice L of the Arrangement A
####################################################################################################

InstallMethod(LMoebius,
    [IsGeomLattice],
function(L)
 	return function(m,i)
		local m2,j,I, gset;
			gset := LGroundSet(L);
			if not m in gset[i] then
				return fail;
			fi;
			if i=0 then
				return 1;
			fi;
			if i=1 then
				return -1;
			fi;
			I:=[];
			for j in Reversed([1..i-1]) do
				for m2 in gset[j] do
					if IsSubset(m,m2) then
						Add(I,[m2,j]);
					fi;
				od;
			od;
			return -1-Sum(List(I,x->LMoebius(L)(x[1],x[2])));
		end;
end);

####################################################################################################
## Direkt Computation of the Characteristic Polynomial
## of a Lattice L

InstallMethod(LCharPoly,
	[IsGeomLattice],
function(L)
local m,g,t,i,j,gset;
	if IsBound(L!.charpoly) then
		return L!.charpoly;
	fi;
	gset := LGroundSet(L);
	t:=X(Rationals,"t");
	m:=LMoebius(L);
	g:=t^(Length(gset));
	for i in [1..Length(gset)] do
		for j in [1..Length(gset[i])] do
			g:=g+t^(Length(gset)-i)*m(gset[i][j],i);
		od;
	od;
	L!.charpoly := g;
	return L!.charpoly;
end);

InstallMethod(LIsIrreducible,
    [IsGeomLattice],
function(L)
local f,t;
	f :=LCharPoly(L);
	t := IndeterminateOfUnivariateRationalFunction(f);
	if f mod (t-1)^2 = 0*t then
		return false;
	fi;
    return true;
end);

InstallMethod(LIsBoolean,
    [IsGeomLattice],
function(L)
	return Length(LAtoms(L))=LRank(L);
end);

InstallMethod(LIsGeneric,
    [IsGeomLattice],
function(L)
local r, Lk, rfct;
	if not(LIsIrreducible(L)) then
		return false;
	fi;
	r := LRank(L);
	Lk := LkFlats(L)(r-1);
	rfct := LRankFunction(L);
	if ForAny(Lk,m->Length(m)<>rfct(m)) then
		return false;
	fi;
	return true;
end);

InstallMethod(LHasGenericAtom,
    [IsGeomLattice],
function(L)
local r, Lk, Lka, rfct, a;
	r := LRank(L);
	Lk := LkFlats(L)(r-1);
	rfct := LRankFunction(L);
	for a in LAtoms(L) do
        Lka := Filtered(Lk,m->a in m);
        if ForAll(Lka,m->Length(m)=rfct(m)) then
            return true;
        fi;
	od;
	return false;
end);



####################################################################################################
InstallMethod(LLocalizationRk,
	[IsGeomLattice, IsList, IsInt],
function(L,mX,k)
local gset, type, gsetLocX, Fi;
	gset:=LGroundSet(L);
	if not(mX in LkFlats(L)(k)) then
		return fail;
	fi;
	gsetLocX := List([1..k-1],
		i->gset[i]{Positions(List(gset[i],x->IsSubset(mX,x)),true)});
	gsetLocX := Concatenation(gsetLocX,[[mX]]);

	type := NewType(GeomLatticeFamily,
                    IsGeomLatticeRep);

    return Objectify(type,
        rec(
            grGroundSet := gsetLocX,
			rank := Length(gsetLocX),
			atoms := Concatenation(gsetLocX[1])
        )
    );

end);



InstallGlobalFunction(LDelH,
function(L,h)
local Ls,LDel, LDels,g, LPerm, n, k, Lk, Xk, XkDel, rkFkt, type;
    Ls:=LGroundSet(L);
    n := Length(Ls[1]);
    if h = n then
        g:=(1);
    else
        g := Product(List([h+1..n],x->(x,x-1)));
    fi;;
    LPerm := List(Ls,Lk->List(Lk,x->List(x,y->y^g)));
    LDels:=[];
    rkFkt := S->LRankFunction(L)(List(S,x->x^(g^(-1))));
    for k in [1..Length(LPerm)] do
        Lk:=[];
        for Xk in LPerm[k] do
            XkDel := Difference(Xk,[n]);
            if rkFkt(XkDel)=rkFkt(Xk) then
                Add(Lk,Set(XkDel));
            fi;;
        od;;
        if Lk<>[] then
            Add(LDels,Set(Lk));
        fi;;
    od;;

    type := NewType(GeomLatticeFamily,
                    IsGeomLatticeRep);
    LDel:= Objectify(type,
        rec(
            grGroundSet := LDels,
            rank := Length(LDels),
            atoms := Concatenation(LDels[1])
        )
    );
    
    return LDel;
end);


####################################################################################################

InstallMethod(LIsIsomorphic,
	[IsGeomLattice, IsGeomLattice],
function(LA,LB)
local LGraphA,LGraphB,
    GSetA,nA, cClsA,
    GSetB, nB, cClsB;
    GSetA := LGroundSet(LA);
	nA:=Concatenation([0],List([1..Length(GSetA)],y->Sum(List(GSetA{[1..y]},x->Length(x)))));
	cClsA := List([1..Length(GSetA)],i->[nA[i]+1..nA[i+1]]);;
    GSetB := LGroundSet(LB);
	nB:=Concatenation([0],List([1..Length(GSetB)],y->Sum(List(GSetB{[1..y]},x->Length(x)))));
	cClsB := List([1..Length(GSetB)],i->[nB[i]+1..nB[i+1]]);;
    LGraphA := ShallowCopy(LGraph(LA));
    LGraphB := ShallowCopy(LGraph(LB));
    return IsIsomorphicGraph(rec(graph:=LGraphA,colourClasses:=cClsA) ,rec(graph:=LGraphB,colourClasses:=cClsB));
end);

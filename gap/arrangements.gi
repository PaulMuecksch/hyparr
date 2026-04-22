#
# HypArr: Computations with hyperplane arrangements
#
# Implementations
# #


BindGlobal("HyperplaneArrangementFamily",
    NewFamily("HyperplaneArrangementFamily"));

BindGlobal("GeomLatticeFamily",
    NewFamily("GeomLatticeFamily"));

# test if the linear forms given by l are pairwise linear independent
# if not return a pw linear ind. subset of l

InstallGlobalFunction(HypArr_PWLinInd,
function(ll)
local test,l2,i,j,k,l,d;
    l:=ShallowCopy(ll);
    k:=0;
	if IsBound(ll[1]) then
		d:=Length(ll[1]);
	else
		d:=0;
	fi;

    for i in [1..Length(ll)] do
        if Rank(ll{[i]})=0 then
            Remove(l,i+k);
            k:=k-1;
        fi;
    od;

    if l=[] then
		# l:=[0*[1..d]];
        return l;
    fi;

#     for
	for i in [1..Length(l)] do
		test:=true;
		k:=0;
		l2:=ShallowCopy(l);
		for j in [(i+1)..Length(l)] do
			if Rank(l{[i,j]})=1 then
# 				Print(j);
				Remove(l2,j+k);
				k:=k-1;
				test:=false;
			fi;
		od;
		if not(test) then
			return HypArr_PWLinInd(l2);
		fi;
	od;

	if test then
		return l;
	fi;
end);

# Implement the hyperplane arrangement constructor

InstallMethod(HyperplaneArrangement,
    "for list of linear forms",
    [IsList],
function(r)

    local dim, l, type, F;

    if r = [] then
        dim := 0;
        l := [];
		F := "not determined";
    else
        dim := Length(r[1]);
		F:=DefaultField(Concatenation(r));
        l := HypArr_PWLinInd(r);
    fi;

    type := NewType(HyperplaneArrangementFamily,
                    IsHyperplaneArrangementRep);

    return Objectify(type,
        rec(
            roots := l,
            dimension := dim,
			deffield := F
        )
    );
end);

InstallMethod(ViewObj,
    [IsHyperplaneArrangement],
function(A)
    Print("<HyperplaneArrangement: ",
          Length(Roots(A)), " hyperplanes in ",
          Dimension(A), "-space>");
end);

InstallMethod(ViewObj,
    [IsGeomLattice],
function(L)
    Print("<Geometric lattice: ",
          Length(LAtoms(L)), " atoms, rank ",
          LRank(L), ">");
end);


# Some basic attributes of hyperplane arrangements

InstallMethod(Roots,
    [IsHyperplaneArrangement],
    A -> A!.roots);

InstallMethod(Dimension,
    [IsHyperplaneArrangement],
    A -> A!.dimension);

InstallMethod(HArrDefField,
    [IsHyperplaneArrangement],
    A -> A!.deffield);

InstallMethod(IsReal,
    [IsHyperplaneArrangement],
    A -> not(ForAny(Roots(A),r->ForAny(r,x->x<>cj(x)))) );


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
				    # GraphMat[k][j]:=1;
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
local G,GraphL;
	GraphL:=ShallowCopy(LGraph(L));
	G := AutGroupGraph(GraphL);
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
    Bs := Combinations(atoms,rL);;
    Bs := Bs{Positions(List(Bs,B->rkFkt(B)=rL),true)};;
    return Bs;;
end);


#####################################################################
# HypArr_AddHToL(R, Lo, Hn)
#
# Adds a new hyperplane Hn to an already constructed intersection
# lattice Lo of a hyperplane arrangement whose defining linear forms
# are stored in R.
#
# Parameters:
#   R  - list of linear forms (hyperplanes) that are already processed
#   Lo - current intersection lattice (organized by levels)
#   Hn - the new hyperplane to add
#
# Representation of the lattice:
#   Each element in the lattice is stored as a list of indices referring
#   to hyperplanes whose intersection defines that subspace.
#
#   Lo[k] contains all intersections of codimension k-1 (or equivalently
#   intersections of k-1 hyperplanes).
#
# The function updates the lattice when a new hyperplane is added.
#####################################################################

InstallGlobalFunction(HypArr_AddHToL,
function(R,Lo,Hn)

    local Ln, m, k, i, n, r;

    # ------------------------------------------------------------
    # If the new hyperplane Hn is linearly dependent with an
    # existing hyperplane in R (i.e. defines the same hyperplane),
    # we do not change the lattice.
    # ------------------------------------------------------------
    if ForAny(R, x -> Rank([x,Hn]) = 1) then
        return Lo;
    fi;

    # ------------------------------------------------------------
    # If the lattice is empty, this is the first hyperplane.
    # The lattice consists only of the hyperplane itself.
    # ------------------------------------------------------------
    if Lo=[] then
        return [[[1]]];
    fi;

    # Make a copy of the lattice that we will modify
    Ln:=List(Lo, x -> List(x, ShallowCopy));

    # n = number of hyperplanes already present
    n := Length(Lo[1]);

    # r = number of levels in the lattice
    r := Length(Lo);

    # ------------------------------------------------------------
    # Iterate through all existing lattice elements
    # ------------------------------------------------------------
    for k in [1..r] do
        for i in [1..Length(Lo[k])] do

            # m represents the set of hyperplanes defining
            # a particular intersection
            m := ShallowCopy(Lo[k][i]);

            # ----------------------------------------------------
            # Check if the intersection defined by m is already
            # contained in Hn.
            #
            # If adding Hn does not increase the rank, then the
            # intersection lies inside Hn and we simply append
            # the new hyperplane index.
            # ----------------------------------------------------
            if Rank(R{m}) = Rank(Concatenation(R{m},[Hn])) then

                Add(Ln[k][i],n+1);

            else

                # ------------------------------------------------
                # Otherwise the intersection with Hn creates a
                # new lattice element of higher codimension.
                # ------------------------------------------------
                if k<r then

                    # Check whether such an element already exists
                    if not( true in List(Lo[k+1],
                        x->IsSubset(x,m) and
                        Rank(R{x}) = Rank(Concatenation(R{x},[Hn])) ) ) then

                        Add(Ln[k+1],Concatenation(m,[n+1]));
                    fi;

                elif k=r then

                    # If we are at the top level, create a new level
                    Add(Ln,[Concatenation(m,[n+1])]);

                fi;
            fi;
        od;
    od;

    # ------------------------------------------------------------
    # Add the new hyperplane itself as a rank-1 element
    # ------------------------------------------------------------
    Add(Ln[1],[n+1]);

    return Ln;
end);


#####################################################################

InstallMethod(IntersectionLattice,
    [IsHyperplaneArrangement],
function(A)

    local R, Rt, r, Ls, type;

    # R  = list of defining linear forms (roots) of the arrangement
    R := ShallowCopy(Roots(A));

    # Ls = current intersection lattice
    Ls := [];

    # Rt = hyperplanes already processed
    Rt := [];

    # ------------------------------------------------------------
    # Add hyperplanes one by one and update the lattice
    # ------------------------------------------------------------
    for r in R do
        Ls := HypArr_AddHToL(Rt, Ls, r);
        Add(Rt, r);
    od;

	type := NewType(GeomLatticeFamily,
                    IsGeomLatticeRep);

    return Objectify(type,
        rec(
            grGroundSet := Ls,
			rank := Length(Ls),
			atoms := Concatenation(Ls[1])
        )
    );

end);

InstallMethod( MSetInvL,
    [ IsHyperplaneArrangement ] ,
function(A)
    local L,I,i;

    if HasMSetInvL(A) then
        return A!.MSetInvL;
    fi;

    L:=LGroundSet(IntersectionLattice(A));
	I:=[];
	for i in [1..Length(L)] do
		Add(I,List(Set(List(L[i],x->Length(x))),x->[x,Length(Positions(List(L[i],x->Length(x)),x))]));
	od;
	return I;
end);

#####################################################################

InstallMethod( CharPoly,
    [ IsHyperplaneArrangement ],
function(A)
    local dim,t,r,q,v,rn,An,AA,x,z,ns;

	r:=ShallowCopy(Roots(A));
	q:=Size(r);
	dim:=Dimension(A);

	t:=X(Rationals,"t");

	if dim=0 then
		return 0*t;
	elif q=2 then
		return t^dim-2*t^(dim-1)+t^(dim-2);
	elif q=1 then
		return t^dim-t^(dim-1);
	else
		AA := HyperplaneArrangement(r{[2..q]});
		An := HArrRestriction(A,1);
	    return CharPoly(AA) - CharPoly(An);
    fi;
end);

## Factorization of an rational Polynomial

BindGlobal("facQ",
function(g)
	return Reversed(Factors(PolynomialRing(Rationals,"t"),g));
end);

InstallMethod(ExpArr,
	[ IsHyperplaneArrangement ],
function(A)
local expA;
	if IsBound(A!.exp) then
		return A!.exp;
	fi;
    expA:=List(facQ(CharPoly(A)),x->-Value(x,0));
    if Length(expA)<>Dimension(A) then
        return fail;
    fi;
    return expA;
end);


InstallMethod(HArrIsIrreducible,
    [IsHyperplaneArrangement],
function(A)
local f,t;
	f :=CharPoly(A);
	t := IndeterminateOfUnivariateRationalFunction(f);
	if f mod t = 0*t or f mod (t-1)^2 = 0*t then
		return false;
	fi;
    return true;
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


InstallMethod(HArrIsGeneric,
    [IsHyperplaneArrangement],
function(A)
	return LIsGeneric(IntersectionLattice(A));
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

####################################################################################################
# Global auxillary functions
####################################################################################################

InstallGlobalFunction( HArrResHvec,
function(A,h)
local k,Am,T,i,z, type, dim;

    # If h is the zero vector, return the arrangement unchanged
    if Rank([h])=0 then
        return A;
    fi;

    # Dimension of the ambient space
    k:=Length(h);

    # Generator of the underlying field
    z:=GeneratorsOfField(Field(h))[1];

    # Start with the identity transformation matrix
    T:=z*IdentityMat(k);

    # Find the first nonzero entry of h
    i:=Minimum(Positions(List(h,x->x<>0*z),true));

    # Replace the i-th row with h
    T[i]:=h;

    # Invert the transformation matrix
    T:=T^(-1);

    # Copy the defining linear forms of A
    Am:=ShallowCopy(Roots(A));

    # Apply the coordinate transformation
    Am:=Am*T;

    # Remove the i-th coordinate to obtain the restriction
    Am:=List(Am,x->Concatenation(x{[1..(i-1)]},x{[(i+1)..Dimension(A)]}));

	dim := Rank(Am);

    # Return the restricted hyperplane arrangement
	# type := NewType(HyperplaneArrangementFamily,
    #                 IsHyperplaneArrangementRep);

    # return Objectify(type,
    #     rec(
    #         roots := Am,
    #         dimension := ,
	# 		deffield := HArrDefField(A)
    #     )
    # );

    return HyperplaneArrangement(Am);
end);

InstallMethod( HArrRestriction,
	[IsHyperplaneArrangement, IsInt],
function(A,k)
    # Restrict the arrangement A to the hyperplane indexed by k
    return HArrResHvec(A,Roots(A)[k]);
end);

InstallMethod( HArrRestriction,
	[IsHyperplaneArrangement, IsList],
function(A,S)
local An,Sn;
	# If S contains vectors defining hyperplanes
    if IsBound(S[1]) then

        # Restrict A to the first hyperplane in S
        An:=HArrResHvec(A,S[1]);

        # Compute the remaining restriction directions
        Sn:=Roots(HArrResHvec(HyperplaneArrangement(S),S[1]));

		if Sn<>[] then
        # Continue restricting recursively
	        return HyperplaneArrangement(Roots(HArrRestriction(An,Sn)));
		else
			return An;
		fi;

    else

        # If no restriction is specified, return A unchanged
        return HyperplaneArrangement(Roots(A));

    fi;
end);


####################################################################################################

InstallMethod(Essentialization,
[IsHyperplaneArrangement],
function(A)
local C;

    # Compute the nullspace of the transpose of the defining matrix
	C:=NullspaceMat(TransposedMat(Roots(A)));

    # If the nullspace is nontrivial, restrict the arrangement
	if C<>[] then
		return HArrRestriction(A,C);
	else
        # Otherwise the arrangement is already essential
		return A;
	fi;

end);

####################################################################################################

InstallMethod(LIsIsomorphic,
	[IsGeomLattice, IsGeomLattice],
function(LA,LB)
local LGraphA,LGraphB;
    LGraphA := ShallowCopy(LGraph(LA));
    LGraphB := ShallowCopy(LGraph(LB));
    return IsIsomorphicGraph(LGraphA,LGraphB);
end);

InstallMethod(IsLEquiv,
	[IsHyperplaneArrangement, IsHyperplaneArrangement],
function(A,B)
	return LIsIsomorphic(IntersectionLattice(A),IntersectionLattice(B));
# local LGraphA,LGraphB;
#     LGraphA := ShallowCopy(LGraph(IntersectionLattice(A)));
#     LGraphB := ShallowCopy(LGraph(IntersectionLattice(B)));
#     return IsIsomorphicGraph(LGraphA,LGraphB);
end);



############################################################
## the wedge-product
############################################################

## the wedge-product for two 3-dim vectors v,w

InstallGlobalFunction(HypArr_wg3,function(v,w)
	return [	v[2]*w[3]-v[3]*w[2],
				v[3]*w[1]-v[1]*w[3],
				v[1]*w[2]-v[2]*w[1]
			];
end);

## the wedge-product of (l-1) l-dim vectors given by a matrix m

InstallGlobalFunction(HypArr_wg,function(m)
local dim,x,y;

	dim := Length(m[1]);
	if dim=3 and Length(m)=2 then
		return HypArr_wg3(m[1],m[2]);
	#elif Length(m)<>dim-1 then
	#	return fail;
	fi;

	return List([1..dim],x->(-1)^(x+1)*Determinant(List(m,y->y{Concatenation([1..(x-1)],[(x+1)..dim])})));

end);



## the complex conjugation
InstallGlobalFunction(cj,
function(x)
	return ComplexConjugate(x);
end);

#####################################################################################
## Timer
#####################################################################################

InstallGlobalFunction(tnow,function()
    return Runtimes().user_time;
end);

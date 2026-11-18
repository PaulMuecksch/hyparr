#
# HypArr: Arrangements
#
# Implementations
# #


BindGlobal("HyperplaneArrangementFamily",
    NewFamily("HyperplaneArrangementFamily"));


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
    "for hyperplane arrangements",
    [IsHyperplaneArrangement],
function(A)
    Print("<HyperplaneArrangement: ",
          Length(Roots(A)), " hyperplanes in ",
          Dimension(A), "-space>");
end);

InstallMethod(PrintObj,
    "for hyperplane arrangements",
    [IsHyperplaneArrangement],
function(A)
    Print("HyperplaneArrangement defined by\n");
    PrintArray(Roots(A));
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


InstallMethod(IsRank3,
    [IsHyperplaneArrangement],
    A -> Rank(Roots(A))=3 and Dimension(A)=3);



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
# function(R,Lo,Hn)
function(R,Lo,LinSpaces,Hn)

    local lspaces,Ln, m, ms, k, i, n, r;

    # ------------------------------------------------------------
    # If the new hyperplane Hn is linearly dependent with an
    # existing hyperplane in R (i.e. defines the same hyperplane),
    # we do not change the lattice.
    # ------------------------------------------------------------
    if ForAny(R, x -> Rank([x,Hn]) = 1) then
        return rec(lattice:=Lo,spaces := LinSpaces);
    fi;

    # ------------------------------------------------------------
    # If the lattice is empty, this is the first hyperplane.
    # The lattice consists only of the hyperplane itself.
    # ------------------------------------------------------------
    if Lo=[] then
        AddDictionary(LinSpaces,[1],NullspaceMat(TransposedMat([Hn])));
        return rec(lattice:=[[[1]]], spaces := LinSpaces);
        # return [[[1]]];
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

            ms := LookupDictionary(LinSpaces,m);

            # ----------------------------------------------------
            # Check if the intersection defined by m is already
            # contained in Hn.
            #
            # If adding Hn does not increase the rank, then the
            # intersection lies inside Hn and we simply append
            # the new hyperplane index.
            # ----------------------------------------------------
            if Rank(R{m}) = Rank(Concatenation(R{m},[Hn])) then
            # if ms*Hn = List([1..r-k],x->0) then
                Add(Ln[k][i],n+1);
                AddDictionary(LinSpaces,Ln[k][i],ms);
            else

                # ------------------------------------------------
                # Otherwise the intersection with Hn creates a
                # new lattice element of higher codimension.
                # ------------------------------------------------
                if k<r then

                    # Check whether such an element already exists
                    if not( true in List(Lo[k+1],
                        x->IsSubset(x,m) and
                        # LookupDictionary(LinSpace,x)*Hn = List([1..r-k-1],x->0)
                        Rank(R{x}) = Rank(Concatenation(R{x},[Hn])) ) ) then
                        ms := NullspaceMat(TransposedMat(Concatenation(R{m},[Hn])));
                        if ms = [] then
                            ms := [0*Hn];
                        fi; 
                        AddDictionary(LinSpaces,Concatenation(m,[n+1]),ms);
                        Add(Ln[k+1],Concatenation(m,[n+1]));
                    fi;

                elif k=r then

                    # If we are at the top level, create a new level
                    Add(Ln,[Concatenation(m,[n+1])]);
                    ms := NullspaceMat(TransposedMat(Concatenation(R{m},[Hn])));
                    if ms = [] then
                        ms := [0*Hn];
                    fi;
                    AddDictionary(LinSpaces,Concatenation(m,[n+1]),ms);

                fi;
            fi;
        od;
    od;

    # ------------------------------------------------------------
    # Add the new hyperplane itself as a rank-1 element
    # ------------------------------------------------------------
    Add(Ln[1],[n+1]);
    AddDictionary(LinSpaces,[n+1],NullspaceMat(TransposedMat([Hn])));

    return rec(lattice:=Ln,spaces := LinSpaces);
end);


#####################################################################

InstallMethod(IntersectionLattice,
    [IsHyperplaneArrangement],
function(A)
    local R, Rt, r, Lrec, Ls, type, L, LSpaces;

    if IsBound(A!.lattice) then
        return A!.lattice;
    fi;

    # R  = list of defining linear forms (roots) of the arrangement
    R := ShallowCopy(Roots(A));

    # Ls = current intersection lattice
    Ls := [];
    LSpaces := NewDictionary([],true);

    # Rt = hyperplanes already processed
    Rt := [];

    # ------------------------------------------------------------
    # Add hyperplanes one by one and update the lattice
    # ------------------------------------------------------------
    for r in R do
        # Ls := HypArr_AddHToL(Rt, Ls, LSpaces, r);
        Lrec := HypArr_AddHToL(Rt, Ls,LSpaces, r);
        Ls := Lrec.lattice;
        LSpaces := Lrec.spaces;
        Add(Rt, r);
    od;

	type := NewType(GeomLatticeFamily,
                    IsGeomLatticeRep);

    L:= Objectify(type,
        rec(
            grGroundSet := Ls,
			rank := Length(Ls),
			atoms := Concatenation(Ls[1]),
            islinear := true,
            linspaces := LSpaces
        )
    );

    A!.lattice := L;
    return A!.lattice;

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
    local dim,t,r,q,v,rn,An,AA,x,z,ns, chi;


    if IsBound(A!.charpoly) then
        return A!.charpoly;
    fi;

	r:=ShallowCopy(Roots(A));
	q:=Size(r);
	dim:=Dimension(A);

	t:=X(Rationals,"t");

	if dim=0 then
        chi := 0*t;
	elif q=2 then
		chi:= t^dim-2*t^(dim-1)+t^(dim-2);
	elif q=1 then
		chi := t^dim-t^(dim-1);
	else
		AA := HyperplaneArrangement(r{[2..q]});
		An := HArrRestriction(A,1);
	    chi := CharPoly(AA) - CharPoly(An);
    fi;

    A!.charpoly:=chi;
    return A!.charpoly;
end);

## Factorization of a rational Polynomial

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
	f := CharPoly(A);
	t := IndeterminateOfUnivariateRationalFunction(f);
	if f mod t = 0*t or f mod (t-1)^2 = 0*t then
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

InstallMethod( HArrAddition,
	[IsHyperplaneArrangement, IsList],
function(A,h)
local LAA,AA,Lo,Ln, Lrec,L,type,Rt, CharPolyAA,LSpaces;
    if Length(h)<>Dimension(A) or ForAny(h,x->not(x in HArrDefField(A))) then
        Print("New hyperplane ",h," is not in the ambient space!\n");
        return fail;
    fi;

    if ForAny(Roots(A),r->Rank([r,h])=1) then
        Print("Hyperplane already in the arrangement!\n");
        return fail;
    fi;

    Rt:= Concatenation(Roots(A),[h]);
    AA := Arr(Rt);

    if Tester(IntersectionLattice)(A) then
        LAA:=IntersectionLattice(A); 
        Lo:=LGroundSet(LAA);
        LSpaces := ShallowCopy(LLinSpaces(LAA));
        Lrec := HypArr_AddHToL(Roots(A), Lo, LSpaces, h);
        Ln := Lrec.lattice;
        LSpaces := Lrec.spaces;
        type := NewType(GeomLatticeFamily,
                    IsGeomLatticeRep);
        L:= Objectify(type,
            rec(
                grGroundSet := Ln,
                rank := Length(Ln),
                atoms := Concatenation(Ln[1]),
                islinear := true,
                linspaces := LSpaces
            )
        );
        SetIntersectionLattice(AA,L);
        # AA!.lattice := L;
    fi;

    if Tester(CharPoly)(A) then
        CharPolyAA:= CharPoly(A) - CharPoly(HArrRestriction(AA,[h]));
        SetCharPoly(AA,CharPolyAA);
        # AA!.charpoly := CharPolyAA;
    fi;;

    return AA;
end);

InstallMethod( HArrDeletion,
	[IsHyperplaneArrangement, IsInt],
function(A,i)
local ADel, LDel, L, CharPolyADel;

    ADel := Arr(Roots(A){Concatenation([1..i-1],[i+1..Length(Roots(A))])});

    if Tester(IntersectionLattice)(A) then
        L:=IntersectionLattice(A);
        LDel := LDelH(L,i);
        SetIntersectionLattice(ADel,LDel);
        # ADel!.lattice := LDel;
    fi;


    if Tester(CharPoly)(A) then
        CharPolyADel:= CharPoly(A) + CharPoly(HArrRestriction(A,i));
        SetCharPoly(ADel,CharPolyADel);
        # ADel!.charpoly := CharPolyADel;;
    fi;;


    return ADel;
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

## Combinations of coatoms and lines giving new hyperplanes
InstallMethod(CandidatesLinesPointsNewH,
    [IsGeomLattice],
function(L)
local d, SpPs, Cs, c, Lts, Pts;
    d := LRank(L);
    Pts := ShallowCopy(LkFlats(L)(d-1)); 
    Lts := ShallowCopy(LkFlats(L)(2)); 
    SpPs :=[];
    # Cs:=Concatenation(List(ShallowCopy(Pts),x->List(ShallowCopy(Lts),y->[x,y])));
    Cs := Cartesian(Pts,Lts);
    for c in Cs do
        if Intersection(c)=[] then
            Add(SpPs,c);
        fi;
    od;
    
    return SpPs;
end);

InstallGlobalFunction(NewHsThroughIntersections,
function(A)
local L,Cs,NewHs;
    L := IntersectionLattice(A);
    Cs := Set(CandidatesLinesPointsNewH(L),x->Set(x,y->Set(y)));

    if Cs=[] then
        return fail;
    fi;
    
    # NewHs:= List(Cs, c-> NullspaceMat( TransposedMat(Concatenation(List(c,y->NullspaceMat(TransposedMat(Roots(A){y}))))))[1] );
    NewHs:= List(Cs, c-> NullspaceMat( TransposedMat(Concatenation(List(c,y->LookupDictionary(LLinSpaces(L),y) ))))[1] );
    return NewHs;
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

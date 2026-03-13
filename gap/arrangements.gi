#
# HypArr: Computations with hyperplane arrangements 
#
# Implementations
# #



# # generation of a hyperplane arrangement A given by a set of linear forms r

BindGlobal("HyperplaneArrangementFamily",
    NewFamily("HyperplaneArrangementFamily"));

# test if the linear forms given by l are pairwise linear independent
# if not return a pw linear ind. subset of l

InstallGlobalFunction(HypArr_PWLinInd,
function(ll)
local test,l2,i,j,k,l;
    l:=ShallowCopy(ll);;
    k:=0;;
    for i in [1..Length(ll)] do
        if Rank(ll{[i]})=0 then
            Remove(l,i+k);;
            k:=k-1;;
        fi;;
    od;;
    
    if l=[] then
        return l;;
    fi;;
    
#     for 
	for i in [1..Length(l)] do
		test:=true;
		k:=0;
		l2:=ShallowCopy(l);
		for j in [(i+1)..Length(l)] do
			if Rank(l{[i,j]})=1 then
# 				Print(j);;
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
################################################################################
##
##  <#GAPDoc Label="HyperplaneArrangement">
##  <ManSection>
##  <Func Name="HyperplaneArrangement" Arg="R"/>
##
##  <Returns> A hyperplane arrangement (as a record). </Returns>
##
##  <Description>
##
##  Defines the hyperplane arrangement from a list of vectors giving defining linear forms.
##  
##
##  </Description>
##  </ManSection>
##  <#/GAPDoc>

InstallMethod(HyperplaneArrangement,
    "for list of linear forms",
    [IsList],
function(r)

    local dim, l, type;

    if r = [] then
        dim := 0;
        l := [];
    else
        dim := Length(r[1]);
        l := HypArr_PWLinInd(r);
    fi;

    type := NewType(HyperplaneArrangementFamily,
                    IsHyperplaneArrangementRep);

    return Objectify(type,
        rec(
            roots := l,
            dimension := dim
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


# Some basic attributes of hyperplane arrangements

InstallMethod(Roots,
    [IsHyperplaneArrangement],
    A -> A!.roots);

InstallMethod(Dimension,
    [IsHyperplaneArrangement],
    A -> A!.dimension);

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
    fi;;

    # ------------------------------------------------------------
    # If the lattice is empty, this is the first hyperplane.
    # The lattice consists only of the hyperplane itself.
    # ------------------------------------------------------------
    if Lo=[] then
        return [[[1]]];;
    fi;;    

    # Make a copy of the lattice that we will modify
    Ln:=List(Lo, x -> List(x, ShallowCopy));;

    # n = number of hyperplanes already present
    n := Length(Lo[1]);;

    # r = number of levels in the lattice
    r := Length(Lo);;

    # ------------------------------------------------------------
    # Iterate through all existing lattice elements
    # ------------------------------------------------------------
    for k in [1..r] do
        for i in [1..Length(Lo[k])] do

            # m represents the set of hyperplanes defining
            # a particular intersection
            m := ShallowCopy(Lo[k][i]);;

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
                    Add(Ln,[Concatenation(m,[n+1])]);;

                fi;
            fi;;
        od;;
    od;;

    # ------------------------------------------------------------
    # Add the new hyperplane itself as a rank-1 element
    # ------------------------------------------------------------
    Add(Ln[1],[n+1]);;

    return Ln;;
end);;


#####################################################################
# IntersectionLattice(A)
#
# Computes the intersection lattice of a hyperplane arrangement A.
#
# The algorithm processes hyperplanes one by one and incrementally
# updates the lattice using HypArr_AddHToL.
#####################################################################

InstallMethod(IntersectionLattice,
    [IsHyperplaneArrangement],
function(A)

    local R, Rt, r, Ls;

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

    # The resulting lattice structure
    return Ls;

end);

## Multiset invariants of a Lattice L
InstallMethod(MSetInvL,
    [IsHyperplaneArrangement],
function(A)
    local L,I,i;
    
    if HasMSetInvL(A) then
        return A!.MSetInvL;
    fi;

    L:=IntersectionLattice(A);;
	I:=[];
	for i in [1..Length(L)] do
		Add(I,List(Set(List(L[i],x->Length(x))),x->[x,Length(Positions(List(L[i],x->Length(x)),x))]));
	od;
    # SetMSetInvL(A, I);
	return I;
end);

####################################################################################################
####################################################################################################

####################################################################################################
# Global auxillary functions
####################################################################################################

####################################################################################################
## The Restriction of an Arrangement A to
## the Hyperplane H_k or to X given by a list of vectors
####################################################################################################

InstallGlobalFunction( HArrResHvec,
function(A,h)
local k,Am,T,i,z;;

    # If h is the zero vector, return the arrangement unchanged
    if Rank([h])=0 then
        return A;
    fi;;

    # Dimension of the ambient space
    k:=Length(h);;

    # Generator of the underlying field
    z:=GeneratorsOfField(Field(h))[1];;

    # Start with the identity transformation matrix
    T:=z*IdentityMat(k);;

    # Find the first nonzero entry of h
    i:=Minimum(Positions(List(h,x->x<>0*z),true));;

    # Replace the i-th row with h
    T[i]:=h;;

    # Invert the transformation matrix
    T:=T^(-1);;

    # Copy the defining linear forms of A
    Am:=ShallowCopy(Roots(A));;

    # Apply the coordinate transformation
    Am:=Am*T;

    # Remove the i-th coordinate to obtain the restriction
    Am:=List(Am,x->Concatenation(x{[1..(i-1)]},x{[(i+1)..Dimension(A)]}));

    # Return the restricted hyperplane arrangement
    return HyperplaneArrangement(Am);
end);


InstallGlobalFunction( HArrResHind,
function(A,k)

    # Restrict the arrangement A to the hyperplane indexed by k
    return HArrResHvec(A,A.roots[k]);;

end);


InstallGlobalFunction( HArrResX,
function(A,S)
local An,Sn;;

    # If S contains vectors defining hyperplanes
    if IsBound(S[1]) then

        # Restrict A to the first hyperplane in S
        An:=HArrResHvec(A,S[1]);

        # Compute the remaining restriction directions
        Sn:=Roots(HArrResHvec(HyperplaneArrangement(S),S[1]));;

        # Continue restricting recursively
        return HyperplaneArrangement(Roots(HArrResX(An,Sn)));;

    else

        # If no restriction is specified, return A unchanged
        return HyperplaneArrangement(Roots(A));;

    fi;;
end);


####################################################################################################
## Essentialize the Arrangement A
####################################################################################################

InstallGlobalFunction(Essentialization,
function(A)
local C;

    # Compute the nullspace of the transpose of the defining matrix
	C:=NullspaceMat(TransposedMat(Roots(A)));

    # If the nullspace is nontrivial, restrict the arrangement
	if C<>[] then
		return HArrResX(A,C);
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

############################################################
## The arrangment of the monomial group G(p,q,l)
############################################################

InstallGlobalFunction(AGpql,
function(p,q,l)
local C,c,v,i,roots;

	if q<>p then
		roots:=IdentityMat(l);
	else
		roots:=[];
	fi;
	
	C := Combinations([1..l],2);
	for c in C do
		for i in [1..(Order(E(p)))] do
			v :=0*[1..l];
			v[c[1]]:=1;
			v[c[2]]:=-E(p)^i;
			Add(roots,v);
		od;
	od;

	return HyperplaneArrangement(roots);

end);


#####################################################################################
## Timer
#####################################################################################

InstallGlobalFunction(tnow,function()
    return Runtimes().user_time;;
end);
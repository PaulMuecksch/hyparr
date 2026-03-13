#
# HypArr: Computations with hyperplane arrangements 
#
# Implementations
# #

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
##  Defines the hyerplane arrangement from a list of vectors giving defining linear forms.
##  
##
##  </Description>
##  </ManSection>
##  <#/GAPDoc>

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
    # A := NewRepresentation(IsHyperplaneArrangementRep);
    # A!.Dimension := dim;
    # A!.Roots := l;
    # return A;
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

# Compute the intersection lattice of the arrangement

InstallGlobalFunction(HypArr_AddHToL,
function(R,Lo,Hn)
    local Ln, m, k, i, n, r;
	if ForAny(R, x -> Rank([x,Hn]) = 1) then
		return Lo;
	fi;;
	
	if Lo=[] then
		return [[[1]]];;
	fi;;	

	Ln:=List(Lo, x -> List(x, ShallowCopy));;
	n := Length(Lo[1]);;
	r := Length(Lo);;


	for k in [1..r] do
		for i in [1..Length(Lo[k])] do
			m := ShallowCopy(Lo[k][i]);;
			if Rank(R{m}) = Rank(Concatenation(R{m},[Hn])) then
				Add(Ln[k][i],n+1);
			else
				if k<r then
					if not( true in List(Lo[k+1],x->IsSubset(x,m) and Rank(R{x}) = Rank(Concatenation(R{x},[Hn]))) ) then
						Add(Ln[k+1],Concatenation(m,[n+1]));
					fi;
				elif k=r then
					Add(Ln,[Concatenation(m,[n+1])]);;
				fi;
			fi;;
		od;;
	od;;

	Add(Ln[1],[n+1]);;

	return Ln;;
end);;

InstallMethod(IntersectionLattice,
    [IsHyperplaneArrangement],
function(A)
    local R, Rt, r, Ls;
    # if HasIntersectionLattice(A) then
    #     return IntersectionLattice(A;
    # fi;
    R := ShallowCopy(Roots(A));

    Ls := [];
    Rt := [];

    for r in R do
        Ls := HypArr_AddHToL(Rt, Ls, r);
        Add(Rt, r);
    od;

    # SetIntersectionLattice(A, Ls);

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
## The Restiction of an Arrangement A to
## the Hyperplane H_k or to X given by a list of vectors
####################################################################################################

InstallGlobalFunction( HArrResHvec,
function(A,h)
local k,Am,T,i,z;;
#     
    if Rank([h])=0 then
        return A;
    fi;;
    k:=Length(h);;
    z:=GeneratorsOfField(Field(h))[1];;
    T:=z*IdentityMat(k);;
    i:=Minimum(Positions(List(h,x->x<>0*z),true));;
    T[i]:=h;;
#     T:=z*T;;
    T:=T^(-1);;
    Am:=ShallowCopy(Roots(A));;
    Am:=Am*T;
    Am:=List(Am,x->Concatenation(x{[1..(i-1)]},x{[(i+1)..Dimension(A)]}));
    return HyperplaneArrangement(Am);
end);

InstallGlobalFunction( HArrResHind,
function(A,k)
    return HArrResHvec(A,A.roots[k]);;
end);

InstallGlobalFunction( HArrResX,
function(A,S)
local An,Sn;;
#     Print(S,"\n");;
    if IsBound(S[1]) then
        An:=HArrResHvec(A,S[1]);
        Sn:=Roots(HArrResHvec(HyperplaneArrangement(S),S[1]));;
        return HyperplaneArrangement(Roots(HArrResX(An,Sn)));;
    else
        return HyperplaneArrangement(Roots(A));;
    fi;;
end);

####################################################################################################
## Essentialize the Arrangement A
####################################################################################################

InstallGlobalFunction(Essentialization,
function(A)
local C;
	C:=NullspaceMat(TransposedMat(Roots(A)));
	if C<>[] then
		return HArrResX(A,C);
	else
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
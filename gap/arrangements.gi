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
          Length(GLAtoms(L)), " atoms, rank ",
          GLRank(L), ">");
end);


# Some basic attributes of hyperplane arrangements

InstallMethod(Roots,
    [IsHyperplaneArrangement],
    A -> A!.roots);
    
InstallMethod(Dimension,
    [IsHyperplaneArrangement],
    A -> A!.dimension);


InstallMethod(IsReal,
    [IsHyperplaneArrangement],
    A -> not(ForAny(Roots(A),r->ForAny(r,x->x<>cj(x)))) );


# Some basic attributes of geometric lattices

InstallMethod(GLGroundSet,
    [IsGeomLattice],
    L -> L!.grGroundSet);
    
InstallMethod(GLAtoms,
    [IsGeomLattice],
    L -> L!.atoms);

InstallMethod(GLRank,
    [IsGeomLattice],
    L -> L!.rank);

InstallMethod(GLkFlats,
    [IsGeomLattice],
function(L)
local kFlatsFct, gset;
	gset := GLGroundSet(L);;
	kFlatsFct := function(k)
		return gset[k];;
	end;;
	return kFlatsFct;;
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

    # The resulting lattice structure
    return Ls;

end);

InstallMethod( MSetInvL,
    [ IsHyperplaneArrangement ] ,
function(A)
    local L,I,i;
    
    if HasMSetInvL(A) then
        return A!.MSetInvL;
    fi;

    L:=GLGroundSet(IntersectionLattice(A));;
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
		An := HArrResHind(A,1);
	    return CharPoly(AA) - CharPoly(An);
    fi;;
end);

## Factorization of an rational Polynomial

BindGlobal("facQ",
function(g)
	return Reversed(Factors(PolynomialRing(Rationals,"t"),g));
end);

InstallMethod(ExpArr,
	[ IsHyperplaneArrangement ],
function(A)
local expA;;
	if IsBound(A!.exp) then
		return A!.exp;;
	fi;;
    expA:=List(facQ(CharPoly(A)),x->-Value(x,0));;
    if Length(expA)<>Dimension(A) then
        return fail;
    fi;;
    return expA;;
end);

####################################################################################################
# Global auxillary functions
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
    return HArrResHvec(A,Roots(A)[k]);;

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



## the complex conjugation
InstallGlobalFunction(cj, 
function(x)
	return ComplexConjugate(x);
end);

#####################################################################################
## Timer
#####################################################################################

InstallGlobalFunction(tnow,function()
    return Runtimes().user_time;;
end);

####################################################################################################
## Drawing LaTeX Pictures
## 
####################################################################################################

# Rotating normal of a distinguished hyperplane to the z-axis
InstallGlobalFunction(RotTozMat,
function(t)
local nt,i,nv,P,r,v,v1,v2,v3,B,calpha,salpha,DD,Dnt;;

	# normal for the plane spanned by t and the z-axis
	r:=HypArr_wg([t,[0,0,1]]);;

	# length of t
	nt:=Sqrt(t*t);;

	# matrix giving the dilation in direction t
	Dnt:=IdentityMat(3);;
	Dnt[3][3]:=nt;;

	# t not on the z axis
	if r<>[0,0,0] then
	calpha:=t[3]/nt;;
	salpha:=Sqrt(1-calpha^2);;
	else
	return Dnt;;
	fi;;
	# axis of rotation given by r<>0

	# look for the fist non-zero entry
	i:=1;;
	while r[i]=0 do
	i:=i+1;;
	od;

	# swith 1 with the non-zero index
	if i=1 then
	P:=IdentityMat(3);;
	elif i>3 then 
	return fail; 
	else
	P:=PermutationMat((1,i),3);;
	fi;;
	v:=P*ShallowCopy(r);;

	# normalized vector
	v1:=1/Sqrt(v*v)*v;;

	# orthogonal basis for v^\perp
	v2:=[-v[2]/v[1],1,0];;
	v2:=1/Sqrt(v2*v2)*v2;;
	v3:=[-v[3]/v[1],0,1];;
	v3:=1/Sqrt(v3*v3)*v3;;
	B:=TransposedMat([v1,v2,v3]);;

	# cos and sin of alpha
	#cq := 1/2*(zeta^p + zeta^(-p));;
	#sq := 1/(2*E(4))*(zeta^p - zeta^(-p));;



	# Rotation matrix DD with resp to B
	DD:=[[1,0,0],[0,calpha,-salpha],[0,salpha,calpha]];;
	# Matrix D with resp to the standard basis
	#D := B*DD*(B^(-1));;
	return Dnt*P*B*DD*(B^(-1));;
end);

InstallGlobalFunction(ctf, 
function(T)
	if IsList(T) then
		return List(T,x->ctf(x));
	else 
		return CCToFloat(T);
	fi;
end);

InstallGlobalFunction(FloatStringCutoff,
function(x)
local posdot;
	posdot := Position(x,'.');;
	if Length(x)-posdot >= 4 then
		return Concatenation(x{[1..posdot]},x{[posdot+1..posdot+3]});
	else
		return x;;
	fi;;
end);

InstallGlobalFunction(DrawLatex3Arr,
function(arg) # function(A,[ps,[ip,[Hind,[disthv,[MarkHs]]]]])
local A,s,ip,Hind,disthv,
	#TM,
	R,RR,r1,r2,v,vv,v2d,sp,t,cs,cf,
	a,b,c,
	x1,x2,y1,y2,
	xc1,xc2,yc1,yc2,
	p, p1,p2,p3, i, j ,n, k, sg,
	rinf,xyinf,
	px,py,sv,
    Mind, MarkHs;
	
	if IsList(arg) then
		if Length(arg)=0 then
			return fail;
		else 
			if IsReal(arg[1]) then
				A:=arg[1];;
			else
				return fail;
			fi;
			s:=1;;
			ip:=0;;
			Hind:=0;;
			disthv:=[0,0,1];;
			Mind:=0;;
			if Length(arg)=2 then
				s:=arg[2];;
			elif Length(arg)=3 then
				s:=arg[2];;
				ip:=arg[3];;
			elif Length(arg)=4 then
				s:=arg[2];;
				ip:=arg[3];;
				Hind:=arg[4];;			
			elif Length(arg)=5 then
				s:=arg[2];;
				ip:=arg[3];;
				Hind:=arg[4];;
				disthv:=arg[5];;			
			elif Length(arg)=6 then
				s:=arg[2];;
				ip:=arg[3];;
				Hind:=arg[4];;
				disthv:=arg[5];;
                Mind:=1;;
                MarkHs:=arg[6];;
			fi;
		fi;;
	fi;;
	
	R:=List(ShallowCopy(Roots(A)),x->RotTozMat(disthv)*x);;

	# sp:="\\begin{tikzpicture}[scale=\\sc]\n";;
	sp:="\\begin{tikzpicture}[scale=1.0]\n";;
	
	RR:=ctf(R);;
	
	r1:=4.0;;
	
	for vv in RR do
		if AbsoluteValue(vv[1]^2 + vv[2]^2) < 0.0001 then
			rinf:=String(18/17*r1);;
			#xyinf:=String(Sqrt(2.0)/2*18/17*r1+0.35);;
			xyinf := String(Sqrt(2.0)/2*18/17*r1);;
            
            
            if Mind=1 and Position(RR,vv) in MarkHs then
			if Hind=1 then
                sp:=Concatenation(sp,
                    "\\draw[color=red] (0,",rinf,") arc [start angle=90, end angle=0, radius=",rinf,"] ;\n",
                    "\\node [above right] at (",xyinf,",",xyinf,") {$\\infty =$ \\small $",String(Position(RR,vv))," $};  % H_",String(Position(RR,vv))," \n");;
			else
				sp:=Concatenation(sp,
					"\\draw[color=red] (0,",rinf,") arc [start angle=90, end angle=0, radius=",rinf,"] ;\n",
					"\\node [above right] at (",xyinf,",",xyinf,") {$\\infty$};  % H_",String(Position(RR,vv))," \n");;
			fi;;
			else
			if Hind=1 then
                sp:=Concatenation(sp,
                    "\\draw (0,",rinf,") arc [start angle=90, end angle=0, radius=",rinf,"] ;\n",
                    "\\node [above right] at (",xyinf,",",xyinf,") {$\\infty =$ \\small $",String(Position(RR,vv))," $};  % H_",String(Position(RR,vv))," \n");;
			else
				sp:=Concatenation(sp,
					"\\draw (0,",rinf,") arc [start angle=90, end angle=0, radius=",rinf,"] ;\n",
					"\\node [above right] at (",xyinf,",",xyinf,") {$\\infty$};  % H_",String(Position(RR,vv))," \n");;
			fi;;
			fi;;
		else
			t:=1/Sqrt( vv[1]^2 + vv[2]^2 );;
		
			v:=t*vv;;
		
			r2:=-s*v[3];;
		
			if v[2]^2*r2^2 - (r2^2 - r1^2*v[1]^2) > 0.00001 or v[1]^2*r2^2 - (r2^2 - r1^2*v[2]^2) > 0.00001 then
				if AbsoluteValue(v[1]) > 0.0001 then 
					yc1:= v[2]*r2 + Sqrt( v[2]^2*r2^2 - (r2^2 - r1^2*v[1]^2) );;
					yc2:= v[2]*r2 - Sqrt( v[2]^2*r2^2 - (r2^2 - r1^2*v[1]^2) );;
					xc1:= (r2 - v[2]*yc1)/v[1];
					xc2:= (r2 - v[2]*yc2)/v[1];
				elif AbsoluteValue(v[2]) > 0.0001 then
					xc1:= v[1]*r2 + Sqrt( v[1]^2*r2^2 - (r2^2 - r1^2*v[2]^2) );;
					xc2:= v[1]*r2 - Sqrt( v[1]^2*r2^2 - (r2^2 - r1^2*v[2]^2) );;
					yc1:= (r2 - v[1]*xc1)/v[2];
					yc2:= (r2 - v[1]*xc2)/v[2];
				fi;
	
				if AbsoluteValue(xc1) < 0.0001 then xc1:=0.0;; fi;;
				if AbsoluteValue(xc2) < 0.0001 then xc2:=0.0;; fi;;
				if AbsoluteValue(yc1) < 0.0001 then yc1:=0.0;; fi;;
				if AbsoluteValue(yc2) < 0.0001 then yc2:=0.0;; fi;;
				x1:=String(xc1);
				y1:=String(yc1);
				x2:=String(xc2);
				y2:=String(yc2);

				x1:=FloatStringCutoff(x1);;
				x2:=FloatStringCutoff(x2);;
				y1:=FloatStringCutoff(y1);;
				y2:=FloatStringCutoff(y2);;

                if Mind=1 and Position(RR,vv) in MarkHs then
                    sp:=Concatenation(sp,"\\draw[color=red] (",x1,",",y1,") -- (",x2,",",y2,");  % H_",String(Position(RR,vv))," \n");;
                else
                    sp:=Concatenation(sp,"\\draw (",x1,",",y1,") -- (",x2,",",y2,");  % H_",String(Position(RR,vv))," \n");;
				fi;;

                if Hind=1 then
					#\node at (4.,0.) {\tiny$1$};
										
					if AbsoluteValue(v[1]) > 0.0001 then 
						yc1:= v[2]*r2 + Sqrt( v[2]^2*r2^2 - (r2^2 - (r1+0.2)^2*v[1]^2) );;
						yc2:= v[2]*r2 - Sqrt( v[2]^2*r2^2 - (r2^2 - (r1+0.2)^2*v[1]^2) );;
						xc1:= (r2 - v[2]*yc1)/v[1];
						xc2:= (r2 - v[2]*yc2)/v[1];
					elif AbsoluteValue(v[2]) > 0.0001 then
						xc1:= v[1]*r2 + Sqrt( v[1]^2*r2^2 - (r2^2 - (r1+0.2)^2*v[2]^2) );;
						xc2:= v[1]*r2 - Sqrt( v[1]^2*r2^2 - (r2^2 - (r1+0.2)^2*v[2]^2) );;
						yc1:= (r2 - v[1]*xc1)/v[2];
						yc2:= (r2 - v[1]*xc2)/v[2];
					fi;
	
					if AbsoluteValue(xc1) < 0.0001 then xc1:=0.0;; fi;;
					if AbsoluteValue(xc2) < 0.0001 then xc2:=0.0;; fi;;
					if AbsoluteValue(yc1) < 0.0001 then yc1:=0.0;; fi;;
					if AbsoluteValue(yc2) < 0.0001 then yc2:=0.0;; fi;;
					x1:=String(xc1);
					y1:=String(yc1);
					x2:=String(xc2);
					y2:=String(yc2);
					
					if x1>=0 then
						sp:=Concatenation(sp,"\\node at (",x2,",",y2,") {\\small $",String(Position(RR,vv)),"$}; \n");;
					else
						sp:=Concatenation(sp,"\\node at (",x1,",",y1,") {\\small $",String(Position(RR,vv)),"$}; \n");;
					fi;
				fi;;
			else
				sp:=Concatenation(sp,"% H_",String(Position(RR,vv))," out of draw area \n");;
			fi;
		fi;
		
	od;
	sp:=Concatenation(sp, "\n");;
	if ip=1 then
		for sv in GLGroundSet(IntersectionLattice(A))[2] do
			a:=ctf(NullspaceMat(TransposedMat(R{sv}))[1]);;
			if AbsoluteValue(a[3]) > 0.0001 and a[1]^2+a[2]^2 < (r1/s)^2 then
				px:=String(s*a[1]/a[3]);;
				py:=String(s*a[2]/a[3]);;
				if AbsoluteValue(s*a[1]/a[3]) < 0.0001 then px:="0.0";; fi;;
				if AbsoluteValue(s*a[2]/a[3]) < 0.0001 then py:="0.0";; fi;;
				sp:=Concatenation(sp, "\\fill[red] (",px,",",py,") circle[radius=2pt];  % P",String(sv)," \n");;
			fi;	
		od;;
		sp:=Concatenation(sp, "\n");;
	fi;
	
	sp:=Concatenation(sp, "\\end{tikzpicture}\n");;

	return sp;
	
end);;
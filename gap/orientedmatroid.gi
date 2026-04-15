#
# HypArr: Computations with oriented matroids
#
# Implementations
# #


BindGlobal("OrientedMatroidFamily",
    NewFamily("OrientedMatroidFamily"));


BindGlobal("FacePosetFamily",
    NewFamily("FacePosetFamily"));

# Implement the oriented matroid constructor

InstallMethod(OrientedMatroid,
    "for list of linear forms",
    [IsList],
function(r)
    local dim, l, type, A;

    if r = [] then
        dim := 0;
        l := [];
    else
        # dim := Length(r[1]);
        A := HyperplaneArrangement(r);;
        if IsReal(A) then
            l := Roots(A);
        else
            Print("Can't construct an oriented matroid from linear forms which are not real!\n");
            return fail;
        fi;;
    fi;

    type := NewType(OrientedMatroidFamily,
                    IsOrientedMatroidRep);

    return Objectify(type,
        rec(
            GroundSet := [1..Length(l)],
            lforms := l,
            rank := Rank(l)
        )
    );
end);

InstallMethod(OrientedMatroid,
    "for a real arrangement",
    [ IsHyperplaneArrangement ],
function(A)
    local l,dim,type;
    if not(IsReal(A)) then
        Print("Can't construct an oriented matroid from hyperplane arrangement which is not real!\n");
        return fail;
    fi;;

    l := Roots(A);
    # dim := Dimension(A);

    type := NewType(OrientedMatroidFamily,
                    IsOrientedMatroidRep);

    return Objectify(type,
        rec(
            GroundSet := [1..Length(l)],
            lforms := l,
            rank := Rank(l)
        )
    );
end);


InstallMethod(OrientedMatroid,
    "for a list of lists of signed covectors",
    [IsList, IsString],
function(Cs,c)
    local type, CCs, CVs, n, r;
    if c="cv" then
        CVs := ShallowCopy(Cs);;
        r := Length(CVs)-1;;
        CCs:=CVs[r];;
        n := Length(CVs[r][1]);

        type := NewType(OrientedMatroidFamily,
                    IsOrientedMatroidRep);

        return Objectify(type,
            rec(
                GroundSet := [1..n],
                cocircuits := CCs,
                covectors := CVs,
                rank := r
            )
        );
    fi;;
    Print("Argument c not cv'!\n");
    return fail;;
    # elif c="cc" then
end);;


BindGlobal("BsFromChiroCore",
function(r,n,ChiroCore)
local Bs;
    Bs := Combinations([1..n],r);;
    Bs := Bs{Positions(List(ChiroCore,x->x<>0),true)};
    return Bs;;
end);

InstallMethod(OrientedMatroid,
    "for a chirotope data",
    [IsInt, IsInt, IsList],
function(r,n,ChiroCore)
    local type, ChirotopeFct;
    # For an r-tuple S return chi(S) \in {0,1,-1} or fail if l(s)<>r
    ChirotopeFct := ChirotopeFromChiroCore(r,n,ChiroCore);;

    type := NewType(OrientedMatroidFamily,
                    IsOrientedMatroidRep);

    return Objectify(type,
        rec(
            GroundSet := [1..n],
            chirocore := [r,n,ChiroCore],
            chirotope := ChirotopeFct,
            rank := r
        )
    );

end);;

InstallMethod(ViewObj,
    [ IsOrientedMatroid ],
function(OM)
    Print("<OrientedMatroid: ",
          Length(OMGroundSet(OM)), " elements, rank ",
          OMRank(OM), ">");
end);

InstallMethod(ViewObj,
    [ IsFacePoset ],
function(FP)
local GSet;
    GSet := FPGroundSet(FP);;
    Print("<FacePoset of dimension ",
          Length(GSet)-1," with f-vector ",List(GSet,x->Length(x)),">");
end);


InstallMethod(FPGroundSet,
    [ IsFacePoset ],
    FP -> FP!.grGroundSet);

InstallMethod(FPOrder,
    [ IsFacePoset ],
    FP -> FP!.orderfunction);


InstallMethod(OMGroundSet,
    [ IsOrientedMatroid ],
    OM -> OM!.GroundSet);

InstallMethod(OMRank,
    [ IsOrientedMatroid ],
    OM -> OM!.rank);

InstallMethod(OMLForms,
    [ IsOrientedMatroid ],
function(OM)
    if IsBound(OM!.lforms) then
        return OM!.lforms;
    else
        return fail;
    fi;;
end);

InstallMethod(OMChirotope,
    [ IsOrientedMatroid ],
function(OM)
    if IsBound(OM!.chirotope) then
        return OM!.chirotope;
    else
        return fail;
    fi;;
end);

InstallMethod(OMIsLinear,
    [ IsOrientedMatroid ],
    OM -> IsBound(OM!.lforms));

BindGlobal("RkFctFromChiroCore",
function(r,n,ChiroCore)
    local Bs, RkFct;;
    Bs := BsFromChiroCore(r,n,ChiroCore);;
    RkFct := function(S)
        return Maximum(List(Bs,B->Length(IntersectionSet(S,B))));;
    end;;

    return RkFct;;
end);

InstallMethod(OMRankFunction,
    [ IsOrientedMatroid ],
function(OM)
local rf;
    if IsBound(OM!.rkfct) then
        return OM!.rkfct;
    elif OMIsLinear(OM) then
        rf := function(S)
            return Rank(OMLForms(OM){S});;
        end;
        OM!.rkfct := rf;
        return OM!.rkfct;
    elif IsBound(OM!.chirocore) then
        rf := RkFctFromChiroCore(OM!.chirocore[1],OM!.chirocore[2],OM!.chirocore[3]);
        OM!.rkfct := rf;
        return OM!.rkfct;
    else
        return fail;
    fi;;
end);

####################################################################################################

BindGlobal("AddEltToL",
function(no,Lo,RkFct)
local Ln, m, k, i, n, r;
	if true in List([1..no],x->RkFct([x,no+1])=1) then 
		return Lo;
	fi;;
	
	if Lo=[] then
		return [[[1]]];;
	fi;;	

	Ln:=List(Lo,x->List(x,y->ShallowCopy(y)));;
	# n := Length(Lo[1]);;
    n := ShallowCopy(no);;
	r := Length(Lo);;


	for k in [1..r] do
		for i in [1..Length(Lo[k])] do
			m := ShallowCopy(Lo[k][i]);;
			if RkFct(m) = RkFct(Concatenation(m,[n+1])) then
				Add(Ln[k][i],n+1);
			else
				if k<r then
					if not( true in List(Lo[k+1],x->IsSubset(x,m) and RkFct(x) = RkFct(Concatenation(x,[n+1]))) ) then
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
end);

BindGlobal("LatticeFromRkFct",
function(n,RkFct)
local Ls,i,type;;
    Ls:=[];;
	for i in [1..n] do
		Ls:=AddEltToL(i-1,Ls,RkFct);;
	od;;

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


BindGlobal("LatticeFromCVs",
function(CVs)
local Ls,type;;
    Ls:= List( CVs{[2..Length(CVs)]},
            Cs->Set(List(Cs,sv->SVZeroSet(sv)))
        );

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


InstallMethod(OMGeomLattice, 
    [ IsOrientedMatroid ],
function(OM)
    local L;;
    if OMIsLinear(OM) then
        L:=IntersectionLattice(HyperplaneArrangement(OMLForms(OM)));
        OM!.lattice := L;;
        return L;;
    elif IsBound(OM!.covectors) then
        L:=LatticeFromCVs(OMCovectors(OM));
        OM!.lattice := L;;
        return L;;
    elif OMRankFunction(OM)<>fail then
        L:=LatticeFromRkFct(Length(OMGroundSet(OM)),OMRankFunction(OM));
        OM!.lattice := L;;
        return L;;
    else
        Print("Sorry, no function yet for this oriented matroid representation!\n");     
        return fail;
    fi;;
end);

####################################################################################################

InstallMethod(OMCocircuits, 
    [ IsOrientedMatroid ],
function(OM)
    local L,Lk,r,n,T,LHs,CoCircs,m,mX,vm,D,
        e,f,Bofm,ChiFct,RkFct,BasisOfFlat;
    if IsBound(OM!.cocircuits) then
        return OM!.cocircuits;
    fi;;

    L:=OMGeomLattice(OM);;
    Lk:=LkFlats(L);;
    r:=LRank(L);
    n:=Length(LAtoms(L));;
    LHs:=Lk(r-1);;
    CoCircs := [];;
    if OMIsLinear(OM) then
        T:=NullspaceMat(TransposedMat(OMLForms(OM)));;

        for m in LHs do
            mX:=NullspaceMat(TransposedMat(OMLForms(OM){m}));
            if T<>[] then
                vm:=mX[Position(List(mX,x->Rank(Concatenation(T,[x]))>Rank(T)),true)];
            else
                vm:=mX[1];;
            fi;;
            D:=List(OMLForms(OM),x->pos(x*vm));;
            Add(CoCircs,D);;
            Add(CoCircs,-D);;
        od;;;
        # return CoCircs;;
    else
        ChiFct := OMChirotope(OM);
        RkFct := OMRankFunction(OM);

        BasisOfFlat := function(m)
        local B,e,r;;
            B:=m{[1]};;
            r:=1;
            for e in [2..Length(m)] do
                if RkFct(Concatenation(B,[m[e]])) >r then
                    Add(B,m[e]);
                    r:=r+1;;
                fi;;
            od;;
            return B;;
        end;;

        for m in LHs do
            D:=List([1..n],x->1);;
            D{m} := List(m,x->0);;
            Bofm := BasisOfFlat(m);;
            e := Difference([1..n],m)[1];;
            for f in Difference([1..n],Concatenation(m,[e])) do
                if ChiFct(Concatenation([e],Bofm))*ChiFct(Concatenation([f],Bofm))=-1 then
                    D[f] := -1;;
                fi;;
            od;;
            Add(CoCircs,D);;
            Add(CoCircs,-D);;
        od;;;
        # return CoCircs;;
    fi;
    OM!.cocircuits := CoCircs;
    return OM!.cocircuits;
end);

####################################################################################################

# The main function computing the covectors 
InstallMethod(OMCovectors, 
    [ IsOrientedMatroid ],
function(OM)
local ACs,GSet,L,Lk,r,n,m,mm,CsRkk,CsRkkp,k,Csinm,c,cn,i,cp,Fcn;;
    if IsBound(OM!.covectors) then
        return OM!.covectors;
    fi;;

    L := OMGeomLattice(OM);;
    Lk:=LkFlats(L);;
    r:=LRank(L);
    n:=Length(LAtoms(L));;
    GSet:=LAtoms(L);;
    CsRkk:=OMCocircuits(OM);;
    ACs := Concatenation([[List(GSet,x->0)]],[CsRkk]);;
    for k in Reversed([1..r-2]) do
        CsRkkp:=[];;
        for m in Lk(k) do
            for mm in Lk(k+2){Positions(List(Lk(k+2),x->IsSubset(x,m)),true)} do
            Csinm := CsRkk{Positions(List(CsRkk,c->IsSubset(Positions(c,0),m) and IsSubset(mm,Positions(c,0))),true)};
            c:=Csinm[1];;
            for i in List([1..Length(Csinm)/2-1],x->2*x+1) do
                cn := OMOperation(Csinm[i],c);
                Fcn := Positions(cn,0);;
                if not( (Fcn<>m) or (cn in CsRkkp) ) then
                    Add(CsRkkp,cn);;
                    Add(CsRkkp,-cn);;
                fi;;
                cn := OMOperation(Csinm[i],-c);;
                Fcn := Positions(cn,0);;
                if not( (Fcn<>m) or (cn in CsRkkp) ) then
                    Add(CsRkkp,cn);;
                    Add(CsRkkp,-cn);;
                fi;;
            od;;
            od;;
        od;;
        Add(ACs,ShallowCopy(CsRkkp));;
        CsRkk := ShallowCopy(CsRkkp);;
    od;;

    CsRkkp:=[];;
    for cp in Combinations(CsRkk,2) do
        cn := OMOperation(cp[1],cp[2]);;
        if not( (0 in cn) or (cn in CsRkkp) ) then
            Add(CsRkkp,cn);;
            Add(CsRkkp,-cn);;
        fi;;
    od;;

    Add(ACs,CsRkkp);;
    OM!.covectors := Reversed(ACs);;
    return OM!.covectors;;
end); 

####################################################################################################

InstallMethod(TopeGraph, 
    [ IsOrientedMatroid ],
function(OM)
local n, i,j, G, GraphMat,TGraph,x,y,Topes;
    Topes := OMCovectors(OM)[1];
    n:= Length(Topes);;
	GraphMat:=NullMat(n,n);
	for i in [1..n] do
		for j in [1..n] do
        	if Length(SeparatingSet(Topes[i],Topes[j]))=1 then
				    GraphMat[i][j]:=1;
				    GraphMat[j][i]:=1;
			fi;    
        od;
	od;
	TGraph := Graph(Group( () ), [1..n], OnPoints,function(x,y) return GraphMat[x][y]=1; end, true);
    OM!.topegraph := TGraph;
    return TGraph;;
end);

####################################################################################################

InstallMethod(SalvettiComplex,
    "for an oriented matroid",
    [ IsOrientedMatroid ],
function(OM)
local SalCpx,SalOF, FCpx,Topes,d,T, k,type;
    FCpx:=OMCovectors(OM);;
    Topes:=FCpx[1];;
    d:=Length(FCpx);;
    SalCpx:=List([1..d],x->[]);;;
    for T in Topes do
        for k in [1..d] do
            SalCpx[k] := Concatenation(SalCpx[k], List(LowerOrderIdeal(FCpx,[T],OrderCovec)[k],x->[x,T]) );;
        od;;
    od;;

    # return SalCpx;;
    SalOF := function(SalCell1,SalCell2)
    local T,R,sigma,tau;;
        sigma:=SalCell1[1];;
        tau:=SalCell2[1];;
        T:=SalCell1[2];;
        R:=SalCell2[2];;

        if OrderCovec(tau,sigma)=true then
            if OMOperation(sigma,R)=T then
                return true;;
            fi;;
        fi;; 
        return false;;
    end;

    type := NewType(FacePosetFamily,
                    IsFacePosetRep);

    return Objectify(type,
        rec(
            grGroundSet := SalCpx,
            orderfunction := SalOF
        )
    );
end);


####################################################################################################


InstallMethod(SalvettiComplex,
    "for a real arrangement",
    [ IsHyperplaneArrangement],
function(A)
local OM,SalCpx,SalOF, FCpx,Topes,d,T, k,type;
    if not(IsReal(A)) then
        Print("Not a real arrangement!\n");
        return fail;
    fi;
    OM := OrientedMatroid(A);;
    FCpx:=OMCovectors(OM);;
    Topes:=FCpx[1];;
    d:=Length(FCpx);;
    SalCpx:=List([1..d],x->[]);;;
    for T in Topes do
        for k in [1..d] do
            SalCpx[k] := Concatenation(SalCpx[k], List(LowerOrderIdeal(FCpx,[T],OrderCovec)[k],x->[x,T]) );;
        od;;
    od;;

    # return SalCpx;;
    SalOF := function(SalCell1,SalCell2)
    local T,R,sigma,tau;;
        sigma:=SalCell1[1];;
        tau:=SalCell2[1];;
        T:=SalCell1[2];;
        R:=SalCell2[2];;

        if OrderCovec(tau,sigma)=true then
            if OMOperation(sigma,R)=T then
                return true;;
            fi;;
        fi;; 
        return false;;
    end;

    type := NewType(FacePosetFamily,
                    IsFacePosetRep);

    return Objectify(type,
        rec(
            grGroundSet := SalCpx,
            orderfunction := SalOF
        )
    );
end);

##

####################################################################################################

InstallMethod(IsLEquiv,
	[IsOrientedMatroid, IsOrientedMatroid],
function(OM1,OM2)
local LGraph1,LGraph2;;
    LGraph1 := ShallowCopy(LGraph(OMGeomLattice(OM1)));
    LGraph2 := ShallowCopy(LGraph(OMGeomLattice(OM2)));
    return IsIsomorphicGraph(LGraph1,LGraph2);
end);

####################################################################################################
## Localization
####################################################################################################

InstallMethod(OMLocalizationRk,
	[IsOrientedMatroid,IsList,IsInt],
function(OM,F,k)
local i, L, CVs, CVsi, Ff, CVsLoc, OMLoc;;
    L:=OMGeomLattice(OM);;
    if not(F in LkFlats(L)(k)) then
        Print(F, " is not a flat!\n");;
        return fail;;
    fi;;
    if OMIsLinear(OM) then
        return OrientedMatroid(OMLForms(OM){F});
    fi;;
    CVs:=OMCovectors(OM);;
    Ff := CVs[k+1][Position(List(CVs[k+1],sv->SVZeroSet(sv)=F),true)];
    CVsLoc := [];;
    for i in [1..k] do
        CVsi := CVs[i]{Positions(List(CVs[i],sv->OrderCovec(Ff,sv)),true)};;
        CVsi := List(CVsi,sv->sv{F});;
        Add(CVsLoc,CVsi);
    od;;
    Add(CVsLoc,[List(F,x->0)]);;

    OMLoc := OrientedMatroid(CVsLoc,"cv");;
    return OMLoc;;
end);

####################################################################################################
## Simple simplices and triangles
####################################################################################################

BindGlobal("VsOfTope",
function(OM,T)
local CCs;
    CCs:=OMCocircuits(OM);;
    return CCs{Positions(List(CCs,sv->OrderCovec(sv,T)),true)};;
end);

InstallMethod(HasSimpleSimplex,
	[ IsOrientedMatroid ],
function(OM)
local Topes,T,VsOfT,r,EsNotAdj;;
    Topes:=OMCovectors(OM)[1];;
    r:=OMRank(OM);
    for T in Topes do
        VsOfT := VsOfTope(OM,T);;
        if Length(VsOfT)=r and not(ForAny(VsOfT,sv->Length(SVZeroSet(sv))>r-1)) then
            EsNotAdj := Difference(OMGroundSet(OM),Union(List(VsOfT,sv->SVZeroSet(sv))));
            if EsNotAdj<>[] then
                Print("  - tope: ",T,"\n  - vertices: ",VsOfT,"\n");;
                return true;
            fi;;
        fi;;
    od;;
    return false;;
end);


InstallMethod(HasSimpleSimplexRk,
	[ IsOrientedMatroid, IsInt ],
function(OM,k)
local Fk,L,Lk,OMLok,Topes,T,VofT,CVsRk;;
    L:= OMGeomLattice(OM);;
    Lk := LkFlats(L)(k);
    # return ForAny( Lk,Fk->HasSimpleSimplex(OMLocalizationRk(OM,Fk,k)) );
    for Fk in Lk do
        if HasSimpleSimplex(OMLocalizationRk(OM,Fk,k)) then
            Print(" Flat with simple simplex: ",Fk,"\n");
            return true;;
        fi;;
    od;;
    return false;
end);

InstallMethod(HasSimpleTriangle,
	[IsOrientedMatroid],
function(OM)
    return HasSimpleSimplexRk(OM,3);;
end);


####################################################################################################
# Global auxillary functions
####################################################################################################

# Compute the float representation of the real part of a cyclotomic (complex) number

BindGlobal("Pi",21053343141/6701487259);

# cosinus
InstallGlobalFunction(cosn,
function(n,k)
local S,theta;
	theta:=2*Pi*k/n;;
	return Cos(Float(theta));;
end);

InstallGlobalFunction(CCToFloat,
function(z)
local ccs,cs,cs2,p1,p2,p3,p4,p,
	vv,sg,k,i,j,n,cc;;

	
	if IsFloat(z) then
		return z;;	
	elif z in Rationals then
		return Float(z);;
	else
		cs:=String(z);;
		if cs[1] <> '-' then
			p3:=Set(Concatenation([1],Positions(cs,'+'),Positions(cs,'-'),[Length(cs)+1]));;
		else
			p3:=Set(Concatenation(Positions(cs,'+'),Positions(cs,'-'),[Length(cs)+1]));;
		fi;;
		p:=[];;
				
		for i in [1..(Length(p3)-1)] do
			cs2 := cs{[p3[i]..(p3[i+1]-1)]};;
			sg:=1;
			p1:=Position(cs2,'(');;
			#Print(cs2," ");
			if p1=fail then
				ccs:=cs2;;
				n:=1;;
				k:=0;;
				if cs2[1]<>'-' and cs2[1]<>'+' then 
					sg:=1;
					cc:=Rat(ccs);;
				elif cs2[1]='-' then
					sg:=-1;;
					cc:=Rat(ccs{[2..Length(ccs)]});;
				elif cs2[1]='+' then
					sg:=1;;
					cc:=Rat(ccs{[2..Length(ccs)]});;
				fi;;
				Add(p,[sg,cc,n,k]);
			else
				p2:=Position(cs2,')');;
				n:=Int(cs2{[(p1+1)..(p2-1)]});;
				k:=Int(cs2{[(p2+2)..(Length(cs2))]});;
				if p1>2 and cs2[p1-2]= '*' then
					ccs:=cs2{[1..(p1-3)]};;
					if ccs[1]<>'-' and ccs[1]<>'+' then
						sg:=1;
						cc:=Rat(ccs);;
					elif ccs[1]='-' then
						sg:=-1;;
						cc:=Rat(ccs{[2..Length(ccs)]});;
					elif ccs[1]='+' then
						sg:=1;;
						cc:=Rat(ccs{[2..Length(ccs)]});;
					fi;;
				else
					if cs2[1]<>'-' and cs2[1]<>'+' then
						sg:=1;
					elif cs2[1]='-' then
						sg:=-1;;
					elif cs2[1]='+' then
						sg:=1;;
					fi;;
					cc:=1;;
				fi;
				if k=0 then
					Add(p,[sg,cc,n,1]);
				else
					Add(p,[sg,cc,n,k]);
				fi;
			fi;
			#Print([sg,cc,n,k]," ");
		od;
				
			#Print("\n",List(p,x->x[1]*x[2]*cosn(x[3],x[4])),"\n");
		return Sum(List(p,x->x[1]*x[2]*cosn(x[3],x[4])));;
	fi;
	
	return fail;
end);

InstallGlobalFunction(pos,
function(x)
local fx;
    if x<>cj(x) then
        Print("not real\n");;
        return fail;;
    fi;;
    fx := CCToFloat(x);;
    if fx^2 < 10.0^(-6) then
#     if fx^2 < 10.0^(-10) then
        return 0;;
    elif fx < .0 then
        return -1;;
    elif fx > .0 then
        return 1;;
    fi;;
    return fail;;
end);

InstallGlobalFunction(OMOperation,
function(sv1,sv2)
local svn, i;    
    if Length(sv1)<>Length(sv2) then
        return fail;;
    fi;;
    svn := 0*[1..Length(sv1)];;
    for i in [1..Length(sv1)] do
        if sv1[i]<>0 then
            svn[i] := sv1[i];;
        else
            svn[i] := sv2[i];;
        fi;;
    od;;
    return svn;
end);  


InstallGlobalFunction(SVZeroSet,
function(sv)
    return Positions(sv,0);
end);  

InstallGlobalFunction(OrderCovec,
function(sv1,sv2)
local t,i,x,y;
    if Length(sv1)<>Length(sv2) then
        return fail;
    fi;;
    if sv1=sv2 then
        return false;;
    fi;;
    for i in [1..Length(sv1)] do
        x:=sv1[i];;
        y:=sv2[i];;
        if not((x=0 and y<>0) or x=y) then
        # if Os1(sv1[i],sv2[i])=false then
            return false;;
        fi;;
    od;;
    return true;;
end); 

InstallGlobalFunction(LowerOrderIdeal,
function(Pset,gens,OF)
local I,x,y,P,k,nePs;;
    I:=[];;
    k:=0;;
    for P in Pset do
        k:=k+1;;
        Add(I,[]);;
        for x in P do
            if true in List(gens,y->OF(x,y) or x=y) then
                Add(I[k],x);;
            fi;;
        od;;
    od;;
    nePs := Positions(List(I,x->x<>[]),true);;
    Sort(nePs);;
    I:= I{nePs};;
    return I;;
end);


InstallGlobalFunction(SeparatingSet,
function(c1,c2)
    return Positions(List([1..Length(c1)],x->c1[x]<>0 and c2[x]=-c1[x]),true);;
end);

InstallGlobalFunction(IsOMEquiv,
function(OM1,OM2)
local TGraph1,TGraph2;
    TGraph1 := ShallowCopy(TopeGraph(OM1));
    TGraph2 := ShallowCopy(TopeGraph(OM2));
    return IsIsomorphicGraph(TGraph1,TGraph2);
end);

InstallGlobalFunction(ChirotopeFromChiroCore,
function(r,n,ChiroCore)
local ChiFct;
    # For an r-tuple S return chi(S) \in {0,1,-1} or fail if l(s)<>r
    ChiFct := function(S)
    local Bs,BS,k,kk;;
        Bs := BsFromChiroCore(r,n,ChiroCore);;
        if Length(S)<>r then
            return fail;
        else
            k := Position(List(Bs,B->Set(ShallowCopy(B))=Set(ShallowCopy(S)) ),true);
            if k<>fail then
                BS := Bs[k];;
                kk:=Position(Combinations([1..n],r),BS);
                return Determinant(List(BS,x->IdentityMat(r)[Position(S,x)]))*ChiroCore[kk];
            else
                return 0;
            fi;;
        fi;;
        # BS:=Position( List([1..Binomial(n,r)],i->Combinations([1..n],r))[i]
    
        return 0;;
    end;;
    return ChiFct;
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

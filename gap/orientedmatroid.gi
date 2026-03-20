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
        dim := Length(r[1]);
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
            rank := dim
        )
    );
end);

InstallOtherMethod(OrientedMatroid,
    "for a real arrangement",
    [ IsHyperplaneArrangement ],
function(A)
    local l,dim,type;
    if not(IsReal(A)) then
        Print("Can't construct an oriented matroid from hyperplane arrangement which is not real!\n");
        return fail;
    fi;;

    l := Roots(A);
    dim := Dimension(A);

    type := NewType(OrientedMatroidFamily,
                    IsOrientedMatroidRep);

    return Objectify(type,
        rec(
            GroundSet := [1..Length(l)],
            lforms := l,
            rank := dim
        )
    );
end);

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

InstallMethod(OMIsLinear,
    [ IsOrientedMatroid ],
    OM -> IsBound(OM!.lforms));


####################################################################################################

InstallMethod(OMGeomLattice, 
    [ IsOrientedMatroid ],
function(OM)
    local L;;
    if OMIsLinear(OM) then
        L:=IntersectionLattice(HyperplaneArrangement(OMLForms(OM)));
        OM!.lattice := L;;
        return L;;
    else
        Print("Sorry, no function yet for an oriented matroid which is not linear!\n");     
        return fail;
    fi;;
end);

####################################################################################################

InstallMethod(OMCocircuits, 
    [ IsOrientedMatroid ],
function(OM)
    local L,Lk,r,n,T,LHs,CoCircs,m,mX,vm,D;
    L:=OMGeomLattice(OM);;
    Lk:=GLkFlats(L);;
    r:=GLRank(L);
    n:=Length(GLAtoms(L));;
    LHs:=Lk(r-1);;
    CoCircs := [];;
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
    return CoCircs;;
end);

####################################################################################################

# The main function computing the covectors 
InstallMethod(OMCovectors, 
    [ IsOrientedMatroid ],
function(OM)
local ACs,GSet,L,Lk,r,n,m,mm,CsRkk,CsRkkp,k,Csinm,c,cn,i,cp,Fcn;;
    L := OMGeomLattice(OM);;
    Lk:=GLkFlats(L);;
    r:=GLRank(L);
    n:=Length(GLAtoms(L));;
    GSet:=GLAtoms(L);;
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
    return Reversed(ACs);;
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
    [ IsHyperplaneArrangement ],
function(A)
local OM,SalCpx,SalOF, FCpx,Topes,d,T, k,type;
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


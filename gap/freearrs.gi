#
# HypArr: Functions to analyse freeness properties
#
# Implementations
# #
############################################################

####################################################################################################
# Derivation modules
####################################################################################################

BindGlobal("DerivationModuleFamily",
    NewFamily("DerivationModuleFamily"));

InstallMethod(DerModGenerators,
	[IsDerivationModule],
D->D!.gens);

InstallMethod(DerModPRing,
	[IsDerivationModule],
D->D!.pring);

InstallMethod(DerModDegreeSequence,
	[IsDerivationModule],
function(D)
local degSeq, g, nzgs;
	nzgs:=[];
	for g in DerModGenerators(D) do
		Add(nzgs,g[Position(List(g,x->x<>Zero(DerModPRing(D))),true)]);
	od;
	degSeq := List(nzgs,g->SingularInterface("deg",[g],"int"));
	D!.degseq := degSeq;
	return D!.degseq;
end);

InstallMethod(DerModProjDim,
	[IsDerivationModule],
function(D)
local PRing, r, k, syzk;
	PRing := DerModPRing(D);
    r := Length(IndeterminatesOfPolynomialRing(PRing));
	SingularSetBaseRing(PRing);
	syzk := TransposedMat(DerModGenerators(D));
	for k in [1..r] do
		syzk := SingularInterface("syz",[syzk],"matrix");
		if not(false in List(syzk,x-> x = [Zero(PRing)])) then
			D!.projdim := k-1;
			return D!.projdim;
		fi;
	od;

	return fail;
end);

InstallMethod(DerModIsFree,
	[IsDerivationModule],
function(D)
	return DerModProjDim(D)=0;
end);


InstallMethod(HArrIsFree,
	[IsHyperplaneArrangement],
function(A)
	 return DerModIsFree(DerModule(A));
end);


InstallMethod(HArrIsLocallyFree,
	[IsHyperplaneArrangement],
function(A)
local L,Lk;
	L:=IntersectionLattice(A);
	Lk := LkFlats(L)(LRank(L)-1);
	return not( ForAny(Lk,m-> HArrIsFree(Arr(Roots(A){m}))=false));
end);



InstallMethod(ViewObj,
    [IsDerivationModule],
function(D)
    Print("<Derivation module\n",
		"  over ", DerModPRing(D), "\n",
        "  with ", Length(DerModGenerators(D)), " generators>");
end);

BindGlobal("LFormFromVector",
function(PRing,v)
local VarsPRing;
    VarsPRing := IndeterminatesOfPolynomialRing(PRing);
    if Length(VarsPRing)<>Length(v) then
        Print("Length of vector not equal to number of Variables.\n");
        return fail;
    fi;
    return Sum(List([1..Length(v)],i->v[i]*VarsPRing[i]));
end);

BindGlobal("MatrixDA",
function(A)
local PRing, DefField, e, r,n, i, M,VarsPRing;
    r := Dimension(A);
    n := Length(Roots(A));
    DefField := HArrDefField(A);
    PRing := PolynomialRing(DefField,r);
    VarsPRing := IndeterminatesOfPolynomialRing(PRing);
    e := VarsPRing[1]^0;
    M:=[];
    for i in [1..n] do 
        Add(M,Concatenation(e*Roots(A)[i],LFormFromVector(PRing,Roots(A)[i])*IdentityMat(n)[i]));
    od;
    return M;
end);

InstallMethod(DerModule,
	[IsHyperplaneArrangement],
function(A)
local MatDA, DA, PRing, ModGenDA, DefField, r, vars, type;
    r := Dimension(A);
    DefField := HArrDefField(A);
    if Roots(A) = [] then
        return One(DefField)*IdentityMat(r);
    fi;

    PRing := PolynomialRing(DefField,r);
	SetTermOrdering(PRing,"dp");

	SingularSetBaseRing(PRing);
    MatDA := MatrixDA(A);
    ModGenDA := SingularInterface( "syz", [SingularInterface("module", [MatDA], "module")], "matrix");
    ModGenDA := List(TransposedMat(ModGenDA),x->x{[1..r]});
	ModGenDA := TransposedMat(SingularInterface("minbase",[TransposedMat(ModGenDA)],"matrix"));
	
	type := NewType(DerivationModuleFamily,
                    IsDerivationModuleRep);

    return Objectify(type,
        rec(
            pring := PRing,
            gens := ModGenDA,
			deffield := DefField
			)
		);
end);

BindGlobal("MatrixDAmult",
function(A,mult)
local PRing, DefField, e, r,n, i, M,VarsPRing, vars;
    n := Length(Roots(A));
	if n<>Length(mult) then
		Print("Length of multiplicity vector not correct!\n");
		return fail;
	fi;
	r := Dimension(A);
    DefField := HArrDefField(A);
    PRing := PolynomialRing(DefField,r);
    VarsPRing := IndeterminatesOfPolynomialRing(PRing);
    e := VarsPRing[1]^0;
    M:=[];
    for i in [1..n] do 
        Add(M,Concatenation(e*Roots(A)[i],LFormFromVector(PRing,Roots(A)[i])^mult[i]*IdentityMat(n)[i]));
    od;

    return M;
end);

InstallMethod(DerModule,
	[IsHyperplaneArrangement, IsList],
function(A,mult)
local MatDAm, DA, PRing, ModGenDA, DefField, r, type;
    r := Dimension(A);
    DefField := HArrDefField(A);
    if Roots(A) = [] then
        return One(DefField)*IdentityMat(r);
    fi;

    PRing := PolynomialRing(DefField,r);
	SetTermOrdering(PRing,"dp");

	SingularSetBaseRing(PRing);
    MatDAm := MatrixDAmult(A,mult);
    ModGenDA := SingularInterface( "syz", [SingularInterface("module", [MatDAm], "module")], "matrix");
    ModGenDA := List(TransposedMat(ModGenDA),x->x{[1..r]});
	ModGenDA := TransposedMat(SingularInterface("minbase",[TransposedMat(ModGenDA)],"matrix"));

    type := NewType(DerivationModuleFamily,
                    IsDerivationModuleRep);

    return Objectify(type,
        rec(
            pring := PRing,
            gens := ModGenDA,
			deffield := DefField
			)
		);
end);



####################################################################################################
## Compuation of the D^p(A,m)-module

BindGlobal("MatrixDpAmult",
function(A,p,mult)
local PRing, DefField, e, r, n, VarsPRing, PSubs, KmSubs,
      N, q, M, allinds, i, h, K, j, J, col, posJ,
      row, avec, alphaPow, idxAux;

    n := Length(Roots(A));

    if n <> Length(mult) then
        Print("Length of multiplicity vector not correct!\n");
        return fail;
    fi;

    r := Dimension(A);

    if p < 1 or p > r then
        Print("The exterior degree is out of range!\n");
        return fail;
    fi;

    DefField := HArrDefField(A);
    PRing := PolynomialRing(DefField,r);
    VarsPRing := IndeterminatesOfPolynomialRing(PRing);
    e := VarsPRing[1]^0;

    PSubs := Combinations([1..r],p);
    KmSubs := Combinations([1..r],p-1);

    N := Length(PSubs);
    q := Length(KmSubs);

    allinds := [1..r];
    M := [];

    for i in [1..n] do
        avec := e*Roots(A)[i];
        alphaPow := LFormFromVector(PRing,Roots(A)[i])^mult[i];

        for h in [1..q] do
            K := KmSubs[h];
            row := List([1..N+n*q], u -> 0*e);

            for j in Difference(allinds,K) do
                J := Set(Concatenation(K,[j]));
                col := Position(PSubs,J);
                posJ := Position(J,j);

                row[col] := row[col] + ((-1)^(posJ-1))*avec[j];
            od;

            idxAux := N + (i-1)*q + h;
            row[idxAux] := alphaPow;

            Add(M,row);
        od;
    od;

    return M;
end);

# Then compute the syzygy module and project to the first
# coordinates:

InstallMethod(DerPModule,
	[IsHyperplaneArrangement, IsInt],
function(A,p)
local MatDp, Dp, PRing, ModGenDp, DefField, r, n,
      PSubs, N, type, e, mult;

    r := Dimension(A);
    n := Length(Roots(A));
	mult := List([1..n],x->1);;
    DefField := HArrDefField(A);

    if p < 1 or p > r then
        Print("The exterior degree is out of range!\n");
        return fail;
    fi;

    PRing := PolynomialRing(DefField,r);
    SetTermOrdering(PRing,"dp");
    SingularSetBaseRing(PRing);

    PSubs := Combinations([1..r],p);
    N := Length(PSubs);

    if Roots(A) = [] then
        e := IndeterminatesOfPolynomialRing(PRing)[1]^0;

        type := NewType(DerivationModuleFamily,
                         IsDerivationModuleRep);

        return Objectify(type,
            rec(
                pring := PRing,
                gens := e*IdentityMat(N),
                basis := PSubs,
                deffield := DefField
            )
        );
    fi;

    MatDp := MatrixDpAmult(A,p,mult);

    ModGenDp :=
        SingularInterface(
            "syz",
            [SingularInterface("module",[MatDp],"module")],
            "matrix"
        );

    ModGenDp := List(TransposedMat(ModGenDp), x -> x{[1..N]});

    ModGenDp :=
        TransposedMat(
            SingularInterface(
                "minbase",
                [TransposedMat(ModGenDp)],
                "matrix"
            )
        );

    type := NewType(DerivationModuleFamily,
                     IsDerivationModuleRep);

    return Objectify(type,
        rec(
            pring := PRing,
            gens := ModGenDp,
            basis := PSubs,
            deffield := DefField
        )
    );
end);


InstallMethod(DerPModule,
	[IsHyperplaneArrangement, IsInt, IsList],
function(A,p,mult)
local MatDp, Dp, PRing, ModGenDp, DefField, r, n,
      PSubs, N, type, e;

    r := Dimension(A);
    n := Length(Roots(A));
    DefField := HArrDefField(A);

    if p < 1 or p > r then
        Print("The exterior degree is out of range!\n");
        return fail;
    fi;

    PRing := PolynomialRing(DefField,r);
    SetTermOrdering(PRing,"dp");
    SingularSetBaseRing(PRing);

    PSubs := Combinations([1..r],p);
    N := Length(PSubs);

    if Roots(A) = [] then
        e := IndeterminatesOfPolynomialRing(PRing)[1]^0;

        type := NewType(DerivationModuleFamily,
                         IsDerivationModuleRep);

        return Objectify(type,
            rec(
                pring := PRing,
                gens := e*IdentityMat(N),
                basis := PSubs,
                deffield := DefField
            )
        );
    fi;

    MatDp := MatrixDpAmult(A,p,mult);

    ModGenDp :=
        SingularInterface(
            "syz",
            [SingularInterface("module",[MatDp],"module")],
            "matrix"
        );

    ModGenDp := List(TransposedMat(ModGenDp), x -> x{[1..N]});

    ModGenDp :=
        TransposedMat(
            SingularInterface(
                "minbase",
                [TransposedMat(ModGenDp)],
                "matrix"
            )
        );

    type := NewType(DerivationModuleFamily,
                     IsDerivationModuleRep);

    return Objectify(type,
        rec(
            pring := PRing,
            gens := ModGenDp,
            basis := PSubs,
            deffield := DefField
        )
    );
end);


####################################################################################################
## Test if the arrangement is inductively free
InstallMethod(IsInductivelyFree,
    [ IsHyperplaneArrangement ],
function(A)
local p,dim,i,j,r,AoH,AResH,tAoH,tAResH,c,expAoH,expAResH,expA,x,t;  
	# if IsBound(A!.IsInductivelyFree) then
	# 	return A!.IsInductivelyFree;
	# fi;
		
	dim:=Dimension(A);
	# t:=X(Rationals,"t");
	# expA := List(facQ(CharPolyArr(A)),x->-Value(x,[t],[0]));
	expA := ExpArr(A);
	# if Length(expA)<>dim then
	if expA=fail then
		SetIsInductivelyFree(A,false);
		return false;
	fi;
	
	c:=Length(Roots(A));
	if dim=2 or c<=2 then
		SetIsInductivelyFree(A,true);
        SetIsDivisionallyFree(A,true);
		return true;
	fi;
	r:=ShallowCopy(Roots(A));
	
	for i in [1..c] do
		# AoH:=Arr(r{Concatenation([1..(i-1)],[(i+1)..c])});
        AoH := HArrDeletion(A,i);
		AResH := HArrRestriction(A,i);

		expAResH := ExpArr(AResH);				
		expAoH := ExpArr(AoH);
		
		if expAResH<>fail and expAoH<>fail then
			if IsSubMultiSet(expAoH,expAResH) then
				tAoH:=IsInductivelyFree(AoH);
				if tAoH then
					tAResH:=IsInductivelyFree(AResH);
					if tAResH then
						SetIsInductivelyFree(A,true);
                        SetIsDivisionallyFree(A,true);
						return true;
					fi;
                fi;
			fi;
		fi;
	od;
	
	SetIsInductivelyFree(A,false);
	
	return false;
end);

InstallMethod(IsLocallyInductivelyFree,
	[IsHyperplaneArrangement],
function(A)
local L,Lk;
	L:=IntersectionLattice(A);
	Lk := LkFlats(L)(LRank(L)-1);
	return not( ForAny(Lk,m-> IsInductivelyFree(Arr(Roots(A){m}))=false));
end);

####################################################################################################
## Test if the arrangement A is divisionally free
####################################################################################################


InstallMethod(IsDivisionallyFree,
    [ IsHyperplaneArrangement ],function(A)
local AA,expAA,expA,h,n;

    # if IsBound(A!.IsDivisionallyFree) then
    #     return A!.IsDivisionallyFree;
    # fi;

    if Roots(A)=[] or Rank(Roots(A))<=2 then
        return true;
    fi;
    
    expA:=ExpArr(A);
    
    if expA= fail then
        return false;
    fi;
    
    n:=Length(Roots(A));
    
    for h in [1..n] do
        AA:=HArrRestriction(A,h);
        expAA:=ExpArr(AA);
        if expAA<>fail then
            if IsSubMultiSet(expA,expAA) and IsDivisionallyFree(AA) then
                SetIsDivisionallyFree(A,true);
                return true;
            fi;
        fi;
    od;
    SetIsDivisionallyFree(A,false);
	SetIsInductivelyFree(A,false);
    return false;    
end);

InstallMethod(IsLocallyDivisionallyFree,
	[IsHyperplaneArrangement],
function(A)
local L,Lk;
	L:=IntersectionLattice(A);
	Lk := LkFlats(L)(LRank(L)-1);
	return not( ForAny(Lk,m-> IsDivisionallyFree(Arr(Roots(A){m}))=false));
end);

####################################################################################################
# Global auxillary functions
####################################################################################################

InstallGlobalFunction(IsSubMultiSet,
function(T,S)
local i;
    for i in S do
        if Length(Positions(S,i))>Length(Positions(T,i)) then
            return false;
        fi;
    od;
    return true;
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

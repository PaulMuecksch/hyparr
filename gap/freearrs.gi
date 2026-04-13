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
## Test if the arrangement is inductively free
InstallMethod(IsInductivelyFree,
    [ IsHyperplaneArrangement ],
function(A)
local p,dim,i,j,r,AoH,AResH,tAoH,tAResH,c,expAoH,expAResH,expA,x,t;  
	if IsBound(A!.IsInductivelyFree) then
		return A!.IsInductivelyFree;
	fi;
		
	dim:=Dimension(A);
	# t:=X(Rationals,"t");
	# expA := List(facQ(CharPolyArr(A)),x->-Value(x,[t],[0]));
	expA := ExpArr(A);
	# if Length(expA)<>dim then
	if expA=fail then
		A!.IsInductivelyFree := false;
		return A!.IsInductivelyFree;
	fi;
	
	c:=Length(Roots(A));
	if dim=2 or c<=2 then
		A!.IsInductivelyFree:=true;
        A!.IsDivisionallyFree := true;
		return A!.IsInductivelyFree;
	fi;
	r:=ShallowCopy(Roots(A));
	
	for i in [1..c] do
		AoH:=Arr(r{Concatenation([1..(i-1)],[(i+1)..c])});
		AResH := HArrRestriction(A,i);

		expAResH := ExpArr(AResH);				
		expAoH := ExpArr(AoH);
		
		if expAResH<>fail and expAoH<>fail then
			if IsSubMultiSet(expAoH,expAResH) then
				tAoH:=IsInductivelyFree(AoH);
				if tAoH then
					tAResH:=IsInductivelyFree(AResH);
					if tAResH then
						# if p<>0 then
						# 	Print("  exp(A-{H}):",expAoH,"-> exp(A)",expA,", H:",Roots(A)[i],"\n");
						# fi;
						A!.IsInductivelyFree := true;
                        A!.IsDivisionallyFree := true;
						return A!.IsInductivelyFree;
					# else
					# 	if IsDivisionallyFree(AResH) then
					# 		Print("Divisionall free but not inductively free: ",AResH!.roots,"\n");
					# 	fi;
					# 	# if p <> 0 then
					# 	# 	Print("AResH nicht IF.\n");
					# 	# fi;
					fi;
				# else
					
				# 	if IsDF(AoH) then
				# 		Print("DF but not IF: ",AoH.roots,"\n");
				# 	fi;
				# 	if p <> 0 then
				# 		Print("AoH nicht IF.\n");
				# 	fi;
				fi;					
				#if IsInductivelyFree(AoH) and IsInductivelyFree(AResH) then
				#	A.IsInductivelyFree := true;
				#	return A.IsInductivelyFree;
				#fi;
			fi;
		fi;
	od;
	
	A!.IsInductivelyFree := false;
	
	return A!.IsInductivelyFree;
end);

####################################################################################################
## Test if the arrangement A is divisionally free
####################################################################################################


InstallMethod(IsDivisionallyFree,
    [ IsHyperplaneArrangement ],function(A)
local AA,expAA,expA,h,n;

    if IsBound(A!.IsDivisionallyFree) then
        return A!.IsDivisionallyFree;
    fi;

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
                A!.IsDivisionallyFree := true;
                return A!.IsDivisionallyFree;
            fi;
        fi;
    od;
    A!.IsDivisionallyFree := false;
	A!.IsInductivelyFree := false;
    return false;    
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

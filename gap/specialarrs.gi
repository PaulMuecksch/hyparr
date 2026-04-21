#
# HypArr: Some special arrangements
#
# Implementations
# #
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

####################################################################################################
## Construct the 3-dimensional supersolvable simplicial arrangement with 
## n hyperplanes, where n = 0 (mod 2) or n = 1 (mod 4). (n-gon with symmetries).
####################################################################################################

# cosinus
InstallGlobalFunction(cp,
function(p,k)
local zeta;
	zeta := E(2*p);
	return (zeta^k+zeta^(2*p-k))/2;
end);

# sinus
InstallGlobalFunction(sp,
function(p,k)
local zeta;
	zeta := E(2*p);
	return (zeta^k-zeta^(2*p-k))/(2*E(4));
end);

InstallGlobalFunction(SsS3,
function(m)
local k,n,R;
	
	if m<6 then
		Print("m >\= 6!  ");
		return fail;
	fi;
		
	if (m mod 2) = 1 then
		n:=(m-1)/2;
		if (n mod 2) = 0 then
			R:=Concatenation(
				[[0,0,1]],
				List([0..(n-1)],k->[-sp(n,k),cp(n,k),0]),
				List([0..(n-1)],k->[cp(n,2*k+1),sp(n,2*k+1),1])
				);
		else	
			Print("m = 1 (mod 4)!  ");
			return fail;
		fi;
	else
		n:=m/2;
		R:=Concatenation(
			List([0..(n-1)],k->[-sp(n,k),cp(n,k),0]),
			List([0..(n-1)],k->[cp(n,2*k+1),sp(n,2*k+1),1])
			);
	fi;
	
	return HyperplaneArrangement(R);
end);

####################################################################################################


InstallGlobalFunction(SimpGraphFromEdgeSet,
function(SetOfEdges)
local e,n, AdjMat;
	n := Maximum(Concatenation(SetOfEdges));
	AdjMat := NullMat(n,n);
	for e in SetOfEdges do
		AdjMat[e[1]][e[2]] := 1;
		AdjMat[e[2]][e[1]] := 1;
	od;
	return Graph( Group(()), [1..n], OnPoints, function(x,y) return AdjMat[x][y]=1; end, true );
end);

InstallGlobalFunction(ConnectedSubgraphArrG,
function(G)
local Gm, V, Vm, v, R, r, Imap;
    if not(IsConnectedGraph(G)) then
        return fail;
    fi;
    if Length(Vertices(G)) = 1 then
        return Arr([[1]]);
    fi;

    V := Vertices(G);
    R := [List(V,x->1)];
    for v in V do
        Vm := Difference(V,[v]);
        Gm := InducedSubgraph(G,Vm);
        if IsConnectedGraph(Gm) then
            r := 0*[1..Length(Vertices(G))];
            r{Vm} := List(Vm,x->1);
            Add(R,r);
            
            Imap := TransposedMat(IdentityMat(Length(V)){List(Vm,x->Position(V,x))});
            R := Concatenation( R, List( Roots(ConnectedSubgraphArrG(Gm)),x->Imap*x));
        fi;
    od;

    return Arr(R);
end);

InstallMethod( ConnectedSubgraphArr,
	[IsList],
function(Es)
local G;
    G := SimpGraphFromEdgeSet(Es);
    return ConnectedSubgraphArrG(G);
end);



####################################################################################################

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

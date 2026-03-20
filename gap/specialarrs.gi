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
	zeta := E(2*p);;
	return (zeta^k+zeta^(2*p-k))/2;;
end);

# sinus
InstallGlobalFunction(sp,
function(p,k)
local zeta;
	zeta := E(2*p);;
	return (zeta^k-zeta^(2*p-k))/(2*E(4));;
end);

InstallGlobalFunction(SsS3,
function(m)
local k,n,R;
	
	if m<6 then
		Print("m >\= 6!  ");;
		return fail;
	fi;
		
	if (m mod 2) = 1 then
		n:=(m-1)/2;
		if (n mod 2) = 0 then
			R:=Concatenation(
				[[0,0,1]],
				List([0..(n-1)],k->[-sp(n,k),cp(n,k),0]),
				List([0..(n-1)],k->[cp(n,2*k+1),sp(n,2*k+1),1])
				);;
		else	
			Print("m = 1 (mod 4)!  ");;
			return fail;
		fi;
	else
		n:=m/2;
		R:=Concatenation(
			List([0..(n-1)],k->[-sp(n,k),cp(n,k),0]),
			List([0..(n-1)],k->[cp(n,2*k+1),sp(n,2*k+1),1])
			);;
	fi;
	
	return HyperplaneArrangement(R);;
end);

####################################################################################################

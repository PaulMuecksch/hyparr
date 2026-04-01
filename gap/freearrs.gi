#
# HypArr: Functions to analyse freeness properties
#
# Implementations
# #
############################################################

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
		AResH := HArrResHind(A,i);

		expAResH := ExpArr(AResH);;				
		expAoH := ExpArr(AoH);;
		
		if expAResH<>fail and expAoH<>fail then
			if IsSubMultiSet(expAoH,expAResH) then
				tAoH:=IsInductivelyFree(AoH);
				if tAoH then
					tAResH:=IsInductivelyFree(AResH);
					if tAResH then
						# if p<>0 then
						# 	Print("  exp(A-{H}):",expAoH,"-> exp(A)",expA,", H:",A.roots[i],"\n");
						# fi;
						A!.IsInductivelyFree := true;
                        A!.IsDivisionallyFree := true;
						return A!.IsInductivelyFree;
					# else
					# 	if IsDivisionallyFree(AResH) then
					# 		Print("Divisionall free but not inductively free: ",AResH!.roots,"\n");;
					# 	fi;;
					# 	# if p <> 0 then
					# 	# 	Print("AResH nicht IF.\n");
					# 	# fi;
					fi;
				# else
					
				# 	if IsDF(AoH) then
				# 		Print("DF but not IF: ",AoH.roots,"\n");;
				# 	fi;;
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
end);;

####################################################################################################
## Test if the arrangement A is divisionally free
####################################################################################################


InstallMethod(IsDivisionallyFree,
    [ IsHyperplaneArrangement ],function(A)
local AA,expAA,expA,h,n;;

    if IsBound(A!.IsDivisionallyFree) then
        return A!.IsDivisionallyFree;
    fi;;

    if Roots(A)=[] or Rank(Roots(A))<=2 then
        return true;;
    fi;;
    
    expA:=ExpArr(A);;
    
    if expA= fail then
        return false;;
    fi;;
    
    n:=Length(Roots(A));;
    
    for h in [1..n] do
        AA:=HArrResHind(A,h);;
        expAA:=ExpArr(AA);;
        if expAA<>fail then
            if IsSubMultiSet(expA,expAA) and IsDivisionallyFree(AA) then
                A!.IsDivisionallyFree := true;;
                return A!.IsDivisionallyFree;
            fi;;
        fi;;
    od;;
    A!.IsDivisionallyFree := false;;
	A!.IsInductivelyFree := false;
    return false;;    
end);

####################################################################################################
# Global auxillary functions
####################################################################################################

InstallGlobalFunction(IsSubMultiSet,
function(T,S)
local i;;
    for i in S do
        if Length(Positions(S,i))>Length(Positions(T,i)) then
            return false;;
        fi;
    od;;
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

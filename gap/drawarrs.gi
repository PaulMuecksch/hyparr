#
# HypArr: Visualization of real 3-arrangements
#
# Implementations
# #


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

BindGlobal("FloatRound",
function(x,k)
	return Round(10^k*x)/10^k;
end);;

InstallGlobalFunction(FloatStringCutoff,
function(x,k)
local posdot;
	posdot := Position(x,'.');;
	if Length(x)-posdot >= k then
		return Concatenation(x{[1..posdot]},x{[posdot+1..posdot+k]});
	else
		return x;;
	fi;;
end);


coordstr := function(x)
    return FloatStringCutoff(String(FloatRound(x,2)),2);
end;;

InstallGlobalFunction(LaTeXDrawProjPicture,
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
			ip:=false;;
			Hind:=false;;
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
			rinf:=coordstr(18/17*r1);
			#xyinf:=String(Sqrt(2.0)/2*18/17*r1+0.35);;
			xyinf := coordstr(Sqrt(2.0)/2*18/17*r1);;

            if Mind=1 and Position(RR,vv) in MarkHs then
				if Hind then
					sp:=Concatenation(sp,
						"\\draw[color=red] (0,",rinf,") arc [start angle=90, end angle=0, radius=",rinf,"] ;\n",
						"\\node [above right] at (",xyinf,",",xyinf,") {$\\infty =$ \\small $",String(Position(RR,vv))," $};  % H_",String(Position(RR,vv))," \n");;
				else
					sp:=Concatenation(sp,
						"\\draw[color=red] (0,",rinf,") arc [start angle=90, end angle=0, radius=",rinf,"] ;\n",
						"\\node [above right] at (",xyinf,",",xyinf,") {$\\infty$};  % H_",String(Position(RR,vv))," \n");;
				fi;;
			else
			if Hind then
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
				x1:=coordstr(xc1);
				y1:=coordstr(yc1);
				x2:=coordstr(xc2);
				y2:=coordstr(yc2);

                if Mind=1 and Position(RR,vv) in MarkHs then
                    sp:=Concatenation(sp,"\\draw[color=red] (",x1,",",y1,") -- (",x2,",",y2,");  % H_",String(Position(RR,vv))," \n");;
                else
                    sp:=Concatenation(sp,"\\draw (",x1,",",y1,") -- (",x2,",",y2,");  % H_",String(Position(RR,vv))," \n");;
				fi;;

                if Hind then
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
					x1:=coordstr(xc1);
					y1:=coordstr(yc1);
					x2:=coordstr(xc2);
					y2:=coordstr(yc2);

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
	# sp:=Concatenation(sp, "\n");;
	if ip then
		sp:=Concatenation(sp, "\n");;
		for sv in LGroundSet(IntersectionLattice(A))[2] do
			a:=ctf(NullspaceMat(TransposedMat(R{sv}))[1]);;
			if AbsoluteValue(a[3]) > 0.0001 and a[1]^2+a[2]^2 < (r1/s)^2 then
				px:=coordstr(s*a[1]/a[3]);;
				py:=coordstr(s*a[2]/a[3]);;
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


#######################################################
# Draw intersection with sphere

BindGlobal("SphereGraph3Arr",
function(A)
local Vertices, Edges, ACs, vCs, d, L,R;
    d:= Dimension(A);;
    L := LGroundSet(IntersectionLattice(A));
    R:=Roots(A);;
    Vertices := List(L[2],x->NullspaceMat(TransposedMat(R{x}))[1]);;
    Vertices := Concatenation(Vertices,-Vertices);;
    vCs := List(Vertices,v->List(R*v,x->pos(x)));
    # Print(vCs);
    Vertices := List(Vertices,v->List(v,y->CCToFloat(y)));;
    Vertices := List(Vertices,v->v/Sqrt(v*v));
        
    Edges := Combinations([1..Length(vCs)],2);;
    Edges := Edges{Positions(List(Edges,x->OMOperation(vCs[x[1]],vCs[x[2]])=OMOperation(vCs[x[2]],vCs[x[1]]) and 0 in OMOperation(vCs[x[1]],vCs[x[2]])),true)};;
    
    return rec(DVertices := Vertices, DEdges := Edges, SignVectors := vCs);;
    
end); 

BindGlobal("PrintVerts",
function(Vs)
local rs, str, n,i,r ;;
    n:=Length(Vs);;
    str:="";;
    for i in [1..n-1] do
        r:=Vs[i];;
        rs := Concatenation(String(i),"/",coordstr(r[1]),"/",coordstr(r[2]),"/",coordstr(r[3]), ", \n");
        str := Concatenation(str,rs);
    od;;
    r:=Vs[n];;
    rs := Concatenation(String(n),"/",coordstr(r[1]),"/",coordstr(r[2]),"/",coordstr(r[3]), " \n");
    str := Concatenation(str,rs);

    return str;
end);

BindGlobal("PrintEdges",
function(Es,Vs)
local e, r1, r2, str;
    str := "";;
    for e in Es{[1..Length(Es)-1]} do
        r1:=Vs[e[1]];
        r2:=Vs[e[2]];;
        str := Concatenation(str,coordstr(r1[1]),"/",coordstr(r1[2]),"/",coordstr(r1[3]),"/  ",coordstr(r2[1]),"/",coordstr(r2[2]),"/",coordstr(r2[3]),", %",String(e)," \n");
    od;
    e:=Es[Length(Es)];
    r1:=Vs[e[1]];
    r2:=Vs[e[2]];;
    str := Concatenation(str,coordstr(r1[1]),"/",coordstr(r1[2]),"/",coordstr(r1[3]),"/  ",coordstr(r2[1]),"/",coordstr(r2[2]),"/",coordstr(r2[3])," %",String(e)," \n");

    return str;;

end);


InstallGlobalFunction(LaTeXDrawSpherePicture,
function(A)
local G,Vs, Es, fn, s1,s2,s3, str;
    G:=SphereGraph3Arr(A);;
    Vs:=G.DVertices;
    Es:=G.DEdges;;

    fn:=Filename(GAPInfo.PackageDirectories[1],"hyparr/gap/graphonsphere_1");
    s1:=ReadAll(InputTextFile(fn));
    fn:=Filename(GAPInfo.PackageDirectories[1],"hyparr/gap/graphonsphere_2");
    s2:=ReadAll(InputTextFile(fn));
    fn:=Filename(GAPInfo.PackageDirectories[1],"hyparr/gap/graphonsphere_3");
    s3:=ReadAll(InputTextFile(fn));
    str := Concatenation(s1,PrintVerts(Vs),s2,PrintEdges(Es,Vs),s3);;
    return str;;
end);;

##
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
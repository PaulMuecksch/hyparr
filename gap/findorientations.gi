#
# HypArr: Find orientations of a geomeric lattice
#
## Implementations

InstallGlobalFunction(BasesToCNF,
function(r,n,Bs)
local zv, zv2, BsSet, varOf, inBs,
    CNFStr, cn, clauses, SignSUV,
    S, abcd, a,b,c,d,
    B_ab, B_cd, B_ac, B_bd, B_ad, B_bc,
    id_ab, id_cd, id_ac, id_bd, id_ad, id_bc,
    s_ab, s_cd, s_ac, s_bd, s_ad, s_bc,
    sv, sv_full, sv_4term, sv_4term_ac,
    F, B0, e_r, e_r1, i, k, base, IBi, 
    ClausesToCNFStr;

    ClausesToCNFStr :=function(nvar,cl)
    local str;
        str := JoinStringsWithSeparator( List(cl,c-> JoinStringsWithSeparator(List(c,x->String(x))," "))," 0\n");
        str := Concatenation("p cnf ", String(nvar), " ", String(Length(cl)),"\n",str, " 0\n");
        return str;
    end;

    # BsSet := Set(Combinations([1..n],r){BsIDs});
    BsSet := Set(Bs);

    #
    varOf := B -> PositionSet(BsSet, B);     # returns fail if B not in Bs
    inBs  := B -> PositionSet(BsSet, B) <> fail;

    # CNFStr := "";
    # cn := 0;
    clauses := [];

    SignSUV := function(S, u, v)
        return SignPerm( PermList(List([1..r],x->Position(Union(S,[u,v]),Concatenation(S,[u,v])[x]))) );
        # local inv;
        # # S is sorted and u,b are not in  S
        # inv := Number(S, x -> x > u) + Number(S, x -> x > v);
        # if u > v then inv := inv + 1; fi;
        # if inv mod 2 = 0 then
        #     return 1;
        # else
        #     return -1;
        # fi;
    end;

    sv_full := [    
        [  -1,  -1,  -1,   1,  -1,  -1 ],
        [  -1,  -1,  -1,   1,   1,   1 ],
        [  -1,  -1,   1,  -1,  -1,  -1 ],
        [  -1,  -1,   1,  -1,   1,   1 ],
        [  -1,   1,  -1,  -1,  -1,   1 ],
        [  -1,   1,  -1,  -1,   1,  -1 ],
        [  -1,   1,   1,   1,  -1,   1 ],
        [  -1,   1,   1,   1,   1,  -1 ],
        [   1,   1,   1,  -1,   1,   1 ],
        [   1,   1,   1,  -1,  -1,  -1 ],
        [   1,   1,  -1,   1,   1,   1 ],
        [   1,   1,  -1,   1,  -1,  -1 ],
        [   1,  -1,   1,   1,   1,  -1 ],
        [   1,  -1,   1,   1,  -1,   1 ],
        [   1,  -1,  -1,  -1,   1,  -1 ],
        [   1,  -1,  -1,  -1,  -1,   1 ] ];

    sv_4term_ac := [
        [   1,   1,  -1,   1 ],
        [   1,   1,   1,  -1 ],
        [   1,  -1,   1,   1 ],
        [   1,  -1,  -1,  -1 ],
        [  -1,   1,   1,   1 ],
        [  -1,   1,  -1,  -1 ],
        [  -1,  -1,  -1,   1 ],
        [  -1,  -1,   1,  -1 ]];


    sv_4term := [
        [   1,   1,   1,   1 ],
        [   1,   1,  -1,  -1 ],
        [   1,  -1,   1,  -1 ],
        [   1,  -1,  -1,   1 ],
        [  -1,   1,   1,  -1 ],
        [  -1,   1,   1,  -1 ],
        [  -1,  -1,   1,   1 ],
        [  -1,  -1,  -1,  -1 ]];

    # Fixing some bases to have sign 1 from the start
    # This breaks the reorientation symmetry
    B0:=BsSet[1];
    Add(clauses, [1]);
    for i in Difference([1..n],B0) do
        IBi := Position(List(BsSet,B->i in B and IsSubset(Union(B0,[i]),B)),true);
        Add(clauses, [IBi]);
    od;
    
    zv:=0;;
    zv2:=0;;

    for S in Combinations([1..n], r-2) do
        for abcd in Combinations(Difference([1..n],S),4) do
            a := abcd[1]; 
            b := abcd[2]; 
            c := abcd[3]; 
            d := abcd[4];

            B_ab := Union(S, [a,b]);
            B_cd := Union(S, [c,d]);
            B_ac := Union(S, [a,c]);
            B_bd := Union(S, [b,d]);
            B_ad := Union(S, [a,d]);
            B_bc := Union(S, [b,c]);

            # if  Number( [B_ab,B_cd], B->inBs(B) )=2 or
            #     Number( [B_ac,B_bd], B->inBs(B) )=2 or
            #     Number( [B_ad,B_bc], B->inBs(B) )=2 then
            #     zv := zv+1;
            # fi;
            if inBs(B_ab) and inBs(B_cd) then
            # zv2 := zv2+1;
                id_ab := varOf(B_ab); 
                id_cd := varOf(B_cd);
                s_ab := SignSUV(S, a, b);
                s_cd := SignSUV(S, c, d);

                # all 6 bases exist
                if inBs(B_ac) and inBs(B_bd) and inBs(B_ad) and inBs(B_bc) then
                    id_ac := varOf(B_ac); 
                    id_bd := varOf(B_bd);
                    id_ad := varOf(B_ad); 
                    id_bc := varOf(B_bc);

                    s_ac := SignSUV(S, a, c);
                    s_bd := SignSUV(S, b, d);
                    s_ad := SignSUV(S, a, d);
                    s_bc := SignSUV(S, b, c);

                    for sv in sv_full do
                        Add(clauses,
                            [sv[1]*s_ab*id_ab, 
                            sv[2]*s_cd*id_cd, 
                            sv[3]*s_ac*id_ac, 
                            sv[4]*s_bd*id_bd, 
                            sv[5]*s_ad*id_ad, 
                            sv[6]*s_bc*id_bc]);
                    od;
                elif inBs(B_ac) and inBs(B_bd) then
                    id_ac := varOf(B_ac);
                    id_bd := varOf(B_bd);

                    s_ac := SignSUV(S, a, c);
                    s_bd := SignSUV(S, b, d);

                    for sv in sv_4term_ac do
                        Add(clauses,[sv[1]*s_ab*id_ab, sv[2]*s_cd*id_cd, sv[3]*s_ac*id_ac, sv[4]*s_bd*id_bd]);
                    od;
                elif inBs(B_ad) and inBs(B_bc) then
                    id_ad := varOf(B_ad); 
                    id_bc := varOf(B_bc);

                    s_ad := SignSUV(S, a, d);
                    s_bc := SignSUV(S, b, c);

                    for sv in sv_4term do
                        Add(clauses,[sv[1]*s_ab*id_ab, sv[2]*s_cd*id_cd, sv[3]*s_ad*id_ad, sv[4]*s_bc*id_bc]);
                    od;
                fi;
            elif inBs(B_ac) and inBs(B_bd) and inBs(B_ad) and inBs(B_bc) then
            # zv2 := zv2+1;
                id_ac := varOf(B_ac); 
                id_bd := varOf(B_bd);
                id_ad := varOf(B_ad); 
                id_bc := varOf(B_bc);

                s_ac := SignSUV(S, a, c);
                s_bd := SignSUV(S, b, d);
                s_ad := SignSUV(S, a, d);
                s_bc := SignSUV(S, b, c);

                for sv in sv_4term_ac do
                    Add(clauses,[sv[1]*s_ac*id_ac, sv[2]*s_bd*id_bd, sv[3]*s_ad*id_ad, sv[4]*s_bc*id_bc]);
                od;
            fi;
        od;
    od;
    CNFStr := ClausesToCNFStr(Length(Bs),clauses);
    # Print(zv, " ", Binomial(n,r-2)*Binomial(n-r+2,4),"\n");
    # Print(zv2, "\n");
    return rec( cnfstr := CNFStr, nvar := Length(Bs), nclauses := Length(clauses) );
end);

# extract the solutions from the text output of an SAT-solver

InstallGlobalFunction(ParseSATSolutions,
function(text)
local pss, pse, slist, i, ps, pe, tn, pslb, sls, sl, tnn, j, pws;

    pss:= Positions(text,'s');
    pss := Filtered(pss,x->text{[x..x+12]} = "s SATISFIABLE");

    pse := Positions(text,'c');
    pse := Filtered(pse,x->text{[x..x+12]} = "c initialized");
    pse := pse{[2..Length(pse)]};;

    slist:=[];;

    for i in [1..Length(pss)] do
        ps:=pss[i]+14;
        pe := pse[i]-3;
        tn := text{[ps..pe]};
        # Print(tn,"\n\n");;
        pslb := Union([1],Positions(tn,'\n'),[Length(tn)+1]);;
        sls := [];;
        for j in [1..Length(pslb)-1] do
            tnn := tn{[pslb[j]+1..pslb[j+1]-1]};
            sl := [];
            pws := Union(Positions(tnn,' '),[Length(tnn)+1]);
            # pws := Positions(tnn,' ');
            # Print(Positions(tnn,' '),"\n",Positions(tn,'\n') ,"\n\n");;
            Add(sls,List([1..Length(pws)-1],x->Int(tnn{[pws[x]+1..pws[x+1]-1]})));
        od;
        Add(slist,Concatenation(sls));
    od;;

    return List(slist,s->s{[1..Length(s)-1]});
end);

# convert the SAT-solutions to lists giving chirotope cores

InstallGlobalFunction(BsSIDsToChi,
function(r,n,BsIDs,sol)
local chi, i;
    chi := List([1..Binomial(n,r)],x->0);
    if Length(BsIDs)<>Length(sol) then 
        Print("Number of bases not equal to length of solution list!\n");
        return fail;
    fi;
    for i in [1..Length(BsIDs)] do
        if sol[i]>0 then chi[BsIDs[i]]:=1; fi;
        if sol[i]<0 then chi[BsIDs[i]]:=-1; fi;
    od;;
    return chi;
end);

InstallGlobalFunction( PicoSATOrientations,
function(r,n,Bs)
local UBs, BsIs, cnf, picosat, TempDir, cnffile, strresult, 
    out, sols; 

    UBs:=Combinations([1..n],r);;
    BsIs:=List(Bs,x->Position(UBs,x));;

    cnf := BasesToCNF(r,n,Bs);;
    picosat := PathSystemProgram("picosat");
    TempDir:=DirectoryTemporary();
    cnffile := Filename(TempDir,"cnfpico");
    PrintTo(cnffile,cnf.cnfstr);

    strresult:="";; 
    out := OutputTextString(strresult,true);

    Process(TempDir, picosat, InputTextFile(cnffile), out, ["-v","--all"]);;

    sols := ParseSATSolutions(strresult);

    return sols;

end);

#########################################################################

InstallMethod(LFindOrientations,
    [IsGeomLattice],
function(L)
local Bases, BsIDs, chiros, r,n;
    r := LRank(L);
    n := Length(LAtoms(L));
    Bases := LBases(L);
    BsIDs:=List(Bases,B->Position(Combinations([1..n],r),B));
    chiros := List(PicoSATOrientations(r,n,Bases),s->BsSIDsToChi(r,n,BsIDs, s));
    return List(chiros,chi->OM(r,n,chi));
end);

# p cnf 3 2
# 1 2 -3 0
# -2 3 0

# k:=0; l:=0;
# k11:=0;
# k12:=0;
# k11_12:=0;
# r:=Length(Bs[1]);
# for PBs in Combinations(Bs,2) do
#     B1:=PBs[1];
#     B2:=PBs[2];
#     IPBs := Intersection(B1,B2);
#     if Length(IPBs)=r-2 then
#         k:=k+1;
#         DiffB1 := Difference(B1,IPBs);
#         DiffB2 := Difference(B2,IPBs);
#         A11 := Union([DiffB1[1],DiffB2[1]],IPBs);
#         A12 := Union([DiffB1[1],DiffB2[2]],IPBs);
#         A21 := Union([DiffB1[2],DiffB2[1]],IPBs);
#         A22 := Union([DiffB1[2],DiffB2[2]],IPBs);
#         if A11 in Bs and A22 in Bs then
#             k11:=k11+1;
#         fi;
#         if A12 in Bs and A21 in Bs then
#             k12 := k12+1;
#         fi;
#         if A11 in Bs and A22 in Bs and A12 in Bs and A21 in Bs then
#             k11_12:=k11_12+1;
#         fi;
#     fi;
# od;




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
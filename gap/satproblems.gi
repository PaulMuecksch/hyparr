#
# HypArr: SAT-problems
#
## Implementations


BindGlobal("SATProblemFamily",
    NewFamily("SATProblemFamily"));

InstallMethod(ViewObj,
    [ IsSATProblem ],
function(SProb)
    Print("<SAT-problem with ",
          SATnvariables(SProb), " variables and ",
          Length(SATClauses(SProb)), " clauses>");
end);

InstallMethod( SATnvariables,
    [ IsSATProblem ],
    SProb -> SProb!.nvars);

InstallMethod(SATClauses,
    [ IsSATProblem ],
    SProb -> SProb!.clauseslist);

InstallMethod( SATallSolutions,
    [ IsSATProblem ],
    SProb -> SProb!.allsols);

InstallMethod(SATSolutions,
    [ IsSATProblem ],
    SProb -> SProb!.sols);

InstallGlobalFunction(ClausesToCNFStr,
function(nvar,cl)
local str;
    str := JoinStringsWithSeparator( List(cl,c-> JoinStringsWithSeparator(List(c,x->String(x))," "))," 0\n");
    str := Concatenation("p cnf ", String(nvar), " ", String(Length(cl)),"\n",str, " 0\n");
    return str;
end);

InstallMethod(SATCNFStr,
    [ IsSATProblem ],
function(SProb)
    return ClausesToCNFStr(SATnvariables(SProb),SATClauses(SProb));
end);

InstallMethod(SATProblem,
    [IsInt, IsList, IsBool],
function(nv,cl,allsols)
local type;

    type := NewType(SATProblemFamily,
                    IsSATProblemRep);

    return Objectify(type,
        rec(
            nvars := nv,
            clauseslist := cl,
            allsols := allsols
        )
    );
end);

BindGlobal("HypArr_SATSolsCUTOFF", 500);

# extract the solutions from the text output of an SAT-solver
InstallGlobalFunction(ParseSATSolutions,
function(text)
local pss, pse, slist, i, ps, pe, tn, pslb, sls, sl, tnn, j, pws, len;
    len := Length(text);

    pss:= Positions(text,'s');
    pss := Filtered(pss,x-> x+12 <= len and text{[x..x+12]} = "s SATISFIABLE");

    # locate the terminating " 0" of each solution; a solution whose
    # terminator is missing (output truncated) is discarded rather than
    # scanned past the end of the string
    pse:=[];;
    for ps in pss do
        i:=ps+14;
        while i <= len and text{[i-1,i]}<>" 0" do
            i:=i+1;
        od;
        if i > len then
            break;
        fi;
        Add(pse,i);
    od;
    pss := pss{[1..Length(pse)]};;

    # pse := Positions(text,'c');
    # pse := Filtered(pse,x->text{[x..x+12]} = "c initialized");
    # pse := pse{[2..Length(pse)]};;

    slist:=[];;

    for i in [1..Length(pss)] do
        ps:=pss[i]+14;
        pe := pse[i];
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

# solve an SAT-problem using picosat
InstallMethod(SATSolve,
    [IsSATProblem],
function(SProb)
local cnfstr, picosat, picoenum, dir, cnffile, strresult, 
    out, sols, inputstr;

    picosat := PathSystemProgram("picosat");
    picoenum := Filename(DirectoriesPackagePrograms("hyparr"),"picoenum");
    cnfstr := SATCNFStr(SProb);
    # dir:=DirectoryTemporary();
    dir:=DirectoryCurrent();
    # cnffile := Filename(dir,"cnfpico");
    # PrintTo(cnffile,cnfstr);
    inputstr := InputTextString(cnfstr);
    strresult:="";; 
    out := OutputTextString(strresult,true);

    if SATallSolutions(SProb) then
        Process(dir, picoenum, inputstr, out, [String(HypArr_SATSolsCUTOFF)]);;
        # Process(dir, picosat, inputstr, out, ["--all"]);;
        # Process(dir, picosat, InputTextFile(cnffile), out, ["-v","--all"]);;
    else
        Process(dir, picoenum, inputstr, out, ["1"]);;
        # Process(dir, picosat, inputstr, out, []);;
        # Process(dir, picosat, InputTextFile(cnffile), out, ["-v"]);;
    fi; 

    # RemoveFile(cnffile);
    
    sols := ParseSATSolutions(strresult);

    SProb!.sols := sols;
    
    SetSATSolutions(SProb,sols);

    return sols;
end);


#########################################################################



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
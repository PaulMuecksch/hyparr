#
# HypArr: Relization spaces of geometric lattices
#
#$ Implementations


BindGlobal("RealizationSpaceOfGeomLatticeFamily",
    NewFamily("IsRealizationSpaceOfGeomLatticeFamily"));

InstallMethod(ViewObj,
    [ IsRealizationSpaceOfGeomLattice ],
function(RS)
    Print("<RealizationSpaceOfGeomLattice: in characteristic",
           RSCharacteristic(RS), ", non-empty:",RSIsNonEmpty,">");
end);

InstallMethod(RSLattice,
    [ IsRealizationSpaceOfGeomLattice ],
    RS -> RS!.lattice);

InstallMethod(RSCharacteristic,
    [ IsRealizationSpaceOfGeomLattice ],
    RS -> RS!.char);

InstallMethod(RSDefField,
    [ IsRealizationSpaceOfGeomLattice ],
    RS -> RS!.dfield);

InstallMethod(RSCoeffMat,
    [ IsRealizationSpaceOfGeomLattice ],
    RS -> RS!.coeffmat);

InstallMethod(RSDimension,
    [ IsRealizationSpaceOfGeomLattice ],
    RS -> RS!.dim);

InstallMethod(RSPRing,
    [ IsRealizationSpaceOfGeomLattice ],
    RS -> RS!.pring);

InstallMethod(RSIdealMinors,
    [ IsRealizationSpaceOfGeomLattice ],
    RS -> RS!.idealminors);

InstallMethod(RSIdealNonMinors,
    [ IsRealizationSpaceOfGeomLattice ],
    RS -> RS!.idealnonminors);

InstallMethod(RSIsNonEmpty,
    [ IsRealizationSpaceOfGeomLattice ],
    RS -> RS!.isrep);


#######################################################
##
## Computation of realization space 
##
#######################################################

BindGlobal("GenPointAndLineOfEltFromGenSet",
function(L,GenSet,e)
local rkFkt,rL,PsOverElt,LsOverElt,GenPs,pos, PLPairOverElt,POverElt,LOverElt;
    rkFkt := RankL(L);
    rL := Length(L);
    PsOverElt := L[rL-1]{Positions(List(L[rL-1],p->e in p and rkFkt(Intersection(GenSet,p))=rL-1 ),true)};
    LsOverElt := L[2]{Positions(List(L[2],l->e in l and rkFkt(Intersection(GenSet,l))=2 ),true)};
    PLPairOverElt := Cartesian(PsOverElt,LsOverElt);
    pos := Position(List(PLPairOverElt,pl -> Length(Intersection(pl))=1),true);
    if pos<>fail then
        PLPairOverElt := PLPairOverElt[pos];
        POverElt := PLPairOverElt[1];
        LOverElt := Intersection(PLPairOverElt[2],GenSet){[1,2]};
        POverElt := Combinations(Intersection(POverElt,GenSet),rL-1);
        POverElt := POverElt[Position(List(POverElt,p->rkFkt(p)=rL-1),true)];
        return [POverElt,LOverElt];
    fi;
    return fail;
end);


InstallMethod(LSubsetGeneratedByS,
    [IsGeomLattice,IsList],
function(L,S)
local Sn1,Sn2, Es, newElts, e, Atoms;
#     Es := Concatenation(L[1],S);
    newElts := true;
    Sn1 := ShallowCopy(S);
    Atoms := LAtoms(L);
    while newElts=true do
        Es := Difference(Concatenation(Atoms),Sn1);
        Sn2 := ShallowCopy(Sn1);
        for e in Es do
            if GenPointAndLineOfEltFromGenSet(L,Sn2,e)<>fail then
                Add(Sn2,e);
            fi;
        od;
        if Length(Sn2)=Length(Sn1) then
            newElts := false;
        else
            Sn1 := Sn2;
        fi;
    od;
    return Sn2;
end);

InstallMethod(LIsGenSet,
    [IsGeomLattice,IsList],
function(L,S)
local rkFkt,rL,PsFormS,EsFromS,Sn,Es,e;
    if Length(LSubsetGeneratedByS(L,S))=Length(LAtoms(L)[1]) then
        return true;
    fi;
    
    return false;
end);

InstallMethod(LGenSet,
    [IsGeomLattice],
function(L)
local genSet;
    if IsBound(L!.genset) then
        return L!.genset;
    fi;


end);

InstallMethod(RealizationSpaceOfGeomLattice,
    "for a geometric lattice and a characteristic",
    [IsGeomLattice, IsInt],
function(L,char)
local type, ml, fI, eR,sI,rI, rkL, rkFkt, Bs, DepSs, VarRing, VarRingExt, IMat, A, Det, GenSetL, IdealVanishingMinors,NonVanishingMinors, f, ff, GenMinors,g, b, DefIdeal,
    L,K, IsRepresentable, AssPrimesDefIdeal, dim, fr;
    # local L, dfield, gset, cmat, isrep, dim, PRing,IMinors,INMinors;
    # "lattice","char","deffield","coeffmat",
    # "isrep","dimension",
    # "pring","idealminors","idealnonminors"

    type := NewType(RealizationSpaceOfGeomLatticeFamily,
                    IsRealizationSpaceOfGeomLatticeRep);

    return Objectify(type,
        rec(
        )
    );
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
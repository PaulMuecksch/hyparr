#
# HypArr: Computations with tope posets
#
# Implementations
# #


BindGlobal("TopePosetFamily",
    NewFamily("TopePosetFamily"));

InstallMethod(ViewObj,
    [ IsTopePoset ],
function(TP)
local GSet;
    GSet := TPGroundSet(TP);;
    Print("<TopePoset with ",
          Length(GSet)," topes>");
end);


InstallMethod(TPGroundSet,
    [ IsTopePoset ],
    TP -> TP!.grgroundset);

InstallMethod(TPBastTope,
    [ IsTopePoset ],
    TP -> TP!.btope);

InstallMethod(TopePoset,
    [ IsOrientedMatroid, IsList ],
function(OM,BTope)
local Ps, gset, OF, type, Topes, n;
    Topes := OMCovectors(OM)[1];;
    n := Length(BTope);;
    Ps := List(Topes,T->SeparatingSet(BTope));;
    Sort(Ps);;
    gest:=Concatenation(List([0..n],x->Ps{Positions(List(Ps,y->Length(y)),x)}));;
    
    type := NewType(TopePosetFamily,
                    IsTopePosetRep);

    return Objectify(type,
        rec(
            grgroundset := gset,
			bt := BaseTope
        )
    );
end);;


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

#
# HypArr: Greedy search for special arrangements
#
#$ Implementations


BindGlobal("HArrGreedySearchFamily",
    NewFamily("IsHArrGreedySearchFamily"));

InstallMethod(ViewObj,
    [ IsHArrGreedySearch ],
function(GS)
    Print("GreedySearch: over ",
           GreedySearchGF(GS), ",\n", 
           "for arrangements of rank: ",GreedySearchDimension(GS),"\n",
           "with ",GreedySearchNOfHs(GS)," hyperplanes");
end);

InstallMethod(GreedySearchGF,
    [ IsHArrGreedySearch ],
    GS -> GS!.gf);

InstallMethod(GreedySearchDimension(,
    [ IsHArrGreedySearch ],
    GS -> GS!.dim);

InstallMethod(GreedySearchNOfHs,
    [ IsHArrGreedySearch ],
    GS -> GS!.nhs);

InstallMethod(GreedySearchTargetFct,
    [ IsHArrGreedySearch ],
    GS -> GS!.targetfct);

InstallMethod(GreedySearchRun,
    [ IsHArrGreedySearch ],
    GS -> GS!.runsearch;

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
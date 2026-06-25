#
# HypArr: Find orientations of a geomeric lattice
#
#! @Chapter Orientations of matroids

DeclareGlobalFunction("BasesToCNF");
DeclareGlobalFunction("ParseSATSolutions");
DeclareGlobalFunction("BsSIDsToChi");
DeclareGlobalFunction("PicoSATOrientations");

#################################
##
#! @Section Find orientations of a given geometric lattice
##
#################################

#! @Arguments L
#! @Returns A list of oriented matroids
#! @Description
#! Computes all oriented matroids (up to some isomorphisms) which have <A>L</A>
#! as underlying matroid structe or geometric lattice.
#!
#! Depending on this size of <A>L</A> this might take a considerable amount of time
#! and there may be many orientations depending on the sparsety of relations in <A>L</A>.
#! The algorithm reformulates the problem of determining orientations to
#! an SAT-instance and then uses an SAT-solver (currently PicoSAT as a standard) to solve.
#! @BeginExampleSession
#! gap> A:=AGpql(2,2,3); L:=IntersectionLattice(A); Bs:=LBases(L);; Length(Bs);
#! <HyperplaneArrangement: 6 hyperplanes in 3-space>
#! <Geometric lattice: 6 atoms, rank 3>
#! 16
#! gap> OMs:=FindOrientations(L);
#! [ <OrientedMatroid: 6 elements, rank 3>, 
#!   <OrientedMatroid: 6 elements, rank 3>, 
#!   <OrientedMatroid: 6 elements, rank 3>, 
#!   <OrientedMatroid: 6 elements, rank 3> ]
#! @EndExampleSession
DeclareOperation("LFindOrientations",[IsGeomLattice]);



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
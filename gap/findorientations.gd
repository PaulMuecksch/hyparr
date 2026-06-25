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
#! and there may be many orientations depending on the sparsity of relations in <A>L</A>.
#! 
#! The algorithm converts the problem of determining orientations to
#! an SAT-instance and then uses an SAT-solver (currently PicoSAT) to solve.
#! @BeginExampleSession
#! gap> A:=AGpql(2,1,4); L:=IntersectionLattice(A); Bs:=LBases(L);; Length(Bs);
#! <HyperplaneArrangement: 16 hyperplanes in 4-space>
#! <Geometric lattice: 16 atoms, rank 4>
#! 1138
#! gap> OMs:=LFindOrientations(L);
#! [ <OrientedMatroid: 16 elements, rank 4>, 
#!   <OrientedMatroid: 16 elements, rank 4>, 
#!   <OrientedMatroid: 16 elements, rank 4>, 
#!   <OrientedMatroid: 16 elements, rank 4>, 
#!   <OrientedMatroid: 16 elements, rank 4>, 
#!   <OrientedMatroid: 16 elements, rank 4>, 
#!   <OrientedMatroid: 16 elements, rank 4>, 
#!   <OrientedMatroid: 16 elements, rank 4> ]
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
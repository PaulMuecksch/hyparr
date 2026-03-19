#
# HypArr: Computations with milnor fibers
#
#! @Chapter Milnor fibers
#!
#! The Milnor fiber is the typical fiber <M>f^{-1}</M> of the Milnor fibration 
#! <Display>f:\mathbb{C}^\ell \setminus \cup_{H \in \mathcal{A}}H \to \mathbb{C}^\times, z\mapsto \prod_{H \in \mathcal{A}}\alpha_H(z)</Display>
#! of the hyperplane arrangement <M>\mathcal{A}</M>, where <M>\alpha_H</M> are defining linear forms.
#!
#! The following describes functions to construct regular cell complex having the homotopy type of
#! the Milnor fiber and thus enables computation of homotopy invaraints using e.g. the HAP package.


#################################
##
#! @Section Attributes
##
#################################

#! @Arguments OM
#! @Returns FacePoset
#! @Description
#! Computes the face poset of the regular cell complex
#! of the combinatorial Milnor fiber of the oriented matroid <A>OM</A>. 
#! @BeginExampleSession
#! gap> A:=AGpql(2,2,3);
#! <HyperplaneArrangement: 6 hyperplanes in 3-space>
#! gap> MCpx:=MilnorFiberComplex(A);
#! <FacePoset of dimension 2 with f-vector [ 12, 60, 60 ]>
#! @EndExampleSession
DeclareAttribute("MilnorFiberComplex", IsOrientedMatroid);

#! @Arguments A
#! @Returns FacePoset
#! @Description
#! Computes the face poset of the regular cell complex
#! having the homotopy type of Milnor fiber of the arrangement <A>A</A>. 
#! @BeginExampleSession
#! gap> O:=OrientedMatroid([[1,0],[0,1],[1,1]]);
#! <OrientedMatroid: 3 elements, rank 2>
#! gap> MCpx:=MilnorFiberComplex(O);
#! <FacePoset of dimension 1 with f-vector [ 3, 6 ]>
#! @EndExampleSession
DeclareAttribute("MilnorFiberComplex", IsHyperplaneArrangement);

#################################
##
#! @Section Global methods
##
#################################


DeclareGlobalFunction("rkSubDivCodim1");

DeclareGlobalFunction("RUp");

DeclareGlobalFunction("MCpxOF");

#! @Arguments FP
#! @Returns HAP CW Complex
#! @Description
#! Converts a <B>HypArr</B> <C>FacePoset</C> into a <B>HAP</B> CW-complex
#! for computing topological invariants.
#! @BeginExampleSession
#! gap> A:=AGpql(2,2,3);
#! <HyperplaneArrangement: 6 hyperplanes in 3-space>
#! gap> MCpx:=MilnorFiberComplex(A);
#! <FacePoset of dimension 2 with f-vector [ 12, 60, 60 ]>
#! gap> MCW := FPtoCWCpx(MCpx);
#! Regular CW-complex of dimension 2
#! gap> Homology(MCW,0);
#! [ 0 ]
#! gap> Homology(MCW,1);
#! [ 0, 0, 0, 0, 0, 0, 0 ]
#! @EndExampleSession
DeclareGlobalFunction("FPtoCWCpx");



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

#
# HypArr: Visualization of real 3-arrangements
#
#! @Chapter Visualization of real 3-arrangements


#################################
##
#! @Section Global methods
##
#################################

#! @Arguments A,[ps,[ip,[Hind,[disthv,[MarkHs]]]]]
#! @Returns A string.
#! @Description
#! Generates LaTeX tikz-code
#! for a nice projective picture of the real 3-arrangement.
#! If $x,y,z$ are the coordinates, by default, 
#! this is the 2-dim affine arrangement
#! obtained by intersecting <A>A</A> with the plane $z=1$.
#! 
#! The optional parameters are:
#!  * <A>ps</A> a scaling factor,
#!  * <A>ip</A> intersection points are drawn,
#!  * <A>Hind</A> labels for the hyperplanes are added,
#!  * <A>disthv</A> a vector giving the normal of the plane whith which to intersect <A>A</A>,
#!  * <A>MarkHs</A> a list of indices of hyperplanes of <A>A</A>, these are drawn in another color.
#!
#! The example below will look as follows (only in pdf or <URL Text="pic">https://paulmuecksch.github.io/HypArr/doc/LaTeX_Examples/LaTeXDrawProjPicture_Example.pdf</URL>).
#!
#! @BeginExampleSession
#! gap> A:=AGpql(2,2,3);
#! <HyperplaneArrangement: 6 hyperplanes in 3-space>
#! gap> Print(LaTeXDrawProjPicture(A));
#! \begin{tikzpicture}[scale=1.0]
#! \draw (-2.83,2.83) -- (2.83,-2.83);  % H_1 
#! \draw (2.83,2.83) -- (-2.83,-2.83);  % H_2 
#! \draw (-1.,3.87) -- (-1.,-3.87);  % H_3 
#! \draw (1.,3.87) -- (1.,-3.87);  % H_4 
#! \draw (3.87,-1.) -- (-3.87,-1.);  % H_5 
#! \draw (3.87,1.) -- (-3.87,1.);  % H_6 
#! \end{tikzpicture}
#! gap> Print(LaTeXDrawProjPicture(A,1/2,true,true,[1,1,1],[1,2]));
#! \begin{tikzpicture}[scale=1.0]
#! \draw[color=red] (-3.56,1.83) -- (1.83,-3.56);  % H_1 
#! \node at (1.97,-3.71) {\small $1$}; 
#! \draw[color=red] (2.83,2.83) -- (-2.83,-2.83);  % H_2 
#! \node at (-2.97,-2.97) {\small $2$}; 
#! \draw (3.35,2.16) -- (-4.,0.20);  % H_3 
#! \node at (-4.20,0.14) {\small $3$}; 
#! \draw (-1.04,3.85) -- (1.04,-3.85);  % H_4 
#! \node at (1.09,-4.06) {\small $4$}; 
#! \draw (2.16,3.35) -- (0.20,-4.);  % H_5 
#! \node at (0.14,-4.20) {\small $5$}; 
#! \draw (-3.85,1.04) -- (3.85,-1.04);  % H_6 
#! \node at (4.06,-1.09) {\small $6$}; 
#!
#! \fill[red] (-0.87,-0.87) circle[radius=2pt];  % P[ 1, 2 ] 
#! \fill[red] (-2.37,0.63) circle[radius=2pt];  % P[ 1, 3, 6 ] 
#! \fill[red] (1.73,1.73) circle[radius=2pt];  % P[ 2, 3, 5 ] 
#! \fill[red] (0.63,-2.37) circle[radius=2pt];  % P[ 1, 4, 5 ] 
#! \fill[red] (0.0,0.0) circle[radius=2pt];  % P[ 2, 4, 6 ] 
#! \fill[red] (-0.32,1.17) circle[radius=2pt];  % P[ 3, 4 ] 
#! \fill[red] (1.17,-0.32) circle[radius=2pt];  % P[ 5, 6 ] 
#!
#! \end{tikzpicture}
#! 
#! @EndExampleSession
#! 
#! @BeginLatexOnly
#! \includegraphics{./LaTeX_Examples/LaTeXDrawProjPicture_Example.pdf}
#! @EndLatexOnly
#! 
DeclareGlobalFunction("LaTeXDrawProjPicture");


#! @Arguments A
#! @Returns A string.
#! @Description
#! Generates LaTeX tikz-code
#! for the intersection of a real 3-arrangement with the unit sphere.
#! To compile the LaTeX-code the .sty-file "<URL Text="graphonsphere.sty">https://paulmuecksch.github.io/HypArr/doc/LaTeX_Examples/graphonsphere.sty</URL>" (from /doc/LaTeX_Examples)
#! needs to be in the same folder and added via "\usepackage{graphonsphere}".
#! 
#! The example below will look as follows (only in pdf or <URL Text="pic">https://paulmuecksch.github.io/HypArr/doc/LaTeX_Examples/LaTeXDrawSpherePicture_Example.pdf</URL>).
#!
#! @BeginExampleSession
#! gap> A:=AGpql(2,2,3);
#! <HyperplaneArrangement: 6 hyperplanes in 3-space>
#! gap> Print(LaTeXDrawSpherePicture(A));
#! \tdplotsetmaincoords{63}{63}
#! \begin{tikzpicture}[scale=3,tdplot_main_coords]
#!
#! \draw[ball color = gray!40, opacity = 0.2] (0,0,0) circle (1cm);
#!
#! \def\OMcolor{black}
#! {\color{\OMcolor}
#! % the vertices of the OM-cpx
#! \foreach \i/\vx/\vy/\vz in {
#! 1/0./0./1., 
#! 2/-0.57/0.57/0.57, 
#! 3/-0.57/-0.57/0.57, 
#! 4/0.57/-0.57/0.57, 
#! 5/0.57/0.57/0.57, 
#! 6/0./1./0., 
#! 7/1./0./0., 
#! 8/0./0./-1., 
#! 9/0.57/-0.57/-0.57, 
#! 10/0.57/0.57/-0.57, 
#! 11/-0.57/0.57/-0.57, 
#! 12/-0.57/-0.57/-0.57, 
#! 13/0./-1./0., 
#! 14/-1./0./0. 
#! }{
#! \node (\i) at (\vx,\vy,\vz) {};
#! %			\node[anchor=south east] at ($(\i)$) {\tiny{$\i$}};
#! \filldraw[color=\OMcolor] (\i) circle[radius=0.5pt];
#! }
#! %		
#! % the edges of the OM-cpx
#! \foreach \ax/\ay/\az/\bx/\by/\bz in {
#! 0./0./1./  -0.57/0.57/0.57, %[ 1, 2 ] 
#! 0./0./1./  -0.57/-0.57/0.57, %[ 1, 3 ] 
#! 0./0./1./  0.57/-0.57/0.57, %[ 1, 4 ] 
#! 0./0./1./  0.57/0.57/0.57, %[ 1, 5 ] 
#! -0.57/0.57/0.57/  -0.57/-0.57/0.57, %[ 2, 3 ] 
#! -0.57/0.57/0.57/  0.57/0.57/0.57, %[ 2, 5 ] 
#! -0.57/0.57/0.57/  0./1./0., %[ 2, 6 ] 
#! -0.57/0.57/0.57/  -0.57/0.57/-0.57, %[ 2, 11 ] 
#! -0.57/0.57/0.57/  -1./0./0., %[ 2, 14 ] 
#! -0.57/-0.57/0.57/  0.57/-0.57/0.57, %[ 3, 4 ] 
#! -0.57/-0.57/0.57/  -0.57/-0.57/-0.57, %[ 3, 12 ] 
#! -0.57/-0.57/0.57/  0./-1./0., %[ 3, 13 ] 
#! -0.57/-0.57/0.57/  -1./0./0., %[ 3, 14 ] 
#! 0.57/-0.57/0.57/  0.57/0.57/0.57, %[ 4, 5 ] 
#! 0.57/-0.57/0.57/  1./0./0., %[ 4, 7 ] 
#! 0.57/-0.57/0.57/  0.57/-0.57/-0.57, %[ 4, 9 ] 
#! 0.57/-0.57/0.57/  0./-1./0., %[ 4, 13 ] 
#! 0.57/0.57/0.57/  0./1./0., %[ 5, 6 ] 
#! 0.57/0.57/0.57/  1./0./0., %[ 5, 7 ] 
#! 0.57/0.57/0.57/  0.57/0.57/-0.57, %[ 5, 10 ] 
#! 0./1./0./  0.57/0.57/-0.57, %[ 6, 10 ] 
#! 0./1./0./  -0.57/0.57/-0.57, %[ 6, 11 ] 
#! 1./0./0./  0.57/-0.57/-0.57, %[ 7, 9 ] 
#! 1./0./0./  0.57/0.57/-0.57, %[ 7, 10 ] 
#! 0./0./-1./  0.57/-0.57/-0.57, %[ 8, 9 ] 
#! 0./0./-1./  0.57/0.57/-0.57, %[ 8, 10 ] 
#! 0./0./-1./  -0.57/0.57/-0.57, %[ 8, 11 ] 
#! 0./0./-1./  -0.57/-0.57/-0.57, %[ 8, 12 ] 
#! 0.57/-0.57/-0.57/  0.57/0.57/-0.57, %[ 9, 10 ] 
#! 0.57/-0.57/-0.57/  -0.57/-0.57/-0.57, %[ 9, 12 ] 
#! 0.57/-0.57/-0.57/  0./-1./0., %[ 9, 13 ] 
#! 0.57/0.57/-0.57/  -0.57/0.57/-0.57, %[ 10, 11 ] 
#! -0.57/0.57/-0.57/  -0.57/-0.57/-0.57, %[ 11, 12 ] 
#! -0.57/0.57/-0.57/  -1./0./0., %[ 11, 14 ] 
#! -0.57/-0.57/-0.57/  0./-1./0., %[ 12, 13 ] 
#! -0.57/-0.57/-0.57/  -1./0./0. %[ 12, 14 ] 
#! }{
#! \GCArcABfb{\ax}{\ay}{\az}{\bx}{\by}{\bz}{color=\OMcolor}
#! }
#! }
#! \end{tikzpicture}
#! @EndExampleSession
#! 
#! @BeginLatexOnly
#! \includegraphics{./LaTeX_Examples/LaTeXDrawSpherePicture_Example.pdf}
#! @EndLatexOnly
#! 
DeclareGlobalFunction("LaTeXDrawSpherePicture");

#! @Arguments A
#! @Returns A string.
#! @Description
#! Generates LaTeX tikz-code
#! for the tope graph of a real 3-arrangement on the unit sphere.
#! To compile the LaTeX-code the .sty-file "<URL Text="graphonsphere.sty">https://paulmuecksch.github.io/HypArr/doc/LaTeX_Examples/graphonsphere.sty</URL>" (from /doc/LaTeX_Examples)
#! needs to be in the same folder and added via "\usepackage{graphonsphere}".
#! 
#! The example below will look as follows (only in pdf or <URL Text="pic">https://paulmuecksch.github.io/HypArr/doc/LaTeX_Examples/LaTeXDrawTopeGraph_Example.pdf</URL>).
#!
#! @BeginExampleSession
#! @EndExampleSession
#! 
#! @BeginLatexOnly
#! \includegraphics{./LaTeX_Examples/LaTeXDrawTopeGraph_Example.pdf}
#! @EndLatexOnly
#! 
DeclareGlobalFunction("LaTeXDrawTopeGraph");


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
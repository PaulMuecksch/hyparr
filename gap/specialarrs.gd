#
# HypArr: Some special arrangements
#
#! @Chapter Special arrangements
#!
#! The following describes functions to construct some special arrangements.
#!

#################################
##
#! @Section Global methods
##
#################################



#! @Arguments p,q,l
#! @Returns A hyperplane arrangement.
#! @Description
#!  Constructs the reflection arrangement associated to the monomial
#!  complex reflection group <M>G(p,q,l)</M>.
#!  The hyperplanes are defined by equations of the form
#!  <Display>
#!     x_i = \zeta^k x_j
#!  </Display>
#!  where <M>\zeta</M> is a primitive <M>p</M>-th root of unity.
#! @BeginExampleSession
#! gap> A := AGpql(2,1,3);
#!  <HyperplaneArrangement: 9 hyperplanes in 3-space>
#! gap> Roots(A);
#! [ [ 1, 0, 0 ], [ 0, 1, 0 ], [ 0, 0, 1 ],
#!   [ 1, 1, 0 ], [ 1, -1, 0 ], [ 1, 0, 1 ],
#!   [ 1, 0, -1 ], [ 0, 1, 1 ], [ 0, 1, -1 ] ]
#!
#! @EndExampleSession
DeclareGlobalFunction( "AGpql" );



DeclareGlobalFunction( "cp" );
DeclareGlobalFunction( "sp" );

#! @Arguments n
#! @Returns A hyperplane arrangement.
#! @Description
#!  Generates the irreducible supersolvable simplicial arrangement
#!  of rank 3 with n hyperplanes.
#!  n must either be even oder congruent 1 mod 4.
#!  In any case, $n\geq 6$. 
#! @BeginExampleSession
#! gap> A:=SsS3(9); Roots(A);
#! <HyperplaneArrangement: 9 hyperplanes in 3-space>
#! [ [ 0, 0, 1 ], [ 0, 1, 0 ], 
#!   [ -1/2*E(8)+1/2*E(8)^3, 1/2*E(8)-1/2*E(8)^3, 0 ], 
#!   [ -1, 0, 0 ], 
#!   [ -1/2*E(8)+1/2*E(8)^3, -1/2*E(8)+1/2*E(8)^3, 0 ], 
#!   [ 1/2*E(8)-1/2*E(8)^3, 1/2*E(8)-1/2*E(8)^3, 1 ], 
#!   [ -1/2*E(8)+1/2*E(8)^3, 1/2*E(8)-1/2*E(8)^3, 1 ], 
#!   [ -1/2*E(8)+1/2*E(8)^3, -1/2*E(8)+1/2*E(8)^3, 1 ], 
#!   [ 1/2*E(8)-1/2*E(8)^3, -1/2*E(8)+1/2*E(8)^3, 1 ] ]
#! 
#! @EndExampleSession
DeclareGlobalFunction( "SsS3" );

DeclareGlobalFunction( "SimpGraphFromEdgeSet" );
DeclareGlobalFunction( "ConnectedSubgraphArrG" );

#! @Arguments Es
#! @Returns A hyperplane arrangement.
#! @Description
#!  Generates the connected subgraph arrangement (see <Cite Key="CK2022_ConnSubgraph_arXiv"/>)
#!  of the graph with edges <A>Es</A>.
#!
#! Let $G = (N,E)$ be an undirected graph with vertex set $N = [n]$ and edge set $E$. For $I \subseteq N$, let $G[I]$ be the induced subgraph of $G$ on the set of vertices $I$.
#! For $I \subseteq N$, define the hyperplane
#! $$H_I := \ker \sum_{i \in I}x_i.$$
#! The connected subgraph arrangement consists of hyperplanes 
#! $\{H_I \mid \varnothing \ne I \subseteq N$ if $G[I]$ is connected $\}.$
#! @BeginExampleSession
#! gap> A:=ConnectedSubgraphArr([[1,2],[1,3],[2,3]]); Roots(A);
#! <HyperplaneArrangement: 7 hyperplanes in 3-space>
#! [ [ 1, 1, 1 ], [ 0, 1, 1 ], [ 0, 0, 1 ], [ 0, 1, 0 ], 
#!   [ 1, 0, 1 ], [ 1, 0, 0 ], [ 1, 1, 0 ] ]
#! @EndExampleSession
DeclareOperation( "ConnectedSubgraphArr" , [IsList]);
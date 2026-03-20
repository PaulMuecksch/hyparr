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
#!  n must either even oder congruent 1 mod 4. 
#! @BeginExampleSession
#! gap> A:=SsS3(9); Roots(A);
#! <HyperplaneArrangement: 9 hyperplanes in 3-space>
#! [ [ 0, 0, 1 ], [ 0, 1, 0 ], 
#!   [ -1/2*E(8)+1/2*E(8)^3, 1/2*E(8)-1/2*E(8)^3, 0 ], [ -1, 0, 0 ], 
#!   [ -1/2*E(8)+1/2*E(8)^3, -1/2*E(8)+1/2*E(8)^3, 0 ], [ 1/2*E(8)-1/2*E(8)^3, 1/2*E(8)-1/2*E(8)^3, 1 ], 
#!   [ -1/2*E(8)+1/2*E(8)^3, 1/2*E(8)-1/2*E(8)^3, 1 ], [ -1/2*E(8)+1/2*E(8)^3, -1/2*E(8)+1/2*E(8)^3, 1 ], 
#!   [ 1/2*E(8)-1/2*E(8)^3, -1/2*E(8)+1/2*E(8)^3, 1 ] ]
#! @EndExampleSession
DeclareGlobalFunction( "SsS3" );
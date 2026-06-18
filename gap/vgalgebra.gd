#
# HypArr: Varchenko-Gelfand algebras
#
#! @Chapter Varchenko-Gelfand algebra
#!


#################################
##
#! @Section Construction
##
#################################

DeclareCategory("IsVGAlgebra", IsComponentObjectRep and IsAttributeStoringRep );

DeclareRepresentation(
    "IsVGAlgebraRep",
    IsVGAlgebra,
    ["field", "ideal", "gens", "pring", "grAPres"]
);

DeclareOperation("ViewObject", [ IsVGAlgebra ]);

#! @Arguments OM, field
#! @Returns Varchenko-Gelfand albgera
#! @Description
#!  Constructs the Varchenko-Gelfand algebra of <A>OM</A>.
#! @BeginExampleSession
#! @EndExampleSession
DeclareOperation("VGAlgebra",[IsOrientedMatroid, IsField]);

DeclareAttribute("VGField",IsVGAlgebra);

DeclareAttribute("VGGenerators",IsVGAlgebra);

# DeclareAttribute("VGSpace",IsVGAlgebra);

DeclareAttribute("VGPRing",IsVGAlgebra);

DeclareAttribute("VGgrAlgebraPresentation",IsVGAlgebra);
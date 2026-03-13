#
# HypArr: Computations with oriented matroids
#
# Implementations
# #

################################################################################
##
##  <#GAPDoc Label="HyperplaneArrangement">
##  <ManSection>
##  <Func Name="HyperplaneArrangement" Arg="R"/>
##
##  <Returns> A hyperplane arrangement (as a record). </Returns>
##
##  <Description>
##
##  Defines the hyerplane arrangement from a list of vectors giving defining linear forms.
##  
##  </Description>
##  </ManSection>
##  <#/GAPDoc>

# # generation of a hyperplane arrangement A given by a set of linear forms r

BindGlobal("OrientedMatroidFamily",
    NewFamily("OrientedMatroidFamily"));


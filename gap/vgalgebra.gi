#
# HypArr: Varchenko-Gelfand algebras
#
# Implementations
# #

BindGlobal("VGAlgebraFamily",
    NewFamily("VGAlgebraFamily"));

InstallMethod(VGField,
	[IsVGAlgebra],
VGA->VGA!.field);

InstallMethod(VGGenerators,
	[IsVGAlgebra],
VGA->VGA!.gens);

# InstallMethod(VGSpace,
# 	[IsVGAlgebra],
# VGA->VGA!.space);

# InstallMethod(VGSingularQRing,
# 	[IsVGAlgebra],
# VGA->VGA!.sqring);

InstallMethod(VGPRing,
	[IsVGAlgebra],
VGA->VGA!.pring);

InstallMethod(VGgrAlgebraPresentation,
    [IsVGAlgebra],
VGA -> VGA!.grAPres);


InstallMethod(ViewObj,
    [ IsVGAlgebra ],
function(VGA)
    Print("<Varchenko-Gelfand Algebra: ",
          Length(VGGenerators(VGA)), " generators over ",
          VGField(VGA), ">");
end);

InstallMethod(VGAlgebra,
    [IsOrientedMatroid, IsField],
function(O, K)
local gset, gc, c, cSupp, PRing,vars, gI, IdealVG, homIdeal, hgI, hIdealVG, VGPresentation, SQRing, type;
    gset:=OMGroundSet(O);
    vars := List(gset,i->X(K, Concatenation("e",String(i))));
    PRing := PolynomialRing(K,vars);
    gI:=List([1..Length(gset)],i->vars[i]^2-vars[i]);

    # for c in OMCircuits(O) do
    #     gc := Product(List(SVPlusSet(c),i->vars[i]))*Product(List(SVMinusSet(c),i->vars[i]-1))
    #         - Product(List(SVMinusSet(c),i->vars[i]))*Product(List(SVPlusSet(c),i->vars[i]-1));
    #     Add(gI,gc);
    # od;
    # IdealVG :=  Ideal(PRing,gI);

    hgI := List([1..Length(gset)],i->vars[i]^2);
    for c in OMCircuits(O) do
        cSupp := Difference(gset,SVZeroSet(c));
        gc := Sum(List(cSupp,p-> c[p]*Product(List(Difference(cSupp,[p]),i->vars[i]))));
        Add(hgI,gc);
    od;
    hIdealVG :=  Ideal(PRing,gI);

    VGPresentation := GradedAlgebraPresentation(PRing,hgI,List(vars,x->1));

    SetTermOrdering(PRing,"dp");
	SingularSetBaseRing(PRing);
    hIdealVG := SingularInterface("std",[hIdealVG],"ideal");
    # SQRing := SingularInterface("qring",[IdealVG],"ring" );
    # SQRing := PRing;

    type := NewType(VGAlgebraFamily,
                    IsVGAlgebraRep);

    return Objectify(type,
        rec(
            field := K,
            space := [],
            ideal := hIdealVG,
			# gens := GeneratorsOfIdeal(hIdealVG),
            gens := hgI,
            pring := PRing,
            grAPres := VGPresentation
            # sqring := SQRing
        )
    );

end);

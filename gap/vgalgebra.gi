#
# HypArr: Varchenko-Gelfand algebras
#
# Implementations
# #

BindGlobal("VGAlgebraFamily",
    NewFamily("VGAlgebraFamily"));

InstallMethod(VGField,
	[IsVGAlgebra],
VGA->VGA!.gfield);

InstallMethod(VGGenerators,
	[IsVGAlgebra],
VGA->VGA!.gens);

InstallMethod(VGSpace,
	[IsVGAlgebra],
VGA->VGA!.space);

InstallMethod(VGSingularQRing,
	[IsVGAlgebra],
VGA->VGA!.sqring);

InstallMethod(VGPRing,
	[IsVGAlgebra],
VGA->VGA!.pring);

InstallMethod(ViewObj,
    [ IsVGAlgebra ],
function(VGA)
    Print("<Varchenko-Gelfand Algbra: ",
          Length(VGGenerators(VGA)), " generators over ",
          VGField(VGA), ">");
end);

InstallMethod(VGAlgebra,
    [IsOrientedMatroid, IsField],
function(OM, K)
local gset, gc, c, PRing,vars, gI, IdealVG, SQRing, type;
    gset:=OMGroundSet(OM);
    vars := List(gset,i->X(K, Concatenation("e",String(i))));
    PRing := PolynomialRing(K,vars);
    gI:=List([1..Length(gset)],i->vars[i]^2-vars[i]);

    for c in OMCircuits(OM) do
        gc := Product(List(SVPlusSet(c),i->vars[i]))*Product(List(SVMinusSet(c),i->vars[i]-1))
            - Product(List(SVMinusSet(c),i->vars[i]))*Product(List(SVPlusSet(c),i->vars[i]-1));
        Add(gI,gc);
    od;
    IdealVG :=  Ideal(PRing,gI);

    SetTermOrdering(PRing,"dp");
	SingularSetBaseRing(PRing);
    IdealVG := SingularInterface("std",[IdealVG],"ideal");
    SQRing := SingularInterface("qring",[IdealVG],"ring" );
    # SQRing := PRing;

    type := NewType(VGAlgebraFamily,
                    IsVGAlgebraRep);

    return Objectify(type,
        rec(
            field := K,
            space := [],
            ideal := IdealVG,
			gens := GeneratorsOfIdeal(IdealVG),
            pring := PRing,
            sqring := SQRing
        )
    );

end);

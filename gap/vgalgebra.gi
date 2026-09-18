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

############################
## filtVGAGraph
#############################

BindGlobal("CycOrderSignsRk2OM",
function(Or2)
local GSet,CycOrder, Signs, CVs, i, T, C1,C2, h;
    GSet := OMGroundSet(Or2);
    CVs:=OMCovectors(Or2);
    h:=GSet[1];
    CycOrder := [h];
    Signs:=[1];
    C1 := Filtered(CVs[2],D->SVZeroSet(D)=[h])[1];
    for i in [2..Length(GSet)] do
        if i mod 2 = 0 then
            T:=Filtered(CVs[1],R->OrderCovec(C1,R) and R[h]=Signs[i-1])[1];
            C2 := Filtered(CVs[2],D->OrderCovec(D,T) and D<>C1)[1];
            h := SVZeroSet(C2)[1];
            Add(CycOrder,h);
            Add(Signs,T[h]);
        else
            T:=Filtered(CVs[1],R->OrderCovec(C1,R) and R[h]=-Signs[i-1])[1];
            C2 := Filtered(CVs[2],D->OrderCovec(D,T) and D<>C1)[1];
            h := SVZeroSet(C2)[1];
            Add(CycOrder,h);
            Add(Signs,-T[h]);
        fi;
        C1 := C2;
    od;
    return rec(cycorder := CycOrder, sgns:=Signs);
end);

# OMLocalizationRk(O,[1,2,3,5],3);

InstallMethod(OMfiltVGAGraph,
    [IsOrientedMatroid],
function(O)
local Ts, HSFsP, HSFsM, GenHSFs, EfiltVGAGraph, filtVGAGraphColourClasses, filtVGAGraph, L2s, V1, V2, V3,
    h, m, hsf, ghsf, nTs, TSetToIVec, COLocm, OneVG, i;

    Ts := OMTopes(O);
    nTs := Length(Ts);
    OneVG := List(Ts,x->1);
    
    TSetToIVec := function(S)
    local I;
        I:=IdentityMat(nTs);
        return Sum(I{S});
    end;

    EfiltVGAGraph := [];

    L2s := LkFlats(OMGeomLattice(O))(2);
    L2s := Filtered(L2s,x->Length(x) mod 2 = 1);

    V1 := [1..Length(Ts)];
    V2 := [Length(V1)+1..Length(V1)+2*Length(OMGroundSet(O))];
    V3 := [Length(V1)+Length(V2)+1..Length(V1)+Length(V2)+2*Length(L2s)];

    HSFsP:=[];;
    HSFsM:=[];;
    for h in OMGroundSet(O) do
        hsf := Filtered([1..Length(Ts)],i->Ts[i][h]=1);
        hsf :=  TSetToIVec( hsf );
        Add(HSFsP,hsf);
        Add(HSFsM,OneVG-hsf);
    od;
    # for h OMFGroundSet(O) do
    #     hsf := Filtered([1..Length(Ts)],i->Ts[i][h]=-1);
    #     hsf :=  TSetToIVec( hsf );
    #     Add(HSFsM,hsf);
    # od;
    GenHSFs := [];
    for m in L2s do
        ghsf := -(Length(m)-1)/2*OneVG;
        COLocm := CycOrderSignsRk2OM(OMLocalizationRk(O,m,2));
        for i in [1..Length(m)] do
            if COLocm.sgns[i]= 1 then
                ghsf := ghsf + HSFsP[m[COLocm.cycorder[i]]];
            else
                ghsf := ghsf + HSFsM[m[COLocm.cycorder[i]]];
            fi;
        od;
        Add(GenHSFs,ghsf);
        Add(GenHSFs,OneVG-ghsf);
    od;
    
    for i in V1 do
        for hsf in HSFsP do
            if hsf[i]=1 then
                Add(EfiltVGAGraph,[i,Length(V1)+Position(HSFsP,hsf)]);
            fi;
        od;
        for hsf in HSFsM do
            if hsf[i]=1 then
                Add(EfiltVGAGraph,[i,Length(V1)+Length(HSFsP)+Position(HSFsM,hsf)]);
            fi;
        od;
        for ghsf in GenHSFs do
            if ghsf[i]=1 then
                Add(EfiltVGAGraph,[i,Length(V1)+Length(V2)+Position(GenHSFs,ghsf)]);
            fi;
        od;
    od;

    return rec(graph:=SimpGraphFromEdgeSet(EfiltVGAGraph), 
    colourClasses := [V1,Union(V2,V3)]);

    # GenHSFs := Union(List(L2s,m->OMLocalizationRk(O,m,2)))
end);

InstallMethod(OMfiltVGAIsIsomorphic,
    [IsOrientedMatroid, IsOrientedMatroid],
function(O1,O2)
    return IsIsomorphicGraph(   rec(graph:=ShallowCopy(OMfiltVGAGraph(O1).graph), colourClasses := OMfiltVGAGraph(O1).colourClasses),
                                rec(graph:=ShallowCopy(OMfiltVGAGraph(O2).graph), colourClasses := OMfiltVGAGraph(O2).colourClasses) );
end);
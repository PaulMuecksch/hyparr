#
# HypArr: Computations with oriented matroids
#
# Implementations
# #


BindGlobal("OrientedMatroidFamily",
    NewFamily("OrientedMatroidFamily"));

# Implement the hyperplane arrangement constructor

InstallMethod(OrientedMatroid,
    "for list of linear forms",
    [IsList],
function(r)

    local dim, l, type;

    if r = [] then
        dim := 0;
        l := [];
    else
        dim := Length(r[1]);
        l := HypArr_PWLinInd(r);
    fi;

    type := NewType(OrientedMatroidFamily,
                    IsOrientedMatroidRep);

    return Objectify(type,
        rec(
            groundset := [1..Length(l)],
            lforms := l,
            rank := dim
        )
    );
end);

InstallMethod(OrientedMatroid,
    [ IsOrientedMatroid ],
function(O)

    Print("<OrientedMatroid: ",
          Length(OMGroundSet(O)), " element, rank ",
          OMRank(O), ".");

end);

InstallMethod(OMGroundSet,
    [ IsOrientedMatroid ],
    O -> O!.groundset);

InstallMethod(OMRank,
    [ IsOrientedMatroid ],
    O -> O!.rank);
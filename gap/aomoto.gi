#
# HypArr: The Aomoto complex of a geometric lattice
#
# Implementations
# #

BindGlobal("AomotoComplexFamily",
    NewFamily("AomotoComplexFamily"));


#####################################################################
# HypArr_ShuffleSign(A, B)
#
# Given two disjoint, strictly increasing lists A and B of atoms,
# returns the sign (+1 or -1) obtained when the exterior product
# e_A * e_B (each factor written in increasing order) is rewritten
# as e_{A cup B} with the union sorted increasingly.
#
# This sign equals (-1)^m, where m is the number of pairs
# (x,y) with x in A, y in B and x > y.
#####################################################################

InstallGlobalFunction(HypArr_ShuffleSign,
function(A, B)
    local s, a, b;
    s := 0;
    for a in A do
        for b in B do
            if a > b then
                s := s + 1;
            fi;
        od;
    od;
    if s mod 2 = 0 then
        return 1;
    else
        return -1;
    fi;
end);


#####################################################################
# HypArr_OSReduce(circuits, S, cache)
#
# Expresses the exterior monomial e_S in the no broken circuit (nbc)
# monomial basis of the Orlik-Solomon algebra, where <circuits> is a
# list of the circuits of the underlying geometric lattice.
#
# The set S is a list of atoms; the monomial e_S is understood with
# the atoms written in increasing order.  The return value is a list
# of pairs [c, T], where T is an nbc set and c an integer coefficient,
# representing the linear combination
#       e_S = sum_{[c,T]} c * e_T
# in the Orlik-Solomon algebra.
#
# If S contains a broken circuit, the Orlik-Solomon relation
# d(e_C) = 0 of a corresponding circuit C is used to rewrite e_S in
# terms of monomials containing the smaller atom min(C); iterating
# this straightening terminates and yields the nbc normal form.  A
# monomial whose set is dependent is rewritten to 0 automatically.
#
# The record <cache> memoises intermediate results (keyed by the
# string of the sorted set) and is shared across a single computation.
#####################################################################

InstallGlobalFunction(HypArr_OSReduce,
function(circuits, S, cache)
    local Ssort, key, Csel, C, Cs, a, bc, R, s0, res, k, ck, Tk, Uk, s1,
          coeff, sub, t, combined, term, found, i;

    Ssort := Set(S);
    key := String(Ssort);
    if IsBound(cache.(key)) then
        return cache.(key);
    fi;

    # Search for a circuit whose broken circuit is contained in Ssort.
    Csel := fail;
    for C in circuits do
        Cs := Set(C);
        if IsSubset(Ssort, Cs{[2..Length(Cs)]}) then
            Csel := Cs;
            break;
        fi;
    od;

    # No broken circuit contained: S is already an nbc set.
    if Csel = fail then
        res := [ [ 1, Ssort ] ];
        cache.(key) := res;
        return res;
    fi;

    # a = min(C), bc = broken circuit = C \ {a}, R = S \ bc.
    a := Csel[1];
    bc := Csel{[2..Length(Csel)]};
    R := Difference(Ssort, bc);

    # e_S = s0 * e_bc * e_R.
    s0 := HypArr_ShuffleSign(bc, R);

    # Substitute the relation
    #   e_bc = sum_{k>=2} (-1)^k e_{C \ {c_k}}.
    res := [];
    for k in [2..Length(Csel)] do
        ck := Csel[k];
        Tk := Difference(Csel, [ck]);
        # A repeated atom (Tk meets R) yields a vanishing monomial.
        if Intersection(Tk, R) <> [] then
            continue;
        fi;
        Uk := Union(Tk, R);
        s1 := HypArr_ShuffleSign(Tk, R);
        coeff := s0 * (-1)^k * s1;
        sub := HypArr_OSReduce(circuits, Uk, cache);
        for t in sub do
            Add(res, [ coeff * t[1], t[2] ]);
        od;
    od;

    # Collect equal nbc monomials and drop vanishing coefficients.
    combined := [];
    for term in res do
        found := false;
        for i in [1..Length(combined)] do
            if combined[i][2] = term[2] then
                combined[i][1] := combined[i][1] + term[1];
                found := true;
                break;
            fi;
        od;
        if not found then
            Add(combined, [ term[1], term[2] ]);
        fi;
    od;
    combined := Filtered(combined, x -> x[1] <> 0);

    cache.(key) := combined;
    return combined;
end);


#####################################################################
# Orlik-Solomon combinatorics of a geometric lattice
#####################################################################

InstallMethod(LBrokenCircuits,
    [IsGeomLattice],
function(L)
    return Set(LCircuits(L), C -> Set(C){[2..Length(Set(C))]});
end);

InstallMethod(LNBCSets,
    [IsGeomLattice],
function(L)
    local atoms, BCs, N, p, cands;
    atoms := LAtoms(L);
    BCs := LBrokenCircuits(L);
    N := [ [ [] ] ];   # degree 0: the empty set
    for p in [1..LRank(L)] do
        cands := Combinations(atoms, p);
        cands := Filtered(cands, S -> ForAll(BCs, bc -> not IsSubset(S, bc)));
        Add(N, cands);
    od;
    return N;
end);

InstallMethod(LOrlikSolomonBetti,
    [IsGeomLattice],
function(L)
    return List(LNBCSets(L), Length);
end);


#####################################################################
# The Aomoto complex
#####################################################################

InstallMethod(ViewObj,
    [ IsAomotoComplex ],
function(AC)
    Print("<Aomoto complex of a rank ", LRank(AomotoLattice(AC)),
          " geometric lattice over ", AomotoField(AC),
          ", ranks ", AomotoBettiNumbers(AC), ">");
end);

InstallMethod(AomotoLattice,
    [ IsAomotoComplex ],
    AC -> AC!.lattice);

InstallMethod(AomotoField,
    [ IsAomotoComplex ],
    AC -> AC!.field);

InstallMethod(AomotoWeights,
    [ IsAomotoComplex ],
    AC -> AC!.weights);

InstallMethod(AomotoBasis,
    [ IsAomotoComplex ],
    AC -> AC!.basis);

InstallMethod(AomotoDifferentials,
    [ IsAomotoComplex ],
    AC -> AC!.diffs);

InstallMethod(AomotoBettiNumbers,
    [ IsAomotoComplex ],
    AC -> AC!.betti);

InstallMethod(AomotoCohomology,
    [ IsAomotoComplex ],
    AC -> AC!.cohomology);


InstallMethod(AomotoComplex,
    [IsGeomLattice, IsList],
function(L, lambda)
    return AomotoComplex(L, lambda, Rationals);
end);

InstallMethod(AomotoComplex,
    [IsGeomLattice, IsList, IsField],
function(L, lambda, K)
    local atoms, n, rank, wts, circuits, N, cache, MatRank, diffs, pk, src, tgt,
          M, i, S, a, sgn, U0, red, wa, t, j, coho, p, dimA, rOut, rIn, type;

    atoms := LAtoms(L);
    n := Length(atoms);

    if Length(lambda) <> n then
        Error("AomotoComplex: <lambda> must have one weight per atom, ",
              "i.e. length ", n, "\n");
    fi;

    # Coerce the weights into the coefficient field K.
    wts := List(lambda, x -> x * One(K));

    rank := LRank(L);
    circuits := LCircuits(L);
    N := LNBCSets(L);            # nbc bases, N[p+1] has degree p

    # Rank of a matrix over K, guarding against empty source/target.
    MatRank := function(mat)
        if Length(mat) = 0 then
            return 0;
        fi;
        if Length(mat[1]) = 0 then
            return 0;
        fi;
        return RankMat(mat);
    end;

    # Shared memoisation cache for the nbc straightening.
    cache := rec();

    # Differentials: diffs[pk] is the matrix of
    #   a_lambda wedge - : A^{pk-1} -> A^{pk}
    # with rows indexed by the source basis N[pk] and columns by the
    # target basis N[pk+1].
    diffs := [];
    for pk in [1..rank] do
        src := N[pk];
        tgt := N[pk+1];
        M := NullMat(Length(src), Length(tgt), K);
        for i in [1..Length(src)] do
            S := src[i];
            for a in atoms do
                if not a in S then
                    sgn := HypArr_ShuffleSign([a], S);
                    U0 := Union([a], S);
                    red := HypArr_OSReduce(circuits, U0, cache);
                    wa := wts[Position(atoms, a)];
                    for t in red do
                        j := Position(tgt, t[2]);
                        M[i][j] := M[i][j] + wa * sgn * t[1];
                    od;
                fi;
            od;
        od;
        diffs[pk] := M;
    od;

    # Cohomology dimensions: dim H^p = dim A^p - rank(d^p) - rank(d^{p-1}).
    coho := [];
    for p in [0..rank] do
        dimA := Length(N[p+1]);
        if p < rank then
            rOut := MatRank(diffs[p+1]);
        else
            rOut := 0;
        fi;
        if p >= 1 then
            rIn := MatRank(diffs[p]);
        else
            rIn := 0;
        fi;
        coho[p+1] := dimA - rOut - rIn;
    od;

    type := NewType(AomotoComplexFamily,
                    IsAomotoComplexRep);

    return Objectify(type,
        rec(
            lattice := L,
            field := K,
            weights := wts,
            basis := N,
            diffs := diffs,
            betti := List(N, Length),
            cohomology := coho
        )
    );

end);

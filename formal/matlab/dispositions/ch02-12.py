# -*- coding: utf-8 -*-
# MATLAB FAIL triage, Chapters 2-12 (FAIL lines with L < 15000 in RESULTS-2026-11-08.txt).
EDITS = [
    # L5165 TEXT-Ch02: REAL — a magnitude is non-negative (|v| = 0.894), so S = -1 cannot be "its magnitude".
    ("sub", "perhaps its magnitude, or a weighted sum",
     "perhaps a weighted sum of its components (its magnitude alone, being non-negative, could not be −1)"),

    # L8540 TEXT-Ch17: CHECK-ERROR (for Ch5) — Ch5's 89% matches the source data
    #   (C:\source\non-abelian-sqnd\experiments\ground_truth_summary.md: "only if convenient" (89%));
    #   the conflict is real, but the wrong side is the Ch17 table/text (94%), outside this range. No edit here.
    # L8543 TEXT-Ch17: CHECK-ERROR (for Ch5) — Ch5's 94% for "you promised" matches the same source file;
    #   Ch17 (91%) is the side to fix. No edit here.

    # L9740 GE-PROP-6-3: already corrected in v1.25 (skipped per brief).

    # L9611 TEXT-Ch06: REAL — g^{μα}E_α^β I_β·O^μ contracts two upper μ's (not a scalar).
    #   Corrected to S = E_μ^β I_β · O^μ by single-text-node edits (math structure kept;
    #   the leading g^{μα} script object is emptied — CHECK it renders with no placeholder box).
    ("sub_in", "S=gμαEαβIβ⋅Oμ", "μα", ""),
    ("sub_in", "S=gEαβIβ⋅Oμ", "g", ""),
    ("sub_in", "S=EαβIβ⋅Oμ", "α", "μ"),

    # L9859 TEXT-Ch07: REAL — 0.25 + 0.042 + 0.144 = 0.436, rounds to 0.44 (ranking unchanged: Bob 0.68, Alice 0.65, Carol 0.44).
    ("sub", "S_Carol = 0.5(0.5) + 0.3(0.14) + 0.2(0.72) = 0.43",
     "S_Carol = 0.5(0.5) + 0.3(0.14) + 0.2(0.72) = 0.44"),

    # L10267 TEXT-Ch07: REAL — listed terms 0.02+0.75+0.20+0.02+0.04+0.045 = 1.075; √1.075 = 1.04.
    ("sub", "√1.14 ≈ 1.07", "√1.08 ≈ 1.04"),
    # L10270 TEXT-Ch07: REAL — listed terms 0.32+0+0.09+0.045+0.64+0.125 = 1.22; √1.22 = 1.10. Decision (Alice) unchanged.
    ("sub", "√1.30 ≈ 1.14", "√1.22 ≈ 1.10"),

    # L10549 TEXT-Ch07: REAL — the three 6-vectors are linearly independent (rank 3); it is their
    #   differences (the affine plane of the 2-simplex of choices) that span two dimensions.
    ("sub", "shows that the vectors span a two-dimensional subspace without a clear ordering.",
     "shows that the vectors are linearly independent: they span a three-dimensional subspace, and their differences span a two-dimensional plane without a clear ordering."),

    # L12020 TEXT-Ch08: REAL — only co-directional moves on positively correlated dimensions are cheaper
    #   (2/(1+ρ) < 2); a single-dimension move costs 1/(1−ρ²) > 1 and an opposite-sign move 2/(1−ρ) > 2.
    ("sub", "so that changes along highly correlated dimensions (e.g., trust and autonomy) are cheaper than changes along independent or anti-correlated dimensions.",
     "so that a change that moves highly correlated dimensions together (e.g., trust and autonomy rising jointly) is cheaper than the same change along independent or anti-correlated dimensions, while a change that moves correlated dimensions apart, or moves one of them alone, is dearer."),

    # L12031 TEXT-Ch08: REAL — Δaᵀ Σ⁻¹ Δa is a squared distance; summed over a refining path it tends to 0.
    #   Arc length is the limit of the sum of its square roots (and the geodesic claim needs those weights).
    ("sub", "The first term is the Mahalanobis distance on the attribute space",
     "The first term is the squared Mahalanobis distance on the attribute space"),
    ("sub", "the Mahalanobis distance Δaᵀ Σ⁻¹ Δa defines the finite cost",
     "the squared Mahalanobis distance Δaᵀ Σ⁻¹ Δa defines the finite cost"),
    ("sub", "In the limit of infinitesimal transitions (Δa → da), the Mahalanobis distance converges to the Riemannian arc length, and the discrete geodesic (minimum-weight path on Δ) converges",
     "In the limit of infinitesimal transitions (Δa → da), the quadratic form Δaᵀ Σ⁻¹ Δa becomes the squared line element ds², so the sum of its square roots √(Δaᵀ Σ⁻¹ Δa) along a refining path converges to the Riemannian arc length (the sum of the quadratic forms themselves tends to zero), and the discrete geodesic (minimum-weight path on Δ, with each edge weighted by that square root) converges"),

    # L13260 GE-PROP-9-2: REAL (proof only) — (2) and (3) are met by f = (p₁/p₂)^k for every k (incl. f ≡ 1),
    #   and (1) is the definition of f, so uniqueness is not established. The statement only says f is
    #   "a function of the correlative rates", so its meaning is unchanged; no "(Corrected)" tag.
    ("sub", "which by the symmetry of the correlative exchange yields f(p₁, p₂) = p₁/p₂;",
     "which is the definition of f;"),
    ("sub", "All three are satisfied by f(p₁, p₂) = p₁/p₂, and this is the unique solution consistent with the correlative symmetry constraint.",
     "All three are satisfied by f(p₁, p₂) = p₁/p₂, but not uniquely: every power (p₁/p₂)^k, including f ≡ 1, satisfies them too, so the constraint fixes the form of f only up to this family, and f = p₁/p₂ is the simplest choice within it."),

    # L14528 GE-PROP-10-2: REAL — sign. With the book's R (Def 4.5) and the loop e_α then e_β,
    #   transport by dO = −ΓO gives H(O) − O = −R^μ_{ναβ} O^ν δA^{αβ} (numerical sphere check: rel.err 3e-4 vs −R, 2.0 vs +R).
    #   Also the second-leg term ε²∂_αΓ_β enters with a minus sign.
    ("sub_in", "Hγ(O)μ-Oμ=RναβμOνδAαβ", "=", "=-"),
    ("sub_eq", "The Riemann tensor is the infinitesimal holonomy.",
     "The Riemann tensor, with a minus sign, is the infinitesimal holonomy (for a loop traversed first along e_α, then along e_β). (Corrected in v1.25.)"),
    ("sub", "+ ε²∂_αΓᵘ_{νβ}Oᵛ + O(ε³)", "− ε²∂_αΓᵘ_{νβ}Oᵛ + O(ε³)"),
    ("sub", "δOᵘ = ε²(∂_αΓ", "δOᵘ = −ε²(∂_αΓ"),
    ("sub", "Γᵘ_{σβ}Γᵠ_{να})Oᵛ = Rᵘ_{ναβ} Oᵛ ε². Identifying δA^{αβ} = ε²: H_γ(O)ᵘ − Oᵘ = Rᵘ_{ναβ} Oᵛ δA^{αβ}. □",
     "Γᵘ_{σβ}Γᵠ_{να})Oᵛ = −Rᵘ_{ναβ} Oᵛ ε². Identifying δA^{αβ} = ε²: H_γ(O)ᵘ − Oᵘ = −Rᵘ_{ναβ} Oᵛ δA^{αβ}. □"),
    #   the trailing inline math restatement "δOμ=RναβμOνϵ2+O(ϵ3)" of the proof paragraph: its "=" is its own
    #   math text node, but every prose "=" in the paragraph is " = ", so park those, sign the math one, restore.
    ("sub_in", "Consider the infinitesimal parallelogram at point p spanned by", " = ", " ≡ "),
    ("sub_in", "Consider the infinitesimal parallelogram at point p spanned by", "=", "=-"),
    ("sub_in", "Consider the infinitesimal parallelogram at point p spanned by", " ≡ ", " = "),
    #   downstream: the proof that cites Prop 10.2 (appendix, cur.tsv para 8931) — the sign only; its conclusion
    #   (ΔO ≠ 0 implies R ≠ 0 somewhere) is unaffected.
    ("sub", "satisfies H_γ(O)ᵘ − Oᵘ = Rᵘ_{ναβ} Oᵛ δA^{αβ}", "satisfies H_γ(O)ᵘ − Oᵘ = −Rᵘ_{ναβ} Oᵛ δA^{αβ}"),
    ("sub", "ΔOᵘ = ∮_Σ Rᵘ", "ΔOᵘ = −∮_Σ Rᵘ"),
]

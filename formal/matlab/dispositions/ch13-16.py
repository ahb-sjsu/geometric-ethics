# Edits for MATLAB FAIL lines 15000 <= L < 22000 (Chapters 11 tail, 12 appendix, 13-16), Geometric Ethics v1.25.
# Skipped as already corrected: GE-PROP-11-3 (L15222), GE-PROP-15-1 (L19891), GE-PROP-15-3 (L20525).
EDITS = [
    # L15131 GE-THM-11-2: REAL — Step 2 assumes O(N^2) edges, so with N ~ 10^18 the edge count is m*10^36, not m*10^18 (intractability verdict only strengthens).
    ("sub", "the edge count on the order of m · 10¹⁸", "the edge count on the order of m · 10³⁶"),
    ("sub", "requires on the order of 10¹⁸ metric evaluations", "requires on the order of 10³⁶ metric evaluations (one per edge)"),

    # L16771 GE-THM-A-1: REAL — the proof needs xi^nu d_nu V = 0 (V invariant under the flow of xi); the statement omits it (fails for xi = d/dz2, V = z2).
    ("sub_in", "is conserved along geodesics:", "Then the quantity",
     "If, in addition, the potential V is invariant under the flow of ξ (ξ(V) = 0, i.e. ξᵛ∂ᵥV = 0, the condition used in the proof; corrected in v1.25), then the quantity"),

    # L17099 TEXT-Ch13: REAL — for psi = sqrt(p)|a> + e^{i th} sqrt(1-p)|b>, |psi><psi| has e^{-i th}|a><b| + e^{i th}|b><a|.
    # Fix by swapping the outer products (keeps the superscript structure of the equation): e^{i th}|b><a| + e^{-i th}|a><b|.
    ("sub_in", "ρsup=|ψ⟩⟨ψ|", "|b⟩⟨a|", "|A⟩⟨B|"),
    ("sub_in", "ρsup=|ψ⟩⟨ψ|", "|a⟩⟨b|", "|b⟩⟨a|"),
    ("sub_in", "ρsup=|ψ⟩⟨ψ|", "|A⟩⟨B|", "|a⟩⟨b|"),
    # L17104 TEXT-Ch13: REAL — same phase swap in the coherence term rho_sup - rho_mix.
    ("sub_in", "ρsup-ρmix=", "|b⟩⟨a|", "|A⟩⟨B|"),
    ("sub_in", "ρsup-ρmix=", "|a⟩⟨b|", "|b⟩⟨a|"),
    ("sub_in", "ρsup-ρmix=", "|A⟩⟨B|", "|a⟩⟨b|"),

    # L17254 GE-PROP-13-1: REAL — S = I_mu O^mu is linear in O; non-commutation must come from the interest operator, not nonlinearity.
    ("sub", " depends nonlinearly on the obligation",
     ", though linear in the obligation, involves the interest operator, which need not commute with the obligation operator"),

    # L17316 TEXT-Ch13: REAL — theta = 0 does not make framings reinforce everywhere: sum_x I(x) = 2Re(e^{i th}<a|b>) = 0 for orthogonal framings,
    # and the sign of I(x) at each x is set by <x|a>*<x|b>.
    ("sub", ", the framings are aligned: they reinforce everywhere, and the superposition acts like an enhanced version of either framing alone. When ",
     ", the interference at each verdict x is set by the overlap product ⟨x|a⟩*⟨x|b⟩ alone: the framings reinforce where their amplitudes agree in sign and cancel where they disagree. When "),
    ("sub", ", the framings are anti-aligned: they cancel everywhere, and the superposition suppresses both framings simultaneously. For intermediate values, the interference pattern is complex — some verdicts are enhanced, others suppressed.",
     ", every sign is reversed: the verdicts enhanced at θ = 0 are suppressed, and vice versa; intermediate values shift the pattern continuously between the two. No phase makes the framings reinforce (or cancel) everywhere: summed over all verdicts, the interference is Σₓ I(x) = 2 Re(eⁱᶿ⟨a|b⟩), which is zero for orthogonal framings, so enhancement at some verdicts is paid for by suppression at others."),

    # L18138 GE-PROP-13-4: REAL — rho_AB is separable for eps >= 2/3 (Werner state; PPT), yet S(rho_A) = ln 2 there too:
    # for a mixed rho_AB, S(rho_A) is not an entanglement measure, and the indeterminacy does not require entanglement.
    ("sub", "the entanglement entropy of the reduced state", "the von Neumann entropy of the reduced state"),
    ("sub", "are uniformly indeterminate whenever the collective state has any entanglement.",
     "are uniformly indeterminate at every noise level, including ε ≥ 2/3, where ρ_AB is separable and carries no entanglement at all (ρ_AB is entangled if and only if ε < 2/3). For a mixed collective state, S(ρ_A) is therefore not a measure of entanglement. (Corrected in v1.25.)"),

    # L18579 GE-PROP-14-1: REAL — uncentred 1-body and 2-body parts are not Frobenius-orthogonal; orthogonality needs averaged traces and the 0-body term (Hoeffding/ANOVA).
    # L18583 GE-PROP-14-1: REAL — the stated Moebius relation is false: sum_{|S|=k} mu(S)mu(S') = C(n,k)(-1)^(k+|S'|) != 0 (n=3, k=1, |S'|=2 gives -3).
    ("sub", "where C_k involves exactly k-agent interactions,", "where C_k (k = 0, …, n) involves exactly k-agent interactions,"),
    ("sub", "This follows from Möbius inversion on the subset lattice: the decomposition C_k = Σ_{|S|=k} μ(S) C_S (where μ is the Möbius function) produces orthogonal components because the Möbius function of a Boolean lattice satisfies the orthogonality relation Σ_{S: |S|=k} μ(S)μ(S’) = 0 for |S’| ≠ k.",
     "This holds when the decomposition is built as in Prop. 14.3, with normalized (averaged) partial traces and the 0-body term (the overall mean) included: it is then the Hoeffding (functional-ANOVA) decomposition, in which each component C_S averages to zero over every one of its own indices, so ⟨C_S, C_S’⟩ = 0 for S ≠ S’, and hence ⟨C_j, C_k⟩ = 0 for j ≠ k. Without this centring the components are not orthogonal."),

    # L18667 TEXT-Ch14: REAL — Delta R = R_coll - sum R_a > 0 means the sum is LESS than R_coll, which the text defines as a gap, not a surplus; use the Claim's own name.
    ("sub", "The responsibility surplus ", "The collective responsibility remainder "),

    # L18822 TEXT-Ch14 (Def 14.6): REAL — nabla_{gamma'} O already contains Gamma gamma' O, so the explicit Gamma term counts the connection twice;
    # the first term must be the component derivative dO/dt (then Sigma' = 0 does reduce to individual transport).
    ("sub", "is the Levi-Civita connection (as in Chapter 10),",
     "is the Levi-Civita connection (as in Chapter 10; because the connection term is written out explicitly, the first term here denotes the component derivative dO_collᵘ/dt along γ, not the covariant derivative, which would count the connection twice; corrected in v1.25),"),

    # L19267 GE-PROP-14-3 (two FAILs): REAL — with raw traces and no 0-body term, Pi_S Pi_S' != delta Pi_S (Pi_1 Pi_1 = d Pi_1; Pi_1 Pi_12 != 0).
    # Correct Moebius/Hoeffding form: averaged traces, C_(empty) included, C_(k) centred, C_(jk) = Tr_{\{j,k}} C - C_(j) - C_(k) - C_(empty).
    ("sub", "is the fully irreducible remainder. This is the moral analogue of the cluster expansion in statistical mechanics.",
     "is the fully irreducible remainder. The expansion also contains a 0-body term C_(∅)ᵘ, the average of C over all member indices, about which the individual contributions are centred. (Corrected in v1.25.) This is the moral analogue of the cluster expansion in statistical mechanics."),
    ("sub", r"traces over all indices not in S.",
     r"is the normalized trace (the average) over all indices not in S, and S' ranges over all proper subsets of S, including the empty set."),
    ("sub", r"The 1-body terms are the marginals C_(k)ᵘ = Tr_{\{k}} Cᵘ.",
     r"The 0-body term is the overall average C_(∅)ᵘ = Tr Cᵘ (normalized over all member indices). The 1-body terms are the centred marginals C_(k)ᵘ = Tr_{\{k}} Cᵘ − C_(∅)ᵘ."),
    ("sub", "δ_{ν_j} ⊗ C_(k)ᵘ. The remainder", "δ_{ν_j} ⊗ C_(k)ᵘ − C_(∅)ᵘ. The remainder"),
    ("sub", "Σ_S Π_S = id (completeness).",
     "Σ_S Π_S = id (completeness), the sum running over all S including ∅. With the normalized traces and the 0-body term, this is the Hoeffding (functional-ANOVA) decomposition, whose components are mutually orthogonal in the Frobenius inner product."),

    # L19618 TEXT-Ch15: REAL — maximin (stated two lines later), lexicographic and satisficing contractions are not w.O for any fixed w.
    ("sub", "Every ethical theory that yields a scalar verdict is performing a weighted contraction, differing only in the weights.",
     "Every ethical theory that yields a scalar verdict by a fixed linear rule is performing a weighted contraction, differing only in the weights; the nonlinear rules below (maximin, lexicographic, satisficing) are not weighted contractions for any fixed weights."),

    # L19768 GE-THM-15-1: REAL — false for arbitrary Q (digit interleaving is injective with a left inverse); needs Q continuous (and C^1 for the dQ proof), as Thm 20.2 states.
    ("sub", "Let Q: ℝ⁹ → ℝ be any function that maps a 9-dimensional moral attribute vector to a scalar evaluation.",
     "Let Q: ℝ⁹ → ℝ be any continuous function (continuously differentiable where the proof below uses dQ) that maps a 9-dimensional moral attribute vector to a scalar evaluation. (Corrected in v1.25.)"),

    # L20098 GE-PROP-15-2: REAL — w7 = 0 puts e7 in ker C, so a general pre-image can have any x7 component; only the minimal-norm pre-image qualifies.
    ("sub", "where C⁻¹(S) is any pre-image and",
     "where C⁻¹(S) is the minimal-norm pre-image (the pre-image orthogonal to ker C) and"),
    ("sub", "then C⁻¹(S) has zero component along x⁷,",
     "then e₇ lies in ker C, so the minimal-norm pre-image C⁻¹(S) has zero component along x⁷ (for a metric in which x⁷ is orthogonal to the retained dimensions),"),

    # L20394 GE-PROP-15-2 (summary table): REAL — H(R) >= 0 does not follow (T = (1, 0.2), w = (1,1): H(R) = -0.4); Prop 15.2 gives the identity only.
    ("sub_eq", "H(R) ≥ 0", "H(R) = H(T) − H(C⁻¹(S))"),

    # L20554 GE-PROP-15-4: REAL — the floor S_i = min_a M_ia depends on the option i, so the total is sum M - |A| sum_i S_i (M = [1 2;3 4]: 2, not 8 or 4). Conclusion unchanged.
    ("sub", "Σ_{i,a} R_{ia} = Σ_{i,a} M_{ia} − n·S where n = |A|.",
     "Σ_{i,a} R_{ia} = Σ_{i,a} M_{ia} − n·Σ_i S_i where n = |A| and S_i = min_a M_{ia} is the floor for option i."),

    # L21160 GE-PROP-16-1: REAL — |sum_k dc_k s_k| < eps sum_k |s_k| <= m eps max_k |s_k|; eps max|s_k| alone fails (m = 4 example gives 1.96 eps). Conclusion unchanged.
    ("sub_in", "the perturbation does not change the sign of", "which is bounded by ", "which, for m theories, is bounded by m times "),

    # L21605 GE-PROP-16-4: REAL — lambda -> inf selects minimum cross-theory dispersion, not minimax regret
    # (S(a1) = (0,0), S(a2) = (10,9), c = (1/2,1/2): lambda -> inf picks a1, regret 10; minimax regret picks a2, regret 0). CONCLUSION CHANGES.
    ("sub", "(Hedging as Minimax Regret)", "(Hedging and Minimax Regret)"),
    ("sub_eq", "Hedging as Minimax Regret", "Hedging and Minimax Regret"),
    ("sub", "to the minimax-regret strategy:",
     "to the minimum-dispersion strategy a* = argmin_a std_k(S_{T_k}(a)) (ties broken by the MEC mean), and not, in general, to the minimax-regret strategy (Corrected in v1.25.):"),
    ("sub", "That is, extreme hedging minimizes the worst-case regret across all theories.",
     "That is, extreme hedging minimizes cross-theory disagreement, which is not the same as worst-case regret: with two equally credible theories and S(a₁) = (0, 0), S(a₂) = (10, 9), λ → ∞ selects a₁ (σ = 0, worst-case regret 10), whereas minimax regret selects a₂ (worst-case regret 0)."),
    ("sub_in", "That is, extreme hedging", "and minimax regret", "and minimum dispersion"),
    ("sub", "Minimizing the worst-case deviation as λ → ∞ converges to minimizing max_k r_k(a) (under the regularity condition that the maximum is achieved by a single theory): a* = argmin_a max_k[max_{a'} S_{T_k}(a') − S_{T_k}(a)], which is the minimax-regret strategy.",
     "Minimizing σ(a) is not, in general, minimizing the worst-case regret max_k r_k(a) = max_k[max_{a'} S_{T_k}(a') − S_{T_k}(a)]: adding the same constant to every S_{T_k}(a) for one action a leaves σ(a) unchanged but changes its regrets, so the two criteria can select different actions (the example after the statement separates them)."),
    ("sub", "Hence λ interpolates between MEC and minimax regret. □", "Hence λ interpolates between MEC and minimum dispersion. □"),
]

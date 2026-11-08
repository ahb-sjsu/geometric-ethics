# e33: MATLAB FAIL lines 22000 <= L < 35000 (Chapters 17-28). v1.25 corrections.
EDITS = [
    # L22311 TEXT-Ch17: REAL — no count k/582 that prints as 91% has Wilson CI [88.2, 93.4] (width 4.6-4.7 pp for every such k); k = 530 (91.07%) gives [88.5, 93.1]. True k unknown; 530 assumed.
#SUPERSEDED by e37     ("sub", "has a 95% Wilson CI of [88.2%, 93.4%] (n = 582)", "has a 95% Wilson CI of [88.5%, 93.1%] (n = 582)"),
    # L22312 TEXT-Ch17: REAL — k = 326/347 (93.95%) gives Wilson [90.9, 96.0]; the printed [91.1, 96.2] matches no k under Wilson. True k unknown; 326 assumed.
#SUPERSEDED by e37     ("sub", "has CI [91.1%, 96.2%] (n = 347)", "has CI [90.9%, 96.0%] (n = 347)"),
    # L22315 TEXT-Ch17: REAL — h = 2 asin(sqrt(.902)) - pi/2 = 0.93 for the mean of the five gate rates (86-94%, mean 90.2%); even 94% gives 1.08. Verdict "large" (h > 0.8) unchanged.
#SUPERSEDED by e37     ("sub", "Cohen’s h = 1.42 (large)", "Cohen’s h = 0.93 (large; unweighted mean of the five gate rates, 90.2%)"),
#SUPERSEDED by e37     ("sub", "Cohen’s h = 1.42 (see §17.3 for comparison specification)", "Cohen’s h = 0.93 (see §17.3 for comparison specification)"),
    # L22417 TEXT-Ch17: REAL — 0 errors in n = 10,000: two-sided 95% Clopper-Pearson lower bound 0.025^(1/n) = 99.963%; 99.7% is the bound for n = 1,228.
    ("sub", "95% Clopper-Pearson CI: [99.7%, 100%] (n > 10,000 per language)", "95% Clopper-Pearson CI: [99.96%, 100%] (n > 10,000 per language)"),
    # L22420 TEXT-Ch17: REAL — 300,000 passages / 14 languages = 21,429 per language: CP lower bound 99.983% (pooled: 99.9988%).
    ("sub", "confirmed perfect transfer (CI: [99.8%, 100%])", "confirmed perfect transfer (CI: [99.98%, 100%] per language)"),
    # L23923 TEXT-Ch17: REAL — same CI in the Methods appendix; plus the claims ledger and the evidence table that copy it.
    ("sub", "is [99.7%,100%] given the sample size", "is [99.96%, 100%] (Clopper-Pearson, n > 10,000 per language)"),
    ("sub", "[Boundary] CI: [99.7%, 100%]", "[Boundary] CI: [99.96%, 100%]"),
    ("sub_eq", "[99.7,100]", "[99.96,100]"),
    # L23250 TEXT-Ch17: REAL but ALREADY CORRECTED in v1.25 — both passages now read p = 1.3 × 10⁻¹⁰ (one-tailed binomial vs 10%); no edit.
    # L23278 TEXT-Ch17: REAL, UNRESOLVED — the same N = 3,680 fuzz study lists "Rights (22%), Loyalty (18%)" in §17.10 and "Loyalty (28%), Rights (17%)" in Discovery 2; the source data were not found, so no edit (owner must pick).
    # L25803 GE-PROP-18-4: REAL — IV = Var[Σ_total] vanishes when component violations cancel (Σ¹ = −Σ²), so L_inv = 0 gives invariance of the total only. Statement unchanged; proof clause fixed.
    ("sub", "L_inv ≥ 0 with equality iff Σ(g(x)) = Σ(x) for all g ∈ G almost surely — i.e., iff Σ is gauge-invariant.",
     "L_inv ≥ 0 with equality iff Σ_total(g(x)) = Σ_total(x) for all g ∈ G almost surely — i.e., iff the total evaluation is gauge-invariant. (Invariance of each component Σᵘ is stronger: violations in different components can cancel in Σ_total, so componentwise invariance needs the per-dimension loss E[Σ_μ Var_g[Σᵘ(g(x))]].)"),
    # L25042 GE-LEMMA-18-1: REAL — metric non-degeneracy does not make Σ̃ depend on every coordinate (g = I, Σ̃ = x¹ has ∂Σ̃/∂x² ≡ 0), and the proof only reaches "at some configuration". Hypothesis added, conclusion weakened to what the proof gives.
    ("sub", "If C1 holds, then the moral evaluation function Σ has no “blind spots”: ∂Σ/∂Ψ_i ≠ 0 for all i ∈ {1, …, 9}.",
     "If C1 holds and Σ̃ depends non-trivially on every coordinate of M, then the moral evaluation function Σ has no “blind spots”: for each i ∈ {1, …, 9}, ∂Σ/∂Ψ_i ≠ 0 at some configuration. (Corrected in v1.25.)"),
    ("sub", "depends on the full metric g_μν and all nine dimensions contribute (non-degeneracy, Def. A.1 condition 2), the chain rule gives",
     "depends non-trivially on every coordinate (the hypothesis; non-degeneracy of g_μν, Def. A.1 condition 2, does not imply it, since Σ̃ = x¹ with g = I has ∂Σ̃/∂x² ≡ 0), the chain rule gives"),
    ("sub", "for at least one configuration (otherwise dimension i would be degenerate in g). □",
     "for at least one configuration (otherwise Σ̃ would not depend on dimension i). □"),
    # L27790 GE-PROP-19-3: REAL — the "only if" is false with all w_k > 0: J₁ = f + h, J₂ = f − h, w = (½, ½) gives S = f invariant though neither module is. Statement reduced to the (true) "if" direction.
    ("sub", "The aggregation satisfies the BIP if and only if all EMs satisfy the BIP and the aggregation weights are gauge-invariant.",
     "The aggregation satisfies the BIP if all EMs satisfy the BIP and the aggregation weights are gauge-invariant; the converse fails, because BIP violations in different EMs can cancel in the weighted sum. (Corrected in v1.25.)"),
    ("sub", "(⇒) Suppose the aggregation satisfies the BIP: S(g·F) = S(F) for all g ∈ G. Then Σ_k w_k J_k(g·F) = Σ_k w_k J_k(F). If some J_k violates the BIP, then J_k(g·F) ≠ J_k(F) for some g, and the weighted sum changes unless the violation is exactly cancelled by other terms — which cannot hold for all F unless w_k = 0. Hence each J_k must satisfy the BIP. Similarly, if w is not gauge-invariant, the aggregation would change under re-description. (⇐) Suppose each J_k",
     "Suppose each J_k"),
    ("sub", "eliminate actions before the linear aggregation step. □",
     "eliminate actions before the linear aggregation step. The converse fails: if f is gauge-invariant and h is not, the modules J_1 = f + h and J_2 = f − h with w_1 = w_2 = 1/2 give S = f, which satisfies the BIP although neither module does. □"),
    # L27811 + L27815 GE-PROP-19-4: REAL — max deviation <= 2 std is false (|G| = 100, one outlier: 1.000 vs 0.199); Samuelson gives 2 sqrt(|G|-1) std. And L_inv < ε does not give E[Bd] <= ε/τ (proof needs L_inv <= ε²/4). Statement now carries the bound the proof yields.
    ("sub_in", "Proposition 19.4 (Bond Index Convergence)", "For an AI system with invariance loss",
     "For an AI system with a finite transformation suite G (containing the identity) and invariance loss"),
    ("sub_in", "Proposition 19.4 (Bond Index Convergence)", "]≤ϵ/τ", "]≤2√((|G|−1)ϵ)/τ"),
    ("sub_in", "Proposition 19.4 (Bond Index Convergence)", "is the domain-specific tolerance. As",
     "is the domain-specific tolerance. (Corrected in v1.25.) As"),
    ("sub", "Since max_g |Σ(g(x)) − Σ(x)| ≤ 2 std_g[Σ(g(x))] = 2√(IV(x,G)) (the maximum deviation from the mean is bounded by twice the standard deviation), we have Bd(x) ≤ 2√(IV(x,G))/τ. Taking expectations and applying Jensen’s inequality: E[Bd] ≤ 2√(E[IV])/τ. The invariance loss satisfies L_inv = E[IV] by definition. Hence E[Bd] ≤ 2√(L_inv)/τ ≤ ε/τ when L_inv ≤ ε²/4. As L_inv → 0, E[Bd] → 0 monotonically.",
     "Since the identity lies in G, |Σ(g(x)) − Σ(x)| is at most twice the largest deviation of the |G| values Σ(g(x)) from their mean, and by Samuelson’s inequality no value lies more than √(|G| − 1) standard deviations from the mean. Hence max_g |Σ(g(x)) − Σ(x)| ≤ 2√(|G| − 1) std_g[Σ(g(x))] = 2√((|G| − 1) IV(x,G)), and Bd(x) ≤ 2√((|G| − 1) IV(x,G))/τ. (Twice the standard deviation alone is not a bound: with |G| = 100 and one outlying value, the maximum deviation is about five times 2 std.) Taking expectations and applying Jensen’s inequality: E[Bd] ≤ 2√((|G| − 1) E[IV])/τ. The invariance loss satisfies L_inv = E[IV] by definition. Hence E[Bd] ≤ 2√((|G| − 1) L_inv)/τ < 2√((|G| − 1) ε)/τ, and E[Bd] ≤ ε/τ holds once L_inv ≤ ε²/(4(|G| − 1)). As L_inv → 0, this bound, and with it E[Bd], goes to 0."),
    # L27402 GE-PROP-19-5: REAL — the trace removes the index g but not the dependence of T on the input's language (T_en, T_fr can give O = (1,0) vs (3,0)); chance-level probing needs tr_G(T(g·x)) = tr_G(T(x)). Also "chance (~50%)" contradicts the 16.7% (six-language) chance rate stated in §17.10.
    ("sub", "That is, the canonicalized output carries zero gauge-fiber information in the sense that no linear probe on Oᵘ can recover the gauge index g.",
     "That is, the canonicalized output has no gauge-fiber component: the gauge index g is not a coordinate of Oᵘ. This does not by itself stop a probe from recovering the input’s language, because Oᵘ still depends on the input through T; the trace removes that dependence only if tr_G(T(g·x)) = tr_G(T(x)) for all g, the condition the contrastive objective below trains for. (Corrected in v1.25.)"),
    ("sub", "The 99.8% language-probe accuracy of Section 17.10 would drop to chance level (~50%) under this architecture — not by better training, but by structural impossibility.",
     "If that condition holds exactly, the 99.8% language-probe accuracy of Section 17.10 would drop to chance level (the 16.7% chance rate quoted there) under this architecture; the trace alone does not guarantee it."),
    ("sub", "This replaces the post-hoc linear probe test of Section 17.10 with an architectural guarantee.",
     "This replaces the post-hoc linear probe test of Section 17.10 with an architectural constraint whose invariance is enforced in training."),
    # L28494 TEXT-Ch20: REAL (rounding) — (750 − 13.50)/13.50 = 5,455.56%, which rounds to 5,456%.
    ("sub", "a 5,455% increase overnight", "a 5,456% increase overnight"),
    # L28213 GE-LEMMA-20-1: REAL — the max-over-i step bounds ||T(s) − T(s')|| only in the max-norm; with Euclidean norms the constant is L sqrt(n − 1) (n = 5, ratios 0.5: eigenvalue 1, BGE not unique). Norm specified.
    ("sub", "then the best-response mapping on Gamma+ is a contraction with Lipschitz constant L = max_i(kappa_i / alpha_i) < 1, and the BGE is unique.",
     "then, with kappa_i/alpha_i measured against the max-norm ||s_{-i}|| = max_{j≠i} ||s_j|| on the other agents' paths, the best-response mapping on Gamma+ is a contraction in the max-norm ||s|| = max_i ||s_i|| with Lipschitz constant L = max_i(kappa_i / alpha_i) < 1, and the BGE is unique. (Corrected in v1.25.)"),
    ("sub", "Taking the maximum over i, ||T(s) - T(s')||≤ L||s - s'|| with L = max_i(kappa_i/alpha_i) < 1.",
     "Since ||s_{-i} - s'_{-i}|| ≤ ||s - s'|| in the max-norm, taking the maximum over i gives ||T(s) - T(s')||≤ L||s - s'|| with L = max_i(kappa_i/alpha_i) < 1. (The norm matters: with Euclidean norms the same per-agent ratios give a Lipschitz constant of up to L√(n − 1), which need not be below 1.)"),
    # L29212 TEXT-Ch21: REAL — Def. 21.2 weight Da^T Sigma^-1 Da also charges the nonzero Da_5 (and the Sigma_{1,5} cross term). w_B stays finite, so Path B is still selected.
    ("sub", "Edge weight: w_B = (mortality risk)^2 / sigma_1^2.",
     "Edge weight: w_B = Da^T Sigma^{-1} Da over the two nonzero components Da_1 and Da_5 — the (mortality risk)^2 / sigma_1^2 term plus the d_5 and d_1-d_5 terms (the quadratic form charges the trust gain too) — finite, with no boundary crossed."),
    ("sub", "to reduce Da_1 while maintaining zero cost on d_2 through d_9.", "to reduce Da_1 while crossing no boundary on d_2 through d_9."),
    # L30201 GE-THM-23-1: REAL — with a d_9 cross term (Sigma_{3,9} is named as critical in the definition) the quadratic is minimised at Da_9 = −(Σ⁻¹)_9k Da_k/(Σ⁻¹)_99, not at 0. Hypothesis added.
    ("sub", "the informed agent's Mahalanobis distance to the true future state is systematically lower on the d_9 component:",
     "the informed agent's Mahalanobis distance to the true future state is systematically lower on the d_9 component, provided the other components of the move are the same for both agents and uncoupled from d_9 in Sigma_F^{-1} (Corrected in v1.25.):"),
    ("sub", "is smaller when Da_9 is small (informed agent is already close to the true state on d_9).",
     "is smaller when Da_9 is small (informed agent is already close to the true state on d_9), given that d_9 has no cross terms with the other components of Da; with a coupling such as Sigma_{3,9} and Da_3 ≠ 0, the distance is minimised not at Da_9 = 0 but at Da_9 = -Sum_{k≠9} (Sigma_F^{-1})_{9k} Da_k / (Sigma_F^{-1})_{99}."),
    # L31571 TEXT-Ch25: REAL — PV of $1 in 100 years: 1.03^-100 = $0.052 (about five cents); only at 5% (1.05^-100 = $0.0076) is it under a cent.
    ("sub", "implies that a dollar of climate damage in 100 years is worth less than a cent today.",
     "implies that a dollar of climate damage in 100 years is worth about five cents today at 3% and less than one cent at 5%."),
    # L31669 GE-THM-25-3: REAL — with discount rate r > 0 both discounted totals converge; full wins iff g_s > G(1 − e^{−rk}) (G = 10, g_s = 2, k = 5, r = 0.5: 4.00 < 18.36 for all T). Holds undiscounted or at low r. Changes the conclusion: dominance is not guaranteed at high (Nordhaus-range) rates.
    ("sub", "Then for sufficiently large n, every agent achieves higher long-run d_1 value at BGE_full than at BGE_1.",
     "Then for sufficiently large n and a sufficiently low discount rate, every agent achieves higher long-run d_1 value at BGE_full than at BGE_1. (Corrected in v1.25.)"),
    ("sub", "For any positive discount rate, there exists a time horizon T beyond which the cumulative d_1 value at BGE_full exceeds the cumulative d_1 value at BGE_1 (because BGE_1 produces zero d_1 after collapse).",
     "Without discounting, there exists a time horizon T beyond which the cumulative d_1 value at BGE_full exceeds the cumulative d_1 value at BGE_1 (because BGE_1 produces zero d_1 after collapse). With a discount rate r > 0 both discounted totals converge, so a long horizon does not settle the comparison: if BGE_1 yields G per period until collapse at time k and BGE_full yields g_s per period indefinitely, BGE_full wins if and only if g_s > G(1 − e^{−rk}), which holds at low discount rates and can fail at high ones."),
    ("sub", "For intergenerational decisions, where the relevant time horizon is effectively infinite, BGE_full strictly dominates.",
     "For intergenerational decisions, where the relevant time horizon is effectively infinite and the discount rate is low, BGE_full strictly dominates."),
    ("sub", "showing that the tragedy of the commons is a BGE on the d_1 projection that is Pareto-dominated by the BGE on the full manifold.",
     "showing that the tragedy of the commons is a BGE on the d_1 projection that, at low discount rates, is Pareto-dominated by the BGE on the full manifold."),
    ("sub", "produces sustainable cooperative geodesics that Pareto-dominate the d_1-only equilibrium (Theorem 25.3).",
     "produces sustainable cooperative geodesics that Pareto-dominate the d_1-only equilibrium at low discount rates (Theorem 25.3)."),
    # L33046 GE-THM-26-5: REAL — a constant-Sigma metric is exactly flat (K = 0) yet off-d_1 costs can separate the scalar and manifold optima (T = 3 > 0 = C K L²). Hypothesis added.
    ("sub", "The alignment tax T(v) is bounded above by the sectional curvature K(v) of the moral manifold at the decision point v:",
     "If the scalar-optimal and manifold-optimal paths coincide wherever the manifold is flat, the alignment tax T(v) is bounded above by the sectional curvature K(v) of the moral manifold at the decision point v (Corrected in v1.25.):"),
    ("sub", "and the projection from 9D to 1D preserves path optimality to first order — the scalar-optimal path is close to the manifold-optimal path on all dimensions.",
     "and by hypothesis the scalar-optimal path is close to the manifold-optimal path. Flatness alone does not give this: under a constant covariance Sigma_A the manifold is exactly flat (K = 0), yet costs on d_2–d_9 can make the manifold-optimal path differ from the scalar one, with T > 0."),
    ("sub", "the performance cost of alignment is bounded by the curvature of the moral manifold, explaining",
     "the performance cost of alignment is bounded by the curvature of the moral manifold where scalar and manifold optima agree in flat regions, explaining"),
    # L33084 GE-THM-26-5: REAL — an L² bound is quadratic growth, not exponential.
    ("sub", "long-horizon planning with compounding moral consequences is exponentially more expensive.",
     "long-horizon planning with compounding moral consequences is quadratically more expensive."),
    # L34089 GE-THM-27-1: REAL — a heterozygous edit passes to each child with p = 1/2, so expected carriers among 2^k descendants stay ~1; spread is not automatic. Statement already conditions on propagation, so only the proof changes. (A neutral edit can also be lost by drift, which bears on "absorbing"; noted in report.)
    ("sub", "By heritability, all n descendants carry the modification. The number of affected vertices grows as n(k) >= 2^k (assuming replacement fertility). To reverse the modification requires applying the inverse edit G^{-1} to every affected individual at every future generation — a set that grows exponentially and, after sufficient generations, encompasses a substantial fraction of the population.",
     "Each child of a carrier inherits a heterozygous edit with probability 1/2, so under replacement fertility the 2^k descendants at generation t+k include on average only about one carrier: spread is not automatic, and a neutral edit can be lost by drift. The theorem concerns an edit that has propagated (by selection, repeated use, or drift), so that its carriers are a substantial fraction of the population, scattered among descendants who cannot be told apart without genome screening. To reverse the modification requires applying the inverse edit G^{-1} to every carrier at every future generation."),
    # L34519 GE-THM-27-5: REAL — the d_4 term (Da_4)²/sigma_44 has second derivative 2/sigma_44 > 0 in either direction; the curvature-sign claim is unsupported. Recast as opposite effects on edge weights (parts (1)-(2) stand).
    ("sub", "have opposite curvature signatures on the bioethical decision complex. Specifically:",
     "have opposite effects on edge weights and reachable sets on the bioethical decision complex. (Corrected in v1.25.) Specifically:"),
    ("sub", "The two types of modification have opposite signs on the d_4 component of the curvature tensor: d_4-expansion produces negative curvature (diverging geodesics — more paths become available), while d_4-restriction produces positive curvature (converging geodesics — paths are funneled toward fewer outcomes).",
     "The two types of modification act in opposite directions on d_4: d_4-expansion spreads the agent's options (more paths become available), while d_4-restriction funnels paths toward fewer outcomes. The difference is in the sign of the change in edge weights, not in the sign of the curvature tensor. (Corrected in v1.25.)"),
    ("sub", "The curvature follows from the second derivative of the metric: expansion yields d^2w/dv^2 < 0 (negative curvature, diverging paths); restriction yields d^2w/dv^2 > 0 (positive curvature, converging paths).",
     "The opposite signs are in the first-order change of edge weights, not in their curvature: the d_4 term (Da_4)^2 / sigma_44 is convex in Da_4 whichever way the modification moves it (d^2w/d(Da_4)^2 = 2/sigma_44 > 0, and 2 (Sigma_B^{-1})_44 > 0 in general)."),
    ("sub", "have opposite curvature signatures, providing a formal basis", "have opposite effects on edge weights and reachable sets, providing a formal basis"),
]

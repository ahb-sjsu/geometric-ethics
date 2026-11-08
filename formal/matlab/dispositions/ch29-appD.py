# Edits for FAIL lines L >= 35000 (Prop. 29.3 and Appendix D case studies).
EDITS = [
    # L37439 GE-PROP-20-3 (Prop. 29.3 Meta-Metric Existence): REAL — the invariant family a Tr(g⁻¹hg⁻¹k) + b Tr(g⁻¹h)Tr(g⁻¹k) has two constants; the proof itself concludes "up to overall scale and the ratio b/a", the statement said scale only.
    ("sub", "This meta-metric is unique up to overall scale if we require invariance",
     "This meta-metric is unique up to two constants, an overall scale and the ratio b/a of the DeWitt family given in the proof (Corrected in v1.25.), if we require invariance"),

    # L38832 TEXT-AppD (D.1 triage, welfare of option γ): REAL — (0.60 + 0.85)/2 = 0.725, not 0.62. Minimal fix keeps 0.62 and states it as a discount for denying A's best prognosis (text already gives that reason); no downstream number or verdict changes.
#SUPERSEDED by e36     ("sub_eq", "Welfare 0.62: moderate combined prognosis (0.60 + 0.85)/2, but denies the best prognosis (A).",
#SUPERSEDED by e36      "Welfare 0.62: combined prognosis (0.60 + 0.85)/2 = 0.725, discounted to 0.62 because it denies the best prognosis (A)."),

    # L39622 TEXT-AppD (D.2 whistleblower, expert-weighted contraction): REAL — 0.2982 + 0.2511 + 0.1418 + 0.09795 = 0.78905 → 0.789, not 0.787. Verdict (Report) unchanged.
    ("sub", "0.15(0.653) = 0.787", "0.15(0.653) = 0.789"),

    # L40464 TEXT-AppD (D.4 hiring, Bond Index of the biased system): REAL — 5.08 / 100 × (1/0.01) = 5.08, not 0.51 (τ = 0.01, as in D.1 and the erisml default).
    ("sub", "5.08 / 100 × (1/0.01) = 0.51", "5.08 / 100 × (1/0.01) = 5.08"),
    # L40464/L40732 downstream: Bd = 5.08 falls in this case's "> 1.0: Fundamental redesign required" tier, not "0.10–1.0: Remediate". VERDICT CHANGES.
    ("sub_eq", "Bd = 0.51 >> 0.10 threshold. Substantive demographic bias detected. Remediation required.",
     "Bd = 5.08 > 1.0 threshold. Severe demographic bias detected. Fundamental redesign required."),
    # L40732 TEXT-AppD (tier of the biased system): REAL — follows from Bd = 5.08.
    ("sub", "For the biased system: Bd = 0.51. Remediation required.",
     "For the biased system: Bd = 5.08. Fundamental redesign required."),
    # L40464 downstream (reference-implementation note): number follows the fix. NOTE erisml-lib appendix_d_cs4_hiring.py computes 5.08 and then overrides it with Bd_b_book = 0.51; it must be updated for this sentence to be true.
    ("sub", "Bd = 0.51 biased) against book reference values.",
     "Bd = 5.08 biased) against book reference values."),

    # L41143/L41154/L41165/L41174/L41183 TEXT-AppD (D.5 climate, φ_N1..φ_N5): REAL — the stated v(S) is additive, so φ_i = v({i}); normalized shares are 0.792/0.068/0.000/0.028/0.113, not 0.387/0.212/0.003/0.128/0.270. Recomputed shares would give N₁ 5.76 Gt (> its 5.0 Gt emissions), so the numbers cannot simply be substituted. erisml-lib also computes the raw values and then substitutes the book's "calibrated" ones. Minimal honest fix: say the φ values are stipulated, not derived; owner decision needed (see report).
#SUPERSEDED by e35     ("sub_eq", "Rather than enumerate all 120 orderings, we compute the marginal contributions for key coalitions and average:",
#SUPERSEDED by e35      "Because this v(S) is additive (a sum of stand-alone terms with no interaction between nations), every marginal contribution v(S∪{i}) − v(S) equals v({i}), and the Shapley value reduces to φ_i = v({i}). Normalized to shares of v(N), the formula as written gives N₁ = 0.792, N₂ = 0.068, N₃ = 0.000, N₄ = 0.028, N₅ = 0.113, which would assign N₁ 5.76 Gt, more than its 5.0 Gt of current emissions. The φ values below are therefore stipulated illustrative shares, not outputs of this v(S); deriving them would require a coalition value function that includes the interaction terms of Step 3 and caps each nation's burden at its current emissions:"),
    # L41143 downstream (reference-implementation note): erisml does not verify the φ values; it substitutes them.
#SUPERSEDED by e35     ("sub", "Verifies Shapley values, fair allocation, NDC comparison,",
#SUPERSEDED by e35      "Computes the Shapley values of the stated v(S) for comparison and then uses the stipulated φ values; verifies fair allocation, NDC comparison,"),
]

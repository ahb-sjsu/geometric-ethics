# Appendix D.5 (climate allocation): rebuilt cooperative game. REPLACES the D.5 items of e34.py
# (drop e34's sub_eq "Rather than enumerate all 120 orderings, ..." and its sub "Verifies Shapley values,
# fair allocation, NDC comparison,"). Numbers computed on Atlas (exact rational Shapley enumeration,
# /archive/ahb-sjsu/ge-v125/cs5/game2.py) and matched by erisml-lib appendix_d_cs5_climate.py and
# formal/matlab/check_appD_5_climate.m.
#
# Game (owner decision 2026-11-08: national capacity): national capacity ∝ capacity_i × current_share_i;
# b_i = equal-weight mean of normalized national capacity, responsibility and current share (sum b_i = 1).
# Each structure-tensor component S^a_{bc} adds 3|S^a_{bc}| b_a to v(S) when b, c are in S and a is not;
# its Shapley effect moves |S^a_{bc}| b_a of burden from a to b and c (half each); v(N) is unchanged.
# phi = 0.484123 / 0.183810 / 0.001405 / 0.111671 / 0.218991. No allocation exceeds current emissions
# (the cap does not bind), so the text states no cap rule.
# Allocations 3.522 / 1.337 / 0.010 / 0.812 / 1.593 (sum 7.274); contraction loss unchanged at 2.264 Gt.
EDITS = [
    # L41109 TEXT-AppD (D.5 v(S)): REAL — the stated v(S) is additive (phi_i = v({i})), so it cannot give the printed shares; rebuilt with interaction terms.
    ("sub_eq", "The coalition value v(S) measures the total emissions reduction achievable by coalition S, weighted by the moral quality of the allocation (fairness, capacity, historical responsibility). For a coalition S ⊆ {N₁, N₂, N₃, N₄, N₅}:",
     "The coalition value v(S) measures the share of the reduction burden that coalition S carries: the stand-alone burdens of its members, plus the burden that relationships inside S owe to a nation outside it. For a coalition S ⊆ {N₁, N₂, N₃, N₄, N₅}:"),
    ("sub_eq", "v(S) = Σ_{i∈S} capacity_i × responsibility_i × (current_emissions_i / total_emissions)",
     "v(S) = Σ_{i∈S} b_i + Σ_{S^a_{bc}} 3|S^a_{bc}| b_a · [b ∈ S, c ∈ S, a ∉ S],   b_i = (ĉ_i + r̂_i + ŝ_i) / 3"),
    ("sub", "- current share = current_emissions_i / 14.55",
     "- current share = current_emissions_i / 14.55 - ĉ_i is national capacity, capacity_i × current share_i, and ĉ_i, r̂_i, ŝ_i are the three normalized to sum to 1 across the five nations. Capacity is taken in national terms (per-capita capacity times current share, with current emissions standing in for economic size, since the case gives no population data) so that all three principles are measured on the same national scale. So b_i, the nation’s stand-alone burden, is the equal-weight mean of ability to pay, polluter pays and current emissions, and Σ b_i = 1. The structure tensor of Step 3 enters as a burden transfer: a coalition that contains b and c but not a carries the extra 3|S^a_{bc}| b_a, the share of a’s burden that the b–c relationship owes. By the Shapley formula this term lowers a’s value by |S^a_{bc}| b_a, raises b’s and c’s by half that each, and adds nothing to v(N). The scaling measures each component in units of the indexed nation’s own stand-alone burden: S^N3_{N1,N2} = 0.35 moves 35% of N₃’s burden to N₁ and N₂ (N₃’s claim is amplified), and S^N2_{N1,N5} = −0.15 moves 15% of N₂’s burden to N₁ and N₅ (N₂’s burden is reduced). (A term present only when all three nations are in the coalition would be split equally among them and would raise N₃’s burden, the opposite of Step 3.)"),
    # L41125 TEXT-AppD (method): REAL — the shares now come from full enumeration of the stated game.
    ("sub_eq", "Rather than enumerate all 120 orderings, we compute the marginal contributions for key coalitions and average:",
     "We enumerate all 2⁴ = 16 coalitions S ⊆ N∖{i} for each nation (equivalent to the 120 orderings). The stand-alone burdens are b = (0.468, 0.216, 0.002, 0.112, 0.203) for N₁ to N₅. (Rebuilt in v1.25: the v1.24 value function was additive, so its Shapley values did not match the printed shares.)"),
    # L41143 TEXT-AppD (phi_N1): REAL — new game.
    ("sub", "Its marginal contribution to any coalition is large — it brings the most reduction capacity and the strongest moral obligation.",
     "Its marginal contribution to any coalition is large — it brings the most reduction capacity and the strongest moral obligation — and both structure-tensor terms move burden onto it."),
    ("sub_eq", "φ_N1 = 0.387", "φ_N1 = 0.484"),
    ("sub_eq", "N₁’s fair share of the 7.275 Gt reduction: 0.387 × 7.275 = 2.815 Gt (56.3% of its current emissions).",
     "N₁’s fair share of the 7.275 Gt reduction: φ_N1 × 7.275 = 3.522 Gt (70.4% of its current emissions)."),
    # L41154 TEXT-AppD (phi_N2): REAL — new game.
    ("sub_eq", "φ_N2 (large developing): N₂ has moderate capacity but high current emissions. Its marginal contribution is significant but reduced by lower historical responsibility.",
     "φ_N2 (large developing): N₂ has moderate capacity but high current emissions. Its marginal contribution is significant but reduced by lower historical responsibility, and the supply-chain term moves 15% of its stand-alone burden to N₁ and N₅."),
    ("sub_eq", "φ_N2 = 0.212", "φ_N2 = 0.184"),
    ("sub_eq", "N₂’s fair share: 0.212 × 7.275 = 1.542 Gt (34.3% of its current emissions).",
     "N₂’s fair share: φ_N2 × 7.275 = 1.337 Gt (29.7% of its current emissions)."),
    # L41165 TEXT-AppD (phi_N3): REAL — new game; N3 stays near zero.
    ("sub_eq", "φ_N3 (small island state): N₃ has negligible capacity, negligible emissions, and negligible responsibility. Its Shapley value is near zero.",
     "φ_N3 (small island state): N₃ has negligible capacity, negligible emissions, and negligible responsibility, and the colonial term moves a further 35% of its stand-alone burden to N₁ and N₂. Its Shapley value is near zero."),
    ("sub_eq", "φ_N3 = 0.003", "φ_N3 = 0.001"),
    ("sub_eq", "N₃’s fair share: 0.003 × 7.275 = 0.022 Gt (essentially zero — 44% of its tiny 0.05 Gt).",
     "N₃’s fair share: φ_N3 × 7.275 = 0.010 Gt (essentially zero — 20% of its tiny 0.05 Gt)."),
    # L41174 TEXT-AppD (phi_N4): REAL — new game.
    ("sub_eq", "φ_N4 = 0.128", "φ_N4 = 0.112"),
    ("sub_eq", "N₄’s fair share: 0.128 × 7.275 = 0.931 Gt (46.6% of its current emissions).",
     "N₄’s fair share: φ_N4 × 7.275 = 0.812 Gt (40.6% of its current emissions)."),
    # L41183 TEXT-AppD (phi_N5): REAL — new game.
    ("sub_eq", "φ_N5 = 0.270", "φ_N5 = 0.219"),
    ("sub_eq", "N₅’s fair share: 0.270 × 7.275 = 1.964 Gt (65.5% of its current emissions).",
     "N₅’s fair share: φ_N5 × 7.275 = 1.593 Gt (53.1% of its current emissions)."),
    # L41190 TEXT-AppD (sum): REAL — new shares.
    ("sub", "= 0.387 + 0.212 + 0.003 + 0.128 + 0.270 = 1.000.", "= 0.484 + 0.184 + 0.001 + 0.112 + 0.219 = 1.000."),
    # L41192 TEXT-AppD (axioms): JUDGMENT — N3 is not exactly a null (dummy) player in this game, only nearly one; wording made exact.
    ("sub", "3. Dummy player: N₃ (negligible contribution) receives near-zero burden.",
     "3. Null player: a nation that adds nothing to any coalition bears nothing; N₃, whose contribution is nearly nothing, receives near-zero burden (φ = 0.001)."),
    # L41226-41231 TEXT-AppD (allocation table): REAL — new allocations, % and residuals; totals 7.274 / 7.276 unchanged.
    ("nth_after", "Shapley Share (Gt)", 5, "2.815", "3.522"),
    ("nth_after", "Shapley Share (Gt)", 6, "56.3%", "70.4%"),
    ("nth_after", "Shapley Share (Gt)", 7, "2.185", "1.478"),
    ("nth_after", "Shapley Share (Gt)", 10, "1.542", "1.337"),
    ("nth_after", "Shapley Share (Gt)", 11, "34.3%", "29.7%"),
    ("nth_after", "Shapley Share (Gt)", 12, "2.958", "3.163"),
    ("nth_after", "Shapley Share (Gt)", 15, "0.022", "0.010"),
    ("nth_after", "Shapley Share (Gt)", 16, "44.0%", "20.4%"),
    ("nth_after", "Shapley Share (Gt)", 17, "0.028", "0.040"),
    ("nth_after", "Shapley Share (Gt)", 20, "0.931", "0.812"),
    ("nth_after", "Shapley Share (Gt)", 21, "46.6%", "40.6%"),
    ("nth_after", "Shapley Share (Gt)", 22, "1.069", "1.188"),
    ("nth_after", "Shapley Share (Gt)", 25, "1.964", "1.593"),
    ("nth_after", "Shapley Share (Gt)", 26, "65.5%", "53.1%"),
    ("nth_after", "Shapley Share (Gt)", 27, "1.036", "1.407"),
    # L41237 TEXT-AppD (key features): REAL — VERDICT CHANGES: N1 (not N5) bears the highest proportional burden; N2 the lowest.
    ("sub_eq", "Key features of the Shapley allocation: - N₁ bears the largest absolute burden (2.815 Gt) — reflecting its combined capacity and historical responsibility. - N₅ bears the highest proportional burden (65.5%) — reflecting that oil exporters have both high per-capita emissions and high wealth, despite lower absolute totals. - N₃ bears negligible burden — the dummy player axiom correctly exempts nations with negligible contribution. - N₂ receives a moderate burden (34.3%) — its right to development partially offsets its current emissions.",
     "Key features of the Shapley allocation: - N₁ bears the largest absolute burden (3.522 Gt) and the highest proportional burden (70.4%) — reflecting its combined capacity and historical responsibility, plus the burden both structure-tensor terms move onto it. - N₅ bears the next-highest proportional burden (53.1%) — reflecting that oil exporters have both high per-capita emissions and high wealth, despite lower absolute totals. - N₃ bears negligible burden (0.010 Gt) — a nation whose contribution is nearly nothing bears nearly nothing. - N₂ receives the lowest proportional burden of the four large emitters (29.7%; N₃’s is 20.4%) — its right to development and the supply-chain term offset its current emissions."),
    # L41274-41279 TEXT-AppD (NDC table): REAL — new fair shares and gaps; totals 7.274 / −2.264 unchanged.
    ("nth_after", "Shapley Fair (Gt)", 4, "2.815", "3.522"),
    ("nth_after", "Shapley Fair (Gt)", 5, "−0.815", "−1.522"),
    ("nth_after", "Shapley Fair (Gt)", 8, "1.542", "1.337"),
    ("nth_after", "Shapley Fair (Gt)", 9, "−0.542", "−0.337"),
    ("nth_after", "Shapley Fair (Gt)", 12, "0.022", "0.010"),
    ("nth_after", "Shapley Fair (Gt)", 13, "−0.012", "0.000"),
    ("nth_after", "Shapley Fair (Gt)", 16, "0.931", "0.812"),
    ("nth_after", "Shapley Fair (Gt)", 17, "−0.131", "−0.012"),
    ("nth_after", "Shapley Fair (Gt)", 20, "1.964", "1.593"),
    ("nth_after", "Shapley Fair (Gt)", 21, "−0.764", "−0.393"),
    # L41292/L41294 TEXT-AppD (where the loss concentrates): REAL — new gaps; N1 still the largest absolute gap, N5 second (verdict holds).
    ("sub", "N₁ undercommits by 0.815 Gt (29% of its fair share)", "N₁ undercommits by 1.522 Gt (43% of its fair share)"),
    ("sub", "N₅ undercommits by 0.764 Gt (39% of its fair share)", "N₅ undercommits by 0.393 Gt (25% of its fair share)"),
    # L41316 TEXT-AppD (metric 1): REAL — shifted shares now computed from the game (a metric weights the three base terms by g_11, g_33, g_66). VERDICT CHANGES: N1's share falls slightly and N2's rises (v1.24: N1 up, N2 down).
    ("sub_eq", "This metric increases N₁’s burden (highest per-capita historical emissions) and decreases N₂’s (low per-capita despite high absolute emissions). The Shapley allocation shifts:",
     "In v(S) a metric acts by weighting the three base terms: national capacity by g_11 (welfare: the economic cost of reducing), responsibility by g_33 (fairness: historical responsibility) and current share by g_66 (societal: climate stabilization). The Euclidean metric gives the equal weights of Step 4. This metric weights responsibility 3 and current share 1.5 against capacity 1. Because N₁’s share of national capacity (0.58) exceeds its share of historical responsibility (0.48), the shift lowers N₁ slightly, and it raises N₂, whose historical share (0.24) exceeds its capacity share (0.09). (The case gives no population data, so per-capita equity can enter only through these weights.) The Shapley allocation shifts:"),
    ("sub", "φ'_N1 = 0.42 (up from 0.387)", "φ'_N1 = 0.479 (down from 0.484)"),
    ("sub", "φ'_N2 = 0.18 (down from 0.212)", "φ'_N2 = 0.200 (up from 0.184)"),
    # L41330 TEXT-AppD (metric 2): REAL — recomputed; directions hold (N1, N5 up; N2, N3 down).
    ("sub", "φ'_N1 = 0.44 (up)", "φ'_N1 = 0.518 (up)"),
    ("sub", "φ'_N5 = 0.30 (up)", "φ'_N5 = 0.228 (up)"),
    ("sub", "φ'_N2 = 0.15 (down)", "φ'_N2 = 0.149 (down)"),
    # L41346 TEXT-AppD (metric 3): REAL — autonomy has no term in v(S); computed shares; "closer to the NDC framework" now verified (distance 0.101 -> 0.082).
    ("sub_eq", "This produces an allocation closer to the NDC framework — nations are not compelled beyond what they voluntarily commit. The contraction loss remains large, but the metric says that’s acceptable because autonomy outweighs fairness.",
     "Autonomy (μ = 4) has no term in v(S), so this metric acts only through g_11 = 0.5, which halves the weight of capacity: φ'_N1 = 0.464 (down from 0.484), φ'_N2 = 0.205 (up from 0.184), φ'_N5 = 0.214 (down from 0.219). This produces an allocation closer to the NDC framework (the distance between the allocation shares and the pledge shares falls from 0.101 to 0.082) — nations are asked for less beyond what they voluntarily commit. The contraction loss remains large (the total is still 7.275 Gt), but the metric says that’s acceptable because autonomy outweighs fairness."),
    # L41376 TEXT-AppD (Transform 4): REAL — v(S) has no vulnerability term, and a reduction allocation cannot make N3 a net recipient; reworded to say what the transform does.
    ("sub_eq", "Transform 4 (bond-changing): Vulnerability weighting. Double the weight of climate vulnerability in the coalition value function. - N₃’s effective claim increases (vulnerability 0.95 × 2). N₃ shifts from near-zero allocation to a net recipient of climate finance. - Bd > 0. Correctly identified — vulnerability weighting is a substantive moral choice.",
     "Transform 4 (bond-changing): Vulnerability weighting. Add a climate-vulnerability term to the coalition value function (v(S) as defined has none). - This changes the value function itself, not its presentation: any such term lowers the burden of the most vulnerable nation, N₃ (vulnerability 0.95), and moves it to the others. Within an allocation of reductions N₃’s burden can fall to zero but not below; making N₃ a net recipient of climate finance needs a transfer outside this game. - Bd > 0. Correctly identified — vulnerability weighting is a substantive moral choice."),
    # L41420-41431 TEXT-AppD (audit artifact): REAL — new value function, shares, allocations, gaps; emergence degree recomputed (0.28 had no derivation).
    ("sub_in", "climate-allocation-001", "\"emergence_degree\": 0.28", "\"emergence_degree\": 0.07"),
    ("sub_in", "climate-allocation-001", "\"note\": \"28% of collective obligation is emergent (not decomposable to individual terms)\"",
     "\"note\": \"eta = |phi - b| / |phi| over the five Shapley shares: 7% of the allocation comes from the structure tensor (not decomposable to stand-alone burdens)\""),
    ("sub_in", "climate-allocation-001", "\"coalition_value_function\": \"capacity × responsibility × current_share\"",
     "\"coalition_value_function\": \"mean(normalized national capacity, responsibility, current_share) + structure-tensor burden transfers\""),
    ("sub_in", "climate-allocation-001", "{\"phi\": 0.387, \"reduction_Gt\": 2.815, \"reduction_pct\": 56.3}", "{\"phi\": 0.484, \"reduction_Gt\": 3.522, \"reduction_pct\": 70.4}"),
    ("sub_in", "climate-allocation-001", "{\"phi\": 0.212, \"reduction_Gt\": 1.542, \"reduction_pct\": 34.3}", "{\"phi\": 0.184, \"reduction_Gt\": 1.337, \"reduction_pct\": 29.7}"),
    ("sub_in", "climate-allocation-001", "{\"phi\": 0.003, \"reduction_Gt\": 0.022, \"reduction_pct\": 44.0}", "{\"phi\": 0.001, \"reduction_Gt\": 0.010, \"reduction_pct\": 20.4}"),
    ("sub_in", "climate-allocation-001", "{\"phi\": 0.128, \"reduction_Gt\": 0.931, \"reduction_pct\": 46.6}", "{\"phi\": 0.112, \"reduction_Gt\": 0.812, \"reduction_pct\": 40.6}"),
    ("sub_in", "climate-allocation-001", "{\"phi\": 0.270, \"reduction_Gt\": 1.964, \"reduction_pct\": 65.5}", "{\"phi\": 0.219, \"reduction_Gt\": 1.593, \"reduction_pct\": 53.1}"),
    ("sub_in", "climate-allocation-001", "\"dummy_player\"", "\"null_player\""),
    ("sub_in", "climate-allocation-001", "\"N1\": -0.815", "\"N1\": -1.522"),
    ("sub_in", "climate-allocation-001", "\"N2\": -0.542", "\"N2\": -0.337"),
    ("sub_in", "climate-allocation-001", "\"N3\": -0.012", "\"N3\": 0.000"),
    ("sub_in", "climate-allocation-001", "\"N4\": -0.131", "\"N4\": -0.012"),
    ("sub_in", "climate-allocation-001", "\"N5\": -0.764", "\"N5\": -0.393"),
    # L41455 TEXT-AppD (reference implementation note): REAL — erisml now computes the shares instead of substituting them.
    ("sub", "Verifies Shapley values, fair allocation, NDC comparison, contraction loss, gap distribution, three metric analyses, and Bond Index — all against book reference values.",
     "Computes the Shapley values of the game above by exact enumeration and verifies them, fair allocation, NDC comparison, contraction loss, gap distribution, three metric analyses, and Bond Index — all against book reference values."),
    # L41530 TEXT-AppD (D.6 summary): REAL — the transfers leave v(N) equal to the sum of stand-alone burdens, so collective obligation does not exceed the sum of individual duties; it is redistributed (eta = 0.07).
    ("sub", "a case where emergent collective obligation exceeds the sum of individual duties,",
     "a case where relational structure redistributes collective obligation in ways no individual duty assigns (η = 0.07),"),
]

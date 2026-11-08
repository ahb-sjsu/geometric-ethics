# Formal verification: Geometric Ethics v1.25

`formal/lean/` is a Lean 4 + Mathlib project that machine-checks the claims the book marks
**Proved**, plus the V4-era claims added with the strata and V4 content updates (PR #3) and the
V4 restatements of three D4-era results. Every Lean theorem carries a docstring naming its ledger
id (`ledger/claims/<id>.json`).

Toolchain: `leanprover/lean4:v4.32.2`, Mathlib tag `v4.32.2` (rev `905b958`), the same pin as
erisml-lib `formal/HohfeldV4.lean`, gtc-prototype `formal/twin-containment` and the
geometric-observation papers.

| File | Covers |
|---|---|
| `lean/GeometricEthics/Tensor.lean` | Props 6.1, 6.2, 6.3, 11.3, 15.1, 15.3 (pointwise tensor algebra) |
| `lean/GeometricEthics/Hohfeld.lean` | Prop 8.3-V4, Thm 12.2-V4, Prop A.2-V4, Lemma 9.1-V4, Lemma A.2 |
| `lean/GeometricEthics/Search.lean` | Prop 11.2; supporting lemma for Prop 11.4 |
| `lean/GeometricEthics/Strata.lean` | Def 8.14, Thm 8.6, Thm 8.7 |
| `lean/Axioms.lean` | `#print axioms` for every declaration |
| `lean/build-on-atlas.sh` | rebuild + audit script |
| `lean/RESULTS-<date>.txt` | build record, sorry count, axiom audit |

## Result (2026-11-08, Atlas)

`lake build` succeeds (8660 jobs, no errors, no warnings in these modules), **0 `sorry`**, and
`#print axioms` shows every declaration resting on a subset of `propext`, `Classical.choice`,
`Quot.sound`. The full record is `lean/RESULTS-2026-11-08.txt`.

## Claim by claim

The statements are about the tensor algebra at one point (the tangent space identified with
`Fin n → ℝ`, a coordinate change's Jacobian an invertible matrix), which is all the book's proofs
use. Where the printed statement is false, the corrected statement is proved and a counterexample
to the printed one is machine-checked; those rows say so.

| Ledger id | Book | Lean theorem(s) | Status |
|---|---|---|---|
| GE-PROP-6-1 | Prop 6.1, Invariance of Satisfaction | `Tensor.satisfaction_invariant` | proved |
| GE-PROP-6-2 | Prop 6.2, Decomposition of Disagreement | `Tensor.disagreement_decomposition`, `disagreement_iff`, `disagreement_needs_shared_dimension`, `agree_on_all_obligations_iff`, `disagreement_component_zero_iff` | proved |
| GE-PROP-6-3 | Prop 6.3, Metric Dependence of the Gradient | `Tensor.gradient_unique`, `gradients_differ_iff`; `gradient_sufficient_condition_fails` | proved (symmetric invertible metric); the sufficient condition in the proof is **false**, counterexample checked |
| GE-PROP-10-3 | Prop 10.3, Geodesic Deviation Equation | none | **not formalized**: Mathlib v4.32.2 has covariant derivatives on vector bundles but no Riemann curvature tensor, covariant derivative along a curve, or Jacobi fields; building them is out of scope |
| GE-PROP-11-2 | Prop 11.2, Consistency from Metric Compatibility | `Search.geodesic_heuristic_consistent`, `geodesic_heuristic_zero_on_goal` | proved, over any metric space, with the book's "arc length ≥ geodesic distance" as the hypothesis `dist ≤ c` |
| GE-PROP-11-3 | Prop 11.3, Satisfaction as Directional Derivative | `Tensor.satisfaction_directional_derivative` | proved, Prop 11.1 (`O = −g⁻¹dh`) and a symmetric metric as hypotheses; S is the **negative** of the directional derivative |
| GE-PROP-11-4 | Prop 11.4, A* Optimality on Stratified Spaces | `Search.consistent_implies_admissible` (supporting lemma only) | **not formalized**: the A* algorithm and its optimality proof (Hart, Nilsson and Raphael) are not in Mathlib; only the step that a consistent heuristic vanishing on the goal is admissible is checked |
| GE-PROP-15-1 | Prop 15.1, Inevitability of Residue | `Tensor.residue_mem_ker`, `residue_eq_zero_iff`, `ker_contraction_finrank`, `exists_nonzero_residue`; `residue_zero_for_nonscalar` | proved in the form of the proof supplement (dim V > 1, chosen section); the printed statement is **false**, counterexample checked |
| GE-PROP-15-3 | Prop 15.3, Non-Commutativity of Contraction | `Tensor.C₁_le_C₂`, `C₁_eq_C₂_iff_nonneg`, `C₁_eq_C₂_iff_pos`, `contraction_order_matters`; `equality_without_unanimity`, `unanimity_without_equality_negative_weight` | proved with positive weights (corrected form for nonnegative); the printed "if and only if" is **false** without a sign condition, counterexamples checked |
| GE-LEMMA-A-2 | Lemma A.2, Aut(C₄) ≅ D₄ | `Hohfeld.autC4MulEquivD4`, `card_aut_C4`, `book_generators`, `book_generators_generate`, `book_presentation` | proved, for Mathlib's `cycleGraph 4` |
| GE-LEMMA-A-3 | Lemma A.3, compact connected 1-D Lie group ≅ U(1) | none | **not formalized**: Mathlib v4.32.2 has no classification of Lie groups through the Lie algebra and universal cover |
| GE-PROP-8-3-V4 | §8.4 replacement, V₄ structure of Hohfeldian transitions | `Hohfeld.commuting_involutions`, `V4MulEquivKlein`, `V4_card`, `V4_elements`, `V4_abelian_exponent_two`, `V4_transitive`, `V4_free`, `quarter_turn_not_generated`, `action_is_xor`, `liberty_to_claim_is_sn` | proved (reuses erisml-lib HohfeldV4.lean) |
| GE-THM-12-2-V4 | Thm 12.2 restated for V₄ | `Hohfeld.gauge_group_V4` | proved |
| GE-PROP-A-2-V4 | Prop A.2 restated for V₄ | `Hohfeld.total_invariant`, `charge_s_n`, `charge_sq_V4_invariant` | proved |
| GE-LEMMA-9-1-V4 | Lemma 9.1 restated for V₄ | `Hohfeld.invariant_component_constant`, `degrees_of_freedom_eliminated` | proved (36 − 9 = 27 as a `finrank` statement) |
| GE-DEF-8-14 | Def 8.14, executable stratification | `Strata.ExecStrat`, `ExecStrat.step`, `run`, `crossings`; `step_spec`, `run_eq_last_crossing` | definition formalized, with two consistency lemmas |
| GE-THM-8-6 | Thm 8.6, Containment | `Strata.containment`, `containment_outside` | proved, for any gates |
| GE-THM-8-7 | Thm 8.7, Absorption | `Strata.absorption`, `absorption_set` | proved, for any gates |

The three `-V4` ids were assigned by the coordinator. The ledger has only the D₄ originals
(GE-THM-12-2, GE-PROP-A-2, GE-LEMMA-9-1).

## What the formalization found in the book text (v1.24)

1. **Prop 6.3, proof.** "we have (grad_g f)ᵛ ≠ (grad_ĝ f)ᵛ whenever ∂f/∂xᵘ ≠ 0 along a dimension
   where the inverse metrics differ." This is false. With g⁻¹ = 3I and ĝ⁻¹ = [[2,1],[1,2]] (both
   positive definite, different in every entry) and df = (1,1), both gradients are (3,3). The
   correct criterion is (g⁻¹ − ĝ⁻¹)df ≠ 0 (`gradients_differ_iff`).
2. **Prop 15.1, statement.** "the moral residue R is nonzero unless T is already scalar". This is
   false. Any T in the image of the section (for example T = s(1)) has zero residue, at any rank.
   The proof supplement states the correct result: the residue is nonzero exactly for T outside
   that one-dimensional image, and ker C has dimension nʳ − 1. The proof's "at least 9
   independent components" also assumes n = 9.
3. **Prop 15.3, statement.** "Equality holds if and only if the maximizing ν is the same for all
   μ". The weights carry no sign condition. With a zero weight, C₁ = C₂ holds without a unanimous
   best option (w = (1,0), T = I₂). With a negative weight, a unanimous best option does not give
   equality. The statement holds for strictly positive weights, read as "some ν maximizes every
   row" (ties allowed).
4. **Prop 11.3, statement.** "The satisfaction scalar is the directional derivative of the
   heuristic function h in the interest direction: S = −I_μ gᵘᵛ ∂ᵥh". The formula is right, but it
   is the **negative** of the directional derivative of h along I♯ = g⁻¹I, and the step needs g to
   be symmetric.
5. **§8.4 V₄ text and HohfeldV4.lean disagree on which quarter-turn they mean.** The book prints
   O → C → N → L → O. The `r` excluded by HohfeldV4.lean's `quarter_turn_not_generated` is
   O → C → L → N → O. Both are outside V₄ (`quarter_turn_not_generated` here), because every
   element of V₄ squares to the identity.
6. **Thms 8.6 and 8.7** say more than the gtc-prototype lemmas they cite. `authority_needs_system`
   assumes the run starts outside every authority stratum, and `absorbing_stays` shows only that
   the run stays somewhere in the absorbing set. The book says "an authority stratum it did not
   start in" and "out of an absorbing stratum". Both stronger readings are proved here, under the
   book's hypotheses as written (`containment`, `absorption`).
7. **Prop 11.4, proof** (not formalized). The proof takes "finitely many strata (by the locally
   finite decomposition)" from local finiteness, which gives finitely many strata only on a
   compact region. It also treats Type III penalties β = ∞ as edge weights.

## Rebuild on Atlas

```bash
# project dir on Atlas: /archive/ahb-sjsu/geometric-ethics-lean (copy formal/lean/ there)
bash build-on-atlas.sh        # lake build + lake env lean Axioms.lean + sorry count
```

The script reuses the Mathlib v4.32.2 build in
`/archive/ahb-sjsu/geometric-evaluation-theory/lean/.lake/packages` (it copies that directory if
`.lake/packages` is missing) and downloads nothing. It pins builds to cores 12-23. On any other
host with internet access, `lake exe cache get && lake build` works instead.

## MATLAB symbolic checks (formal/matlab/)

Closed-form algebra, derivations and worked-example arithmetic of
`source/Geometric-Ethics-v1.24.tex`, checked with the MATLAB R2026a Symbolic Math
Toolbox on Atlas (2026-11-08). Each check prints `PASS`/`FAIL` with the claim id
and the book's line number (`grep -n` numbering). `NOTE`/`INFO` lines are
observations (a value the book leaves open, a rounding chain) and are not counted.
A FAIL is a finding about the book. The check was never changed to make it pass.

**Result: 455 PASS, 70 FAIL (525 checks), plus 33 NOTE.** Full output:
`formal/matlab/RESULTS-2026-11-08.txt`.

Conventions: worked-example inputs are exact rationals. A rounded book value passes
if it lies within half a unit of its last printed digit. Identities are checked on
generic symbolic tensors, metrics or functions with `simplify`/`isAlways`; a few use
numerical integration (the holonomy loop) or sampling (decision-region volumes).
`TEXT-ChNN`/`TEXT-AppD` marks worked examples that have no ledger claim. D4-specific
material is skipped because D4 is withdrawn.

Run (headless on Atlas): upload every `formal/matlab/*.m`, then
`matlab -batch "addpath('<dir>'); run_all"`. With the atlas skill:
`python run_matlab.py formal/matlab/run_all.m formal/matlab/*.m`. Pin to cores 12-23
with `taskset -c 12-23` if you run it by hand.

| claim id | check file | result |
|---|---|---|
| TEXT-Ch02 | check_ch02_05.m | 2 PASS; 1 FAIL (L5165); 1 NOTE |
| TEXT-Ch03 | check_ch02_05.m | 1 PASS |
| GE-DEF-4-4 | check_ch02_05.m | 2 PASS |
| GE-DEF-4-5 | check_ch02_05.m | 2 PASS |
| GE-DEF-10-3 | check_ch02_05.m | 1 PASS |
| GE-DEF-4-8 | check_ch02_05.m | 1 PASS |
| TEXT-Ch05 | check_ch02_05.m | 2 PASS |
| GE-PROP-6-1 | check_ch06.m | 1 PASS |
| GE-PROP-6-2 | check_ch06.m | 2 PASS |
| GE-PROP-6-3 | check_ch06.m | 1 PASS; 1 FAIL (L9740) |
| TEXT-Ch06 | check_ch06.m | 8 PASS; 1 FAIL (L9611); 2 NOTE |
| TEXT-Ch07 | check_ch07.m | 25 PASS; 4 FAIL (L9859, L10549, L10267, L10270); 4 NOTE |
| TEXT-Ch08 | check_ch08_09.m | 7 PASS; 2 FAIL (L12020, L12031); 1 NOTE |
| GE-PROP-9-2 | check_ch08_09.m | 1 PASS; 1 FAIL (L13260) |
| GE-LEMMA-9-2 | check_ch08_09.m | 2 PASS; 1 NOTE |
| GE-THM-9-2 | check_ch08_09.m | 3 PASS |
| GE-PROP-9-1 | check_ch08_09.m | 1 PASS |
| GE-PROP-10-1 | check_ch10_12.m | 1 PASS |
| GE-PROP-10-3 | check_ch10_12.m | 1 PASS |
| GE-PROP-10-2 | check_ch10_12.m | 1 FAIL (L14528) |
| TEXT-Ch10 | check_ch10_12.m | 2 PASS; 3 NOTE |
| TEXT-Ch11 | check_ch10_12.m | 1 PASS |
| GE-THM-11-2 | check_ch10_12.m | 3 PASS; 1 FAIL (L15131); 1 NOTE |
| GE-PROP-11-3 | check_ch10_12.m | 1 PASS; 1 FAIL (L15222) |
| GE-PROP-11-2 | check_ch10_12.m | 1 PASS |
| TEXT-Ch12 | check_ch10_12.m | 3 PASS |
| GE-THM-12-1 | check_ch10_12.m | 2 PASS |
| GE-THM-A-1 | check_ch10_12.m | 2 PASS; 1 FAIL (L16771) |
| GE-COR-A-1 | check_ch10_12.m | 1 PASS |
| TEXT-Ch13 | check_ch13.m | 6 PASS; 3 FAIL (L17099, L17104, L17316); 1 NOTE |
| GE-PROP-13-1 | check_ch13.m | 2 PASS; 1 FAIL (L17254) |
| GE-PROP-13-2 | check_ch13.m | 2 PASS |
| GE-PROP-13-3 | check_ch13.m | 2 PASS |
| GE-PROP-13-4 | check_ch13.m | 2 PASS; 1 FAIL (L18138) |
| TEXT-Ch14 | check_ch14.m | 6 PASS; 2 FAIL (L18667, L18822) |
| GE-PROP-14-3 | check_ch14.m | 1 PASS; 2 FAIL (L19267, L19267) |
| GE-PROP-14-1 | check_ch14.m | 2 FAIL (L18579, L18583) |
| GE-PROP-14-4 | check_ch14.m | 2 PASS |
| GE-PROP-14-5 | check_ch14.m | 2 PASS |
| TEXT-Ch15 | check_ch15.m | 9 PASS; 1 FAIL (L19618); 1 NOTE |
| GE-PROP-15-3 | check_ch15.m | 2 PASS; 1 FAIL (L20525) |
| GE-PROP-15-4 | check_ch15.m | 1 PASS; 1 FAIL (L20554) |
| GE-PROP-15-5 | check_ch15.m | 1 PASS |
| GE-DEF-15-2 | check_ch15.m | 1 PASS |
| GE-PROP-15-1 | check_ch15.m | 1 PASS; 1 FAIL (L19891) |
| GE-THM-15-1 | check_ch15.m | 1 PASS; 1 FAIL (L19768) |
| GE-PROP-15-2 | check_ch15.m | 1 PASS; 2 FAIL (L20098, L20394); 1 NOTE |
| TEXT-Ch16 | check_ch16.m | 2 PASS |
| GE-PROP-16-1 | check_ch16.m | 1 PASS; 1 FAIL (L21160) |
| GE-PROP-16-2 | check_ch16.m | 2 PASS |
| GE-PROP-16-4 | check_ch16.m | 1 PASS; 1 FAIL (L21605) |
| TEXT-Ch17 | check_ch17_empirical.m | 11 PASS; 10 FAIL (L22311, L22312, L22315, L22417, L22420, L23923, L23250, L23278, L8540, L8543); 3 NOTE |
| GE-PROP-18-1 | check_ch18_19_alignment.m | 1 PASS |
| GE-PROP-18-2 | check_ch18_19_alignment.m | 2 PASS |
| GE-PROP-18-4 | check_ch18_19_alignment.m | 1 FAIL (L25803) |
| GE-LEMMA-18-1 | check_ch18_19_alignment.m | 1 FAIL (L25042) |
| GE-PROP-19-3 | check_ch18_19_alignment.m | 1 PASS; 1 FAIL (L27790) |
| GE-PROP-19-4 | check_ch18_19_alignment.m | 1 PASS; 2 FAIL (L27811, L27815) |
| GE-PROP-19-5 | check_ch18_19_alignment.m | 1 FAIL (L27402) |
| TEXT-Ch20 | check_ch20_21_econ_clinical.m | 1 FAIL (L28494) |
| GE-LEMMA-20-1 | check_ch20_21_econ_clinical.m | 1 PASS; 1 FAIL (L28213) |
| GE-THM-20-6 | check_ch20_21_econ_clinical.m | 1 PASS |
| GE-THM-21-2 | check_ch20_21_econ_clinical.m | 1 PASS; 1 NOTE |
| GE-THM-21-3 | check_ch20_21_econ_clinical.m | 1 PASS |
| GE-THM-21-4 | check_ch20_21_econ_clinical.m | 1 PASS |
| TEXT-Ch21 | check_ch20_21_econ_clinical.m | 1 FAIL (L29212); 1 NOTE |
| GE-THM-23-1 | check_ch23_finance.m | 1 FAIL (L30201) |
| GE-THM-23-2 | check_ch23_finance.m | 1 PASS; 1 NOTE |
| GE-THM-23-5 | check_ch23_finance.m | 1 PASS |
| GE-THM-23-6 | check_ch23_finance.m | 1 PASS |
| TEXT-Ch25 | check_ch25_environment.m | 3 PASS; 1 FAIL (L31571); 1 NOTE |
| GE-THM-25-2 | check_ch25_environment.m | 1 PASS |
| GE-THM-25-3 (not in ledger) | check_ch25_environment.m | 1 PASS; 1 FAIL (L31669) |
| GE-THM-26-1 | check_ch26_ai.m | 1 PASS |
| GE-THM-26-5 | check_ch26_ai.m | 2 FAIL (L33046, L33084) |
| TEXT-Ch26 | check_ch26_ai.m | 2 PASS; 1 NOTE |
| GE-THM-27-1 | check_ch27_28_bio_military.m | 1 FAIL (L34089) |
| GE-THM-27-5 | check_ch27_28_bio_military.m | 1 FAIL (L34519) |
| GE-PROP-27-4 | check_ch27_28_bio_military.m | 1 PASS |
| GE-THM-28-2 | check_ch27_28_bio_military.m | 1 PASS |
| TEXT-Ch28 | check_ch27_28_bio_military.m | 3 PASS |
| GE-THM-28-5 | check_ch27_28_bio_military.m | 1 NOTE |
| GE-PROP-20-1 | check_ch29_30.m | 2 PASS; 1 NOTE |
| GE-PROP-20-2 | check_ch29_30.m | 2 PASS; 1 NOTE |
| GE-PROP-20-3 | check_ch29_30.m | 2 PASS; 1 FAIL (L37439); 1 NOTE |
| TEXT-Ch30 | check_ch29_30.m | 1 PASS |
| TEXT-AppC | check_ch29_30.m | 2 PASS; 1 NOTE |
| TEXT-AppB | check_ch29_30.m | 1 NOTE |
| TEXT-AppD | check_appD_1_triage.m | 88 PASS; 1 FAIL (L38832) |
| TEXT-AppD | check_appD_2_whistleblower.m | 34 PASS; 1 FAIL (L39622); 1 NOTE |
| TEXT-AppD | check_appD_3_av.m | 53 PASS |
| TEXT-AppD | check_appD_4_hiring.m | 51 PASS; 2 FAIL (L40464, L40732); 1 NOTE |
| TEXT-AppD | check_appD_5_climate.m | 55 PASS; 5 FAIL (L41143, L41154, L41165, L41174, L41183); 1 NOTE |

## Disposition of the MATLAB FAILs (v1.25)

Every FAIL was read in context and classified REAL (the book was wrong), CHECK-ERROR (the
check misread the book) or JUDGMENT. 68 were REAL and 2 were CHECK-ERROR (the Ch. 5 gate rates,
which match the source data; the Ch. 17 rates were the wrong ones). The classification and the
exact correction for each line are recorded, one comment per FAIL, in `formal/matlab/dispositions/`
(the edit files that were applied to `source/Geometric-Ethics-v1.25.docx`). Appendix D.1 and D.5
were rebuilt from their stated rules rather than patched; their checks
(`check_appD_1_triage.m`, `check_appD_5_climate.m`) test the rebuilt numbers.

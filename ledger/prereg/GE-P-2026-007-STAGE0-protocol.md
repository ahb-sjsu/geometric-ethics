# GE-P-2026-007 — Stage 0 protocol: sampling, norming, pilot

**Status: DRAFT, NOT EXECUTED.** This is the procedure that must run, and be
committed as a dated amendment to `GE-P-2026-007`, **before any main-run data is
collected**. The registration is sealed only after this protocol has run,
because the bar depends on the pilot (§7). *Power before bars.*

**Revision, 2026-08-26.** This protocol previously specified *constructing* an
800-item pool of synthetic research-ethics vignettes. That approach was
**abandoned and the generator retired to a fallback role** (§3.4). Items are now
**sampled from Social-Chem-101**, a corpus of real human-written situations
already held at `/archive/ethics-corpora/social-chem-101` on Atlas. The reason
is recorded in §11 because it is the most useful methodological finding this
registration has produced.

---

## 0. Human subjects

**IRB approval is required before any data collection, including norming.**
Norming is human-subjects research, not a pre-step to it. Items describing
interpersonal wrongs can be mildly aversive: content advisory, withdrawal
without penalty, payment at or above platform minimum for all phases.

Source items are third-party accounts of real situations already published in
a public research corpus. No item may be presented in a way that could identify
an original poster.

## 1. What the instrument has to resolve

The experiment measures **a shift in a classification threshold**. That imposes
a requirement most stimulus sets fail:

> **The pool must be dense near the threshold.** A pool of clearly-benign and
> clearly-severe items has no resolution: every observer classifies every item
> identically in every block, and κ is unmeasurable regardless of the true
> effect size.

The sample is therefore built densest in the ambiguous middle and sparse at the
extremes. The extremes exist only to anchor the scale and to serve as attention
checks.

## 2. Source

**Social-Chem-101** (Forbes, Hwang, Shwartz, Sap & Choi, EMNLP 2020),
`social-chem-101.v1.0.tsv`, 355,922 rows / **260,627 distinct actions**, held
locally at `/archive/ethics-corpora/social-chem-101/`.

The item unit is the **`action`** field: a short human-written description of a
thing someone did. Verified length distribution — p5 = 4, **p50 = 7**, p75 = 9,
p95 = 13 words. Examples at judgment −1:

> *insulting a friend's accomplishments* · *flaking out on your friends* ·
> *dating a convicted sex offender*

**This is a better stimulus than the vignettes it replaces, for three reasons.**
(i) It is short enough for the hundreds of rapid trials the paradigm needs.
(ii) It is human-written, so it cannot contain the frame/feature contradictions
that defeated the generator. (iii) **There is no summarization step**, and
therefore no point at which anyone chooses which facts survive — decisive here,
because a study of how context shifts harm judgment must not have uncontrolled
framing injected at item creation.

**BLOCKING CHECK BEFORE SEALING:** confirm the licence permits research reuse
and re-presentation to paid participants. Recorded as unverified as of drafting.

## 3. Sampling frame

### 3.1 Filters, and the counts they yield (verified 2026-08-26)

| filter | rationale |
|---|---|
| drop `area = rocstories` | crowdsourced **fiction**; the other three sources are real reported situations |
| `action-hypothetical ∈ {explicit, probable}` | exclude hypotheticals and negated actions |
| `action-moral-judgment` and `action-agree` both present | ~12.5% of rows are unannotated |
| 4 ≤ words ≤ 25 | readable in a rapid series; excludes fragments |

**82,757 distinct actions survive** (AITA 37,251 · confessions 33,717 ·
Dear Abby 11,789). Cross-tabulated:

| `action-moral-judgment` | agree ≥ 3 (graded) | agree ≤ 1 (contested) |
|---|---|---|
| −2 | 5,299 | 48 |
| −1 | 27,323 | 924 |
| 0 | 25,940 | 951 |
| +1 | 8,172 | 133 |
| +2 | 1,967 | 6 |

**Density is a solved problem.** The ambiguous band needs 440 items against
27,323 candidates — **62× headroom** — so the sample can be filtered hard on
length, source and moral foundation and still fill every stratum. Both anchors
are available (1,967 benign, 5,299 severe).

### 3.2 Over-sample, because the source's judgment is not the study's harm scale

`action-moral-judgment` is a 5-point scale from a different rater population
under different instructions. It is used **only to stratify the sample**; where
an item actually falls is decided by this study's own norming (§5).

Therefore: **sample 1,200 items — 50% more than the 800 required — norm all
1,200, and select the 800 that best fill the normed strata.** The surplus
absorbs the mismatch between source judgment and normed harm. Selecting 800
from 1,200 *after norming but before the main run* is legitimate and is fixed
here in advance; selecting after seeing main-run data would not be.

Sampling targets, by source judgment: +2 → 90 · +1/0 → 180 · −1 → 660 ·
−2 → 270.

### 3.3 Balance, fixed before sampling

- **Moral foundation** (`rot-moral-foundations`) balanced within each stratum.
  Necessary because the corpus is dominated by care-harm (157,355 vs 66,800 for
  the next), and an unbalanced sample would let foundation proxy for severity.
- **Characters involved** (`action-char-involved`) balanced within stratum, so
  the number of affected parties cannot track harm level.
- **Source** (`area`) balanced within stratum: AITA, confessions and Dear Abby
  differ in register and in who is narrating.
- **Word count** matched across strata, verified after sampling.

### 3.4 The generator's remaining role

`experiments/ge007_build_item_pool.py` is **retired to a fallback**: if a
stratum cannot be filled from the corpus after balance constraints, synthetic
items may fill the gap, and every such item **must be flagged in the item
manifest and reported separately in any result.** On the verified counts this
should not be needed.

## 4. Contested versus graded — and a correction to the previous protocol

The previous protocol proposed to separate *graded* items (raters agree it is
moderately harmful — a genuine continuum position) from *contested* items
(raters disagree; two populations, not a midpoint) using SD and a dip test on
norming data. **That distinction still matters and the screen is retained.**
But the corpus complicates it in a way worth registering:

**`action-agree` is ANTICIPATED agreement, not observed agreement.** It records
one worker's *prediction* of how much others would agree. Where actual
agreement can be observed — the 24,013 actions with ≥2 independent annotations —
**46.5% show outright disagreement on the judgment label** (10,121 of 21,769).

Two consequences, both fixed here:

1. `action-agree` is used as a **cheap prior for sampling**, never as the
   contestedness screen. The screen remains this study's own norming SD and dip
   test (§5). Anticipated consensus is not measured consensus.
2. The 24,013 multi-annotated actions become a **calibration set**: whether
   `action-agree` predicts observed annotator disagreement is checkable *before*
   any main-run data, and the answer is reported in the Stage 0 amendment
   whichever way it falls.

Note also that **89.5% of actions carry only one annotation** (233,389 of
260,627), so within-item annotator variance is unavailable for most of the pool.
This is why the study's own norming cannot be skipped.

## 5. Norming — what the corpus cannot replace

The κ estimator (§6) compares each participant's threshold against per-item harm
values. Those values must be on **this study's scale, from this study's
population, under this study's instructions**. Imported labels satisfy none of
those. The corpus replaces *authoring*, not norming.

- **Sample.** n = 300, independent of pilot and main samples, enforced by
  platform ID rather than self-report.
- **Task.** Each participant rates a random 100-item subset of the 1,200 on a
  **continuous 0–100 harm slider**. Each item receives ≥ 25 independent ratings.
- **Derived per item:** mean harm `h_i`, SD `s_i`, agreement.
- **Exclusion:** an item is excluded as contested if `s_i > 20` or its rating
  distribution is significantly bimodal (Hartigan's dip, p < .05). Excluded
  items are **retained and reported as a list** — disagreement about which acts
  are harmful is independently interesting to this corpus.

## 6. The κ estimator

Per participant, per block, fit a logistic psychometric function of
P(judge harmful) against normed harm `h`. The **threshold θ** is the 50% point.

- `B` = count judged harmful in the **baseline block** (prevalence `p₁`)
- `O` = count judged harmful in the **final block** (prevalence `p₂ < p₁`)
- `E` = count in the final block with `hᵢ > θ_baseline` — the count expected
  **if the threshold had not moved**

```
        O − E
κ  =  ─────────
        B − E
```

`κ = 1` when `O = B` (total perceived harm unchanged — conservation).
`κ = 0` when `O = E` (threshold fixed — pure tracking).

### 6.1 Degenerate case

**If `B = E` the estimator is 0/0.** This is the expected outcome for any
participant whose threshold sits above nearly every item, and pooling them
silently would let denominator noise drive the estimate. A participant
contributes only if `B − E ≥ 5`; failures are **reported with their thresholds**,
not dropped. **If more than 25% fail, the prevalence manipulation was too weak
and the run is void** — that is not fixable by reanalysis.

### 6.2 Verified before use

`experiments/ge007_kappa_recovery.py` (seed 20260825) recovers κ across
0.00–1.00 with a **disclosed additive bias of −0.011**, constant across the
range, from integer rounding of the target count. The bias is **downward**: it
under-states κ and so biases toward **refuting** conservation. Negligible
against a 0.5 bar and conservative in direction, but recorded rather than left
to be rediscovered. The §6.1 gate was exercised under a deliberately weak
manipulation and fires as intended.

## 7. Pilot

**n = 60** (30 per condition), procedure identical to the main run. Purpose is
**not** to test the hypothesis, but to estimate:

1. `Var(κ)` across participants → fixes main-run n for 90% power to detect
   κ = 0.5 against κ = 0;
2. the proportion failing the `B − E ≥ 5` gate → confirms manipulation strength;
3. the attention-check exclusion rate;
4. whether the non-moral control arm reproduces the prevalence effect **on this
   platform and sample** (§8).

**Pilot κ is a variance input only.** Its point estimate is not reported as a
result and not used to adjust the bar, which would convert the pilot into an
unregistered first look. Pilot participants are not reused.

## 8. Control arms

- **Positive / instrument gate — non-moral.** A colour-classification arm, same
  sample, same platform, same session structure, must reproduce the standard
  prevalence effect. **If it does not, the ethical arm is not interpreted at
  all** — a null there would be uninterpretable, since "moral judgment shows no
  concept change" and "this sample shows no concept change" are indistinguishable.
- **Negative — stable prevalence.** No threshold drift across blocks. Drift means
  fatigue, practice or scale contraction, and voids the run.
- **Order — counterbalanced.** A shift surviving order reversal is concept
  change; one following time-on-task regardless of prevalence direction is an
  artifact.

## 9. Exclusions, all fixed before data

- Anchor items misclassified at > 20% → exclude participant.
- Response times < 300 ms on > 10% of trials → exclude.
- Straight-lining on > 95% of a block → exclude.
- Incomplete blocks → exclude.

**Target ≤ 15%. Exceeding 25% voids the run** rather than licensing a cleaned
reanalysis.

## 10. What Stage 0 commits

Committed as a dated amendment **before** the main run:

1. the 1,200 sampled item IDs with source row references, and the 800 selected
   after norming, with every `hᵢ`, `sᵢ`, foundation and character tag;
2. the contested-item exclusion list;
3. the `action-agree` calibration result (§4.2), whichever way it falls;
4. the pilot's `Var(κ)`, resulting main-run `n`, gate-failure and exclusion rates;
5. the non-moral control result;
6. the analysis code, **unexecuted against main-run data**, hashed;
7. any synthetic fallback items, flagged (§3.4).

Only then is `GE-P-2026-007` sealed.

## 11. Registered limitations

**Range compression, and it costs power.** Social-Chem-101's −2 tops out at
ordinary interpersonal wrongs — *dating a convicted sex offender*, not
atrocities. The harm continuum is **truncated at the severe end** relative to
the synthetic pool it replaces. A compressed range gives the threshold less room
to travel, which **shrinks the effect the pilot must detect**. Registered in
advance so that a small κ is not later attributed to the absence of the
phenomenon when it may reflect the instrument's range.

**Population and cultural skew.** AITA, confessions and Dear Abby are
US-centric, English-language and self-selected. Findings generalise to that
population and no further.

**Care-harm dominance.** The corpus's moral-foundation distribution is
dominated by care-harm. §3.3 balances within stratum, but the underlying supply
is skewed and some foundations will be thinly represented.

**Why the previous approach was abandoned — the finding worth keeping.** The
generator composed items from a frame, a population and an ethical feature.
Those three are **not semantically independent**: a records-only study cannot
enrol at a bedside, a job-training trial has no loan terms, a zebrafish study
has no rabbits. Three keyword screens were added, *each after reading samples
rather than by prior design*, and each caught a class the previous ones missed;
a fresh six-item sample after the third still contained obvious contradictions.
Every structural check — counts, balance, length matching, uniqueness — passed
throughout. **Semantic incoherence is invisible to structural verification**,
and a pool that passes every automated check can still be unfit. Worse, the
failure mode is silent: incoherent items produce rater disagreement that looks
like genuine contestedness, which §5's dip test would then exclude, deleting
real continuum coverage while appearing to work correctly.

The corpus removes the failure class entirely, because real situations are
coherent by construction.

## 12. Decision owed by the author before results

Repeated from the registration because it cannot be settled afterwards:

> **Does a prevalence-framing shift count as a "representation change" in the
> book's sense?** If it does, a positive result challenges the retained
> invariance-of-harm-accounting claim. If it does not, the author must say what
> distinguishes them — *before* seeing whether κ > 0.

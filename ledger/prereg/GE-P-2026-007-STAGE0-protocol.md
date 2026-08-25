# GE-P-2026-007 — Stage 0 protocol: stimulus construction, norming, pilot

**Status: DRAFT, NOT EXECUTED.** This is the procedure that must run, and be
committed as a dated amendment to `GE-P-2026-007`, **before any main-run data is
collected**. Nothing here has been executed; no item pool exists yet.

The registration is sealed only after this protocol has run, because the bar
depends on the pilot (§5). *Power before bars.*

---

## 0. Human subjects

**IRB approval is required before any data collection, including norming.**
Norming is human-subjects research, not a pre-step to it. Items describing
research misconduct can be mildly aversive: include a content advisory, permit
withdrawal at any point without penalty, and pay at or above platform minimum
for all phases including the pilot.

No item may describe a real, identifiable study or person.

---

## 1. What the instrument has to resolve

The whole experiment measures **a shift in a classification threshold**. That
imposes a requirement most stimulus sets fail:

> **The item pool must be dense near the threshold.** A pool of clearly-benign
> and clearly-atrocious items has no resolution: every observer classifies every
> item identically in every block, and κ is unmeasurable regardless of how large
> the true effect is.

The pool is therefore built to be **densest in the ambiguous middle** and sparse
at the extremes — the opposite of how a stimulus set is usually balanced. The
extremes exist only to anchor the scale and to serve as attention checks.

## 2. Item pool construction

**Domain.** Research-ethics proposals: short descriptions of a proposed study,
judged harmful / not harmful. This is the domain in which the prevalence effect
was originally demonstrated for ethical judgment, which matters because the
non-moral positive control (§6) can only license inference about the ethical arm
if the ethical arm stays close to a paradigm known to work.

**Target pool: 800 items**, generated to span a harm continuum:

| Stratum | Target normed harm (0–100) | Count | Purpose |
|---|---|---|---|
| Anchor-benign | 0–10 | 60 | scale anchor, attention check |
| Low | 10–30 | 120 | continuum |
| **Ambiguous** | **30–70** | **440** | **where threshold shift is detected** |
| High | 70–90 | 120 | continuum |
| Anchor-severe | 90–100 | 60 | scale anchor, attention check |

**Balanced across the continuum, not correlated with it.** Each item is tagged
for topic (medical, psychological, data-privacy, deception, consent, animal,
economic), study population, and length in words. **Topic must be balanced
*within* each harm stratum.** If harmful items are disproportionately medical,
then dropping the prevalence of harmful items also drops the prevalence of
medical items, and any threshold shift is confounded with topic drift. This is
the most likely way to build a broken pool.

**Length and syntactic complexity are matched across strata** for the same
reason: reading time must not covary with harm level.

## 3. Norming

**Sample.** n = 200, independent of the main and pilot samples, with no
participant appearing in more than one phase. Platform-level exclusion is
enforced by ID, not by self-report.

**Task.** Each participant rates a random 100-item subset on a **continuous
0–100 harm slider** (not a binary judgment — the norming phase must produce the
graded quantity the main run's binary judgments are scored against). Each item
receives ≥ 25 independent ratings.

**Derived per item:** mean harm `h_i`, SD `s_i`, and inter-rater agreement.

### 3.1 The distinction that has to be enforced

An item can sit mid-scale for two entirely different reasons, and only one of
them is a continuum position:

- **Graded** — raters agree it is *moderately* harmful. Mean 50, low SD. This is
  a genuine point on the harm continuum.
- **Contested** — raters disagree: half say benign, half say severe. Mean 50,
  high SD. This is *not* a mid-continuum item; it is two populations.

Contested items add variance without adding resolution, and worse, a prevalence
manipulation can shift *which* reading dominates — producing threshold-shift-like
behaviour with no concept change at all.

**Exclusion rule, fixed here:** an item is excluded if `s_i > 20` (on the 0–100
scale) or if its rating distribution is significantly bimodal (Hartigan's dip
test, p < .05). Excluded-as-contested items are **retained and reported as a
separate list** — disagreement about which acts are harmful is independently
interesting to this corpus and should not be discarded silently.

**Retention target:** ≥ 500 items surviving, with ≥ 280 in the ambiguous
stratum. If the ambiguous stratum falls below 280, the pool is unfit and items
are regenerated — **the shortfall is not absorbed by widening the ambiguous
band**, which would silently change what the experiment measures.

## 4. The κ estimator, stated explicitly

Per participant, per block, fit a logistic psychometric function of
P(judge harmful) against normed harm `h`. The **threshold θ** is the 50% point.

Let, for a participant:

- `B` = count judged harmful in the **baseline block** (prevalence `p₁`)
- `O` = count judged harmful in the **final block** (prevalence `p₂ < p₁`)
- `E` = count in the final block with `hᵢ > θ_baseline` — i.e. the count expected
  **if the threshold had not moved at all**

Then

```
        O − E            (observed harmful count) − (count if threshold were fixed)
κ  =  ─────────   =    ───────────────────────────────────────────────────────────
        B − E            (baseline count)        − (count if threshold were fixed)
```

`κ = 1` when `O = B` (total perceived harm unchanged — conservation).
`κ = 0` when `O = E` (threshold fixed — pure tracking).

This is algebraically identical to the registration's
`1 − (observed drop)/(drop expected under fixed threshold)`.

### 4.1 The degenerate case, and the gate it requires

**If `B = E` the estimator is 0/0 and κ is undefined.** This happens when the
prevalence manipulation, expressed in *normed* terms against that participant's
own threshold, imposed no real drop — for instance if their threshold sits above
almost every item in both blocks.

This is not a hypothetical: it is the expected outcome for any participant with
an extreme threshold, and pooling them in silently would bias κ toward whatever
the denominator noise happens to do.

**Gate, fixed in advance:** a participant contributes to the κ estimate only if
`B − E ≥ 5` items. Participants failing this are **reported as a count, with
their thresholds**, not silently dropped. If more than 25% of participants fail
it, the *prevalence manipulation was too weak* — an instrument failure that
voids the run and requires a stronger manipulation, not a reanalysis.

### 4.2 The estimator was checked before it was trusted

`experiments/ge007_kappa_recovery.py` (seed 20260825) simulates participants
with a **known** true κ and confirms the estimator recovers it. This is a test
of the *instrument*, not of the hypothesis, and it was run before the instrument
was pointed at anything:

| true κ | recovered | bias |
|---|---|---|
| 0.00 | −0.011 | −0.011 |
| 0.25 | 0.238 | −0.012 |
| 0.50 | 0.489 | −0.011 |
| 0.75 | 0.738 | −0.012 |
| 1.00 | 0.989 | −0.011 |

**Disclosed bias: ≈ −0.011, additive and constant across the range**, arising
from integer rounding of the target count. It is **downward**, meaning the
estimator *under*-states κ and therefore biases toward **refuting** conservation.
Against a bar of 0.5 it is negligible, and it errs in the conservative
direction — but it is recorded here rather than left for someone to rediscover,
because an undisclosed bias of unknown sign is a different object from a
disclosed one of known sign.

The degenerate-case gate was exercised the same way: under a deliberately weak
manipulation (p₁ = .50 → p₂ = .48) roughly half of simulated participants fail
`B − E ≥ 5`, confirming §4.1 fires when it should.

## 5. Pilot

**n = 60** (30 per condition), full procedure, main-run identical.

Purpose is **not** to test the hypothesis. It is to estimate:

1. `Var(κ)` across participants → fixes main-run n for 90% power to detect
   κ = 0.5 against κ = 0;
2. the proportion failing the `B − E ≥ 5` gate → confirms manipulation strength;
3. the exclusion rate from attention checks;
4. whether the non-moral control arm reproduces the prevalence effect *on this
   platform and sample* (§6).

**The pilot is not analysed for κ's value, and the pilot participants are not
reused.** Pilot κ is computed only as a variance input; its point estimate is
**not reported as a result and not used to adjust the bar**, which would convert
the pilot into an unregistered first look.

## 6. The control arms

**Positive / instrument gate — non-moral.** A colour-classification arm run in
the same sample, on the same platform, in the same session structure, must
reproduce the standard prevalence effect. **If it does not, the ethical arm is
not interpreted at all** — a null there would be uninterpretable, since "moral
judgment shows no concept change" and "this sample shows no concept change"
would be indistinguishable.

**Negative — stable prevalence.** Threshold drift across blocks must be absent.
Drift here means fatigue, practice, or scale contraction, and voids the run.

**Order — counterbalancing.** Block order is counterbalanced. A threshold shift
that survives order reversal is concept change; one that follows time-on-task
regardless of prevalence direction is an artifact.

## 7. Exclusions, all fixed before data

- Attention checks: anchor-benign items judged harmful, or anchor-severe judged
  not harmful, at > 20% → exclude participant.
- Response times below 300 ms on > 10% of trials → exclude.
- Straight-lining: identical response on > 95% of a block → exclude.
- Incomplete blocks → exclude.

**Target exclusion rate ≤ 15%.** Exceeding 25% voids the run rather than
licensing a cleaned reanalysis.

## 8. What Stage 0 commits, and when

The Stage 0 amendment to `GE-P-2026-007` must contain, committed **before** the
main run:

1. the final item list with every `hᵢ`, `sᵢ`, and topic tag;
2. the contested-item exclusion list;
3. the pilot's `Var(κ)` and the resulting main-run `n`;
4. the pilot's gate-failure and exclusion rates;
5. the non-moral control result;
6. the analysis code, **unexecuted against main-run data**, hashed.

Only then is `GE-P-2026-007` sealed.

## 9. Decision owed by the author before results

Recorded in the registration and repeated here because it is the highest-leverage
open item and cannot be settled afterwards:

> **Does a prevalence-framing shift count as a "representation change" in the
> book's sense?** If it does, a positive result challenges the retained
> invariance-of-harm-accounting claim. If it does not, the author must say what
> distinguishes them — *before* seeing whether κ > 0.

Deciding this after the result is the exact degree of freedom registration
exists to remove.

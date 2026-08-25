# GE-P-2026-007 — Conservation of Perceived Harm

Registers a **new** prospective claim. It is not the withdrawn
`GE-HARM-CONSERVATION` and does not attempt to revive it: that claim concerned
harm as a Noether charge of moral dynamics, and remains blocked because the
Lagrangian would have to be built from the moral metric the corpus calls its
principal open problem. **No experiment resolves that. Only the metric does.**

What is registered here is the psychological claim in the neighbourhood, which
*is* testable now: **as harm becomes rarer in the world, does the concept of
harm expand to fill the space, leaving total perceived harm approximately
invariant?**

## Scoping decision, recorded because it is contestable

The author's position, asserted 2026-08-25 and adopted as the scope of this
registration:

> *"morality hinges on what is perceived anyway, so the distinction isn't that
> important"*

This registration **adopts** that premise rather than arguing it, and records it
so that a later reader knows it was a choice and can revisit it. Two consequences
follow, and both are registered in advance:

1. **The premise does not make the test easier.** If harm *is* perceived harm,
   and perception is also the only measuring instrument, then "total harm is
   conserved" has no independent variable and cannot fail. What keeps this
   design falsifiable is that **actual prevalence is set by the experimenter and
   is true by construction** — the item genuinely was pre-normed at that harm
   level. That external anchor is the entire reason the paradigm measures
   anything, and it is why the perceived/actual distinction is retained in the
   *design* even where the metaethics rejects it.
2. **Under this premise a positive result is not comfortable for the corpus.**
   See "Tension with the retained invariance claim" below. Registered here so
   that a result cannot later be reported as purely confirmatory.

```yaml
id: GE-P-2026-007
date: 2026-08-25
retrospective: false
status: DRAFT-UNSEALED
kind: prospective test of a new claim, adjacent to a withdrawn one
governs: GE-PRED-PERCEIVED-HARM
relates_to: GE-HARM-CONSERVATION (withdrawn 2026-06-19; NOT revived by this)

claim: >
  When the actual prevalence of harmful items in a judged series decreases, the
  harmfulness threshold at which observers classify an item as harmful shifts
  DOWNWARD, such that the total quantity of perceived harm is substantially
  conserved rather than tracking actual prevalence.

quantity: >
  CONSERVATION COEFFICIENT kappa = the fraction of an imposed prevalence drop
  that is absorbed by threshold shift rather than expressed as reduced
  harm-attribution.
    kappa = 1  -- perfect conservation: total perceived harm unchanged
    kappa = 0  -- perfect tracking: no concept change; harm attribution simply
                  falls with prevalence
  kappa is estimated as 1 - (observed drop in harmful-classification count) /
  (drop expected under a fixed threshold), with the fixed-threshold expectation
  computed from each participant's OWN pre-manipulation threshold.

prediction:
  primary: >
    kappa >= 0.5, with the 95% bootstrap CI excluding 0.
  three_way_precommitment: >
    Registered BEFORE data because "approximately conserved" is exactly the kind
    of phrase that made Predictions 20.3 and 20.4 unregistrable, and the partial
    outcome is the most likely one:
      (a) CI contains 1 and excludes 0.5  -> CONSERVATION supported
      (b) CI excludes BOTH 0 and 1        -> ANCHORED BUT LEAKY. This is
          reported as NOT supporting conservation. It supports the weaker
          statement that harm accounting is prevalence-anchored, and it must not
          be written up as a win.
      (c) CI contains 0                   -> REFUTED; harm attribution tracks
          prevalence and no concept change occurs.
  falsified_if: outcome (c), or outcome (b) reported as (a).

design:
  paradigm: >
    Levari-style prevalence-induced concept change, ethical-judgment variant.
    Participants judge a long series of items one at a time as harmful / not
    harmful. In the DECREASING condition the true prevalence of harmful items
    drops sharply in later blocks; in the STABLE condition it does not.
    Assignment is between-subjects and randomized.
  ground_truth: >
    Item harm levels come from an independent norming sample and are FIXED
    before the main run. This is the non-perceptual anchor the scoping premise
    above would otherwise remove, and without it kappa is not estimable.
  stage_0_stimulus_freeze: >
    MANDATORY, and committed as a dated amendment BEFORE the main run:
    (i) construct the item pool and norm it on an independent sample;
    (ii) freeze the harm-continuum placement of every item;
    (iii) run the PILOT (below) and fix n from it;
    (iv) record the analysis code, unexecuted, against the frozen pool.
    No main-run data is collected until this amendment is committed.
  pilot: >
    REQUIRED, and this registration is NOT sealed until it has run. The
    prevalence effect is well established for non-moral stimuli, but this
    programme has NO verified effect size for the ethical variant under its own
    stimulus set, and a bar set from a literature effect size the author has not
    reproduced is a bar set from someone else's instrument. Power before bars.
  n: fixed by the pilot to detect kappa = 0.5 against kappa = 0 at 90% power.
  stopping: fixed at the pilot-determined n; no optional stopping, no top-ups.
  clusters: participant-level; bootstrap CI on kappa over 1000 participant resamples.

controls: [
  "INSTRUMENT GATE / positive control: a non-moral perceptual arm (the standard
   colour-classification version) must reproduce the known prevalence effect in
   the same sample on the same platform. If it does NOT, the sample is unfit and
   the ethical arm is not interpreted -- a null in the ethical arm would be
   uninterpretable without it.",
  "negative control: the STABLE-prevalence condition must show no threshold
   drift across blocks. Drift there indicates fatigue or order effects and voids
   the run.",
  "order control: block order counterbalanced; a threshold shift appearing in
   counterbalanced-reverse order is a time-on-task artifact, not concept change.",
]

falsification: |
  PHYSICS gates (a miss refutes GE-PRED-PERCEIVED-HARM): outcome (c) above --
  the CI for kappa contains 0.
  INSTRUMENT gates (a miss voids the run and is recorded, not silently retried):
  the non-moral positive control fails to reproduce the prevalence effect;
  threshold drift appears in the stable condition; attention checks fail beyond
  the pre-set exclusion rate; the norming sample fails to place items on a
  monotone harm continuum.

tension_with_retained_claim: |
  REGISTERED IN ADVANCE so that a positive result cannot be reported as purely
  confirmatory. The corpus withdrew conservation and retained INVARIANCE OF HARM
  ACCOUNTING. Under the scoping premise adopted above -- that harm is perceived
  harm -- a positive result (kappa > 0) says the SAME act receives a DIFFERENT
  harm value depending on the distribution of other items it was judged
  alongside. That is prima facie a failure of invariance, not a success.
  SCOPE CAVEAT, and it is a real one: the book's invariance claim concerns
  representation-invariance (change of basis or coordinates), and it is NOT
  established that a prevalence-framing shift is a "representation change" in
  that sense. Deciding whether it is falls to the author and MUST be decided
  BEFORE results are seen; deciding afterwards is exactly the degree of freedom
  registration removes.
  Consequently this experiment may bite the claim the corpus currently holds
  rather than the one it gave up.

amendments: []
hash: sha256:
```

## What a pass would and would not establish

A pass establishes that **harm judgment is prevalence-anchored** — that the
concept expands as instances become rare. Under the adopted premise that harm
is perceived harm, that is a substantive claim about harm itself.

It does **not** establish the withdrawn claim. `GE-HARM-CONSERVATION` asserted a
conservation *law* — a Noether charge of moral dynamics, constant along
trajectories. This registration tests a *homeostasis of judgment* across a
judged series. They share the word "conserved" and almost nothing else:

| | withdrawn claim | this registration |
|---|---|---|
| conserved along | a trajectory of moral dynamics | a series of judgments |
| requires | the moral metric (open problem) | an experimenter-set prevalence |
| conserved quantity | Noether charge | count of items judged harmful |
| a pass would | be blocked, not passed | support prevalence-anchoring |

**A pass must never be written up as vindicating the retracted thesis.** It is
recorded here in advance because that is precisely the misreading a positive
result would invite, and the corpus has already retreated from this claim once.

## Why this is registrable when 20.5 is not

Prediction 20.5 requires `h*(n)`, defined only given the moral metric. This
registration requires no metric: `kappa` is estimated from classification counts
against an experimenter-imposed prevalence, both of which are observable without
committing to any moral geometry. **That is the whole reason it is drafted.**

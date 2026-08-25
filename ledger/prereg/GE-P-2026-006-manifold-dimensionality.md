# GE-P-2026-006 — Manifold Dimensionality (Prediction 20.6)

Registers, prospectively, a prediction published in *Geometric Ethics* v1.24
§20.11 and never tested. The prediction text is **frozen as published** and is
not strengthened, weakened, or reworded here; what this document adds is the
design the book never specified — data, method, n, bar, and the
falsification condition operationalized.

**Published prediction, verbatim:**

> **Prediction 6 (Manifold Dimensionality)**: Factor analysis of economic
> behavioral data should recover approximately nine independent dimensions.
> What would falsify: if the factor structure is consistently lower-rank
> (fewer than seven) or higher-rank (more than eleven).

```yaml
id: GE-P-2026-006
date: 2026-08-25
retrospective: false
status: SEALED 2026-08-25
kind: prospective test of a published, never-tested prediction
governs: GE-PRED-20-6
claim: >
  Factor analysis of economic behavioral data recovers a factor structure whose
  retained dimensionality k satisfies 7 <= k <= 11.
prediction:
  primary: k in [7, 11] on each of three qualifying corpora, by the
    pre-specified retention rule
  falsified_if: k <= 6 or k >= 12 consistently (the book's own clause,
    operationalized in `falsification` below)

design:
  structure: >
    TWO STAGES. Stage 0 qualifies instruments and FREEZES the item list without
    touching any factor structure. Stage 1 runs the analysis. The stages exist
    because the item inventories of the candidate corpora have NOT been verified
    as of sealing, and an unverified inventory is a researcher degree of freedom
    that would otherwise be exercised after seeing data. Stage 0 output is
    recorded as a dated amendment to this registration BEFORE Stage 1 begins.

  stage_0_instrument_qualification: >
    For each candidate corpus, WITHOUT computing any factor solution:
    (i) enumerate the economic-behaviour item battery per the inclusion rule
        below and record the item count m;
    (ii) verify m >= 33 (see `item_floor`);
    (iii) verify the item correlation matrix is positive definite;
    (iv) record n, the item list, and the preprocessing decisions.
    A corpus failing (ii) or (iii) is DISQUALIFIED and named as disqualified.
    Nothing about dimensionality is computed or inspected at this stage.

  item_floor: >
    m >= 33 items surviving preprocessing, i.e. THREE items per retained factor
    at the prediction's own upper bound of 11. This floor is derived from the
    prediction, not chosen for convenience: a battery of m items cannot support
    a solution with k > m, and conventional identification needs >= 3 indicators
    per factor. A corpus with m < 33 CANNOT produce the k >= 12 branch of the
    falsification clause, so running it would make the test one-sided by
    construction. THIS DEFECT IS THE REASON THE PREVIOUS DRAFT OF THIS
    REGISTRATION WAS REWRITTEN BEFORE SEALING; see `reread_2026_08_25`.

  corpora: >
    THREE qualifying corpora, analysed independently. Two are named here; the
    third is selected at Stage 0 by pre-stated criteria because no specific
    third dataset has been verified to meet the item floor.
    (a) World Values Survey wave 7 -- economic, work and welfare attitude items.
    (b) European Social Survey -- welfare-attitudes module.
    (c) ONE further public dataset chosen at Stage 0 by these criteria, applied
        in this order and stopping at the first dataset that satisfies all:
          - public and downloadable without application or fee;
          - individual-level responses or behaviour (not country aggregates);
          - >= 33 economic-behaviour items by the inclusion rule below;
          - n >= 1000 respondents;
          - not derived from, and not overlapping in respondents with, (a) or (b).
        The search order is fixed here: LISS panel economic modules, then GESIS
        panel economic modules, then the ICPSR public economic-behaviour
        holdings in accession order. The FIRST qualifying dataset is used; there
        is no discretion to continue searching for a better one.
    If fewer than three corpora qualify, the test runs on those that do and the
    shortfall is reported; it is NOT backfilled by relaxing the floor.

  item_inclusion_rule: >
    Fixed before Stage 0. An item is IN if it elicits a preference, valuation,
    allocation, or self-reported behaviour concerning material resources,
    exchange, work, risk, time preference, redistribution, or fairness in
    distribution. An item is OUT if it is demographic, factual-knowledge,
    religious, or political-identity content. Ambiguous items are resolved by
    the rule "does the response express a resource trade-off?" and every
    ambiguous call is logged in the Stage 0 amendment with its resolution.

  method: >
    Stage 1. Exploratory factor analysis on the polychoric item correlation
    matrix (ordinal items); dimensionality by HORN'S PARALLEL ANALYSIS at the
    95th percentile of 1000 random permutations. Parallel analysis is fixed here
    BEFORE seeing any data because retention rule choice is the single largest
    researcher degree of freedom in this design; Kaiser and scree are reported as
    secondary and are NOT gates.
  n: whole corpus in each case; no subsampling
  stopping: fixed -- one analysis per corpus, no reruns
  clusters: item-level; bootstrap CI on k over 1000 resamples

power: |
  NO PILOT WAS RUN, and the bar is NOT power-sized -- it is inherited verbatim
  from the published falsification clause ([7,11]), which is the point of
  registering it rather than inventing a new bar. The interval is wide (5 of
  the plausible range), so the design is INSENSITIVE rather than underpowered:
  it will fail to discriminate a true k of 8 from a true k of 10, and it is
  not intended to. What it CAN do is refute -- a consistent k of 3 or 4, which
  is what a single-general-factor structure would produce, falsifies cleanly.
  DISCLOSED WEAKNESS 1: because the interval is wide and the prediction says
  "approximately nine", a pass is weak evidence and MUST be reported as such.
  DISCLOSED WEAKNESS 2: the k >= 12 branch is reachable only because the item
  floor makes it reachable. It remains harder to hit than the k <= 6 branch,
  since parallel analysis on attitude batteries is conservative. The test is
  therefore ASYMMETRIC and is registered as such: it is a stronger test against
  low-rank structure than against high-rank structure.
pilot: "NO pilot was run."

falsification: |
  PHYSICS gates (a miss refutes GE-PRED-20-6): k outside [7,11] on two or more
  of the three qualifying corpora. "Consistently", in the published clause, is
  operationalized as this two-of-three majority, and the direction must agree --
  two corpora low, or two corpora high. Two corpora out of range in OPPOSITE
  directions is reported as INCOHERENT, which refutes the prediction's premise
  that a single dimensionality exists to be recovered.
  INSTRUMENT gates (a miss voids the run, and is recorded, not silently
  retried): m < 33 items surviving preprocessing; a correlation matrix that is
  not positive definite; parallel analysis failing to converge; fewer than three
  corpora qualifying at Stage 0.
  A SPLIT result (one corpus out of range, two in) is reported as split and is
  NOT a refutation, but is recorded as failing to support "consistently".

controls: [
  "negative control: the same pipeline on column-shuffled items must recover
   k = 1 or fail to converge",
  "positive control: a synthetic 9-factor dataset with matched n, matched m,
   and matched communalities must recover k in [7,11]. If the positive control
   FAILS, the instrument is unfit and Stage 1 does not run",
]

reread_2026_08_25: |
  This registration was reread cold in a session after the one that drafted it,
  per the programme's rate-limit rule, and was REWRITTEN rather than sealed.
  Three defects were found in the draft, all of which would have required
  post-seal amendments or produced an uninterpretable result:
  (1) FATAL -- the draft named the Moral Machine aggregated AMCE matrix as a
      corpus. That dataset carries nine attribute dimensions BY DESIGN, so a
      factor solution on it cannot exceed k = 9 and the published clause's
      "more than eleven" branch is UNREACHABLE BY CONSTRUCTION. A corpus that
      can only falsify in one direction biases the test. It is also
      moral-dilemma data, not "economic behavioral data" as the published
      prediction specifies -- a scope drift away from the frozen clause.
      REMOVED, and recorded here as removed.
  (2) The draft's instrument gate was "fewer than 20 items", which is BELOW the
      33 needed to identify 11 factors. The gate would have admitted corpora on
      which the upper falsification branch was impossible. RAISED to 33, with
      the derivation stated.
  (3) The draft listed the third corpus as "a public ultimatum/dictator/
      public-goods game meta-dataset" -- an unnamed dataset inside a document
      whose purpose is to eliminate unnamed choices. REPLACED with a fixed
      search order and first-qualifying-dataset rule.
  Recorded because the draft-then-reread-then-seal sequence is the control that
  caught these, and a registration that hides its own near-miss teaches nothing.

amendments: []
hash: sha256:11c168e5942a5e3b63da0cdb38e446c3d9d7c0cd5663e3fb48fd4df5463144e1
```

## Why this one is registrable and others are not

This prediction is testable on **existing public data with a standard method
and a pre-stated interval**. That combination is rare in the corpus and is why
it is registered first.

## What a pass would and would not establish

A pass establishes that economic behavioural data is not obviously
low-dimensional. It does **not** establish that the nine dimensions are *the*
nine dimensions of the moral manifold — factor count is not factor identity,
and the corpus's stronger claims about *which* nine require a different test
entirely. This limit is registered here so that a passing result cannot later
be read as more than it is.

## The Stage 0 amendment is mandatory

Stage 1 must not begin until Stage 0's item lists, counts, disqualifications and
ambiguous-item resolutions are written into `amendments` and committed. That
commit is the second binding timestamp in this registration, and its absence
voids any Stage 1 result — an item list frozen after the factor solution is
seen is not a frozen item list.

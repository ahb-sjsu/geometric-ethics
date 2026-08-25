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
status: DRAFT-UNSEALED
kind: prospective test of a published, never-tested prediction
governs: GE-PRED-20-6
claim: >
  Factor analysis of economic behavioral data recovers a factor structure whose
  retained dimensionality k satisfies 7 <= k <= 11.
prediction:
  primary: k in [7, 11] on the pre-specified corpus, by the pre-specified
    retention rule
  falsified_if: k <= 6 or k >= 12 (the book's own clause, operationalized)
design:
  data: >
    PRE-SPECIFIED, PUBLIC, AND FIXED BEFORE ANY ANALYSIS:
    (a) Moral Machine aggregated AMCE preference matrix (public release);
    (b) World Values Survey wave 7 economic-attitude item battery;
    (c) a public ultimatum/dictator/public-goods game meta-dataset.
    Each corpus is analysed independently; the prediction must hold on each.
  method: >
    Exploratory factor analysis on the item correlation matrix; dimensionality
    by HORN'S PARALLEL ANALYSIS at the 95th percentile of 1000 random
    permutations. Parallel analysis is fixed here BEFORE seeing any data
    because retention rule choice is the single largest researcher degree of
    freedom in this design; Kaiser and scree are reported as secondary and are
    NOT gates.
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
  DISCLOSED WEAKNESS: because the interval is wide and the prediction says
  "approximately nine", a pass is weak evidence and MUST be reported as such.
pilot: "NO pilot was run."
falsification: |
  PHYSICS gates (a miss refutes GE-PRED-20-6): k outside [7,11] on two or more
  of the three corpora.
  INSTRUMENT gates (a miss voids the run): fewer than 20 items surviving
  preprocessing in a corpus; a correlation matrix that is not positive
  definite; parallel analysis failing to converge.
  A SPLIT result (in-range on some corpora, out on others) is reported as
  split and refutes the word "consistently" in the published clause.
controls: [
  "negative control: the same pipeline on shuffled item labels must recover
   k = 1 or fail to converge",
  "positive control: a synthetic 9-factor dataset with matched n and
   communalities must recover k in [7,11]"
]
amendments: []
hash: sha256:
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

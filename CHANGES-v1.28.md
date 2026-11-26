# Geometric Ethics v1.28: what changed

Released 2026-11-26. Source: `source/Geometric-Ethics-v1.28.docx`. The edits are the script
`.build/edits_v1_28.py`, which turns the v1.27 document into this one.

v1.28 states the evidence status of the metric. Three paragraphs are added. No existing
sentence changes and no result changes.

## Edits

- **Ch. 8, Section 8.10a.** A paragraph after the one that identifies the covariance Σ with the
  metric tensor, headed "Evidence status of the metric". It says that the metric is a modeling
  choice, that no measurement in the book shows a metric (set by hand or learned) predicting moral
  judgements better than the boundary penalties alone, and that the one registered test of the
  question was void and so neither supports nor refutes the metric.
- **Ch. 17, Section 17.7** ("What the Evidence Does Not Show"). An eighth limitation, "The metric
  is untested", pointing to Section 8.10a.
- **Preface.** "A note on version 1.28".

## The test the new paragraph cites

`prereg-precedent-v1`, in the `erisml-compiler` repository under `experiments/precedent`. It was
sealed and tagged before any held-out judgement was read, and run on 2026-11-25. Its question:
does a metric learned on sentence embeddings improve the prediction of community verdicts on
held-out forum posts (Scruples Anecdotes), beyond two gates read from the text and the nearest
earlier cases? On 1,165 held-out posts no predictor did better than the average verdict by the
registered margin. The registration had fixed that outcome in advance as a void condition (an
instrument that reads no signal), so the comparison of the metric against the gates was not graded.
Record: `RESULTS-prereg-precedent-v1.md` in that directory.

An addendum to that record, not registered and made on the training posts only, found that about
86% of the variance of the verdicts is not vote noise, and that the two sentence encoders tried
explain 2.5% and 4% of it. The paragraph in Section 8.10a quotes these figures as the reason the
test could not have detected a metric effect of ordinary size.

## Ledger

No claim file changes. The ledger has no claim for Definition 8.13 or for the metric's predictive
value, so there is no row whose class this edit could alter. Whether to add one ("a metric adds
prediction beyond the boundaries", class exploratory, untested) is left to the author.

## Formal checks

No statement marked Proved is changed, so `formal/lean` and `formal/matlab` are not rerun. The
ledger conformance lint is not rerun, since no ledger file changes.

## Still open

Three findings of 2026-11-25 about Chapters 8 and 11 are recorded in
`notes/2026-11-25-hnsw-and-stratified-geometry.md` and are not applied in this version: the proof
of Proposition 8.5(i) as written, the proof step of Proposition 8.1 on the Whitney conditions, and
the description of the MORAL-PATHFIND search with additive penalties. They do not depend on the
test above and await the author's decision.

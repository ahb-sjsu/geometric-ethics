# Geometric Ethics v1.27: what changed

Released 2026-11-25. Source: `source/Geometric-Ethics-v1.27.docx`. The edits are the script
`.build/edits_v1_27.py`, which turns the v1.26 document into this one.

v1.27 settles the three passages that v1.26 listed as open. No result changes.

## Edits

- **Ch. 20, Prediction 2** (`GE-PRED-20-2`). It said "Agents with higher Bond Index scores should
  reject more unfair ultimatum offers…", as if a larger index were better. A Bond Index of 0 is
  perfect invariance, so the agents meant are those with a lower index. The prediction now says
  "agents whose moral evaluations are more invariant under re-description, that is, agents with a
  lower Bond Index". Its content and its falsifier are otherwise unchanged, and it is untested.
- **Ch. 21, the clinical Bond Index** (`GE-PROP-21-3`). `BI(P, S)` is the expected excess cost of
  the path a policy mandates over the manifold-optimal path, for a population. It shares a name
  with the Bond Index of Ch. 18 and is a different quantity: one is an invariance defect, the
  other a cost. A note after Definition 21.10 says so. The name is kept, because *Geometric
  Medicine* (Book 8, Chapter 12) develops the quantity under it. Proposition 21.3 and Prediction 4
  now name the clinical Bond Index in their titles, where they said "Bond Index".
- **Appendix A.** It said a `Bd = 0` certificate "guarantees that no redescription of the input
  can change the evaluation — including redescriptions the verifier has not anticipated". No test
  over a finite suite can show that. The sentence now says that a `Bd = 0` result covers the
  declared suite and nothing outside it, and that the suite is part of the result.
- **Preface.** "A note on version 1.27".

## Ledger

`GE-PRED-20-2` and `GE-PROP-21-3` gain a history entry for the rewording. The title recorded for
`GE-PROP-21-3` becomes "The Clinical Bond Index Detects Structural Injustice". Classes and
statuses are unchanged.

## Formal checks

No statement marked Proved is changed, so `formal/lean` and `formal/matlab` are not rerun.

## Still open

*Geometric Medicine* Chapter 12 uses "Bond Index" for the clinical quantity throughout. The note
added here should be mirrored there.

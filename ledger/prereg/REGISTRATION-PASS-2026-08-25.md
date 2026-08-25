# Registration pass — the six chapter-20 predictions

**2026-08-25.** Minting forward exposure for the Geometric Ethics corpus
(PE-BRW-1.0 §5.5). The six predictions of *Geometric Ethics* §20.11 were
published years ago with falsification clauses and never tested. This pass
asks of each: **can it be registered now, prospectively, with a bar that can be
sized and data that exists?**

The honest answer is **not all of them**, and the differences are informative.

| # | Prediction | Registrable now? | Blocker |
|---|---|---|---|
| **20.6** | Manifold Dimensionality | **YES — registered** ([GE-P-2026-006](GE-P-2026-006-manifold-dimensionality.md)) | none: public data, standard method, pre-stated interval |
| **20.3** | Cross-Cultural Metric Variation | **PARTIALLY** | "varies systematically … in ways predicted by known cultural dimensions" names no specific cultural dimensions and no functional form. **Unfalsifiable as written** — any variation can be called systematic post hoc. Registrable only after the author names the predicted mapping in advance |
| **20.4** | Boundary Penalty Measurement | **PARTIALLY** | testable in principle against the sacred-values literature, but "qualitatively different" needs an operational criterion fixed in advance. Needs one design decision, then registrable |
| **20.1** | Dimensional Activation | **NOT YET** | requires primary data collection (ultimatum games under salience manipulation). Registrable, but it is a study to fund and run, not an analysis to schedule |
| **20.2** | Bond Index Correlates | **NOT YET** | requires Bond Index scores *on human subjects* plus their economic-game behaviour. Same: primary collection |
| **20.5** | Heuristic Admissibility | **BLOCKED — and this is the important one** | requires h\*(n), the true optimal cost, which is only defined given the moral metric. The corpus states plainly that specifying that metric is "**the framework's principal open problem**." The prediction therefore **cannot be tested until an open problem the corpus itself names is solved.** It is not a prediction yet; it is a consequence of one |

## What this pass found

**One prediction is genuinely ready** and is registered. Its design is the part
the book never wrote: which corpora, which retention rule (parallel analysis,
fixed in advance because retention choice is this design's largest researcher
degree of freedom), what counts as a split result, and — registered explicitly —
what a *pass* would fail to establish.

**Three need one decision each** before they can be sealed. In every case the
missing piece is the same: a phrase that reads as a prediction in prose
("systematically", "qualitatively different") but names no measurable criterion.
Writing that criterion down is a five-minute act for the author and cannot
honestly be done by anyone else, because choosing it after seeing data is
exactly the degree of freedom registration exists to remove.

**One is blocked by the corpus's own open problem.** Prediction 20.5 assumes an
object — the moral metric — that the book says it cannot yet construct. This is
worth stating plainly because it is a *structural* finding rather than a
scheduling one: a corpus can contain predictions that are not merely untested
but **untestable given its own admitted gaps**, and prose does not distinguish
the two. A ledger does.

## On sealing

`GE-P-2026-006` is written complete and is **DRAFT-UNSEALED**, per the
programme's own rate-limit rule (`crucible/OT-CRUCIBLE-4.md`): a seal follows a
reread in a later working session, not the session that drafted it. Nothing
binds until a dated SEAL line replaces the status line. To seal:

```
python scripts/seal.py ledger/prereg/GE-P-2026-006-manifold-dimensionality.md
git add ledger/prereg && git commit -m "Seal GE-P-2026-006"
```

The seal commit MUST precede any commit containing results (PE-CLS-1.0 P1), and
`.githooks/pre-rebase` must be active in this repository before the seal, or the
priority evidence is one rebase away from destruction (§7.1.1).

## Ledger effect

`GE-PRED-20-6` moves from `registrable` to `registered` on sealing, with an
edge to this registration. Its class stays `exploratory` until a result exists
— **registration is not evidence**, and the row must not advance on the
strength of a design.

The other five rows stay `registrable` with their blockers recorded above, which
is itself the useful output: the corpus's forward exposure is not six
predictions, it is **one ready, three one-decision-away, one study to fund, and
one blocked on an open problem** — and now that is written down where it can be
acted on rather than rediscovered.

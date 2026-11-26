# Geometric Ethics v1.26: what changed

Released 2026-11-25. Source: `source/Geometric-Ethics-v1.26.docx`. The edits are the script
`.build/edits_v1_26.py`, which turns the v1.25 document into this one; each edit names the text
it changes.

v1.26 does one thing: it gives the Bond Index one definition. No result changes.

## The definition

The Bond Index is the mean change of an evaluation under declared re-descriptions, over a
tolerance:

    d(x, g) = dist(E(g(x)), E(x))      deviation under one declared re-description
    D_op    = mean of d over the tested inputs and re-descriptions
    Bd      = D_op / τ                 0 is perfect invariance

reported with the worst single case and the share of tests in which the evaluation moved. The
distance is 0 or 1 for a verdict or a Hohfeldian position, the absolute change over the scale for
a score, and the distance under the moral metric for a vector or a tensor.

v1.25 stated the index in five ways: `D_op / τ` (Ch. 18, Part V Prelude), a maximum (the proof of
Prop. 19.4), a rate of correlative violations (Ch. 17), a rate of verdict changes and a mean
score change (Appendix D), and a mean norm (Ch. 22). These are the one definition in different
output spaces. The reference implementation is `erisml.ethics.bond_index` in erisml-lib 3.2.0,
with the comparison of the earlier forms in its `docs/BOND_INDEX.md`.

## Edits

- **Core Objects at a Glance.** The Bond Index row said "Quantitative alignment score for AI
  systems" and "Scalar measure of structural × invariance × residue compliance". Nothing computed
  that product. The row now states the definition.
- **Preface.** "A note on version 1.26".
- **Ch. 17, the Dear Ethicist game.** The game's index is identified as the Bond Index on
  Hohfeldian positions. **Corrected:** v1.25 said a value of 0.5 indicates random pairing and
  values above 0.5 indicate anti-correlation. With four positions a random answer gives the
  expected pairing one time in four, so random play scores about 0.75.
- **Ch. 18, Requirement 3.** `D_op` is defined (it was used without a definition), with the
  worst case and the share of tests that moved reported beside the index.
- **Ch. 19, proof of Prop. 19.4.** The proof defined the Bond Index as the maximum deviation over
  the suite. That quantity is now called the worst case, `Bd_max`, and the proof notes that the
  index, a mean, is at most the worst case. The inequality proved is the same; the proposition's
  statement is unchanged.
- **Ch. 22.** The Legal Bond Index is identified as the Bond Index with a vector output and a
  tolerance of one.
- **Appendix B.6.** **Corrected:** the section used its own tiers, with thresholds at 0.1 and
  0.5. It now uses the five tiers of Ch. 18 (0.01, 0.1, 1, 10).

## Not changed, and open

Three passages use the name in a way the definition does not cover. Each is tracked in the
ledger or makes a claim about evidence, so they are left for the author:

- **Ch. 20, Prediction 2** (`GE-PRED-20-2`): "Agents with higher Bond Index scores should reject
  more unfair ultimatum offers…". Under the definition a higher index means less invariance, so
  the direction of the prediction reads reversed.
- **Ch. 21, Prop. 21.3** (`GE-PROP-21-3`): the "Clinical Bond Index" `BI(P, S)` is a cost a
  policy imposes on a population. That is a different quantity under the same name.
- **Appendix A**: "A Bd = 0 certificate … guarantees that no redescription of the input can
  change the evaluation — including redescriptions the verifier has not anticipated." The index
  covers the re-descriptions tested.

The calibration suite's `-log(1 - P)` form (erisml-lib) is a function of how often the
evaluation moves, not of how far; the book does not use it.

## Formal checks

No statement marked Proved is changed, so `formal/lean` and `formal/matlab` are not rerun. The
ledger records statements by identifier and class, not by text, and is unchanged.

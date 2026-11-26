# Geometric Ethics v1.30: what changed

Prepared 2026-11-26. Source: `source/Geometric-Ethics-v1.30.docx`. The edits are the script
`.build/edits_v1_30.py`, which turns the v1.29 document into this one. Each edit names the text
it changes and stops the script if that text is missing or occurs more than once.

v1.30 settles two findings of the cross-volume review of the series (E1 and E2) and five smaller
items, two of them left open by v1.29. No result is added and none is strengthened.

## 1. The tests of the economics volume (E1)

- **Preface, "A note on version 1.25".** "the risky-choice tests of the companion economics
  volume favored prospect theory" becomes "the risky-choice tests run in the companion economics
  volume's repository, and not yet reported in that volume, favored prospect theory".
- **§5.3, "A learned basis".** "a nine-axis codebook that follows this grid (the companion
  economics volume's chart, with money in place of consequences)" becomes "(the nine dimensions
  of the companion economics volume, with money in place of consequences; the test was run in
  that volume's repository and is reported here, not in that volume)".
- **Checked against:** the geometric-economics repository. The learned-basis test is
  `experiments/papers/learned/` (`prereg-learned-v1.md`, `RESULTS.md`: the codebook rows give the
  0.0465 nats, 0.038 against a null mean of 0.060, and log-loss 0.6875 against 0.6927 that §5.3
  quotes). No chapter of that volume mentions the Scruples test, and the cross-volume review
  found that its chapters report neither result. The codebook is that volume's nine dimensions,
  so "chart" was right and is kept in substance; what was missing is where the test is reported.

## 2. Theorem 21.4, Consent as Gauge Invariance (E2)

- **Was:** "Valid informed consent is equivalent to a gauge-invariance condition". **Now:**
  "Valid informed consent requires a gauge-invariance condition", with a note in the statement.
- **Checked against the proof.** The formal statement reads "if consent is valid, then for any
  meaning-preserving reframing … the decision is unchanged", and the proof argues that a decision
  that varies under reframing shows d_9 is not calibrated. Both give the necessary direction:
  valid consent implies invariance. Nothing argues that invariance implies valid consent. This is
  the same finding as for Theorem 8.1 of *Geometric Medicine*.
- **Restatements.** No other sentence states an equivalence (the script checks that "consent is
  equivalent" occurs nowhere else). The summaries say that consent "is a gauge-invariance
  condition" and that "valid consent requires that the patient's decision be invariant", which
  agree with the corrected statement and are unchanged. Corollary 21.2 uses only the necessary
  direction.

## 3. Part VI, "Calibration of the Covariance Matrix"

The paragraph described the calibration as done. Section 8.10a (v1.28) says no estimate of the
covariance has yet been shown to predict judgements better than the boundary penalties alone.

- "the dimensional scores are not estimated from raw behavior but from the calibrated probes of
  Chapter 17" becomes "the dimensional scores are to be estimated not from raw behavior but from
  the probes of Chapter 17".
- "The covariance matrix is then estimated from probe-scored data" becomes "is then to be
  estimated from probe-scored data".
- "falsifiable predictions … that provide external validation" becomes "that can provide
  external validation".
- "The covariance matrix is not assumed; it is empirically estimated, cross-validated, and
  falsifiably constrained." becomes "The covariance matrix is not assumed; it is to be estimated
  from data, cross-validated, and is falsifiable (no estimate yet predicts judgements better than
  the boundary penalties alone, Section 8.10a)."
- The sentence on experimental designs already says they "can" identify the parameters and is
  unchanged.

## 4. DEME has one expansion

- Chapter 1: "the Distributed Ethical Monitoring Engine (DEME)" becomes "the Democratically
  Governed Ethics Module Engine (DEME)".
- **Checked against:** Chapter 19 ("DEME (Democratically Governed Ethics Module Engine)") and
  the bibliography entry Bond (2026d). Those are the only other expansions in the document, so
  the book's majority form is used; the script checks that the other form occurs nowhere else.

## 5. Chapter 19: the Tucker figure

- "Tucker decomposition (Section 6.1, Figure 2)" becomes "(Section 6.1, Figure 3)".
- **Checked against:** the table of figures (Figure 2 is the tensor rank tower, Figure 3 is
  "Tucker Decomposition for Tractability") and the built page of Chapter 6.

## 6. Two chapter ranges (open item 5 of v1.29, and one more of the same kind)

- §12.3: "The framework is pluralist by design (Chapters 15–15)" becomes "(Chapters 15–16)".
- Chapter 30: "7. The framework applies to AI systems (Chapters 18–18)" becomes "(Chapters
  18–19)".
- **How the right text was established.** When Chapter 11 was added, later chapters moved up by
  one. In three ranges only the first number was moved: "13–15" (corrected to 13–16 in v1.29),
  and these two. The sentences confirm it: the §12.3 sentence is about contraction and pluralism
  (Chapters 15 and 16), and the Chapter 30 item names the No Escape Theorem (Chapter 18) and the
  DEME/ErisML architecture (Chapter 19). The script checks that no other range of the form
  "Chapters n–n" remains.

## 7. §29.12, the Chapter column of the table (open item 6 of v1.29)

- Every cell began with ", ": ", 29.2", ", 17, 29.5", ", 19, 29.11". The cells now read "§29.2",
  "Ch. 17, §29.5", "Ch. 19, §29.11", and so on.
- **How the right text was established.** The stray comma is also in the v1.24 TeX source, so no
  earlier text survives in the repository. What each cell holds is the section of Chapter 29 that
  treats the problem; the priority list under the table cites the same sections (§29.2, §29.7,
  §29.5 …). If each cell once held a further first entry, it is not recoverable and is not
  restored.

## Preface

"A note on version 1.30" is added.

## Open, for the author

Unchanged from CHANGES-v1.29, less items 5 and 6 above: the three findings that need new
mathematics (Proposition 8.5(i), Proposition 8.1, MORAL-PATHFIND); §10.5's N = 640 evaluations;
the source of Chapter 24's per-religion results; "the trust hysteresis identified in Chapter 9"
in Chapter 25; the F1 attribution in the §17.7a table; the statements Appendix F does not list;
"confirmed" in five general sentences of the front matter and Part I; Appendix B's "Chapter
18.6" and the index entry "holonomy … non-abelian".

One new item: the Part VI paragraph still says the probes of Chapter 17 map text to dimensional
scores "with known accuracy". The figures it rests on (F1 0.74 to 0.91) are those §17.10a gives
as reported by Thiele (unpublished), and §5.3 reports that the rights axis could not be learned.
The phrase was left.

## Ledger

No claim file is changed. `GE-THM-21-4` ("Consent as Gauge Invariance", exploratory) keeps its
title; a history entry for the change from "is equivalent to" to "requires" should be added when
this version is committed, with those still due for v1.29 (`GE-THM-15-1`,
`GE-HARM-CONSERVATION`).

## Formal checks

No statement marked Proved is changed, so `formal/lean` and `formal/matlab` are not rerun. The
ledger conformance lint is not rerun, since no ledger file changes.

## Build

`python .build/edits_v1_30.py source/Geometric-Ethics-v1.29.docx source/Geometric-Ethics-v1.30.docx`,
then `python .build/build_ethics.py` (VERSION = "1.30") and `--check`. The coverage check reports
the same six paragraphs as before, all omitted by design (the author block of the title page and
the heading "Table of Contents"). Not committed and not published.

# Geometric Ethics v1.29: what changed

Prepared 2026-11-26. Source: `source/Geometric-Ethics-v1.29.docx`. The edits are the script
`.build/edits_v1_29.py`, which turns the v1.28 document into this one. Each edit names the text
it changes and stops the script if that text is missing or occurs more than once.

v1.29 reconciles the book with itself and with its ledger, after a review of the series for
results worded above their evidence, withdrawn results still advertised, and numbers and
cross-references that disagree. No result is added and none is strengthened. Where a statement
and the ledger or the README disagreed, the statement was brought down to the lower of the two.

## 1. Theorem 15.1 (Scalar Irrecoverability): the status tag

- **Was:** `[Proved.]`. **Now:** `[Theorem (conditional on Def. 5.2).]`, with a note in the
  statement.
- **Checked against:** ledger `GE-THM-15-1`, class exploratory, whose evidence note reads
  "Entered exploratory rather than proved because its ethical consequent depends on the
  9-dimensional basis (a modeling axiom); the mathematical implication is sound." The ledger row
  is about this theorem, not a different claim. Appendix F defines Proved as "follows from
  standard mathematics alone, without ethical modeling assumptions", which the theorem's moral
  reading does not meet. `formal/matlab/check_ch15_contraction.m` checks part (i) for
  differentiable Q; the theorem is not in `formal/lean`.
- The theorem's statement and proof are unchanged. The four domain theorems that instantiate it
  (20.2, 21.2, 23.4, 26.1) are untagged and are not touched.

## 2. Appendix F

- **Chapter 12 premises.** Axiom A3 was withdrawn in v1.25 (Section 12.3), but Appendix F still
  listed it as a Modeling Axiom and as a premise. Now: Axiom A3 is "Cyclic Ordering (withdrawn in
  v1.25)", status Withdrawn. Thm 12.2 depends on "Axioms A1–A2" (was A1–A3; the text says
  "Proved, from A1–A2"). Posit 12.3 depends on "Axioms A1–A2, A4–A5" (was A1–A5; the text builds
  it from Thm 12.2, Prop 12.1 and Axiom A5), in Appendix F and in the table of central results in
  Core Objects. Axiom A5 depends on "Axioms A1–A2, A4" (was A1–A4).
- **Rows added** for statements of Chapter 8 written in v1.25 and never listed, each with the tag
  the chapter gives it: Def 8.12 (Modeling Axiom), Def 8.13 (Formal Definition; the name carries
  "metric untested, §8.10a"), Def 8.14 (Formal Definition; ledger `GE-DEF-8-14`, class
  definition), Thm 8.6 and Thm 8.7 (Proved (Lean); ledger `GE-THM-8-6`, `GE-THM-8-7`, class
  proved), Axiom 8.1 (Modeling Axiom; ledger `GE-AXIOM-8-1`). A row for Thm 15.1 (Conditional
  Theorem, Def 5.2, §15.6) is added too. Dependencies are those the statements name; for
  Thms 8.6, 8.7 and Axiom 8.1 they match the ledger's `uses`.
- **Proposition 8.5 is not added.** See "Open, for the author".
- **Section column.** 54 rows gave the section a statement stood in before chapters were
  renumbered (for example "§11 TA" for the technical appendix of Chapter 12, "§15.2" for
  Definition 15.1, which is in §15.6). Each now gives the section in which the statement stands.
  The list is the `SECTION` table in the script. It was made by locating every statement in the
  document and reading the numbered heading above it, and checked the same way after the edit.
- **Prop 20.1–20.3** are Propositions 29.1–29.3 in the text (the open-problems chapter is
  Chapter 29). The rows are renumbered and their section is "§29 TA".
- **What the appendix covers.** It said it "catalogues every numbered formal statement in the
  manuscript", and two other passages (Chapter 1 and Appendix E, both on reification) said "all 112
  statements". The table has 148 rows for 154 statements, all from Chapters 4–19 and 29. The 149
  numbered statements of the domain chapters (20–28) are not in it, and all but one of them
  (Conjecture 22.1) carry no status tag in the text. The three passages now say so. "Every formal
  statement in this book carries an explicit epistemic-status label" becomes "formal statements
  in this book carry explicit epistemic-status labels".

## 3. Appendix D, case study 4 (hiring): the tier

- **Was:** "Bd = 5.08 > 1.0 threshold. Severe demographic bias detected. Fundamental redesign
  required.", a deployment protocol with four tiers ("0.10–1.0: Remediate. Substantive bias. Do
  not deploy."; "> 1.0: Fundamental redesign required."), and "For the biased system: Bd = 5.08.
  Fundamental redesign required."
- **Now:** "Bd = 5.08, in the 1–10 tier of Chapter 18 (high). Demographic bias detected. Do not
  deploy."; the protocol has the five tiers of Chapter 18 (0.10–1.0 remediate before deployment;
  1.0–10 do not deploy; > 10 fundamental redesign); "For the biased system: Bd = 5.08. Do not
  deploy", with a note.
- **Checked against:** Section 18.9.6 and Chapter 19's tier table (Bd < 0.01 deploy; 0.01–0.1
  deploy with monitoring; 0.1–1.0 remediate; 1–10 do not deploy; > 10 fundamental redesign), and
  Appendix B.6, which v1.26 moved to those tiers. The value 5.08 is unchanged
  ((6.2 + 5.5 + 4.3 + 2.5 + 6.9)/5 = 5.08, recomputed).
- **Note.** CHANGES-v1.25 records that with τ = 0.01 "the verdict becomes 'fundamental redesign
  required'". That followed from the case's own four-tier scale. This edit changes the scale to
  the book's, not the value or τ. `appendix_d_cs4_hiring.py` in erisml-lib may assert the old
  verdict text; it was not checked.

## 4. Chapter 8: the strength of the gate evidence

- **§8.4.** "It is confirmed by analysis of the Dear Abby corpus and by the BIP … experiments"
  becomes "It is supported by analysis of the Dear Abby corpus, which is retrospective and was
  not preregistered, and by the BIP … experiments …, which are model-mediated (Chapter 17). No
  gate result yet comes from a preregistered study of people (§17.7b)."
- **§8.10.** "The empirical evidence (§8.4) supports genuine stratification: semantic gates
  behave as step functions" becomes "The empirical evidence so far (§8.4) is consistent with
  genuine stratification: in one advice-column corpus and in embedding models, semantic gates
  behave as step functions … No gate result yet comes from a preregistered study of people
  (§17.7b)."
- **Checked against:** §17.7b ("No order effect, gate or invariance result in this chapter yet
  comes from a preregistered study of people"), the status column of §17.8 ("Observed
  (retrospective corpus; not preregistered)"), and §17.7.

## 5. Withdrawn and refuted results

A search of the whole document for D₄, the quarter-turn, Conservation of Harm, SU(2), the Bell
prediction and hysteresis found every mention of D₄, SU(2) and hysteresis already worded as
withdrawn or falsified. What remained:

- **Conservation of Harm** (ledger `GE-HARM-CONSERVATION`, withdrawn; the chapter title was
  changed in v1.24). Two section titles of Chapter 12 kept the name. "12.7 Four Consequences of
  Harm Conservation" is now "12.7 Four Consequences of the Invariance of Harm Accounting", and
  "12.9 Harm Conservation and AI Alignment" is now "12.9 The Invariance of Harm Accounting and AI
  Alignment", in the headings and in the table of contents. The HTML anchors of the two sections
  change with them. The body sentences that say harm "cannot be created or destroyed by
  re-description" state the weaker claim and are unchanged.
- **Where the refuted predictions are reported.** In the Part V Prelude, "the CHSH tests …
  (§12.9)" becomes "(§13.9)" and "hysteresis (§16.10)" becomes "(§17.10)". In §17.10, "the CHSH
  results reported in §13.10" becomes "§13.9". Checked against the headings: the CHSH update is
  in §13.9 and the hysteresis result in §17.10, as §17.7 and Chapter 29 already cite them.
- **Thiele (2026).** v1.25 decided that the study is "reported by … (unpublished)", not an
  independent replication. Three places still said otherwise: Part VI ("with independent
  replication (Thiele, 2026)"), Chapter 24 ("The independently replicated study (Thiele, 2026)
  confirmed this finding"), and the status cell of the methods table in §17.7a ("Independent
  replication"). All three now say "reported by Thiele (unpublished)". The title of §17.10a is
  unchanged, as decided in v1.25.

## 6. Evidence worded above its strength

- **The cross-lingual result is model-mediated** (§17.7: it "is a property of the LaBSE model's
  representations, not a direct measurement of human cross-lingual moral reasoning"). Five
  sentences said more:
  - §12.6: "it is confirmed by the BIP experiments" becomes "it is supported, in a multilingual
    embedding model, by the BIP experiments (§12.8; caveats in §17.7)".
  - §12.9: "language-invariant for the 109K-passage corpus" gains "as a multilingual embedding
    model represents it (§17.7)".
  - §12.11: "has been confirmed empirically across 11 languages" becomes "has been observed
    across 11 languages in a multilingual embedding model (§17.7)".
  - §18.4: "is empirically confirmed" becomes "is observed in a multilingual embedding model
    (§17.7)".
  - §18.4: "have already demonstrated that deontic structure is gauge-invariant in human moral
    reasoning" becomes "have shown that deontic structure is gauge-invariant in the
    representations of a multilingual embedding model. Whether it is so in human moral reasoning
    has not been tested (§17.7)."
- **Case studies read after the fact** (Chapters 20 and 25):
  - §20.10: the three cases were said to demonstrate "that the framework is not merely formal but
    operationally predictive". Now: "illustrating how the framework reads them. The readings are
    retrospective: they were made after the outcomes were known."
  - §20.10, Daraprim: "Every prediction of the manifold framework was confirmed" becomes "Each
    element of the framework's retrospective reading is consistent with what happened".
  - Chapter 25, the Paris Agreement: "This prediction has been confirmed: the UNEP Emissions Gap
    Report" becomes "The record is consistent with this reading, which was made after the fact:
    the UNEP Emissions Gap Report".
- **Chapter 24 (theology).** The chapter says the cross-lingual corpus "recovered the same nine
  dimensions" from each religious tradition, that "factor analysis showed no religion-specific
  dimensions", gives dimension weightings by religion, and says sacred-value texts "activate
  d_1 + d_2 with infinite boundary weight". Chapter 17 reports none of this (it reports the
  transfer of the obligation/permission axis in the LaBSE model, and that content does not
  transfer), and the chapter cites no other source. As v1.25 did for the fuzz study, the text now
  says so: a paragraph "Status of the evidence in this chapter (added in v1.29)" follows the
  first such claim in §24.1. In that first claim, "The 20,030 texts analyzed in Bond (2026)"
  becomes "The 109,294 passages of the cross-lingual corpus (§17.3)" (20,030 is the number of
  Dear Abby letters), and "the same nine-dimensional structure was recovered across all of them"
  becomes "the obligation/permission axis transferred across all eleven languages in the LaBSE
  model (§17.3)". Proposition 24.1, Theorem 24.2, Proposition 24.4 and their "Evidence"
  paragraphs are not edited; the new paragraph says at what strength to read them.
- **Chapter 26 (AI ethics).** "the framework's validity is established independently (Chapters
  5-15, empirical validation in Chapter 16)" becomes "the framework is developed independently
  (Chapters 5-16, with its evidence and the limits of that evidence in Chapter 17)". "The
  cross-lingual validation corpus (Chapter 16) recovered nine moral dimensions across 20,030
  texts and 109,294 cross-lingual passages" becomes "Chapter 17 codes 20,030 advice-column
  letters on the nine dimensions and tests deontic transfer on 109,294 cross-lingual passages. It
  does not show that the dimensions number nine: the nine are a chart, and the measured effective
  rank is below six (§5.3)." "The empirical validation of the manifold structure" becomes "The
  empirical study of the manifold structure". Checked against §5.3 and the README.

## 7. Cross-references left from an earlier numbering

Chapters after 11 moved up by one when Chapter 11 was added, and the open problems became
Chapter 29 when the domain chapters were added. References corrected, each checked against the
headings:

- Core Objects table: BIP "(Ch. 5, 11)" → "(Ch. 5, 12)"; Contraction + Residue "(Ch. 14)" →
  "(Ch. 15)"; No Escape Theorem "(Ch. 17)" → "(Ch. 18)".
- Chapter 19: "Open Problem 19.2" (three times) → "the open problem of §29.2".
- §17.8 table: Correlative symmetry "Ch. 8, 11" → "Ch. 8, 12"; Entanglement (collective)
  "Ch. 13, 13" → "Ch. 13, 14".
- §29.12 table: "19.2" … "19.11" → "29.2" … "29.11"; "16" → "17" (the anomaly, §17.3); "18" →
  "19" (institutional design, the DEME profile).
- Chapter 30: "quantum, collective, and uncertain domains (Chapters 13–15)" → "(Chapters 13–16)".
- Chapter 26: "Chapter 16" → "Chapter 17" (twice, in the edits of section 6 above).

## Open, for the author

**Three findings that need new mathematics.** They are recorded in
`notes/2026-11-25-hnsw-and-stratified-geometry.md`, were listed in CHANGES-v1.28, and are not
edited in this version:

1. **Proposition 8.5(i)**, the proof as written. For this reason Proposition 8.5 was not given a
   row in Appendix F: a row marked Proved would repeat a tag whose proof is in question, and any
   other status would decide the finding.
2. **Proposition 8.1**, the step of the proof on the Whitney conditions.
3. **MORAL-PATHFIND**, the description of the search with additive penalties.

**Items whose right value could not be established from the repository.** The text is unchanged.

4. **§10.5, "Selective path dependence"** (N = 640 evaluations, 8 scenarios, χ² = 72.14). The
   passage does not say who or what made the evaluations. The README says the book's order
   effects come from one language model. If these did too, the passage should say so.
5. **Chapter 24**: the source of the per-religion results (item 6 above). If there is a record,
   it should be cited; if not, the "Evidence" paragraphs under Propositions 24.1 and 24.4 and the
   proof of Theorem 24.2 need rewording beyond the note added here.
6. **Chapter 25, "the trust hysteresis identified in Chapter 9"** (twice: the Great Barrier Reef
   and Flint cases). Chapter 9 of this book identifies no trust hysteresis, and "hysteresis" is
   elsewhere the refuted obligation-threshold prediction. The intended reference is not clear
   (Chapter 10's path dependence of trust rebuilding is the nearest).
7. **§12.3, "The framework is pluralist by design (Chapters 15–15)"**: a broken range.
8. **§29.12 table**: every cell of the Chapter column begins with ", " as if a first entry had
   been lost.
9. **§17.7a table, first row**: F1 0.74–0.91 is given for "Dear Abby (20,030)" with "LaBSE +
   linear probe"; §17.10a gives the same range as Thiele's unpublished result. Which study the
   figure belongs to is not clear.
10. **Appendix F, statements still not listed**: Definition 11.5, Theorem 11.1b and Corollary
    12.1 (tagged in the text, but a row needs a dependencies entry), Definitions 14.5 and 14.6
    (untagged), and the 149 statements of Chapters 20–28 (148 untagged; the ledger classes most
    of their theorems, propositions, lemmas and corollaries as exploratory by characterization).
11. **Front matter and Part I** still use "confirmed" for corpus and model observations in a few
    general sentences (Preface: "the predictions are confirmed by data"; Chapter 1: "experimental
    data confirm that these transitions behave as step functions", "kept confirming the
    predictions"; Chapter 2: "Empirical evidence confirms"; Chapter 3: "Empirical
    confirmation"). They were reviewed and left: each is a summary whose chapter-level statement
    is now qualified, and rewording them is a matter of the author's voice.
12. **Appendix B**, "Chapter 18.6" for the DEME pipeline and four-layer architecture (DEME is
    Chapter 19), and the index entry "holonomy … non-abelian, 10.5": not checked further.

## Ledger

No claim file is changed. Two rows now describe the text of an earlier version and should gain a
history entry when this version is committed: `GE-THM-15-1` (its scope says "tagged [Proved] by
the author … Absent from Appendix F's registry"; the tag is now conditional and the theorem has
a row) and `GE-HARM-CONSERVATION` (two section titles renamed).

## Formal checks

No statement is changed in content, so `formal/lean` and `formal/matlab` are not rerun. Theorem
15.1 changes its tag from Proved to conditional; `formal/README.md` lists it under the MATLAB
checks only. The ledger conformance lint is not rerun, since no ledger file changes.

## Build

`python .build/edits_v1_29.py source/Geometric-Ethics-v1.28.docx source/Geometric-Ethics-v1.29.docx`,
then `python .build/build_ethics.py` (VERSION = "1.29"). Not committed and not published.

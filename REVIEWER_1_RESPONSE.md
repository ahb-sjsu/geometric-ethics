# Response to Reviewer 1 — action plan

The review is largely about **claim calibration, epistemic labeling, and methods
presentation**, not content errors. Almost every point is addressable by tone and
structure changes plus two tables the reviewer effectively pre-authored. Below: for each
concern, our assessment, the concrete action, and who owns it (✎ = a safe edit we can make
now; ★ = an editorial decision for the author; ⧗ = larger work).

## Major concerns

**1. Scope too large / too universal (800+ pp). ★**
Agree it weakens credibility. Recommended split: (a) core monograph — scalar failure,
manifold, tensor hierarchy, stratification, contraction, uncertainty, modest AI; (b)
technical papers — BIP, No-Escape, DEME/ErisML, empirical corpus; (c) application papers
per domain. *Author decision:* either restructure into layers, or compress the domain
chapters (finance/theology/military/…) into short "application sketches" with a
section-level epistemic tag (see #8). Lowest-effort interim: add a preface note framing the
domain chapters as *illustrative extensions*, not load-bearing evidence.

**2. Claim status inconsistent (modest body vs. strong preface/conclusion). ✎**
Agree — this is the single highest-leverage fix. Actions: (i) add a **Claims Ladder** table
near the front (done — see below); (ii) soften the preface/conclusion to the recommended
tone: *"The framework is now precise enough for systematic empirical and engineering
evaluation,"* not *"the mathematics is ready; the obstacle is political."* Specific
replacements are in "Specific recommendations" below.

**3. Empirical chapter needs a methods upgrade. ✎/⧗**
Agree. Action: add a **per-claim empirical-methods table** to Ch. 17
(Claim | Dataset | Unit | Label source | Model/tool | Metric | Baseline | Result | CI/p |
Status). We can add the table scaffold now; filling every cell needs the author's records
(preregistered vs. exploratory, baselines, CIs, splits). Also: (a) stop calling Dear Abby
"expert ground truth" — call it a *single consistent normative respondent*; (b) put the
LaBSE-≠-human caveat **next to every "100% transfer" claim**; (c) label the Dear Ethicist
game *preliminary*; (d) report multiple-comparison corrections and classical baselines for
order-effect / quantum claims. Note: §17.15 (the new relational-tensor section) already
models this standard — its bootstrap CIs, robustness controls, and honest limitations are a
template for upgrading the rest of Ch. 17.

**4. "Quantum" is the riskiest framing. ★**
Agree with the reviewer's logic: the evidence supports *non-commutativity / order effects*,
not quantum states (interference unconfirmed, Bell falsified). *Recommended:* rename Ch. 13
to **"Non-Commutative Normative Dynamics"** and demote "quantum" to a clearly-speculative
subsection/appendix. This is a global find/replace-plus-judgment pass; author sign-off
before we execute.

**5. No-Escape theorem — narrower rhetoric. ★**
Agree. The result is conditional (canonicalization, gauge-invariant evaluation, audit
completeness, external verification) and excludes compromised sensors, TCB failure,
multi-agent, institutional capture. *Recommended rename:* **"No Redescription Escape for
Structurally Contained Agents"** (or "Structural Containment Theorem"), with the conclusion
reworded so it does not read as "AI safety is solved." Author sign-off, then we do the
rename + statement edit throughout.

**6. Nine dimensions need justification. ✎/★**
Agree there's a tension: Appendix E says <6 recovered factors would falsify the dimensional
claim, but nothing pins *exactly nine*. Action: add a paragraph in Ch. 6 stating the
**epistemic status of the nine explicitly** — recommended framing: *a canonical engineering
chart derived from the 3×3 scope/mode grid, not a discovered empirical dimensionality*;
factor analysis is expected to recover ≥6 semi-independent factors, and the chart is chosen
for coverage and auditability, not claimed to be the unique basis. Also add a short
comparison paragraph to Moral Foundations Theory / Schwartz / capability theory / deontic
logic (ties to #9). §17.15 already reports that the dimension mode is not collapsed by the
unfoldings but is prevalence-unequal — useful supporting nuance.

**7. Noether "conservation" → "Noether-inspired invariance." ✎**
Agree; low-risk, high-credibility. Action (done below): qualify the Ch. 12 language to
"a Noether-inspired invariance principle for harm accounting," reserve "conservation law"
for after the formal assumptions (configuration space, action, symmetry group, current,
boundary terms) are stated, and add the reminder that the conserved quantity is a
*model-assigned* harm score invariant under chosen transformations, not a metaphysical
claim.

**8. Domain chapters need section-level epistemic labels. ✎ (repeatable)**
Agree — the machinery already exists (Appendix F). Action: prepend a one-word tag to
domain-chapter section headers/leads: *Formal result / Modeling interpretation / Empirical
hypothesis / Domain analogy / Speculative extension.* We can script a first pass tagging the
most exposed claims (finance-as-curvature, Flash-Crash-as-collapse, Fall-as-impossibility,
Euthyphro-as-gauge) as *Domain analogy* / *Speculative extension*.

**9. Related-work burden. ⧗**
Agree — the bibliography leans on the author's own working papers. Action: expand Appendix A
/ the lit review across the reviewer's list (formal ethics & decision theory; multiobjective
optimization / vector utility; deontic logic & Hohfeld; moral psychology / MFT; quantum
cognition; causal representation learning & IRM; formal verification & runtime assurance;
alignment / reward modeling / constitutional AI / RLHF / scalable oversight; sociotechnical
governance; argumentation & defeasible reasoning; computational social choice;
category-theoretic / geometric agency). Explicitly note where the framework *re-expresses*
established structures (vector utility, Hohfeld, order effects) rather than discovering them.

## Presentation / formatting ✎
- **Accessibility:** 22 high-severity missing alt-texts + 6 medium; add alt text to all
  figures; mark table header rows.
- **Heading-level jump:** "Epistemic Status Tags" is Heading 3 directly under Heading 1 →
  promote to Heading 2 (safe edit; done below if present in source).
- **Styles:** normalize heading-like Normal/directly-formatted paragraphs to heading styles
  before submission.
- **Fields:** update all PAGEREF / SEQ fields in Word and verify TOC/figure list/cross-refs
  before PDF export.
- **SVG images:** test PDF export from Word, LibreOffice, and the publisher pipeline.
- **Glyphs:** check the final PDF for Greek indices, arrows, inequalities, contractions.

## Specific revision recommendations (recommended replacement text)
- **Central thesis (preface).** Replace *"Ethics has the wrong mathematical language; the
  mathematics is ready; the remaining problem is political"* with: *"Many morally significant
  decisions lose essential structure when represented as scalars. Geometric ethics offers a
  formal vocabulary for preserving that structure until an explicit, auditable contraction is
  required. The framework is a conditional modeling and engineering program whose empirical
  adequacy remains under active test."*
- **Move modesty earlier.** Put a compact version of Ch. 16 / Appendix E (structure not
  content; characterizes uncertainty; depends on governed metrics; theorems are conditional)
  into Ch. 1 / the Preface.
- **Reduce strongest AI-safety language.** "the mathematical solution exists" → *"a
  conditional structural-containment theorem exists under explicit assumptions"*; "the
  engineering is tractable" → *"a reference architecture has been specified and partially
  implemented"*; "the obstacle is political, not technical" → *"the remaining obstacles
  include governance, implementation, security, empirical validation, and institutional
  adoption."*

## What we are doing now (this commit)
1. Add the **Claims Ladder** table to the front matter (reviewer-provided content).
2. Qualify the **Noether** language in Ch. 12 (#7).
3. Promote the **"Epistemic Status Tags"** heading if it is mis-leveled.

## Awaiting author decision before executing
- #1 scope split / domain compression; #4 Ch. 13 rename+demote of "quantum"; #5 No-Escape
  rename + conclusion rewrite; the preface/conclusion tone rewrite (#2 / specific recs).
  These change the book's framing and are the author's call — say the word and we execute
  each as a scoped edit + rebuild.

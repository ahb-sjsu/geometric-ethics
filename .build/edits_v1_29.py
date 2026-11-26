#!/usr/bin/env python3
"""The edits that turn source/Geometric-Ethics-v1.28.docx into v1.29.

    python .build/edits_v1_29.py source/Geometric-Ethics-v1.28.docx source/Geometric-Ethics-v1.29.docx

v1.29 reconciles the book with itself and with its ledger (see CHANGES-v1.29.md). No result
is added and none is strengthened. As in edits_v1_27.py and edits_v1_28.py, each edit finds
its paragraph, run, table row or cell by text that must occur exactly once, and the script
stops on the first edit whose target is missing or ambiguous.
"""

from __future__ import annotations

import copy
import sys

import docx
from docx.table import _Row

SRC, DST = sys.argv[1], sys.argv[2]
d = docx.Document(SRC)
P = d.paragraphs
TEXT = [p.text for p in P]  # the v1.28 text of each paragraph: every anchor is matched against it
STYLE = [p.style.name for p in P]
done = []
W = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}"


def one(startswith: str):
    hits = [p for p, t in zip(P, TEXT) if t.startswith(startswith)]
    assert len(hits) == 1, (startswith[:50], len(hits))
    return hits[0]


def heading(text: str):
    hits = [p for p, t, st in zip(P, TEXT, STYLE) if st.startswith("Heading") and t == text]
    assert len(hits) == 1, (text[:50], len(hits))
    return hits[0]


def replace_in_run(p, old: str, new: str, count: int = 1) -> None:
    """Replace text that lies inside a single run of paragraph p (count occurrences in it)."""
    runs = [r for r in p.runs if old in r.text]
    assert len(runs) == 1 and runs[0].text.count(old) == count, (old[:50], len(runs))
    runs[0].text = runs[0].text.replace(old, new)
    done.append(old[:60])


def insert_after(p, text: str, style=None):
    new_p = copy.deepcopy(p._p)
    for child in list(new_p):
        if child.tag.endswith("}r") or child.tag.endswith("}oMath") or child.tag.endswith("}oMathPara"):
            new_p.remove(child)
    p._p.addnext(new_p)
    para = docx.text.paragraph.Paragraph(new_p, p._parent)
    para.add_run(text)
    if style is not None:
        para.style = d.styles[style]
    done.append("+ " + text[:60])
    return para


def table_with_header(*header: str):
    hits = [t for t in d.tables if [c.text.strip() for c in t.rows[0].cells][: len(header)] == list(header)]
    assert len(hits) == 1, (header, len(hits))
    return hits[0]


def row_of(table, first_cell: str):
    hits = [r for r in table.rows if r.cells[0].text.strip() == first_cell]
    assert len(hits) == 1, (first_cell, len(hits))
    return hits[0]


def replace_in_cell(cell, old: str, new: str) -> None:
    """Replace text that lies inside a single run of a table cell."""
    runs = [r for para in cell.paragraphs for r in para.runs if old in r.text]
    assert len(runs) == 1 and runs[0].text.count(old) == 1, (old[:50], len(runs))
    runs[0].text = runs[0].text.replace(old, new)
    done.append("table: " + old[:50])


def set_cell(cell, old: str, new: str) -> None:
    """Replace the whole text of a one-paragraph, one-run cell, checking what was there."""
    assert cell.text.strip() == old, (old, cell.text)
    assert len(cell.paragraphs) == 1 and len(cell.paragraphs[0].runs) == 1, old
    cell.paragraphs[0].runs[0].text = new
    done.append(f"table: {old[:30]} -> {new[:30]}")


def add_row_after(table, row, texts):
    """A new table row after `row`, a copy of it with the given cell texts."""
    new_tr = copy.deepcopy(row._tr)
    row._tr.addnext(new_tr)
    new = _Row(new_tr, table)
    assert len(new.cells) == len(texts)
    for cell, text in zip(new.cells, texts):
        assert len(cell.paragraphs) == 1 and len(cell.paragraphs[0].runs) == 1
        cell.paragraphs[0].runs[0].text = text
    done.append("table: + row " + texts[0])
    return new


def toc_entry(old: str, new: str) -> None:
    """The cached text of a table-of-contents entry (its runs sit inside a hyperlink)."""
    hits = [t for p, st in zip(P, STYLE) if st.startswith("toc") for t in p._p.iter(W + "t") if t.text == old]
    assert len(hits) == 1, (old, len(hits))
    hits[0].text = new
    done.append("toc: " + old[:50])


# ============================================================ 1. Theorem 15.1: the status tag
# Ledger GE-THM-15-1 has class exploratory: "its ethical consequent depends on the
# 9-dimensional basis (a modeling axiom); the mathematical implication is sound".
p = one("Theorem 15.1 (Scalar Irrecoverability). [Proved.]")
replace_in_run(p, "[Proved.] Let Q", "[Theorem (conditional on Def. 5.2).] Let Q")
replace_in_run(
    p,
    "is not bounded by any function of Q alone.",
    "is not bounded by any function of Q alone. (v1.29: earlier versions tagged this theorem Proved. "
    "The mathematical implication is sound for a continuous Q. Its ethical consequent depends on the "
    "nine-dimensional chart of Definition 5.2, which is a modeling axiom, so the tag is now "
    "conditional. This agrees with the ledger, which classes the theorem exploratory, GE-THM-15-1.)",
)

# ============================================================ 2. Appendix F
F = table_with_header("Ref", "Name", "Status", "Dependencies", "§")

# 2a. Chapter 12: Axiom A3 was withdrawn in v1.25, so nothing can depend on it.
r = row_of(F, "Axiom A3")
set_cell(r.cells[1], "Cyclic Ordering", "Cyclic Ordering (withdrawn in v1.25)")
set_cell(r.cells[2], "Modeling Axiom", "Withdrawn")
set_cell(row_of(F, "Axiom A5").cells[3], "Axioms A1–A4", "Axioms A1–A2, A4")
set_cell(row_of(F, "Thm 12.2").cells[3], "Axioms A1–A3", "Axioms A1–A2")
set_cell(row_of(F, "Posit 12.3").cells[3], "Axioms A1–A5", "Axioms A1–A2, A4–A5")
T2 = table_with_header("Result", "Statement (informal)", "Assumptions")
rows = [r for r in T2.rows if r.cells[0].text.strip().startswith("Posit 12.3")]
assert len(rows) == 1
set_cell(rows[0].cells[2], "Axioms A1–A5", "Axioms A1–A2, A4–A5")

# 2b. The section column. Each entry is (old, new); the new value is the section in which the
# statement stands in this version ("TA" is the chapter's Technical Appendix).
SECTION = {
    "Def 5.2": ("§5.2", "§5.3"),
    "Axiom 5.1": ("§5.3", "§5.5"),
    "Def 5.7": ("§5.6", "§5.7"),
    "Def 8.10": ("§8.6", "§8.7"),
    "Def 9.1": ("§9.4", "§9.8"),
    "Cor A.1": ("§11 TA", "§12 TA"),
    "Prop A.2": ("§11 TA", "§12 TA"),
    "Thm A.1": ("§11 TA", "§12 TA"),
    "Lemma A.2": ("§11 TA", "§12 TA"),
    "Lemma A.3": ("§11 TA", "§12 TA"),
    "Def 13.2": ("§13.2", "§13.4"),
    "Def 13.3": ("§13.3", "§13.6"),
    "Def 13.4": ("§13.4", "§13.6"),
    "Def 13.5": ("§13.5", "§13.7"),
    "Def 13.6": ("§13.5", "§13.7"),
    "Def 13.7": ("§13.6", "§13.7"),
    "Thm 13.1": ("§12 TA", "§13 TA"),
    "Prop 13.1": ("§13.3", "§13.4"),
    "Prop 13.2": ("§12 TA", "§13 TA"),
    "Prop 13.3": ("§12 TA", "§13 TA"),
    "Prop 13.4": ("§12 TA", "§13 TA"),
    "Def 14.1": ("§14.2", "§14.3"),
    "Def 14.2": ("§14.2", "§14.3"),
    "Def 14.4": ("§14.5", "§14.6"),
    "Prop 14.1": ("§14.3", "§14.5"),
    "Prop 14.2": ("§14.3", "§14.10"),
    "Prop 14.3": ("§13 TA", "§14 TA"),
    "Prop 14.4": ("§13 TA", "§14 TA"),
    "Prop 14.5": ("§13 TA", "§14 TA"),
    "Def 15.1": ("§15.2", "§15.6"),
    "Def 15.2": ("§15.3", "§15.7"),
    "Prop 15.1": ("§15.3", "§15.7"),
    "Prop 15.2": ("§15.4", "§15.10"),
    "Prop 15.3": ("§14 TA", "§15 TA"),
    "Prop 15.4": ("§14 TA", "§15 TA"),
    "Prop 15.5": ("§14 TA", "§15 TA"),
    "Rmk A.1": ("§14 TA", "§15 TA"),
    "Def 16.2": ("§16.4", "§16.6"),
    "Prop 16.1": ("§16.4", "§16.6"),
    "Prop 16.2": ("§15 TA", "§16 TA"),
    "Prop 16.3": ("§15 TA", "§16 TA"),
    "Prop 16.4": ("§15 TA", "§16 TA"),
    "Lemma 18.1": ("§18.8", "§18.7"),
    "Lemma 18.2": ("§18.8", "§18.7"),
    "Prop 18.1": ("§17 TA", "§18 TA"),
    "Prop 18.2": ("§17 TA", "§18 TA"),
    "Prop 18.3": ("§17 TA", "§18 TA"),
    "Prop 18.4": ("§17 TA", "§18 TA"),
    "Prop 18.5": ("§17 TA", "§18.7"),
    "Def 19.1": ("§19.5", "§19.3"),
    "Prop 19.1": ("§18 TA", "§19 TA"),
    "Prop 19.2": ("§18 TA", "§19 TA"),
    "Prop 19.3": ("§18 TA", "§19 TA"),
    "Prop 19.4": ("§18 TA", "§19 TA"),
}
for ref, (old, new) in SECTION.items():
    set_cell(row_of(F, ref).cells[4], old, new)

# 2c. The three propositions of the open-problems chapter are numbered 29.1 to 29.3 in the text.
for old_ref, new_ref, name in (
    ("Prop 20.1", "Prop 29.1", "Curvature Detection Criterion"),
    ("Prop 20.2", "Prop 29.2", "Torsion Detection Criterion"),
    ("Prop 20.3", "Prop 29.3", "Meta-Metric Existence"),
):
    r = row_of(F, old_ref)
    assert r.cells[1].text.strip() == name, r.cells[1].text
    one(f"Proposition {new_ref[5:]} ({name})")
    set_cell(r.cells[4], "§19 TA", "§29 TA")
    set_cell(r.cells[0], old_ref, new_ref)

# 2d. Rows for the statements of Sections 8.10a and 8.10b, and for Theorem 15.1. The status is
# the tag the chapter gives; Theorems 8.6 and 8.7 are ledger GE-THM-8-6 and GE-THM-8-7 (proved).
# Proposition 8.5 is not added: the proof of its part (i) is under an open finding.
for ref in ("Def 8.12", "Def 8.13", "Def 8.14", "Thm 8.6", "Thm 8.7", "Axiom 8.1", "Thm 15.1"):
    assert not [r for r in F.rows if r.cells[0].text.strip() == ref], ref
for start in (
    "Definition 8.12 (The Moral Decision Complex). [Modeling Axiom.]",
    "Definition 8.13 (Mahalanobis Edge Weights with Boundary Penalties). [Formal Definition.]",
    "Definition 8.14 (Executable stratification).",
    "Theorem 8.6 (Containment).",
    "Theorem 8.7 (Absorption).",
    "Axiom 8.1 (Reversion). [Modeling axiom.]",
):
    one(start)
r = row_of(F, "Prop 8.3")
for texts in (
    ("Def 8.12", "The Moral Decision Complex", "Modeling Axiom", "Defs 5.1, 5.2", "§8.10a"),
    (
        "Def 8.13",
        "Mahalanobis Edge Weights with Boundary Penalties (metric untested, §8.10a)",
        "Formal Definition",
        "Def 8.12",
        "§8.10a",
    ),
    ("Def 8.14", "Executable Stratification", "Formal Definition", "Defs 8.6, 8.8, 8.11", "§8.10b"),
    ("Thm 8.6", "Containment", "Proved (Lean)", "Def 8.14", "§8.10b"),
    ("Thm 8.7", "Absorption", "Proved (Lean)", "Def 8.14", "§8.10b"),
    ("Axiom 8.1", "Reversion", "Modeling Axiom", "Defs 8.9, 8.14", "§8.10b"),
):
    r = add_row_after(F, r, texts)
add_row_after(
    F,
    row_of(F, "Def 15.1"),
    ("Thm 15.1", "Scalar Irrecoverability", "Conditional Theorem", "Def 5.2", "§15.6"),
)

# 2e. What the appendix covers, and how many statements. A row "Def A.1–A.6" stands for six
# statements and "Defs 8.2–8.3" for two.
refs = [r.cells[0].text.strip() for r in F.rows[1:]]
assert len(refs) == 148, len(refs)
assert sum(6 if x == "Def A.1–A.6" else 2 if x == "Defs 8.2–8.3" else 1 for x in refs) == 154
p = one("This appendix catalogues every numbered formal statement in the manuscript")
replace_in_run(
    p,
    "This appendix catalogues every numbered formal statement in the manuscript —",
    "This appendix catalogues the numbered formal statements of Chapters 4 through 19, and the three "
    "propositions of Chapter 29 —",
)
replace_in_run(p, "together with its epistemic status and dependencies.", "each with its epistemic status and dependencies.")
replace_in_run(
    p,
    "and what is conjectured or proposed for future investigation.",
    "and what is conjectured or proposed for future investigation. (v1.29: earlier versions said that "
    "the appendix catalogues every numbered formal statement in the manuscript. The statements of the "
    "domain chapters, 20 through 28, are not catalogued here. All but one of them carry no status tag "
    "in the text, and the repository ledger classes most of their theorems, propositions, lemmas and "
    "corollaries. Six statements of the catalogued chapters are not yet listed: Proposition 8.5, "
    "Definition 11.5, Theorem 11.1b, Corollary 12.1, and Definitions 14.5 and 14.6.)",
)
p = one("Three architectural safeguards block the reification trajectory.")
replace_in_run(
    p,
    "First, every formal statement in this book carries an explicit epistemic-status label:",
    "First, formal statements in this book carry explicit epistemic-status labels:",
)
replace_in_run(
    p,
    "(Appendix F catalogues all 112 statements with their status and dependencies)",
    "(Appendix F catalogues the 154 statements of Chapters 4 through 19 and 29 with their status and "
    "dependencies; the domain chapters, 20 through 28, are mostly untagged and are not catalogued there)",
)
p = one("Five features of the framework’s architecture block the reification trajectory.")
replace_in_run(
    p,
    "every formal statement in the manuscript carries a status tag (Appendix F catalogues all 112 "
    "statements as",
    "formal statements in the core chapters carry a status tag (Appendix F catalogues the 154 statements "
    "of Chapters 4 through 19 and 29 as",
)

# ============================================================ 3. Appendix D, the hiring case
# Bd = 5.08 lies in the 1–10 tier of Chapter 18 (do not deploy). The case used a four-tier
# scale of its own, in which everything above 1.0 was "fundamental redesign".
p = one("Bd = 5.08 > 1.0 threshold.")
replace_in_run(
    p,
    "Bd = 5.08 > 1.0 threshold. Severe demographic bias detected. Fundamental redesign required.",
    "Bd = 5.08, in the 1–10 tier of Chapter 18 (high). Demographic bias detected. Do not deploy.",
)
p = one("Step 1: Run transform suite T₁–T₅ on all 10,000 candidates.")
replace_in_run(
    p,
    "   0.10–1.0:   Remediate. Substantive bias. Do not deploy.",
    "   0.10–1.0:   Remediate before deployment. Substantive bias.",
)
replace_in_run(
    p,
    "   > 1.0:      Fundamental redesign required.",
    "   1.0–10:     Do not deploy.\n   > 10:       Fundamental redesign required.",
)
p = one("For the biased system: Bd = 5.08.")
replace_in_run(
    p,
    "For the biased system: Bd = 5.08. Fundamental redesign required.",
    "For the biased system: Bd = 5.08. Do not deploy (the 1–10 tier; v1.29: earlier versions gave "
    "“fundamental redesign required”, which in the five tiers of Chapter 18 begins above 10).",
)

# ============================================================ 4. Chapter 8: the strength of the gate evidence
p = one("The claim that semantic gates are discrete is empirical, not stipulative.")
replace_in_run(
    p,
    "It is confirmed by analysis of the Dear Abby corpus and by the BIP (Bond Invariance Principle) "
    "experiments across 109,294 passages in 11 languages (Chapter 17).",
    "It is supported by analysis of the Dear Abby corpus, which is retrospective and was not "
    "preregistered, and by the BIP (Bond Invariance Principle) experiments across 109,294 passages in "
    "11 languages, which are model-mediated (Chapter 17). No gate result yet comes from a preregistered "
    "study of people (§17.7b).",
)
p = one("The empirical evidence (§8.4) supports genuine stratification:")
replace_in_run(
    p,
    "The empirical evidence (§8.4) supports genuine stratification: semantic gates behave as step "
    "functions, not smooth transitions.",
    "The empirical evidence so far (§8.4) is consistent with genuine stratification: in one "
    "advice-column corpus and in embedding models, semantic gates behave as step functions, not smooth "
    "transitions. No gate result yet comes from a preregistered study of people (§17.7b).",
)

# ============================================================ 5. Withdrawn and refuted results
# 5a. "Conservation of Harm" was withdrawn as a thesis (ledger GE-HARM-CONSERVATION) and
# Chapter 12 retitled. Two section headings of the chapter kept the old name.
replace_in_run(
    heading("12.7 Four Consequences of Harm Conservation"),
    "12.7 Four Consequences of Harm Conservation",
    "12.7 Four Consequences of the Invariance of Harm Accounting",
)
toc_entry("12.7 Four Consequences of Harm Conservation", "12.7 Four Consequences of the Invariance of Harm Accounting")
replace_in_run(
    heading("12.9 Harm Conservation and AI Alignment"),
    "12.9 Harm Conservation and AI Alignment",
    "12.9 The Invariance of Harm Accounting and AI Alignment",
)
toc_entry("12.9 Harm Conservation and AI Alignment", "12.9 The Invariance of Harm Accounting and AI Alignment")

# 5b. Where the two refuted predictions are reported: the CHSH tests in §13.9, hysteresis in §17.10.
p = one("Retractions are a feature, not an embarrassment.")
replace_in_run(p, "(§12.9)", "(§13.9)")
replace_in_run(p, "16.10) ", "17.10) ")  # the run after "§"
p = one("Theory revision.")
replace_in_run(p, "the CHSH results reported in §13.10", "the CHSH results reported in §13.9")

# 5c. Thiele (2026) is unpublished; since v1.25 it is "reported by", not "independent replication".
p = one("The Grounding Tensor and the Is–Ought Gap")
replace_in_run(
    p,
    "with independent replication (Thiele, 2026).",
    "a result that §17.10a gives as reported by Thiele (2026, unpublished).",
)
T47 = table_with_header("Claim", "Dataset (N)", "Unit")
set_cell(row_of(T47, "Dimensional decodability (repl.)").cells[9], "Independent replication", "Reported by Thiele (unpublished)")

# ============================================================ 6. Evidence worded above its strength
# 6a. The cross-lingual result is model-mediated (§17.7): it is a property of a multilingual
# embedding model, not yet a measurement of people.
p = one("Harm is conserved across translations.")
replace_in_run(
    p,
    "and it is confirmed by the BIP experiments (§12.8).",
    "and it is supported, in a multilingual embedding model, by the BIP experiments (§12.8; caveats in "
    "§17.7).",
)
p = one("This is not a theoretical exercise. It is an implementable test suite.")
replace_in_run(
    p,
    "is language-invariant for the 109K-passage corpus.",
    "is language-invariant for the 109K-passage corpus, as a multilingual embedding model represents it "
    "(§17.7).",
)
p = one("The moral Noether’s theorem is not a metaphor.")
replace_in_run(
    p,
    "is testable and has been confirmed empirically across 11 languages.",
    "is testable and has been observed across 11 languages in a multilingual embedding model (§17.7).",
)
p = one("The BIP experiments found that deontic structure transfers at 100% across languages")
replace_in_run(
    p,
    "the gauge invariance of obligation vs. liberty is empirically confirmed.",
    "the gauge invariance of obligation vs. liberty is observed in a multilingual embedding model "
    "(§17.7).",
)
p = one("This is not a theoretical desideratum; it is a concrete test")
replace_in_run(
    p,
    "have already demonstrated that deontic structure is gauge-invariant in human moral reasoning.",
    "have shown that deontic structure is gauge-invariant in the representations of a multilingual "
    "embedding model. Whether it is so in human moral reasoning has not been tested (§17.7).",
)

# 6b. Chapter 20 and Chapter 25: case studies read after the fact.
p = one("The preceding sections developed the Bond Geodesic Equilibrium as a mathematical structure.")
replace_in_run(
    p,
    "demonstrating that the framework is not merely formal but operationally predictive.",
    "illustrating how the framework reads them. The readings are retrospective: they were made after "
    "the outcomes were known.",
)
p = one("The Daraprim case is a canonical demonstration")
replace_in_run(
    p,
    "Every prediction of the manifold framework was confirmed:",
    "Each element of the framework’s retrospective reading is consistent with what happened:",
)
p = one("Nationally Determined Contributions (NDCs) as Agent-Specific Heuristics.")
replace_in_run(
    p,
    "This prediction has been confirmed: the UNEP Emissions Gap Report",
    "The record is consistent with this reading, which was made after the fact: the UNEP Emissions "
    "Gap Report",
)

# 6c. Chapter 24: what Chapter 17 reports, and what it does not.
p = one("This is empirically supported by the framework's cross-lingual validation corpus.")
replace_in_run(
    p,
    "The 20,030 texts analyzed in Bond (2026) included",
    "The 109,294 passages of the cross-lingual corpus (§17.3) included",
)
replace_in_run(
    p,
    "and the same nine-dimensional structure was recovered across all of them. The independently "
    "replicated study (Thiele, 2026) confirmed this finding across six additional languages.",
    "and the obligation/permission axis transferred across all eleven languages in the LaBSE model "
    "(§17.3). A study reported by Thiele (2026, unpublished) describes linear probes for the nine "
    "dimensions (§17.10a).",
)
insert_after(
    p,
    "Status of the evidence in this chapter (added in v1.29). Chapter 17 reports two things about the "
    "cross-lingual corpus: the obligation/permission axis transfers across its eleven languages in the "
    "LaBSE embedding model, and the specific content of moral reasoning does not transfer (§17.3). That "
    "result is model-mediated, and the instrument may supply the invariance (§17.7). Chapter 17 does not "
    "report a recovery of the nine dimensions tradition by tradition, a factor analysis by religion, the "
    "dimension weightings by tradition given under Proposition 24.1, or the activations of sacred-value "
    "texts given under Proposition 24.4, and this chapter cites no other source for them. They are the "
    "framework’s reading of those traditions, not measured results. The nine dimensions are a chart, "
    "neither complete nor independently measured (§5.3). Where this chapter says “established "
    "empirically”, “recovered” or “the empirical finding”, it is to be read at that strength. (An "
    "earlier version of the preceding paragraph gave the corpus as 20,030 texts. That is the number of "
    "Dear Abby letters, §17.2.)",
)

# 6d. Chapter 26: the empirical chapter is Chapter 17, and it does not show that the dimensions are nine.
p = one("1. Part V of the monograph describes how AI systems can implement")
replace_in_run(
    p,
    "the framework's validity is established independently (Chapters 5-15, empirical validation in "
    "Chapter 16)",
    "the framework is developed independently (Chapters 5-16, with its evidence and the limits of that "
    "evidence in Chapter 17)",
)
p = one("5. The cross-lingual validation corpus (Chapter 16) recovered nine moral dimensions")
replace_in_run(
    p,
    "5. The cross-lingual validation corpus (Chapter 16) recovered nine moral dimensions across 20,030 "
    "texts and 109,294 cross-lingual passages.",
    "5. Chapter 17 codes 20,030 advice-column letters on the nine dimensions and tests deontic transfer "
    "on 109,294 cross-lingual passages. It does not show that the dimensions number nine: the nine are "
    "a chart, and the measured effective rank is below six (§5.3).",
)
replace_in_run(
    p,
    "The empirical validation of the manifold structure is not merely a philosophical curiosity",
    "The empirical study of the manifold structure is not merely a philosophical curiosity",
)

# ============================================================ 7. Cross-references left from an earlier numbering
# The open problems are Chapter 29, the empirical chapter is 17, contraction is 15, the No Escape
# Theorem is 18, the Noether chapter is 12, collective agency is 14 and uncertainty is 16 (the
# sentence in Chapter 30 names the content of Chapters 13, 14, 15 and 16).
p = one("Implementation. The temporal canonicalization tensor requires")
replace_in_run(p, "(this is Open Problem 19.2)", "(this is the open problem of §29.2)")
replace_in_run(p, "depends on Open Problem 19.2 (empirical curvature measurement)", "depends on the open problem of §29.2 (empirical curvature measurement)")
p = one("Four limitations must be stated explicitly.")
replace_in_run(p, "that has not yet been measured (Open Problem 19.2)", "that has not yet been measured (the open problem of §29.2)")
p = one("6. The framework extends to quantum, collective, and uncertain domains")
replace_in_run(p, " (Chapters 13–15).", " (Chapters 13–16).")

T0 = table_with_header("Object / Symbol", "Informal Meaning")
replace_in_cell(row_of(T0, "BIP (Bond Invariance Principle)").cells[2], "(Ch. 5, 11)", "(Ch. 5, 12)")
rows = [r for r in T0.rows if r.cells[0].text.strip().startswith("Contraction + Residue")]
assert len(rows) == 1
replace_in_cell(rows[0].cells[2], "(Ch. 14)", "(Ch. 15)")
replace_in_cell(row_of(T0, "No Escape Theorem").cells[2], "(Ch. 17)", "(Ch. 18)")

T63 = table_with_header("Problem", "Chapter", "Type")
for problem, old, new in (
    ("Direct measurement of curvature", ", 19.2", ", 29.2"),
    ("Metric signature", ", 19.3", ", 29.3"),
    ("Manifold topology", ", 19.3", ", 29.3"),
    ("Moral field equation", ", 19.4", ", 29.4"),
    ("Additional symmetries", ", 19.5", ", 29.5"),
    ("Anomaly source", ", 16, 19.5", ", 17, 29.5"),
    ("Torsion", ", 19.6", ", 29.6"),
    ("Tensorial interpretability", ", 19.7", ", 29.7"),
    ("Scalable containment", ", 19.8", ", 29.8"),
    ("Moral geometric metaphysics", ", 19.9", ", 29.9"),
    ("Intertheoretic comparison", ", 19.10", ", 29.10"),
    ("Institutional design", ", 18, 19.11", ", 19, 29.11"),
):
    cell = row_of(T63, problem).cells[1]
    assert cell.text == old, (problem, cell.text)
    replace_in_cell(cell, old, new)

T48 = table_with_header("Prediction", "Source Chapter", "Empirical Test")
set_cell(row_of(T48, "Correlative symmetry").cells[1], "Ch. 8, 11", "Ch. 8, 12")
set_cell(row_of(T48, "Entanglement (collective)").cells[1], "Ch. 13, 13", "Ch. 13, 14")

# ============================================================ Preface
p = one("This version states the evidence status of the metric.")
body = insert_after(
    p,
    "This version reconciles the book with itself and with its ledger. No result is added and none is "
    "strengthened. Theorem 15.1 is now tagged as conditional on the nine-dimensional chart, as the "
    "ledger classes it. Appendix F gains the statements of Sections 8.10a and 8.10b and Theorem 15.1, "
    "no longer lists the withdrawn Axiom A3 as a premise, gives the section in which each statement now "
    "stands, and says which chapters it covers. The hiring case of Appendix D uses the five tiers of "
    "Chapter 18, so its verdict is “do not deploy”. Passages in Chapters 8, 12, 18, 20, 24, 25 and 26 "
    "that stated an observation in an embedding model, a retrospective reading or an unsourced result "
    "as a confirmed finding now say what they are. Two section titles of Chapter 12 and a number of "
    "cross-references left from an earlier numbering are corrected.",
)
insert_after(p, "A note on version 1.29", style="Heading 3")

d.save(DST)
print(f"wrote {DST}: {len(done)} edits")
for x in done:
    print("  ", x)

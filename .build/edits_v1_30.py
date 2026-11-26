#!/usr/bin/env python3
"""The edits that turn source/Geometric-Ethics-v1.29.docx into v1.30.

    python .build/edits_v1_30.py source/Geometric-Ethics-v1.29.docx source/Geometric-Ethics-v1.30.docx

v1.30 settles two findings of the cross-volume review and five smaller items (see
CHANGES-v1.30.md). No result is added and none is strengthened. As in edits_v1_29.py, each
edit finds its paragraph, run or table cell by text that must occur exactly once, and the
script stops on the first edit whose target is missing or ambiguous.
"""

from __future__ import annotations

import copy
import sys

import docx

SRC, DST = sys.argv[1], sys.argv[2]
d = docx.Document(SRC)
P = d.paragraphs
TEXT = [p.text for p in P]  # the v1.29 text of each paragraph: every anchor is matched against it
done = []


def one(startswith: str):
    hits = [p for p, t in zip(P, TEXT) if t.startswith(startswith)]
    assert len(hits) == 1, (startswith[:50], len(hits))
    return hits[0]


def only_in(text: str, startswith: str) -> None:
    """Check that, in v1.29, a phrase occurs in one paragraph (the one being edited) and in no table."""
    hits = [t for t in TEXT if text in t]
    assert len(hits) == 1 and hits[0].startswith(startswith), (text, len(hits))
    assert not [c for tb in d.tables for r in tb.rows for c in r.cells if text in c.text], text


def replace_in_run(p, old: str, new: str) -> None:
    """Replace text that lies inside a single run of paragraph p."""
    runs = [r for r in p.runs if old in r.text]
    assert len(runs) == 1 and runs[0].text.count(old) == 1, (old[:50], len(runs))
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


def set_cell(cell, old: str, new: str) -> None:
    """Replace the whole text of a one-paragraph, one-run cell, checking what was there."""
    assert cell.text == old, (old, cell.text)
    assert len(cell.paragraphs) == 1 and len(cell.paragraphs[0].runs) == 1, old
    cell.paragraphs[0].runs[0].text = new
    done.append(f"table: {old[:30]} -> {new[:30]}")


# ============================================================ 1. The tests of the economics volume (E1)
# The risky-choice tests and the learned-basis test were run in the geometric-economics
# repository (experiments/). The published economics volume reports neither.
p = one("This version brings the book up to date with the research since v1.24")
replace_in_run(
    p,
    "the risky-choice tests of the companion economics volume favored prospect theory",
    "the risky-choice tests run in the companion economics volume’s repository, and not yet reported in "
    "that volume, favored prospect theory",
)
p = one("A learned basis. In a sealed test on the Scruples dilemmas (prereg-learned-v1")
replace_in_run(
    p,
    "(the companion economics volume’s chart, with money in place of consequences)",
    "(the nine dimensions of the companion economics volume, with money in place of consequences; the "
    "test was run in that volume’s repository and is reported here, not in that volume)",
)

# ============================================================ 2. Theorem 21.4 (E2)
# The formal statement ("if consent is valid, then ...") and the proof give the necessary
# direction only: valid consent implies invariance under reframing. No converse is argued.
p = one("Theorem 21.4 (Consent as Gauge Invariance).")
replace_in_run(
    p,
    "Valid informed consent is equivalent to a gauge-invariance condition:",
    "Valid informed consent requires a gauge-invariance condition:",
)
replace_in_run(
    p,
    "is invariant under meaning-preserving transformations of the clinical information.",
    "is invariant under meaning-preserving transformations of the clinical information. (v1.30: earlier "
    "versions said “is equivalent to”. The formal statement and the proof below give the necessary "
    "direction only: valid consent implies invariance. That invariance implies valid consent is not "
    "shown.)",
)
only_in("consent is equivalent", "Theorem 21.4 (Consent as Gauge Invariance).")

# ============================================================ 3. Part VI, calibration of the covariance matrix
# Section 8.10a (v1.28): no estimate of the covariance has yet been shown to predict judgements
# better than the boundary penalties alone. The paragraph described the calibration as done.
p = one("Calibration of the Covariance Matrix. Every domain chapter relies on a covariance matrix")
replace_in_run(
    p,
    "First, the dimensional scores are not estimated from raw behavior but from the calibrated probes of "
    "Chapter 17,",
    "First, the dimensional scores are to be estimated not from raw behavior but from the probes of "
    "Chapter 17,",
)
replace_in_run(
    p,
    "The covariance matrix is then estimated from probe-scored data, not from unstructured observables.",
    "The covariance matrix is then to be estimated from probe-scored data, not from unstructured "
    "observables.",
)
replace_in_run(
    p,
    "that provide external validation:",
    "that can provide external validation:",
)
replace_in_run(
    p,
    "The covariance matrix is not assumed; it is empirically estimated, cross-validated, and falsifiably "
    "constrained.",
    "The covariance matrix is not assumed; it is to be estimated from data, cross-validated, and is "
    "falsifiable (no estimate yet predicts judgements better than the boundary penalties alone, Section "
    "8.10a).",
)

# ============================================================ 4. DEME has one expansion
# "Democratically Governed Ethics Module Engine" in Chapter 19 and the bibliography (2026d).
p = one("Computability. Finally: geometric objects can be represented in computers")
replace_in_run(
    p,
    "the Distributed Ethical Monitoring Engine (DEME)",
    "the Democratically Governed Ethics Module Engine (DEME)",
)
only_in("Distributed Ethical Monitoring", "Computability. Finally:")
one("DEME (Democratically Governed Ethics Module Engine)")
one("Bond, A. H. (2026d). “DEME: A Democratically Governed Ethics Module Engine.”")

# ============================================================ 5. Chapter 19: the Tucker figure is Figure 3
assert len([t for t in TEXT if t.startswith("Figure 3 | Tucker Decomposition for Tractability")]) >= 1
p = one("Implementation. Coalition parsing requires a speaker-identification step")
replace_in_run(p, "Tucker decomposition (Section 6.1, Figure 2)", "Tucker decomposition (Section 6.1, Figure 3)")

# ============================================================ 6. Two chapter ranges half-renumbered
# When Chapter 11 was added, later chapters moved up by one. In three ranges only the first
# number was moved. "13–15" was corrected in v1.29; these are the other two.
p = one("BIP does not determine which values win.")
replace_in_run(p, "(Chapters 15–15)", "(Chapters 15–16)")
p = one("7. The framework applies to AI systems")
replace_in_run(p, " (Chapters 18–18).", " (Chapters 18–19).")
for t in TEXT:
    for n in range(4, 31):
        assert f"Chapters {n}–{n})" not in t or t.startswith(("BIP does not determine", "7. The framework applies")), t[:60]

# ============================================================ 7. Section 29.12: the Chapter column
# Every cell began with ", ". What remains is the section of Chapter 29 that treats the problem
# (the priority list under the table cites the same sections) and, in two rows, a chapter.
T = table_with_header("Problem", "Chapter", "Type")
for problem, old, new in (
    ("Direct measurement of curvature", ", 29.2", "§29.2"),
    ("Metric signature", ", 29.3", "§29.3"),
    ("Manifold topology", ", 29.3", "§29.3"),
    ("Moral field equation", ", 29.4", "§29.4"),
    ("Additional symmetries", ", 29.5", "§29.5"),
    ("Anomaly source", ", 17, 29.5", "Ch. 17, §29.5"),
    ("Torsion", ", 29.6", "§29.6"),
    ("Tensorial interpretability", ", 29.7", "§29.7"),
    ("Scalable containment", ", 29.8", "§29.8"),
    ("Moral geometric metaphysics", ", 29.9", "§29.9"),
    ("Intertheoretic comparison", ", 29.10", "§29.10"),
    ("Institutional design", ", 19, 29.11", "Ch. 19, §29.11"),
):
    set_cell(row_of(T, problem).cells[1], old, new)
assert len(T.rows) == 13

# ============================================================ Preface
p = one("This version reconciles the book with itself and with its ledger.")
insert_after(
    p,
    "This version settles seven small items. The risky-choice tests and the learned-basis test are said "
    "to have been run in the companion economics volume’s repository, since that volume does not yet "
    "report them. Theorem 21.4 says that valid consent requires gauge invariance, which is what its "
    "proof shows, and no longer that the two are equivalent. The calibration of the covariance matrix "
    "in Part VI is described as work to be done, with the evidence status of Section 8.10a. DEME has "
    "one expansion. A figure number, two chapter ranges and the chapter column of the table in Section "
    "29.12 are corrected. No result changes.",
)
insert_after(p, "A note on version 1.30", style="Heading 3")

d.save(DST)
print(f"wrote {DST}: {len(done)} edits")
for x in done:
    print("  ", x)

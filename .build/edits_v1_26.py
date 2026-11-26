#!/usr/bin/env python3
"""The edits that turn source/Geometric-Ethics-v1.25.docx into v1.26.

    python .build/edits_v1_26.py source/Geometric-Ethics-v1.25.docx source/Geometric-Ethics-v1.26.docx

v1.26 gives the Bond Index one definition throughout (see CHANGES-v1.26.md). Each edit finds
its paragraph by text that must occur exactly once, so the script fails instead of editing
the wrong place, and it changes text inside one run so the paragraph keeps its formatting.
The record of what was changed is this file.
"""

from __future__ import annotations

import copy
import sys

import docx

SRC, DST = sys.argv[1], sys.argv[2]
d = docx.Document(SRC)
P = d.paragraphs
done = []


def one(startswith: str):
    hits = [p for p in P if p.text.startswith(startswith)]
    assert len(hits) == 1, (startswith[:50], len(hits))
    return hits[0]


def replace_in_run(p, old: str, new: str) -> None:
    """Replace text that lies inside a single run of paragraph p."""
    runs = [r for r in p.runs if old in r.text]
    assert len(runs) == 1 and runs[0].text.count(old) == 1, (old[:50], len(runs))
    runs[0].text = runs[0].text.replace(old, new)
    done.append(old[:60])


def insert_after(p, text: str, style=None):
    """A new paragraph after p, copying p's paragraph properties (or with a named style)."""
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


# ---------------------------------------------------------------- Core Objects table
table = d.tables[0]
rows = [r for r in table.rows if r.cells[0].text.strip() == "Bond Index (Bd)"]
assert len(rows) == 1
cells = rows[0].cells
assert cells[1].text.strip() == "Quantitative alignment score for AI systems", cells[1].text
assert "compliance" in cells[2].text, cells[2].text
for cell, text in (
    (cells[1], "How much an evaluation moves when only the description changes"),
    (
        cells[2],
        "Bd = D_op / τ: the mean change of the evaluation under declared re-descriptions, "
        "in units of a tolerance; 0 is perfect invariance (Ch. 17, 18)",
    ),
):
    para = cell.paragraphs[0]
    for child in list(para._p):
        if not child.tag.endswith("}pPr"):
            para._p.remove(child)
    para.add_run(text)
    for extra in cell.paragraphs[1:]:
        extra._p.getparent().remove(extra._p)
    done.append("table: " + text[:50])

# ---------------------------------------------------------------- Chapter 17, the game's index
p = one("A Bond Index of 0 indicates perfect correlative symmetry")
replace_in_run(
    p,
    " A Bond Index of 0.5 indicates random pairing. A Bond Index above 0.5 indicates ",
    " A Bond Index of 1 means that no pairing was the expected one. Answering at random among the "
    "four positions gives the expected pairing one time in four, so random play scores about 0.75 "
    "(corrected in v1.26: earlier versions gave 0.5 as the value of random pairing and read values "
    "above it as ",
)
replace_in_run(
    p,
    " — systematic inversion of the correlative structure.",
    ", which the scoring does not support).",
)
p = one("The Bond Index is the moral analogue of a gauge-invariance violation measure.")
replace_in_run(
    p,
    "The magnitude of the violation is a quantitative measure of the BIP departure.",
    "The magnitude of the violation is a quantitative measure of the BIP departure. This is the Bond "
    "Index of Chapter 18 with Hohfeldian positions as the output and the correlative swap as the "
    "declared re-description: the deviation is 0 when the pairing is the correlative and 1 when it is "
    "not, so the index is the share of pairings that are not correlatives.",
)

# ---------------------------------------------------------------- Chapter 18, Requirement 3
p = one("Requirement 3: Audit via the Bond Index.")
replace_in_run(
    p,
    "that quantifies how well a system respects its declared equivalences.",
    "that quantifies how well a system respects its declared equivalences. D_op is the mean, over the "
    "inputs tested and the re-descriptions declared, of the distance between the evaluation before "
    "and after the re-description: 0 or 1 for a verdict or a Hohfeldian position, the absolute change "
    "over the scale for a score, and the distance under the moral metric for a vector or a tensor. "
    "It is reported with the worst single case and with the share of tests in which the evaluation "
    "moved at all, because a mean hides both. The game's index of Chapter 17, the verdict and score "
    "forms of Appendix D and the Legal Bond Index of Chapter 22 are this one definition in different "
    "output spaces (stated once here in v1.26).",
)

# ---------------------------------------------------------------- Chapter 19, proof of Prop. 19.4
p = one("Proof. The Bond Index is defined as Bd(x) = max")
replace_in_run(
    p,
    "The Bond Index is defined as Bd(x) = max_{g ∈ G} |Σ(g(x)) − Σ(x)| / τ.",
    "Write Bd_max(x) = max_{g ∈ G} |Σ(g(x)) − Σ(x)| / τ for the worst case over the suite. The Bond "
    "Index Bd(x) of Chapter 18 is the mean of |Σ(g(x)) − Σ(x)| over G, divided by τ, so Bd(x) ≤ "
    "Bd_max(x), and a bound on the worst case is a bound on the index. (Stated this way in v1.26; "
    "earlier versions called the worst case the Bond Index. The inequality proved is unchanged.)",
)
replace_in_run(
    p,
    ", and Bd(x) ≤ 2√((|G| − 1) IV(x,G))/τ.",
    ", and Bd(x) ≤ Bd_max(x) ≤ 2√((|G| − 1) IV(x,G))/τ.",
)

# ---------------------------------------------------------------- Chapter 22, the Legal Bond Index
p = one("where S is a test set of cases and tau ranges over bond-preserving transformations.")
replace_in_run(
    p,
    "provides a quantitative measure of judicial consistency.",
    "provides a quantitative measure of judicial consistency. It is the Bond Index of Chapter 18 "
    "with the legal judgment, a vector, as the output and a tolerance of one.",
)

# ---------------------------------------------------------------- Appendix B.6, the tiers
p = one("The Bond Index Bd quantifies the degree of gauge non-invariance in a moral evaluation system.")
replace_in_run(
    p,
    " Bd < 0.1 indicates cosmetic relabeling artifacts (minor formatting or tokenization differences "
    "that do not affect the moral substance). Bd between 0.1 and 0.5 indicates substantive framing "
    "sensitivity (the system’s verdicts are influenced by how the situation is described, which is a "
    "potential bias). Bd > 0.5 indicates systematic bias (the system’s moral evaluations are dominated "
    "by framing effects rather than moral content).",
    " The tiers are those of Chapter 18. Bd < 0.01 is negligible: deploy. Bd from 0.01 to 0.1 is low: "
    "deploy with monitoring. Bd from 0.1 to 1 is moderate: the verdicts depend on how the situation is "
    "described, and the system is remediated before deployment. Bd from 1 to 10 is high: do not "
    "deploy. Bd above 10 is severe: fundamental redesign. (v1.26: this section previously used a "
    "different scale, with thresholds at 0.1 and 0.5.)",
)

# ---------------------------------------------------------------- Preface
p = one("This version brings the book up to date with the research since v1.24")
body = insert_after(
    p,
    "This version gives the Bond Index one definition. Earlier versions stated it in several ways: as "
    "D_op / τ, as a maximum, as a rate of correlative violations, as a rate of verdict changes, and as a "
    "mean norm. It is the mean change of an evaluation under declared re-descriptions, over a tolerance, "
    "and the earlier statements are that definition in different output spaces (Chapter 18, "
    "Requirement 3). Two statements were wrong and are corrected: the value of random play in the game "
    "of Chapter 17, and the tier thresholds of Appendix B. No result changes.",
)
insert_after(p, "A note on version 1.26", style="Heading 3")

d.save(DST)
print(f"wrote {DST}: {len(done)} edits")
for x in done:
    print("  ", x)

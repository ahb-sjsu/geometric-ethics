#!/usr/bin/env python3
"""The edits that turn source/Geometric-Ethics-v1.26.docx into v1.27.

    python .build/edits_v1_27.py source/Geometric-Ethics-v1.26.docx source/Geometric-Ethics-v1.27.docx

v1.27 settles the three passages v1.26 left open (see CHANGES-v1.27.md). As in
edits_v1_26.py, each edit finds its paragraph by text that must occur exactly once and
changes text inside one run.
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


# ---------------------------------------------------------------- Chapter 20, Prediction 2
p = one("Prediction 2 (Bond Index Correlates)")
replace_in_run(
    p,
    ": Agents with higher Bond Index scores should (a)",
    ": Agents whose moral evaluations are more invariant under re-description, that is, agents with a "
    "lower Bond Index, should (a)",
)
replace_in_run(
    p,
    "What would falsify: if Bond Index is uncorrelated with these measures.",
    "What would falsify: if the Bond Index is uncorrelated with these measures. (v1.27: earlier "
    "versions wrote “higher Bond Index scores”, as if a larger index were better. A Bond Index of 0 is "
    "perfect invariance, so the agents meant are those with a lower index. The prediction is otherwise "
    "unchanged, and it is untested.)",
)

# ---------------------------------------------------------------- Chapter 21, the clinical Bond Index
p = one("where gamma_P*(s) is the path mandated by policy P for patient s")
insert_after(
    p,
    "The clinical Bond Index shares a name with the Bond Index of Chapter 18 and is a different "
    "quantity. The Bond Index measures how much an evaluation changes under re-descriptions that should "
    "not change it, and 0 is perfect invariance. BI(P, S) measures how much more the path a policy "
    "mandates costs a population than the manifold-optimal path, and 0 means the policy costs that "
    "population nothing beyond the optimum. The two are not interchangeable, and a value of one says "
    "nothing about the other. Geometric Medicine (Book 8, Chapter 12) develops the clinical Bond Index "
    "under this name. (Note added in v1.27.)",
)
p = one("Proposition 21.3 (Bond Index Detects Structural Injustice)")
replace_in_run(
    p,
    "Proposition 21.3 (Bond Index Detects Structural Injustice)",
    "Proposition 21.3 (The Clinical Bond Index Detects Structural Injustice)",
)
p = one("Age discrimination: If triage protocols underweight equal moral worth")
replace_in_run(
    p,
    "with the Bond Index quantifying the magnitude.",
    "with the clinical Bond Index quantifying the magnitude.",
)
p = one("Prediction 4 (Bond Index Predicts Disparities)")
replace_in_run(
    p,
    "Prediction 4 (Bond Index Predicts Disparities)",
    "Prediction 4 (The Clinical Bond Index Predicts Disparities)",
)
replace_in_run(
    p,
    "Falsified if: BI is uncorrelated with experience disparities.",
    "Falsified if: BI(P, S) is uncorrelated with experience disparities.",
)

# ---------------------------------------------------------------- Appendix A
p = one("Runtime verification for normative systems (Alechina et al. 2012; Dennis et al. 2016)")
replace_in_run(
    p,
    "A Bd = 0 certificate is stronger than rule-by-rule compliance because it guarantees that no "
    "redescription of the input can change the evaluation — including redescriptions the verifier has "
    "not anticipated.",
    "A Bd = 0 result is a different kind of evidence from rule-by-rule compliance: it shows that none "
    "of the re-descriptions in the declared suite changes the evaluation, whatever rules the system "
    "follows. It covers the suite that was tested and nothing outside it, so the suite is part of the "
    "result and has to be reported with it. (Corrected in v1.27: earlier versions said a Bd = 0 "
    "certificate guarantees invariance under redescriptions the verifier has not anticipated. No test "
    "over a finite suite can show that.)",
)

# ---------------------------------------------------------------- Preface
p = one("This version gives the Bond Index one definition.")
body = insert_after(
    p,
    "This version settles three passages that version 1.26 left open. Prediction 2 of Chapter 20 said "
    "that agents with a higher Bond Index are fairer; it means agents with a lower one. The clinical "
    "Bond Index of Chapter 21 is marked as a different quantity from the Bond Index of Chapter 18. "
    "Appendix A no longer says that a Bond Index of zero guarantees invariance under re-descriptions "
    "nobody tested. No result changes.",
)
insert_after(p, "A note on version 1.27", style="Heading 3")

d.save(DST)
print(f"wrote {DST}: {len(done)} edits")
for x in done:
    print("  ", x)

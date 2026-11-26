#!/usr/bin/env python3
"""The edits that turn source/Geometric-Ethics-v1.27.docx into v1.28.

    python .build/edits_v1_28.py source/Geometric-Ethics-v1.27.docx source/Geometric-Ethics-v1.28.docx

v1.28 states the evidence status of the metric (see CHANGES-v1.28.md). Three paragraphs
are added and no existing sentence is changed. As in edits_v1_27.py, each edit finds its
anchor paragraph by text that must occur exactly once.
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


# ---------------------------------------------------------------- Chapter 8, Section 8.10a
p = one("The covariance matrix Σ is the discrete computational counterpart of the metric tensor")
insert_after(
    p,
    "Evidence status of the metric (added in v1.28). The covariance Σ, and with it the metric of the "
    "decision complex, is a modeling choice. No measurement reported in this book shows that a metric, "
    "whether set by hand or learned from data, predicts moral judgements better than the boundary "
    "penalties alone. One registered test has been run. In November 2026 the registration "
    "prereg-precedent-v1 (repository erisml-compiler, experiments/precedent) asked whether a metric "
    "learned on sentence embeddings improves the prediction of community verdicts on 1,165 held-out "
    "forum posts, beyond two gates read from the text and the nearest earlier cases. No predictor in "
    "that run did better than the average verdict, which the registration had fixed in advance as the "
    "sign of an instrument that reads no signal. The run is therefore void. It does not support the "
    "metric and it does not refute it. A later check on the training posts, which was not registered, "
    "found that the sentence embeddings explain between 2.5% and 4% of the variance of the verdicts, "
    "while about 86% of that variance is not vote noise. A test built on those embeddings could not "
    "have detected a metric effect of ordinary size. Until a test is run with an instrument that reads "
    "the judgement, every statement in this book that uses Σ is a statement about a model whose metric "
    "has not been tested.",
)

# ---------------------------------------------------------------- Chapter 17, Section 17.7
p = one("7. Reproducibility constraints.")
insert_after(
    p,
    "8. The metric is untested. None of the evidence in this chapter tests whether the metric of "
    "Chapter 8, the covariance Σ of Definition 8.13, predicts moral judgements better than the "
    "boundaries alone. The one registered test of that question, run in November 2026, was void by its "
    "own instrument check and decides nothing (Section 8.10a). (Added in v1.28.)",
)

# ---------------------------------------------------------------- Preface
p = one("This version settles three passages that version 1.26 left open.")
body = insert_after(
    p,
    "This version states the evidence status of the metric. Section 8.10a and Section 17.7 now say that "
    "no measurement shows a metric predicting moral judgements better than the boundaries alone, and "
    "that the one registered test of the question, run in November 2026, was void and decides nothing. "
    "No existing statement changes.",
)
insert_after(p, "A note on version 1.28", style="Heading 3")

d.save(DST)
print(f"wrote {DST}: {len(done)} edits")
for x in done:
    print("  ", x)

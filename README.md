# Geometric Ethics (Book 2)

The Mathematical Structure of Moral Reasoning. Volume 2 of the Geometric Series.
Served at https://erisml.org/book/ via the erisml-lib `site` submodule.

> **Epistemic status (v1.25, 2026-11-08): posited framework, partially instrumented.**
> This is the series' most-instrumented domain, and the instruments have pushed back.
> MoBSE's moral-dimension encoders clear a pre-registered frozen-null gate on **8 of 9
> dimensions**; `rights_respect` fails, twice, and rights are now a specified constraint rather
> than a measured coordinate. The Moral Spectrum Analyzer validated a tenth axis
> (`identity_attack`), and purity and loyalty also pass, so the nine dimensions are a chart, not a
> complete basis. Four of the learned axes collapse onto one general-valence channel, and the
> validated axes have effective rank 5.19 of 8. The Hohfeldian group is the Klein four-group V4,
> machine-checked; the dihedral D4 of earlier versions is withdrawn, because its quarter-turn was
> never demonstrated and a direct search did not find it. The order effects of Chapter 17 come
> from one language model, not from people. Everything beyond the gated measurements and the
> machine-checked results, including the book's broader geometric thesis, is *posited* theory at
> licensed strength. See [xbse](https://github.com/ahb-sjsu/xbse) (admission filter + gate) and
> [moral-spectrum-analyzer](https://github.com/ahb-sjsu/moral-spectrum-analyzer). Formal-claim
> status is tracked per claim in Appendix F and in `ledger/`.
>
> **What changed in v1.25** is summarized in the Preface ("A note on version 1.25") and listed in
> [CHANGES-v1.25.md](CHANGES-v1.25.md).

## Structure

- `source/*.docx` — the manuscript (source of truth; currently v1.25).
- `*.html`, `images/` — the published per-section HTML + figures, **generated**
  from the docx and served. `book.css` is a static shared asset.
- `.build/` — the build kit (`build_ethics.py` + `template.html`).
- `ledger/` — the claim ledger: one JSON file per formal or empirical claim, with its class,
  status, evidence and history.
- `formal/` — machine checks of the book's mathematics: `formal/lean/` (Lean 4 + Mathlib; the
  claims marked Proved, 0 `sorry`) and `formal/matlab/` (MATLAB Symbolic Math Toolbox checks of
  the derivations and worked examples). `formal/README.md` lists every claim, its check, its
  result, and how to rerun the checks on Atlas.

## Build (docx → HTML)

Requires [pandoc](https://pandoc.org). After updating the docx in `source/`
(keep exactly one), run:

```bash
python .build/build_ethics.py
```

Pipeline: `pandoc -t html5 --katex` (extracting figures) → split on `<h1>` →
wrap each section in `.build/template.html` (unified Geometric Series look) →
write `<section>.html` + `index.html` + `images/` at the repo root. Existing
filenames are reused so URLs stay stable; empty `<h1>` dividers are skipped.
`python .build/build_ethics.py --check` exits non-zero if the served HTML is
out of sync with the docx — suitable for CI. Bump the version stamp via
`VERSION` in the script when the docx version changes.

## License

Two licenses, split by what the file is.

| What | License | File |
|---|---|---|
| Prose and figures: chapters, appendices, front and back matter, figures, ledgers, protocol and standards documents, README | [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) | `LICENSE-TEXT` |
| Source code: build scripts, tools, experiment harnesses, site generators | [MIT](https://opensource.org/licenses/MIT) | `LICENSE` |

Manuscripts under `paper/` or `papers/` that are submitted, accepted or
published elsewhere are outside both files. They carry the rights their
publisher agreement assigns.

CC BY asks you to attribute and to indicate whether you changed anything. Both
halves of that matter here. Every claim in this series carries a status label,
such as `[proved]`, `[posited]` or `[open]`, graded against a claim ledger, and
an adapted version presented as the original misstates the evidence behind it.
Attribution that names the author, the volume and this repository, and that
says whether the text was changed, is enough.

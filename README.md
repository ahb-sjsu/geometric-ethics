# Geometric Ethics (Book 2)

The Mathematical Structure of Moral Reasoning. Volume 2 of the Geometric Series.
Served at https://erisml.org/book/ via the erisml-lib `site` submodule.

## Structure

- `source/*.docx` — the manuscript (source of truth; currently v1.23).
- `*.html`, `images/` — the published per-section HTML + figures, **generated**
  from the docx and served. `book.css` is a static shared asset.
- `.build/` — the build kit (`build_ethics.py` + `template.html`).

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

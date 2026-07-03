# -*- coding: utf-8 -*-
"""
Build Geometric Ethics (Book 3 of the Geometric Series) from the source docx.

The docx in source/ is the source of truth. This script regenerates the served
HTML (per-section files + index.html + images/) at the repo root, in the
unified Geometric Series look.

Pipeline:
    source/*.docx
      -> pandoc -t html5 --katex (images extracted)   [one whole-book doc]
      -> split on <h1> into sections
      -> wrap each section in .build/template.html
      -> write <section>.html + index.html + images/ at the repo root

Building from html5 (not gfm) preserves the figures/illustrations that a
Markdown round-trip drops. Existing root *.html filenames are reused so URLs
stay stable across rebuilds; book.css (a static shared asset), source/,
.build/, and README.md are left untouched.

Usage:
    python .build/build_ethics.py            # rebuild served HTML at repo root
    python .build/build_ethics.py --check    # exit 1 if the build differs (CI)
"""

import argparse
import filecmp
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
SOURCE_DIR = REPO / "source"
TEMPLATE = (REPO / ".build" / "template.html").read_text(encoding="utf-8")
VERSION = "1.24"
TAGLINE = "The geometry was always real. The scalars were always insufficient."
# Cover photo extracted from the docx (unreferenced in body); shown on the landing hero.
COVER_IMAGE = "image1.png"


def find_docx() -> Path:
    docs = sorted(SOURCE_DIR.glob("*.docx"))
    docs = [d for d in docs if not d.name.startswith("~$")]
    if not docs:
        print(f"ERROR: no .docx in {SOURCE_DIR}")
        sys.exit(1)
    if len(docs) > 1:
        print(f"ERROR: multiple .docx in {SOURCE_DIR}: {[d.name for d in docs]} — keep one.")
        sys.exit(1)
    return docs[0]


def slugify(t: str) -> str:
    t = t.lower().replace("’", "").replace("'", "")
    return re.sub(r"[^a-z0-9]+", "-", t).strip("-")


def strip_tags(s: str) -> str:
    return re.sub(r"<[^>]+>", "", s).strip()


def make_out_filename(existing):
    """Return a fn(title)->filename that reuses existing root filenames for
    stable URLs, falling back to a slug for new sections."""
    def existing_prefix(pfx):
        return next((fn for fn in existing if fn.startswith(pfx)), None)

    def out_filename(title):
        if not title.strip():
            return None  # skip empty/blank <h1> dividers (no title, no content)
        m = re.match(r"Chapter\s+(\d+)\s*[:—-]", title)
        if m:
            return existing_prefix(f"chapter-{m.group(1)}-") or \
                f"chapter-{m.group(1)}-{slugify(title.split(':', 1)[-1])}.html"
        m = re.match(r"Part\s+([IVXLC]+)\b", title, re.I)
        if m:
            sl = slugify(title) + ".html"
            return sl if sl in existing else (existing_prefix(f"part-{m.group(1).lower()}-") or sl)
        m = re.match(r"Appendix\s+([A-Z])\b", title, re.I)
        if m:
            return existing_prefix(f"appendix-{m.group(1).lower()}-") or \
                f"appendix-{m.group(1).lower()}-{slugify(title)}.html"
        low = title.strip().lower()
        if low == "preface":
            return "preface.html"
        if low.startswith("core objects"):
            return "core-objects-at-a-glance.html"
        if low == "bibliography":
            return "bibliography.html"
        if low == "table of contents":
            return None
        if low == "table of figures":
            return "table-of-figures.html"
        return slugify(title) + ".html"
    return out_filename


def is_part(t: str) -> bool:
    return bool(re.match(r"Part\s+[IVXLC]+", t, re.I))


def build(out: Path):
    """Build the full served tree (html + index.html + images/) into `out`."""
    (out / "images").mkdir(parents=True, exist_ok=True)
    docx = find_docx()

    with tempfile.TemporaryDirectory() as media_tmp:
        whole = subprocess.run(
            ["pandoc", str(docx), "-t", "html5", "--katex",
             f"--extract-media={media_tmp}"],
            capture_output=True, text=True, encoding="utf-8", check=True,
        ).stdout
        media = Path(media_tmp) / "media"
        if media.exists():
            for f in media.glob("*"):
                shutil.copy(f, out / "images" / f.name)
    whole = re.sub(r'(src|data)="[^"]*?/media/([^"]+)"', r'\1="images/\2"', whole)

    existing = [p.name for p in REPO.glob("*.html")]
    out_filename = make_out_filename(existing)

    body = re.search(r"<body[^>]*>(.*)</body>", whole, re.S)
    body = body.group(1) if body else whole
    h1s = list(re.finditer(r"<h1\b", body))

    toc, seen = [], {}
    for i, m in enumerate(h1s):
        start = m.start()
        end = h1s[i + 1].start() if i + 1 < len(h1s) else len(body)
        section = body[start:end]
        tm = re.search(r"<h1\b[^>]*>(.*?)</h1>", section, re.S)
        title = strip_tags(tm.group(1)) if tm else "Untitled"
        fn = out_filename(title)
        if fn is None:
            continue
        if fn in seen:  # duplicate heading (e.g. repeated Part) -> append
            prev = (out / fn).read_text(encoding="utf-8")
            merged = prev.replace(
                '</div>\n      <div class="chapter-nav-bottom">',
                section + '\n</div>\n      <div class="chapter-nav-bottom">', 1)
            (out / fn).write_text(merged, encoding="utf-8")
            continue
        seen[fn] = title
        html = (TEMPLATE.replace("{{title}}", title).replace("{{content}}", section)
                .replace("{{version}}", VERSION).replace("{{tagline}}", TAGLINE))
        (out / fn).write_text(html, encoding="utf-8")
        toc.append((title, fn))

    items = []
    for title, fn in toc:
        cls = "toc-part" if is_part(title) else (
            "toc-front" if title.lower() in
            ("preface", "core objects at a glance", "bibliography", "table of figures") else "")
        inner = f"<strong>{title}</strong>" if is_part(title) else title
        cls_attr = f' class="{cls}"' if cls else ''
        items.append(f'  <li{cls_attr}><a href="{fn}">{inner}</a></li>')
    cover = (COVER_IMAGE if (out / "images" / COVER_IMAGE).exists() else None)
    cover_html = (f'  <img class="book-cover" src="images/{cover}" '
                  f'alt="Geometric Ethics — book cover" />\n') if cover else ''
    hero = (f'<header class="book-hero">\n  <p class="book-number">Book 3 of the Geometric Series &middot; v{VERSION}</p>\n'
            f'  <h1>Geometric Ethics</h1>\n  <p class="book-subtitle">The Mathematical Structure of Moral Reasoning</p>\n'
            f'  <p class="book-byline">A volume in the <em>Geometric Series</em> by Andrew H. Bond.</p>\n'
            f'{cover_html}</header>\n'
            f'<h2>Contents</h2>\n<ol class="toc-chapters">\n' + "\n".join(items) + "\n</ol>")
    (out / "index.html").write_text(
        TEMPLATE.replace("{{title}}", "Contents").replace("{{content}}", hero)
                .replace("{{version}}", VERSION).replace("{{tagline}}", TAGLINE),
        encoding="utf-8")

    return len(toc), len(list((out / "images").glob("*")))


def sync(out: Path):
    """Replace the repo's served HTML + images/ with the freshly built tree.
    book.css, source/, .build/, README.md, .git are left untouched."""
    for p in REPO.glob("*.html"):
        p.unlink()
    img_dir = REPO / "images"
    if img_dir.exists():
        shutil.rmtree(img_dir)
    (REPO / "images").mkdir()
    for p in out.glob("*.html"):
        shutil.copy(p, REPO / p.name)
    for p in (out / "images").glob("*"):
        shutil.copy(p, REPO / "images" / p.name)


def trees_differ(out: Path) -> bool:
    a = {p.name: p for p in REPO.glob("*.html")}
    b = {p.name: p for p in out.glob("*.html")}
    if set(a) != set(b):
        return True
    for name in a:
        if a[name].read_text(encoding="utf-8") != b[name].read_text(encoding="utf-8"):
            return True
    ai = {p.name for p in (REPO / "images").glob("*")} if (REPO / "images").exists() else set()
    bi = {p.name for p in (out / "images").glob("*")}
    return ai != bi


def main():
    ap = argparse.ArgumentParser(description="Build Geometric Ethics from source docx")
    ap.add_argument("--check", action="store_true", help="exit 1 if served HTML is stale")
    args = ap.parse_args()

    with tempfile.TemporaryDirectory() as td:
        out = Path(td) / "build"
        n_sec, n_img = build(out)
        if args.check:
            stale = trees_differ(out)
            print(f"{'STALE' if stale else 'up to date'}: {n_sec} sections, {n_img} images "
                  f"(v{VERSION}).")
            sys.exit(1 if stale else 0)
        sync(out)
        print(f"Built {n_sec} sections + index.html, {n_img} images (v{VERSION}) -> repo root.")


if __name__ == "__main__":
    main()

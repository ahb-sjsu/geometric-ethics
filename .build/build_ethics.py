# -*- coding: utf-8 -*-
"""
Build Geometric Ethics (Book 2 of the Geometric Series) from the source docx.

The docx in source/ is the source of truth. This script regenerates the served
HTML (per-section files + index.html + images/) at the repo root, in the
unified Geometric Series look.

Pipeline:
    source/*.docx
      -> temporary copy with text boxes moved out of their paragraphs
      -> pandoc -t html5 --katex (images extracted)   [one whole-book doc]
      -> figure captions numbered again from word/document.xml
      -> split on <h1> into sections
      -> wrap each section in .build/template.html
      -> write <section>.html + index.html + images/ at the repo root
      -> table of figures and figure references linked to page#fig-N
      -> coverage check: warn about docx paragraphs missing from the pages

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
import io
import re
import shutil
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET
import zipfile
from html import unescape
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
SOURCE_DIR = REPO / "source"
TEMPLATE = (REPO / ".build" / "template.html").read_text(encoding="utf-8")
VERSION = "1.29"
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
        if low == "index":  # the book's index; index.html is the Contents page
            return "book-index.html"
        if low == "table of contents":
            return None
        if low == "table of figures":
            return "table-of-figures.html"
        return slugify(title) + ".html"
    return out_filename


def is_part(t: str) -> bool:
    return bool(re.match(r"Part\s+[IVXLC]+", t, re.I))


# --- Figures -----------------------------------------------------------------
# Word numbers the figures with SEQ fields; the table of figures links to _Toc
# bookmarks on the captions and in-text references link to fig: bookmarks.
# pandoc drops the "Figure N" label from the captions ("| Title" is left) and
# keeps the bookmark links, whose anchors exist on no page. The captions,
# their order and their bookmarks are read back from word/document.xml.
W = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}"
MC_FALLBACK = "{http://schemas.openxmlformats.org/markup-compatibility/2006}Fallback"
PICTURE = "{http://schemas.openxmlformats.org/drawingml/2006/picture}pic"
# Drawings made of several Word shapes (a group or a canvas); pandoc renders
# neither the drawing nor its text.
SHAPE_GROUPS = ("{http://schemas.microsoft.com/office/word/2010/wordprocessingGroup}wgp",
                "{http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas}wpc",
                "{urn:schemas-microsoft-com:vml}group")
# A caption as pandoc leaves it: "<p>| Title", or "<p>Figure | Title" when the
# paragraph is not in the Caption style (pandoc then keeps its _Toc anchor).
CAPTION_RE = re.compile(r'<p>((?:<span id="[^"]*" class="anchor"></span>)*)(?:Figure )?\|\s+')
# Said under the caption of a figure drawn with Word shapes (see SHAPE_GROUPS).
SHAPE_NOTE = ("<br />\n<em>This figure is a drawing in the "
              f'<a href="https://github.com/ahb-sjsu/geometric-ethics/raw/main/source/Geometric-Ethics-v{VERSION}.docx">'
              "Word edition</a> of the book; the web edition cannot show it.</em>")


def _walk(el, skip=(MC_FALLBACK,)):
    """Descendants in document order, without the subtrees in `skip`
    (mc:Fallback is a copy of mc:Choice that Word does not render or count)."""
    for ch in el:
        if ch.tag not in skip:
            yield ch
            yield from _walk(ch, skip)


def _plain(s: str) -> str:
    """Caption text for comparing the docx with pandoc's HTML (pandoc adds a
    text-style variation selector, U+FE0E, after arrows such as ↔)."""
    return " ".join(unescape(strip_tags(s)).replace("\ufe0e", "").split())


def unbox_text_boxes(src: Path, dst: Path) -> Path:
    """Write a copy of the docx in which each single text box (a figure caption,
    in this book) leaves the paragraph that anchors it and follows that
    paragraph as ordinary paragraphs. pandoc renders a paragraph that anchors a
    text box as the text box alone, so the paragraph's own text and images were
    lost. An image anchored in a heading gets a paragraph of its own after the
    heading. Shape groups (SHAPE_GROUPS) are left as they are."""
    with zipfile.ZipFile(src) as z:
        xml = z.read("word/document.xml")
    for _, (prefix, uri) in ET.iterparse(io.BytesIO(xml), events=("start-ns",)):
        ET.register_namespace(prefix, uri)  # keep Word's prefixes when writing back
    root = ET.fromstring(xml)
    parent = {ch: el for el in root.iter() for ch in el}
    for host in list(root.iter(W + "p")):
        runs = [e for e in _walk(host, (MC_FALLBACK, W + "p")) if e.tag == W + "r"]
        blocks = []
        for run in runs:
            for obj in list(run):
                boxes = [e for e in _walk(obj) if e.tag == W + "txbxContent"]
                if len(boxes) == 1 and not any(e.tag in SHAPE_GROUPS for e in obj.iter()):
                    run.remove(obj)
                    blocks += list(boxes[0])
        if not blocks:
            continue
        for run in runs:  # a page break beside a text box would show as a stray <br />
            for br in run.findall(W + "br"):
                if br.get(W + "type") == "page":
                    run.remove(br)
        style = host.find(f"{W}pPr/{W}pStyle")
        if style is not None and style.get(W + "val", "").startswith("Heading"):
            pictures = [r for r in runs if r.find(".//" + PICTURE) is not None]
            if pictures:
                image_par = ET.Element(W + "p")
                for r in pictures:
                    parent[r].remove(r)
                    image_par.append(r)
                blocks.insert(0, image_par)
        siblings = parent[host]
        i = list(siblings).index(host) + 1
        siblings[i:i] = blocks
    with zipfile.ZipFile(src) as zin, zipfile.ZipFile(dst, "w") as zout:
        for item in zin.infolist():
            data = zin.read(item.filename)
            if item.filename == "word/document.xml":
                data = ET.tostring(root, encoding="UTF-8", xml_declaration=True)
            zout.writestr(item, data)
    return dst


def docx_figures(docx: Path):
    """The docx's figure captions (paragraphs with a SEQ Figure field) in
    document order, which is how Word numbers them. Each caption carries the
    _Toc bookmarks on it and the fig: bookmarks at or before it (a fig:
    bookmark belongs to the first caption after it), and whether the figure is
    a shape group (one after the previous caption, with no picture after it)."""
    with zipfile.ZipFile(docx) as z:
        root = ET.fromstring(z.read("word/document.xml"))
    figs, pending, placed, drawn = [], [], set(), False
    for el in _walk(root):
        name = el.get(W + "name", "")
        if el.tag == W + "bookmarkStart" and name.startswith("fig:") and name not in placed:
            pending.append(name)
        if el.tag in SHAPE_GROUPS or el.tag == PICTURE:
            drawn = el.tag in SHAPE_GROUPS
        if el.tag != W + "p":
            continue
        own = list(_walk(el, (MC_FALLBACK, W + "p")))  # not a text box's paragraphs
        if not any("SEQ Figure" in (e.get(W + "instr") or e.text or "")
                   for e in own if e.tag in (W + "fldSimple", W + "instrText")):
            continue
        text = "".join(e.text or "" for e in own if e.tag == W + "t")
        names = [e.get(W + "name") for e in own if e.tag == W + "bookmarkStart"]
        labels = pending + [b for b in names if b.startswith("fig:")]
        placed.update(labels)
        figs.append({"n": len(figs) + 1,
                     "title": re.sub(r"^\s*Figure\s*\d*\s*\|?\s*", "", text).strip(),
                     "toc": [b for b in names if b.startswith("_Toc")],
                     "labels": labels, "drawn": drawn})
        pending, drawn = [], False
    return figs


def number_captions(body: str, figs):
    """Give each caption its label back ("Figure N | Title") and the id fig-N;
    a figure drawn with Word shapes also gets SHAPE_NOTE. Returns the new body
    and each caption's title HTML (for the table of figures)."""
    out, pos, titles = [], 0, {}
    for f in figs:
        for m in CAPTION_RE.finditer(body, pos):
            end = body.index("</p>", m.end())
            if _plain(body[m.end():end]) == _plain(f["title"]):
                break
        else:
            print(f"ERROR: caption of Figure {f['n']} ({f['title'][:50]}) not found in pandoc output.")
            sys.exit(1)
        out += [body[pos:m.start()], f'<p id="fig-{f["n"]}">{m.group(1)}Figure {f["n"]} | ',
                body[m.end():end], SHAPE_NOTE if f["drawn"] else ""]
        titles[f["n"]] = body[m.end():end]
        pos = end
    return "".join(out) + body[pos:], titles


def link_figures(out: Path, figs, titles, fig_page):
    """Point the table of figures (#_Toc...) and the in-text references
    (#fig:...) at page#fig-N, with the number and title of the caption."""
    by_toc = {b: f["n"] for f in figs for b in f["toc"]}
    by_label = {b: f["n"] for f in figs for b in f["labels"]}
    for page in out.glob("*.html"):
        src = page.read_text(encoding="utf-8")

        def href(n):
            return f"#fig-{n}" if fig_page[n] == page.name else f"{fig_page[n]}#fig-{n}"

        def toc_entry(m):
            n = by_toc.get(m.group(2))
            if n is None:
                return m.group(0)
            old = re.match(r"Figure\s*(\d+)", strip_tags(m.group(3)))
            if old and int(old.group(1)) != n:
                print(f"WARNING: the table of figures calls Figure {n} 'Figure {old.group(1)}' "
                      f"(stale field); numbered {n} by document order.")
            return f'{m.group(1)}href="{href(n)}">Figure {n} | {titles[n]}</a>'

        def reference(m):
            n = by_label.get(m.group(2))
            return m.group(0) if n is None else f'{m.group(1)}href="{href(n)}">{n}</a>'

        # pandoc may wrap a line between "<a" and "href"; group 1 keeps that whitespace.
        new = re.sub(r'(<a\s+)href="#(_Toc\d+)">(.*?)</a>', toc_entry, src, flags=re.S)
        new = re.sub(r'(<a\s+)href="#(fig:[^"]+)">[^<]*</a>', reference, new)
        if new != src:
            page.write_text(new, encoding="utf-8")


def check_coverage(docx: Path, out: Path):
    """Warn about body paragraphs of the docx whose text is not in the built
    pages. Not checked: text boxes and shape drawings (a figure's text), the
    table of contents and table of figures (fields the build replaces);
    headers and footers live in other parts of the docx. A paragraph is cut
    where the HTML differs by design (math, note references, SEQ numbers,
    links to fig: bookmarks), and each piece must appear in the pages' text,
    compared with all whitespace removed."""
    m = "{http://schemas.openxmlformats.org/officeDocument/2006/math}"

    def squash(s):
        return re.sub(r"[\s\u00ad\ufe0e\ufe0f]+", "", s)

    def tokens(el):  # the paragraph's text, None where a piece ends
        for ch in el:
            if ch.tag in (MC_FALLBACK, W + "txbxContent", W + "p", W + "instrText"):
                continue
            if (ch.tag in (m + "oMath", m + "oMathPara", W + "footnoteReference", W + "endnoteReference")
                    or (ch.tag == W + "fldSimple" and "SEQ" in ch.get(W + "instr", ""))
                    or ch.get(W + "anchor", "").startswith("fig:")):
                yield None
                continue
            if ch.tag == W + "t":
                yield ch.text or ""
            yield from tokens(ch)

    text = squash(" ".join(unescape(strip_tags(p.read_text(encoding="utf-8"))) for p in out.glob("*.html")))
    with zipfile.ZipFile(docx) as z:
        body = ET.fromstring(z.read("word/document.xml")).find(W + "body")
    missing, total = [], 0
    for p in _walk(body, (MC_FALLBACK, W + "txbxContent")):
        style = p.find(f"{W}pPr/{W}pStyle")
        if p.tag != W + "p" or (style is not None and re.match(
                r"(?i)toc\d|tableoffigures$", style.get(W + "val", ""))):
            continue
        pieces = "".join(t if t is not None else "\0" for t in tokens(p)).split("\0")
        pieces = [squash(s) for s in pieces if squash(s)]
        total += bool(pieces)
        if any(s not in text for s in pieces):
            missing.append(" ".join("".join(t or " " for t in tokens(p)).split()))
    if not missing:
        print(f"Coverage: all {total} docx paragraphs are in the pages.")
        return
    print(f"WARNING: {len(missing)} of {total} docx paragraphs are not (wholly) in the pages:")
    for s in missing:
        print(f"  - {s[:110]}")


def build(out: Path):
    """Build the full served tree (html + index.html + images/) into `out`."""
    (out / "images").mkdir(parents=True, exist_ok=True)
    docx = find_docx()

    with tempfile.TemporaryDirectory() as media_tmp:
        unboxed = unbox_text_boxes(docx, Path(media_tmp) / "unboxed.docx")
        whole = subprocess.run(
            ["pandoc", str(unboxed), "-t", "html5", "--katex",
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
    figs = docx_figures(docx)
    body, fig_titles = number_captions(body, figs)
    h1s = list(re.finditer(r"<h1\b", body))

    toc, seen, fig_page = [], {}, {}
    for i, m in enumerate(h1s):
        start = m.start()
        end = h1s[i + 1].start() if i + 1 < len(h1s) else len(body)
        section = body[start:end]
        tm = re.search(r"<h1\b[^>]*>(.*?)</h1>", section, re.S)
        title = strip_tags(tm.group(1)) if tm else "Untitled"
        fn = out_filename(title)
        if fn is None:
            continue
        for n in re.findall(r'<p id="fig-(\d+)">', section):
            fig_page[int(n)] = fn
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
    link_figures(out, figs, fig_titles, fig_page)

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
    hero = (f'<header class="book-hero">\n  <p class="book-number">Book 2 of the Geometric Series &middot; v{VERSION}</p>\n'
            f'  <h1>Geometric Ethics</h1>\n  <p class="book-subtitle">The Mathematical Structure of Moral Reasoning</p>\n'
            f'  <p class="book-byline">A volume in the <em>Geometric Series</em> by Andrew H. Bond.</p>\n'
            f'{cover_html}</header>\n'
            f'<h2>Contents</h2>\n<ol class="toc-chapters">\n' + "\n".join(items) + "\n</ol>")
    (out / "index.html").write_text(
        TEMPLATE.replace("{{title}}", "Contents").replace("{{content}}", hero)
                .replace("{{version}}", VERSION).replace("{{tagline}}", TAGLINE),
        encoding="utf-8")
    check_coverage(docx, out)

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

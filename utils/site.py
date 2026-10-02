#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["pymupdf==1.28.2"]
# ///
"""Assemble the GitHub Pages site"""

from __future__ import annotations

import argparse
import re
import shutil
import sys
from pathlib import Path

import pymupdf

REPO = Path(__file__).resolve().parent.parent
NAME = "thesis_AndrejOrsula"
EDITIONS = {"DIGITAL": f"{NAME}.pdf", "PRINT": f"{NAME}_print.pdf"}


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("build", type=Path, help="directory with the downsampled editions")
    parser.add_argument("site", type=Path, help="directory to write the site to (replaced)")
    parser.add_argument("--revision", required=True, help="commit the site is built from")
    args = parser.parse_args(argv)

    site, build = args.site.resolve(), args.build.resolve()
    # The site directory is deleted and recreated, so it must hold nothing else.
    if site in (build, REPO, *build.parents, *REPO.parents):
        print(
            f"error: refusing to replace {site}, which holds the build or the repository",
            file=sys.stderr,
        )
        return 1
    missing = [name for name in EDITIONS.values() if not (build / name).is_file()]
    if missing:
        print(
            f"error: {build} lacks {', '.join(missing)}; build with --optimize first",
            file=sys.stderr,
        )
        return 1

    if site.exists():
        shutil.rmtree(site)
    site.mkdir(parents=True)

    values = {"REVISION": args.revision, "REVISION_SHORT": args.revision[:7]}
    for key, published in EDITIONS.items():
        target = site / published
        shutil.copyfile(build / published, target)
        with pymupdf.open(target) as document:
            values[f"{key}_PAGES"] = str(document.page_count)
        values[f"{key}_SIZE"] = f"{target.stat().st_size / 1e6:.1f} MB"

    page = (REPO / "index.html").read_text()
    page = re.sub(r"\{\{(\w+)\}\}", lambda match: values.get(match[1], match[0]), page)
    left = sorted(set(re.findall(r"\{\{\w+\}\}", page)))
    if left:
        print(f"error: index.html has unfilled placeholders: {', '.join(left)}", file=sys.stderr)
        return 1
    for name in sorted(set(re.findall(r'href="([^":#/]+\.pdf)"', page))):
        if not (site / name).is_file():
            print(f"error: index.html links to {name}, which is not in the site", file=sys.stderr)
            return 1
    (site / "index.html").write_text(page)

    for path in sorted(site.iterdir()):
        print(f"{path.name}: {path.stat().st_size / 1e6:.1f} MB")
    return 0


if __name__ == "__main__":
    sys.exit(main())

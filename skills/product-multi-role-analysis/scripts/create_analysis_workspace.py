#!/usr/bin/env python3
"""Create a product analysis workspace with seven role templates."""

from __future__ import annotations

import argparse
import re
from datetime import date
from pathlib import Path


ROLES = [
    ("01-user.md", "User"),
    ("02-investor.md", "Investor"),
    ("03-product-manager.md", "Product Manager"),
    ("04-market-operator.md", "Market Operator"),
    ("05-brand-operator.md", "Brand Operator"),
    ("06-competitor.md", "Competitor"),
    ("07-partner.md", "Partner"),
]


def slugify(text: str) -> str:
    slug = re.sub(r"[^a-zA-Z0-9]+", "-", text.strip().lower()).strip("-")
    return slug or "product"


def write_if_missing(path: Path, content: str) -> None:
    if not path.exists():
        path.write_text(content, encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("product_name")
    parser.add_argument("--base", default="markdown/product-analysis")
    parser.add_argument("--date", default=date.today().strftime("%Y%m%d"))
    args = parser.parse_args()

    run_dir = Path(args.base) / f"{slugify(args.product_name)}-{args.date}"
    roles_dir = run_dir / "roles"
    sources_dir = run_dir / "sources"
    assets_dir = run_dir / "assets"

    for directory in (roles_dir, sources_dir, assets_dir):
        directory.mkdir(parents=True, exist_ok=True)

    for filename, role in ROLES:
        write_if_missing(
            roles_dir / filename,
            f"""# {args.product_name} - {role} Perspective

## Bottom Line

-

## Evidence Used

-

## Analysis

-

## Risks and Unknowns

-

## Role-Specific Recommendation

-
""",
        )

    write_if_missing(
        sources_dir / "source-notes.md",
        f"""# {args.product_name} Source Notes

| Source | Date Accessed | Publisher | Key Facts | Reliability Notes |
|---|---:|---|---|---|
|  | {date.today().isoformat()} |  |  |  |
""",
    )

    write_if_missing(
        run_dir / "final-report.md",
        f"""# {args.product_name} Product Analysis Report

> Draft after completing all seven role files.
""",
    )

    print(run_dir)


if __name__ == "__main__":
    main()

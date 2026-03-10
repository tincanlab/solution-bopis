from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any

import yaml


DEFAULT_INDEX_PATH = Path(__file__).resolve().parent.parent / "solution-index.yml"


def load_solution_index(index_path: Path) -> dict[str, Any]:
    with index_path.open("r", encoding="utf-8") as handle:
        data = yaml.safe_load(handle)
    if not isinstance(data, dict):
        raise ValueError(f"Expected mapping at root of {index_path}")
    return data


def find_domain(solution_index: dict[str, Any], domain_key: str) -> dict[str, Any] | None:
    domains = solution_index.get("domains", [])
    if not isinstance(domains, list):
        raise ValueError("Expected 'domains' to be a list in solution-index.yml")

    normalized_key = domain_key.strip().lower()
    for domain in domains:
        if not isinstance(domain, dict):
            continue
        if str(domain.get("domain_key", "")).strip().lower() == normalized_key:
            return domain
    return None


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Retrieve domain information from solution-index.yml by domain_key."
    )
    parser.add_argument("domain_key", help="Domain key to look up, for example 'inventory'.")
    parser.add_argument(
        "--index-path",
        type=Path,
        default=DEFAULT_INDEX_PATH,
        help=f"Path to solution index YAML. Defaults to {DEFAULT_INDEX_PATH}.",
    )
    parser.add_argument(
        "--format",
        choices=("json", "text"),
        default="json",
        help="Output format. Defaults to json.",
    )
    return parser


def render_text(domain: dict[str, Any]) -> str:
    lines = [
        f"domain_key: {domain.get('domain_key', '')}",
        f"oda_component: {domain.get('oda_component', '')}",
    ]

    domain_repo = domain.get("domain_repo", {})
    if isinstance(domain_repo, dict):
        lines.append(f"repo_key: {domain_repo.get('repo_key', '')}")
        lines.append(f"repo_url: {domain_repo.get('repo_url', '')}")

        entrypoints = domain_repo.get("entrypoints", {})
        if isinstance(entrypoints, dict):
            for key, value in entrypoints.items():
                lines.append(f"entrypoints.{key}: {value}")

    tmf_apis = domain.get("tmf_apis", [])
    if isinstance(tmf_apis, list):
        for index, api in enumerate(tmf_apis, start=1):
            if not isinstance(api, dict):
                continue
            lines.append(f"tmf_apis[{index}].api_id: {api.get('api_id', '')}")
            lines.append(
                "tmf_apis[{index}].implementation_repo_url: {repo_url}".format(
                    index=index,
                    repo_url=api.get("implementation_repo_url", ""),
                )
            )

    return "\n".join(lines)


def main() -> int:
    args = build_parser().parse_args()

    try:
        solution_index = load_solution_index(args.index_path)
        domain = find_domain(solution_index, args.domain_key)
    except FileNotFoundError:
        print(f"solution-index file not found: {args.index_path}", file=sys.stderr)
        return 1
    except ValueError as exc:
        print(str(exc), file=sys.stderr)
        return 1

    if domain is None:
        print(f"domain_key not found: {args.domain_key}", file=sys.stderr)
        return 2

    if args.format == "text":
        print(render_text(domain))
    else:
        print(json.dumps(domain, indent=2))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())

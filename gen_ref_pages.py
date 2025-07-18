"""Generate the code reference pages and navigation.
Inspired by https://github.com/Quantum-Accelerators/quacc/blob/main/docs/gen_ref_pages.py
"""

from __future__ import annotations

from pathlib import Path

import mkdocs_gen_files  # type: ignore[import-untyped]

nav = mkdocs_gen_files.Nav()

for path in sorted(Path("src").rglob("*.py")):
    module_path = path.relative_to("src").with_suffix("")
    doc_path = path.relative_to("src").with_suffix(".md")
    full_doc_path = Path("reference", doc_path)

    parts = tuple(module_path.parts)

    ignore = ["_cli", "_version", "__init__", "__main__"]
    if any(p in ignore for p in parts):
        continue

    nav[parts] = doc_path.as_posix()

    # Write ::: my.module.name to the generated .md
    with mkdocs_gen_files.open(full_doc_path, "w") as fd:
        ident = ".".join(parts)
        fd.write(f"::: {ident}")

    # Set the edit path so "Edit on GitHub" works
    mkdocs_gen_files.set_edit_path(full_doc_path, Path("..") / path)

# Write the nav structure to reference/SUMMARY.md
with mkdocs_gen_files.open(Path("reference", "SUMMARY.md"), "w") as nav_file:
    nav_file.writelines(nav.build_literate_nav())

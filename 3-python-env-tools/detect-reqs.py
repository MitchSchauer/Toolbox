# detect-reqs.py
"""
Scans a project directory for Python files,
extracts external (non-stdlib) imports,
and outputs a `requirements.txt`-style list.
"""
import os
import ast
import sys
import stdlib_list

project_path = sys.argv[1] if len(sys.argv) > 1 else '.'
stdlib = set(stdlib_list.stdlib_list())
detected = set()

for root, _, files in os.walk(project_path):
    for file in files:
        if file.endswith(".py"):
            with open(os.path.join(root, file), "r", encoding="utf-8") as f:
                try:
                    tree = ast.parse(f.read())
                    for node in ast.walk(tree):
                        if isinstance(node, ast.Import):
                            for alias in node.names:
                                detected.add(alias.name.split(".")[0])
                        elif isinstance(node, ast.ImportFrom):
                            if node.module:
                                detected.add(node.module.split(".")[0])
                except Exception as e:
                    print(f"⚠️ Error parsing {file}: {e}", file=sys.stderr)

for pkg in sorted(detected - stdlib):
    print(pkg)


Scaffold a new file at $ARGUMENTS following this repo's conventions.

1. Read 2 sibling files in the same directory to match imports, structure, naming.
2. If it's a router file, include: pydantic schema import, service call, error handling, async/await.
3. If it's a model file, include: table name, timestamps (created_at/updated_at), relationships.
4. If it's a service file, include: dependency injection of session, one public function, docstring.
5. Add any `__all__` export if neighbors have one.
6. End with a failing stub test next to the file (or in `tests/` mirroring the structure).

Do NOT invent domain-specific logic — the stub should be clearly a template.
Do NOT add new dependencies without checking existing ones in `pyproject.toml` / `package.json` first.

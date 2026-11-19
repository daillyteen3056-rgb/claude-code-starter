---
name: python-test-generator
description: Generate pytest tests for a Python module or function. Produces assertion-heavy tests covering normal paths, edge cases, boundary conditions, and error paths. Use when the user asks to "write tests for", "add pytest coverage", "generate tests from", or when a Python source file needs test cases and none exist. Returns a complete `test_<name>.py` file that runs under pytest with no extra setup.
---

# Python test generator (pytest)

## When to invoke

- "Write tests for `src/foo.py`"
- "Add pytest coverage for `user_service.py`"
- "Generate tests from this function"
- A Python source file is referenced and there is no corresponding `test_*.py` next to it

Do NOT invoke this skill for:
- Integration tests requiring live external services (DB, network) — those belong to a different skill
- Refactoring existing tests — this skill creates new ones

## Procedure

1. **Read the source file completely** before writing any test. Do not guess at function signatures.
2. **Map every public callable** in the module (functions, methods on classes, module-level names not prefixed with `_`).
3. For each callable, write at minimum:
   - One **happy-path test** with realistic inputs
   - One **edge case** per discoverable branch (empty input, boundary, None, type coercion)
   - One **error path** test using `pytest.raises` for each exception the body can produce
4. Use **parametrize** when 3+ cases share a structure. Do not parametrize to collapse unrelated cases.
5. Mock **only** external I/O (filesystem, network, time, random, environment). Do not mock internal collaborators — they are part of the unit under test.
6. Each test function name describes the behavior: `test_<function>_<scenario>_<expected>`. Not `test_foo_1`.
7. Place the output in `tests/test_<module_name>.py`. Create `tests/__init__.py` if missing.

## Output constraints

- **Runnable.** `pytest tests/test_<name>.py` must pass or fail honestly — no stubs, no `pass` placeholders, no `# TODO: write this test`.
- **No unused imports.** Clean `pytest`, no `unittest` mixing.
- **Fixture-first.** Shared setup goes in `@pytest.fixture`, not in a `setUp` method.
- **Minimum 70% branch coverage** on the module being tested. State this coverage claim in a comment at the top: `# Coverage: ~75% of decision branches in <module>.py`.
- **Explicit assertions.** `assert result == expected` with a specific value, not `assert result`.

## Example invocation

User: "Write tests for src/cart_store.py"

Expected process:
1. Read `src/cart_store.py` → identify `CartStore` class with methods `add`, `remove`, `clear`, `get`, `total_items`.
2. Read any config / fixtures the methods depend on.
3. Produce `tests/test_cart_store.py` with:
   - Fixture that creates a clean `CartStore` with a tmp path
   - Tests for `add` with new product, existing product, qty=0, qty=-1 (delete)
   - Tests for `remove` on existing and missing product
   - Tests for `clear` on empty and populated cart
   - Tests for `get` returning list copy (not internal ref)
   - Tests for `total_items` sum
   - `pytest.raises(ValueError)` where applicable

## Anti-patterns to reject

- **Golden-file tests** without explaining what the golden represents. If the output is a dict of fixed shape, assert the shape explicitly.
- **Tests that only call the function** with no assertion. `foo()` without `assert` is coverage theater.
- **Patching `builtins.open`** in unit tests. Use `tmp_path` fixture and real file I/O instead.
- **Over-mocking** — if more than 50% of the test is `mock.patch`, the unit boundary is wrong, not the test.
- **Snapshot testing a dict** without ordering guarantees. Sort first.

## Dependencies the skill assumes

- `pytest >= 7.0`
- `pytest-cov` only if the user asks for coverage reports (do not add unprompted)

## Deliverable checklist (self-check before returning)

- [ ] Every public callable has at least 1 test
- [ ] Every raised exception has a `pytest.raises` test
- [ ] No test body is empty, no TODO comments
- [ ] File ends with a newline
- [ ] Imports are minimal and sorted
- [ ] Coverage comment at the top

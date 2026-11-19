# CLAUDE.md

A FastAPI backend serving [your product]. Python 3.12, Pydantic v2,
SQLAlchemy 2.0 async, Postgres 16. Deployed via GitHub Actions.
Latency-sensitive (p95 under 200ms).

## Layout

- `app/` — FastAPI app. Entry at `app/main.py`.
- `app/routers/` — one file per resource; mount in `main.py`.
- `app/models/` — SQLAlchemy models.
- `app/schemas/` — Pydantic request/response schemas.
- `app/services/` — business logic; routers call services, services call models.
- `migrations/` — Alembic migrations, generated with `alembic revision --autogenerate`.
- `tests/` — pytest; `conftest.py` has the test DB fixture.

## Commands

- Install: `uv sync`
- Run: `uv run uvicorn app.main:app --reload`
- Test: `uv run pytest`
- Single test: `uv run pytest tests/path.py::test_name`
- Lint: `uv run ruff check`
- Format: `uv run ruff format`
- Migration: `uv run alembic revision --autogenerate -m "description"`
- Apply: `uv run alembic upgrade head`

## Conventions

- Async everywhere. No sync SQLAlchemy calls.
- Pydantic v2 syntax: `model_config = ConfigDict(...)`, not `class Config`.
- Return Pydantic schemas from routers, not SQLAlchemy models.
- Services receive a session via DI; don't create sessions inside services.
- Config via `pydantic-settings`, env-var-backed.

## Do not

- Do NOT use the sync SQLAlchemy API (`Session`). Use `AsyncSession`.
- Do NOT return SQLAlchemy models from a router (serialization leaks).
- Do NOT add `print()` for debugging. Use `logger.debug()`.
- Do NOT edit migration files after they've been applied to staging.
- Do NOT bump dependencies without running the full test suite.

## Testing

- Every router endpoint needs at least one happy-path test and one 4xx test.
- Target 75%+ coverage on `app/services/`; lower on routers is fine.
- Use the `db_session` fixture; it rolls back after each test.
- Don't mock the DB — tests run against a real Postgres via testcontainers.

---
name: git-commit-message
description: Write a conventional-commit message from the current staged diff. Reads `git diff --staged`, summarizes the change into a type (feat/fix/docs/refactor/test/chore), optional scope, imperative subject under 72 characters, and a body that explains WHY (not what). Use when the user asks to "commit this", "write a commit message", "what should I commit this as", or finishes a chunk of work and needs to stage it.
---

# Git commit message (conventional-commit style)

## When to invoke

- "Commit this"
- "Write a commit message for these changes"
- "What should I commit this as"
- Right after finishing a staged logical change, if the user doesn't specify a message

Do NOT invoke this skill for:
- Pushing, PR creation, or any destructive git operation
- Re-writing an existing commit message on a pushed branch

## Procedure

1. **Run `git diff --staged`** and `git status --short` to see what will be committed.
2. **Classify the change** into exactly ONE of these types (never two):
   - `feat` — net new user-visible capability
   - `fix` — bug fix
   - `docs` — documentation only
   - `refactor` — code change that does not alter behavior
   - `perf` — performance improvement
   - `test` — test code only
   - `chore` — tooling, config, dependency bumps
   - `style` — whitespace/formatter only (rare; prefer `chore` unless auto-formatter output)
3. **Pick a scope** if one obvious module/area is touched (e.g. `auth`, `cart`, `deploy`). Omit scope if the change spans ≥3 unrelated areas.
4. **Write the subject line**:
   - Format: `<type>(<scope>): <imperative verb> <what>`
   - Max 72 characters total
   - Imperative mood ("add", "fix", "remove" — NOT "added", "fixes", "removing")
   - No trailing period
5. **Write the body** (only if needed):
   - Blank line after subject
   - Wrap at 72 cols
   - Answer: **why** this change is being made. Not what — the diff shows what.
   - Include context a reader cannot derive from the code alone: a bug ticket number, a performance measurement, a user complaint, a deprecated API announcement.
6. **Footer** for breaking changes or issue refs:
   - `BREAKING CHANGE: <description>` on its own line
   - `Closes #123`, `Refs #456`

## Output constraints

- **Return the message only.** No markdown fences, no preamble like "Here's a commit message:". The user will paste directly into `git commit -m`.
- **One subject line + optional body + optional footer**, separated by blank lines.
- **No author tags** (`Co-Authored-By:`) unless the user explicitly asks or project convention requires it.
- **No emoji** unless the project's existing commit history uses them (check `git log --oneline -20`).

## Example

Staged diff:
```diff
# bot/handlers/checkout.py
-    await state.set_state(Checkout.phone)
-    if not name:
-        raise ValueError("name required")
+    if not name or len(name.strip()) < 2:
+        await msg.answer("Please send a real name")
+        return
+    await state.set_state(Checkout.phone)
```

Message produced:
```
fix(checkout): validate name length before FSM transition

The previous code set Checkout.phone state before validating the
name field, so a bad name (empty or single char) would still advance
the user to the phone step with an invalid name stored in state.

Validate first, answer with the error, and stay in Checkout.name
so the user can retry. This matches the pattern already used for
phone and address steps.

Closes #42
```

## Anti-patterns to reject

- **Vague subjects**: "update code", "fix stuff", "misc changes" — if the subject could apply to any commit, it's wrong
- **Subject that restates the diff**: "change line 42 of checkout.py" — the diff already says this
- **Body that is a copy of the diff** — body is WHY, not WHAT
- **Multiple types in one subject**: "feat: add admin + fix: cart bug" — split into two commits
- **Rambling body**: >5 paragraphs for a small fix suggests the commit is too big; recommend splitting

## Edge cases

- **Nothing staged**: tell the user "No staged changes. Run `git add <files>` first."
- **Only whitespace**: subject = `style: reformat <file(s)>`, no body needed
- **Mixed changes spanning many unrelated areas**: say so to the user — "This looks like 2-3 logical changes; suggest `git reset` then stage piece-by-piece. Here are the groups I see: ..."

Review the current diff (`git diff`) for:
- Correctness bugs
- Security issues (secrets in code, injection points, missing auth)
- Performance red flags (N+1 queries, unbounded loops, synchronous I/O in hot paths)
- Style inconsistencies with the surrounding code

Format:
- Group findings by severity (🔴 blocker / 🟡 should-fix / 🟢 nice-to-have)
- Each finding: file:line, one-sentence problem, one-sentence fix
- Top 10 findings max — if more exist, say so and show the worst ones

Do NOT suggest renaming variables or adding type hints unless they affect correctness.
Do NOT nitpick formatting (the formatter handles that).

Debug the latest error.

1. Read the most recent stack trace from `logs/app.log` (last 50 lines) or wherever logs live in this repo.
2. Trace the top frame to source; read ~40 lines of surrounding code.
3. Form 3 specific hypotheses about the cause, ordered by likelihood.
4. For each hypothesis, name the exact file:line to check next.
5. Suggest ONE minimal test that would differentiate the hypotheses.

Do NOT propose fixes until a hypothesis is confirmed.
Do NOT speculate without evidence — if the logs don't support a hypothesis, drop it.

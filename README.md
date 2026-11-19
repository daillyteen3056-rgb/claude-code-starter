# claude-code-starter

A production-ready `.claude/` folder you can drop into any repo. Hooks, skills, slash commands, example `CLAUDE.md`, `settings.json` — the whole Claude Code customization layer, wired up and ready to use.

Clone it, copy `.claude/` and `CLAUDE.md` into your project, edit for your stack, commit. Every teammate gets the same Claude Code experience.

## What's inside

```
.claude/
├── settings.json              # hooks + MCP server slots
├── skills/
│   ├── python-test-generator/
│   │   └── SKILL.md           # free excerpt — "write tests for X" auto-trigger
│   └── git-commit-message/
│       └── SKILL.md           # free excerpt — "commit this" auto-trigger
├── commands/
│   ├── deploy.md              # /deploy <env>
│   ├── review.md              # /review
│   ├── release-notes.md       # /release-notes <version>
│   ├── debug.md               # /debug
│   └── scaffold.md            # /scaffold <path>
└── hooks/
    └── bash-guard.sh          # PreToolUse: blocks rm -rf / force push / curl|sh
CLAUDE.md                      # example repo-level context for a FastAPI project
```

## Install (60 seconds)

```bash
# In your project root:
git clone https://github.com/<you>/claude-code-starter /tmp/ccs
cp -r /tmp/ccs/.claude .
cp /tmp/ccs/CLAUDE.md .
chmod +x .claude/hooks/*.sh
rm -rf /tmp/ccs
```

Edit `CLAUDE.md` with your project's details. Restart Claude Code. Run `/skills` and `/help commands` to verify.

## What each piece does

### `CLAUDE.md`

Always-on repo context. Loaded every session. The example is written for a Python/FastAPI backend — swap in your stack. Rule: under 800 tokens, 6 sections (project description, layout, commands, conventions, do-NOT list, testing policy). Deep dive: [CLAUDE.md best practices](https://telegramorder-bot.pages.dev/blog/claude-md-best-practices.html).

### `.claude/skills/`

SKILL.md files that auto-trigger on matching asks. This starter includes 2 free excerpts:

- `python-test-generator` — type "write tests for X.py", get a complete pytest file
- `git-commit-message` — type "commit this", get a conventional-commit message

Both are production versions of what ships in the [full 6-skill pack](https://telegramorder-bot.pages.dev/claude-code-skills.html) ($19). The pack adds `pr-description-writer`, `docstring-generator`, `env-example-generator`, `dockerfile-optimizer`.

Writing your own: [walkthrough](https://telegramorder-bot.pages.dev/blog/write-your-first-claude-code-skill.html).

### `.claude/commands/`

Reusable slash commands. Type `/deploy staging`, `/review`, `/release-notes v1.2`, `/debug`, `/scaffold routes/users.py`.

Each is a short Markdown file with the prompt body. Add your own: drop a new `.md` in this folder.

Deep dive: [Claude Code slash commands tutorial](https://telegramorder-bot.pages.dev/blog/claude-code-slash-commands-tutorial.html).

### `.claude/hooks/bash-guard.sh`

A PreToolUse hook that runs on every Bash tool call. Blocks:

- `rm -rf /`, `rm -rf ~`
- `git push --force`, `git push -f`
- `curl ... | sh`, `wget ... | sh` (piping remote content into a shell)
- `chmod -R 777` or `chmod 777`

Edit the script to add patterns for your repo (secrets paths, production endpoints, etc.).

Deep dive: [Claude Code hooks tutorial](https://telegramorder-bot.pages.dev/blog/claude-code-hooks-tutorial.html).

### `.claude/settings.json`

Wires up the hooks and includes slots for MCP servers (commented out by default). Also includes a PostToolUse hook that runs your formatter after every edit — adjust the command for your language.

## Also worth knowing

- [Claude Code vs Cursor](https://telegramorder-bot.pages.dev/blog/claude-code-vs-cursor-2026.html) — honest 3-month comparison
- [Claude Code pricing explained](https://telegramorder-bot.pages.dev/blog/claude-code-pricing-explained.html) — Pro vs Max vs API
- [Claude Code sub-agents tutorial](https://telegramorder-bot.pages.dev/blog/claude-code-sub-agents-tutorial.html) — parallel work without filling your context
- [Claude Code MCP server tutorial](https://telegramorder-bot.pages.dev/blog/claude-code-mcp-server-tutorial.html) — connect your own tools in 10 minutes

## Star / watch

If this saves you an afternoon, drop a ⭐ — helps other devs find it. Issues and PRs welcome.

## License

MIT. Use anywhere, modify anything. The full 6-skill pack has its own license (see the pack README).

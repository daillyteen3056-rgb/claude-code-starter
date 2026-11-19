Draft release notes for version $ARGUMENTS.

1. Find the latest tag: `git describe --tags --abbrev=0`. If no tags, tell the user to tag their first release and stop.
2. Get commits since that tag: `git log <latest-tag>..HEAD --pretty=format:'%h %s'`.
3. Group commits by conventional-commit type when present:
   - feat → "Features"
   - fix → "Bug fixes"
   - perf → "Performance"
   - refactor → "Internal changes"
   - docs → "Documentation"
   - Everything else → "Other"
4. For each group, write one bullet per commit:
   - Strip the type/scope prefix from the subject
   - Start with a capital letter, no trailing period
   - Keep issue numbers (`#123`) when present
5. Omit empty groups entirely.
6. Output format: `## $ARGUMENTS — <today ISO date>` + `### <group>` sections.

Do NOT invent commits. Do NOT add a "Breaking changes" section unless a commit body contained "BREAKING CHANGE".
If the diff is >50 commits, suggest splitting into smaller releases.

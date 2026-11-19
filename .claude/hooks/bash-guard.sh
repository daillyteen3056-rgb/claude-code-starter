#!/usr/bin/env bash
# Block dangerous shell patterns before Claude Code runs them.
# Exit 0 = allow; Exit 2 = block (Claude sees the stderr message and aborts).
set -eu

payload="$(cat)"
cmd="$(echo "$payload" | jq -r '.tool_input.command' 2>/dev/null || echo "")"

block() {
  echo "BLOCKED by bash-guard: $1" >&2
  exit 2
}

case "$cmd" in
  *"rm -rf /"*|*"rm -rf /*"*|*"rm -rf ~"*|*"rm -rf \$HOME"*)
    block "destructive rm on root/home" ;;
  *"git push --force"*|*"git push -f"*)
    block "force push — use --force-with-lease if you really need it" ;;
  *"curl "*"| sh"*|*"curl "*"| bash"*|*"wget "*"| sh"*|*"wget "*"| bash"*)
    block "piping remote content into a shell — download, read, then run" ;;
  *"chmod -R 777"*|*"chmod 777 "*)
    block "world-writable permissions" ;;
esac

exit 0

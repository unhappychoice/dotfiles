#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_GNUPG_DIR="$SCRIPT_DIR/../home/.gnupg"
GNUPGHOME="${GNUPGHOME:-$HOME/.gnupg}"
DEST="$GNUPGHOME/gpg-agent.conf"

detect_os() {
  case "$(uname -s)" in
    Darwin) echo macos ;;
    Linux)
      if grep -qiE '(microsoft|wsl)' /proc/version 2>/dev/null; then
        echo wsl
      else
        echo linux
      fi
      ;;
    *) echo unknown ;;
  esac
}

os="$(detect_os)"
src="$REPO_GNUPG_DIR/gpg-agent.conf.$os"

if [[ ! -f "$src" ]]; then
  echo "no gpg-agent.conf variant for '$os' (expected: $src)" >&2
  exit 1
fi

mkdir -p "$GNUPGHOME"
chmod 700 "$GNUPGHOME"

if [[ -L "$DEST" || -e "$DEST" ]]; then
  rm -f "$DEST"
fi

install -m 600 "$src" "$DEST"
echo "installed $src -> $DEST"

if command -v gpgconf >/dev/null 2>&1; then
  gpgconf --kill gpg-agent || true
fi

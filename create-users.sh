#!/bin/sh
set -euo pipefail

for secret in /run/secrets/*.txt; do
  user=$(basename "$secret" .txt)
  pass=$(cat "$secret")

  [[ "$user" =~ ^[a-zA-Z0-9_]+$ ]] || { echo "Invalid username: $user" >&2; exit 1; }

  adduser --disabled-password --gecos "" "$user"
  printf '%s\n%s\n' "$pass" "$pass" | smbpasswd -a -s "$user"
done

exec smbd --foreground --no-process-group

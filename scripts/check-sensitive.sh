#!/usr/bin/env bash
# Sensitive-data check for this public repository. Runs on every push and pull request
# (.github/workflows/sensitive-check.yml) and locally: bash scripts/check-sensitive.sh
#
# Fails when a tracked file (text, or the text of a PDF) contains something that must not be public:
# IPv4 addresses, Tailscale names (*.ts.net), Supabase project URLs or keys, .env file paths,
# server paths, private keys or API tokens. A known false positive can be allowed by putting the
# exact matched string on its own line in .sensitive-allow (keep that file short and explain each line).
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

patterns=(
  '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b'                 # IPv4 address
  '[A-Za-z0-9.-]+\.ts\.net\b'                       # Tailscale MagicDNS name
  '\btailnet\b'                                     # tailnet names in prose
  '[a-z0-9]{20}\.supabase\.(co|in)\b'               # Supabase project URL (project ref)
  '\bsb_(publishable|secret)_[A-Za-z0-9_-]{10,}'    # Supabase keys
  'eyJ[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}\.'     # JWT (e.g. anon or service key)
  '(^|[/\\ "'"'"'])\.env(\.[a-z]+)?\b'              # .env file paths
  '(^|[ "'"'"'(])/(opt|srv|root|home)/[A-Za-z0-9._-]+' # server paths
  '-----BEGIN [A-Z ]*PRIVATE KEY-----'              # private keys
  '\b(sk-[A-Za-z0-9_-]{16,}|ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|xox[abp]-[A-Za-z0-9-]{10,}|AKIA[0-9A-Z]{16})' # API tokens
)
regex=$(IFS='|'; echo "${patterns[*]}")

allow=()
if [ -f .sensitive-allow ]; then
  while IFS= read -r line; do [[ -z "$line" || "$line" == \#* ]] || allow+=("$line"); done < .sensitive-allow
fi

tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
found=0
while IFS= read -r -d '' f; do
  case "$f" in
    .sensitive-allow|scripts/check-sensitive.sh|LICENSE-*) continue ;;
  esac
  src="$f"
  if [[ "$f" == *.pdf ]]; then
    if ! command -v pdftotext >/dev/null; then echo "::error::pdftotext missing, cannot check $f"; found=1; continue; fi
    src="$tmp/pdf.txt"; pdftotext -q "$f" "$src"
  elif ! grep -Iq . "$f" 2>/dev/null; then
    continue   # other binary files (images): not checked, review them by eye
  fi
  while IFS= read -r hit; do
    match=${hit#*:}
    ok=0; for a in "${allow[@]+"${allow[@]}"}"; do [[ "$match" == *"$a"* ]] && ok=1; done
    [ $ok -eq 1 ] && continue
    echo "::error file=$f::possible sensitive data: ${match:0:120}"
    found=1
  done < <(grep -noE -- "$regex" "$src" || true)
done < <(git ls-files -z)

if [ $found -ne 0 ]; then
  echo "Sensitive-data check failed. Remove the data, or allow a false positive in .sensitive-allow."
  exit 1
fi
echo "Sensitive-data check passed ($(git ls-files | wc -l) files)."

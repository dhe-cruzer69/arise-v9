#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail() {
  echo "❌ $*" >&2
  exit 1
}

require_file() {
  [[ -f "$1" ]] || fail "Required file missing: $1"
}

echo "🔎 ARIEX4OPS repository verification"
echo "   root: $ROOT"

echo "→ Governance"
require_file ".arx4/contract.md"
require_file "SECURITY.md"
require_file "LICENSE"

echo "→ CI"
require_file ".github/workflows/ci.yml"

echo "→ Documentation"
require_file "README.md"
require_file "docs/architecture.md"
require_file "docs/REPAIR-BLUEPRINT.md"

echo "→ Tooling"
require_file "scripts/setup.sh"
require_file "scripts/lint.sh"
require_file "scripts/verify-repo.sh"

if grep -RInE '(^|[^A-Za-z0-9_])(sk-[A-Za-z0-9_-]{8,}|sk-ant-[A-Za-z0-9_-]{8,}|-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----)' . \
  --exclude-dir=.git --exclude='LICENSE.html' --exclude='verify-repo.sh' >/dev/null 2>&1; then
  fail "Credential-shaped material detected in tracked text files"
fi

for script in scripts/*.sh; do
  bash -n "$script" || fail "Shell syntax error: $script"
done

if grep -RInF '|| true' scripts .github/workflows \
  --include='*.sh' --include='*.yml' --include='*.yaml' --exclude='verify-repo.sh' >/dev/null 2>&1; then
  fail "Non-failing quality gate detected; remove the suppression from scripts/CI"
fi

echo "→ Current-state consistency"
if [[ -d packages ]]; then
  echo "   packages/ exists; package-specific validation must be added before claiming full application CI."
else
  echo "   packages/ absent; repository is treated as governance/tooling/docs baseline."
fi

echo "✅ Repository verification passed"

#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "🔍 ARIEX4OPS quality gate"

# Structural + shell validation is the canonical gate for the current repository.
bash scripts/verify-repo.sh

# If application packages are restored later, opt into package-specific checks
# instead of silently swallowing failures.
if [[ -d packages ]]; then
  echo "📦 packages/ detected — package-specific linting must be declared by CI before merge."
fi

echo "✅ Quality gate complete"

#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "🚀 ARIEX4OPS — repository setup"

command -v bash >/dev/null 2>&1 || { echo "❌ bash is required"; exit 1; }

if command -v git >/dev/null 2>&1; then
  echo "→ Git: $(git --version)"
else
  echo "❌ git is required"
  exit 1
fi

if [[ -f .env.example && ! -f .env ]]; then
  echo "→ No .env found. Copy .env.example to .env when local configuration is required."
fi

if [[ -d packages ]]; then
  echo "→ packages/ detected. Application dependencies are intentionally not installed by this baseline script."
  echo "  Add package manifests and explicit install commands before enabling package bootstrap."
else
  echo "→ No packages/ directory detected; skipping application dependency installation."
fi

echo "→ Running repository verification"
bash scripts/verify-repo.sh

echo ""
echo "✅ Setup checks complete"
echo ""
echo "Next steps:"
echo "  1. cp .env.example .env"
echo "  2. Fill only local, non-committed values"
echo "  3. bash scripts/lint.sh"

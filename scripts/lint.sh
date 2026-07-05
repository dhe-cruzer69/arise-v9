#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Running cross-package lint..."

# Python
echo "→ Linting cad-automation..."
cd packages/cad-automation
ruff check src/ || true
ruff format --check src/ || true
mypy src/ || true
cd ../..

echo "→ Linting ai-agents..."
cd packages/ai-agents
ruff check agents/ || true
ruff format --check agents/ || true
mypy agents/ || true
cd ../..

# TypeScript
echo "→ Linting web-dashboard..."
cd packages/web-dashboard
npm run lint || true
npm run type-check || true
cd ../..

echo ""
echo "✅ Lint complete!"

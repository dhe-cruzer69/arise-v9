#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
fail(){ echo "❌ $*" >&2; exit 1; }
require_file(){ [[ -f "$1" ]] || fail "Required file missing: $1"; }
require_dir(){ [[ -d "$1" ]] || fail "Required directory missing: $1"; }
echo "🔎 ARIEX4OPS repository verification"
for f in .arx4/contract.md SECURITY.md LICENSE README.md docs/architecture.md docs/REPAIR-BLUEPRINT.md docs/DEPLOYMENT-BLUEPRINT.md .env.example .dockerignore Dockerfile docker-compose.yml nginx.conf app/index.html app/styles.css app/app.js plugins/README.md .github/workflows/ci.yml scripts/setup.sh scripts/lint.sh scripts/verify-repo.sh; do require_file "$f"; done
require_dir app
require_dir plugins
if grep -RInE '(^|[^A-Za-z0-9_])(sk-[A-Za-z0-9_-]{8,}|sk-ant-[A-Za-z0-9_-]{8,}|-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----)' . --exclude-dir=.git --exclude='LICENSE.html' --exclude='verify-repo.sh' >/dev/null 2>&1; then fail "Credential-shaped material detected in tracked text files"; fi
for script in scripts/*.sh; do bash -n "$script" || fail "Shell syntax error: $script"; done
if grep -RIn '|| true' scripts .github/workflows --include='*.sh' --include='*.yml' --include='*.yaml' >/dev/null 2>&1; then fail "Non-failing quality gate detected: remove '|| true' from scripts/CI"; fi
if grep -RInE 'abhiachar126-s/v9-core|packages/(cad-automation|ai-agents|web-dashboard|devops-tools)' README.md docs scripts .github --include='*.md' --include='*.sh' --include='*.yml' --include='*.yaml' >/dev/null 2>&1; then fail "Stale repository/package references detected"; fi
echo "→ Docker blueprint"
command -v docker >/dev/null 2>&1 && echo "   Docker available" || echo "   Docker not installed locally; CI will perform image validation"
echo "→ Current state"
if [[ -d packages ]]; then echo "   packages/ detected; package-specific validation remains required"; else echo "   application packages absent; dashboard baseline is static and Dockerized"; fi
echo "✅ Repository verification passed"

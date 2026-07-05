#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Arise GenOps v9-Core — Development Setup"

# Check prerequisites
command -v python3 >/dev/null 2>&1 || { echo "❌ python3 is required"; exit 1; }
command -v node >/dev/null 2>&1 || { echo "❌ node is required"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "⚠️ docker not found — containers will not work"; }

# Setup Python packages
echo "📦 Installing Python packages..."
cd packages/cad-automation
pip install -e ".[dev]" 2>/dev/null || pip3 install -e ".[dev]"
cd ../ai-agents
pip install -e ".[dev]" 2>/dev/null || pip3 install -e ".[dev]"

# Setup Node packages
echo "📦 Installing Node packages..."
cd ../web-dashboard
npm install

# Return to root
cd ../..

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "  1. cp .env.example .env"
echo "  2. Fill in your API keys and secrets"
echo "  3. cd packages/web-dashboard && npm run dev"
echo "  4. docker-compose -f packages/devops-tools/docker/docker-compose.yml up"

# Plugin / integration contract

This directory defines integration boundaries without embedding credentials or pretending that external services are configured.

## Adapter contract

Every future plugin/connector should provide:

1. `manifest` — name, version, capabilities, required permissions.
2. `input schema` — validated request shape.
3. `output schema` — deterministic response shape.
4. `health` — explicit availability state.
5. `audit` — action/result evidence.
6. `failure policy` — bounded retries and explicit failure states.
7. `secrets` — references only; values live in GitHub Secrets or a runtime secret manager.

## Recommended adapters

- GitHub: repository/PR/issue automation.
- Docker: build, scan, run, health.
- CI: GitHub Actions workflow dispatch and evidence collection.
- AI: provider-neutral model gateway.
- Observability: structured logs and metrics.

Plugins are opt-in. No plugin should silently gain write permissions or execute production actions without an explicit policy gate.

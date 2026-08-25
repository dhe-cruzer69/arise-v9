# X4 Deployment Blueprint

## Runtime

The current application surface is a static control dashboard served by nginx and packaged as an immutable Docker image.

```text
GitHub push / PR
      ↓
GitHub Actions
      ├── shell + repository gates
      ├── Docker build
      └── container smoke test
      ↓
Image artifact
      ↓
Approved deployment target
      ↓
HTTP :80 + /health
```

## Local

```bash
docker compose up --build
# open http://localhost:8080
```

## CI gates

1. Validate shell syntax.
2. Run `scripts/verify-repo.sh`.
3. Build the Docker image.
4. Start the container.
5. Poll `/health`.
6. Stop and remove the container.

## Security baseline

- No secrets in source.
- Read-only container filesystem.
- Drop Linux capabilities.
- `no-new-privileges`.
- Security headers from nginx.
- Explicit health endpoint.

## Animation contract

UI animation is limited to presentation and must never imply that an external action executed. Execution state must come from verified backend/CI evidence when a real control plane is introduced.

## Expansion blueprint

```text
Dashboard
   ↓
API Gateway
   ↓
Policy Gate → Audit Ledger → Queue
   ↓
Adapters: GitHub / Docker / AI / Cloud
   ↓
Workers
   ↓
Evidence + Observability
```

The repository must not claim production deployment until an actual deployment target and successful health evidence exist.

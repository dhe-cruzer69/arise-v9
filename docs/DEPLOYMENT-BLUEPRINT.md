# Deployment Blueprint

## Overview

Static control dashboard served by nginx inside a minimal Docker image.

## Local run

```bash
docker compose up --build
# open http://localhost:8080
```

## Security baseline (docker-compose runtime)

These hardening flags are applied by `docker-compose.yml` and by the CI smoke-test container:

- No secrets in source.
- Read-only container filesystem (`--read-only`).
- Dropped Linux capabilities (`--cap-drop=ALL`).
- `no-new-privileges`.

Running the image with a plain `docker run` without these flags is possible but is **not** the documented security baseline. Operators who need the baseline should use `docker compose` or pass the same flags explicitly.

## Health endpoint

`GET /health` returns `200 ok` and carries the same security headers as every other response.

## Production notes

- Provide secrets only via environment or a secrets manager.
- Prefer the compose definition or an equivalent hardened runtime.
- The UI is presentation-only; it does not execute external actions.

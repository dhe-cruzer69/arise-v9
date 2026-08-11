# ARIEX Control Contract

## Role
GenOps core platform spanning CAD automation, AI agents, web observability, and DevOps tooling.

## Observed baseline
- Python 3.11+, Rust, TypeScript 5+
- Next.js/React dashboard
- Docker, Kubernetes, Terraform, GitHub Actions
- Existing CI/CD and security workflow documentation

## Advanced upgrade track
1. Add a single CI matrix covering Python, Rust and TypeScript packages.
2. Add SBOM generation and dependency provenance.
3. Add integration tests for the AI-agent/CAD/dashboard boundaries.
4. Publish machine-readable health metrics for `x4-arx4-dash`.
5. Require security and test jobs to fail closed.
6. Add release tags and reproducible build metadata.

## Definition of done
Build, tests, lint/type checks, security scan and package-specific integration tests must pass before a release is marked validated.

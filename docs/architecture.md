# v9-Core System Architecture

## Overview

Arise GenOps v9-Core is a modular, event-driven platform that unifies AI automation, CAD engineering, and DevOps intelligence into a single cohesive ecosystem.

## Design Principles

1. **Modularity** — Each package is independently versioned, tested, and deployable
2. **Event-Driven** — Components communicate via async message bus (Redis/NATS)
3. **AI-Native** — Every module exposes LLM-compatible APIs for agent orchestration
4. **Observability** — OpenTelemetry tracing across all services
5. **GitOps** — All infrastructure changes flow through Git

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Client Layer                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │  Web UI      │  │  CLI Tool    │  │  GitHub App / API    │  │
│  │  (Next.js)   │  │  (Python)    │  │  (FastAPI Webhooks)  │  │
│  └──────┬───────┘  └──────┬───────┘  └──────────┬───────────┘  │
└─────────┼────────────────┼────────────────────┼──────────────┘
          │                │                    │
          └────────────────┴────────────────────┘
                             │
┌────────────────────────────┴──────────────────────────────────┐
│                      API Gateway (Kong/Traefik)                │
└────────────────────────────┬──────────────────────────────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
┌───────┴────────┐  ┌────────┴────────┐  ┌───────┴────────┐
│  AI Agent      │  │  CAD Engine     │  │  DevOps        │
│  Service       │  │  Service        │  │  Controller    │
│  (CrewAI)      │  │  (ezdxf)        │  │  (Terraform)   │
└───────┬────────┘  └────────┬────────┘  └───────┬────────┘
        │                    │                    │
        └────────────────────┼────────────────────┘
                             │
┌────────────────────────────┴──────────────────────────────────┐
│                   Message Bus (Redis Streams / NATS)           │
└───────────────────────────────────────────────────────────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
┌───────┴────────┐  ┌────────┴────────┐  ┌───────┴────────┐
│  PostgreSQL    │  │  ClickHouse     │  │  Object Store  │
│  (Metadata)    │  │  (Metrics)      │  │  (S3/MinIO)    │
└────────────────┘  └─────────────────┘  └────────────────┘
```

## Package Interactions

### CAD Automation (`packages/cad-automation`)

- Receives JSON floor plan definitions via REST API
- Generates DXF files using `ezdxf`
- Stores output in S3-compatible object store
- Emits events: `cad.job.completed`, `cad.job.failed`

### AI Agents (`packages/ai-agents`)

- Listens to GitHub webhooks (`pull_request.opened`, `issue.created`)
- Uses CrewAI to orchestrate review agents
- Posts comments back to GitHub via GitHub App API
- Emits events: `agent.review.completed`, `agent.issue.escalated`

### Web Dashboard (`packages/web-dashboard`)

- Next.js 14 app with server components
- Real-time updates via Server-Sent Events
- Displays:
  - CI/CD pipeline status
  - AI agent activity feed
  - CAD job queue status
  - Infrastructure health

### DevOps Tools (`packages/devops-tools`)

- Terraform modules for AWS/GCP/Azure
- Kubernetes manifests with Helm charts
- Docker multi-stage builds
- Prometheus + Grafana monitoring stack

## Data Flow

### PR Review Flow

```
GitHub PR opened
    ↓
Webhook → AI Agent Service
    ↓
CrewAI analyzes code (AST + LLM)
    ↓
Quality score computed
    ↓
GitHub comment posted
    ↓
Event logged to ClickHouse
    ↓
Dashboard SSE update
```

### CAD Generation Flow

```
Client POST /cad/generate {json_plan}
    ↓
CAD Engine validates schema
    ↓
ezdxf generates DXF
    ↓
Upload to S3
    ↓
Return download URL
    ↓
Event: cad.job.completed
```

## Technology Decisions

| Decision | Rationale |
|----------|-----------|
| Python for AI/CAD | Rich ecosystem (ezdxf, CrewAI, FastAPI) |
| TypeScript for UI | Type safety, Next.js ecosystem |
| Monorepo structure | Shared tooling, atomic changes, easier CI |
| GitHub Actions | Native integration, matrix builds |
| Redis Streams | Simple, persistent event bus |
| ClickHouse | Fast analytics on time-series data |

## Security Model

- All services run in isolated containers
- Secrets managed via GitHub Secrets + external vault
- GitHub App uses least-privilege permissions
- CodeQL + TruffleHog in CI pipeline
- Dependabot auto-updates enabled

## Scaling Considerations

- CAD jobs: Queue-based async processing (Celery/RQ)
- AI agents: Rate-limited LLM calls with caching
- Dashboard: Static generation + ISR for performance
- Database: Read replicas for analytics queries

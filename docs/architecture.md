# ARIEX4OPS Architecture Blueprint

## Status

This document is a **target-state blueprint**. The current repository does not contain the application services represented below. Do not interpret this diagram as proof of deployed or implemented services.

## 1. Current observed architecture

```text
Git repository
│
├── Governance (.arx4)
├── GitHub automation (.github)
├── Documentation (docs)
├── Verification tooling (scripts)
└── Configuration template (.env.example)
```

The current CI boundary is intentionally limited to repository integrity and shell verification.

## 2. Target architecture

```text
                       ┌─────────────────────────┐
                       │ Client / CLI / GitHub   │
                       │ App / Dashboard         │
                       └────────────┬────────────┘
                                    │
                                    ▼
                       ┌─────────────────────────┐
                       │ API / Webhook Gateway    │
                       │ auth + schema validation│
                       └────────────┬────────────┘
                                    │
              ┌─────────────────────┼─────────────────────┐
              ▼                     ▼                     ▼
      ┌───────────────┐     ┌───────────────┐     ┌───────────────┐
      │ AI Agent Plane│     │ CAD Plane     │     │ DevOps Plane  │
      │ review/agent  │     │ DXF generation│     │ IaC/control   │
      └───────┬───────┘     └───────┬───────┘     └───────┬───────┘
              └─────────────────────┼─────────────────────┘
                                    ▼
                       ┌─────────────────────────┐
                       │ Durable Event / Job Bus │
                       │ Redis Streams / NATS    │
                       └────────────┬────────────┘
                                    │
                 ┌──────────────────┼──────────────────┐
                 ▼                  ▼                  ▼
          ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
          │ PostgreSQL  │    │ Analytics   │    │ Object Store│
          │ metadata    │    │ metrics     │    │ artifacts   │
          └─────────────┘    └─────────────┘    └─────────────┘
                                    │
                                    ▼
                       ┌─────────────────────────┐
                       │ Observability / Ledger  │
                       │ traces + audit + SLOs   │
                       └─────────────────────────┘
```

## 3. Control-plane contracts

Every executable action should carry:

```text
request_id
actor
intent
scope
risk_class
policy_decision
evidence_refs
idempotency_key
created_at
```

High-impact actions require explicit policy approval. Audit records should be append-only/tamper-evident.

## 4. Event contract

Example event envelope:

```json
{
  "event_id": "evt_<uuid>",
  "event_type": "agent.review.completed",
  "schema_version": 1,
  "occurred_at": "<RFC3339 timestamp>",
  "producer": "<service>",
  "request_id": "req_<id>",
  "payload": {}
}
```

Consumers must reject unsupported schema versions rather than silently guessing.

## 5. Package restoration blueprint

When implementation packages return, use this separation:

```text
packages/
├── ai-agents/
│   ├── source/
│   ├── tests/
│   └── README.md
├── cad-automation/
│   ├── source/
│   ├── tests/
│   └── README.md
├── web-dashboard/
│   ├── source/
│   ├── tests/
│   └── README.md
└── devops-tools/
    ├── infrastructure/
    ├── tests/
    └── README.md
```

No package should be represented in CI until its source and dependency contract exists.

## 6. Verification ladder

```text
G0  identity / repository tree
 ↓
G1  shell syntax
 ↓
G2  structural contract
 ↓
G3  documentation consistency
 ↓
G4  security checks
 ↓
G5  package unit tests       (when packages exist)
 ↓
G6  integration tests        (when services exist)
 ↓
G7  deployment verification  (when deployment exists)
```

A higher-level claim cannot be marked `VALIDATED` when its lower-level evidence is missing.

## 7. Non-functional requirements

- **Security:** least privilege, no committed secrets, explicit approval for high-risk actions.
- **Reliability:** idempotent jobs, bounded retries, explicit failure states.
- **Observability:** structured logs, metrics, traces, correlation IDs.
- **Change safety:** isolated branches, small commits, deterministic CI.
- **Performance:** record baseline and post-change measurements before claiming improvement.

## 8. Source of truth

The repository's observed tree is authoritative for implementation claims. This document is authoritative only for the intended architecture and contracts until corresponding implementation evidence exists.

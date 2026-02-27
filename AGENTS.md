# BOPIS Solution Architecture Agents

## Repository Context

This repository contains the solution architecture for the Buy Online, Pick Up In Store (BOPIS) initiative.

## Solution Architect

- **Name**: Zhong
- **Role**: Technical Lead / Solution Architect
- **Scope**: System architecture design, component decomposition, interface contracts

## Entry Points

- **SOLUTION.md** - Solution architecture entrypoint and overview
- **VISION.md** - Long-term intent and target outcomes
- **ROADMAP.md** - Implementation phases and timeline
- **solution-index.yml** - Machine-authoritative scope manifest

## Architecture Artifacts

- **architecture/solution/architecture-design.yml** - System architecture baseline with patterns, NFR budgets, TMF alignment
- **architecture/solution/interface-contracts.yml** - Canonical interface contracts (APIs and events)
- **architecture/solution/domain-handoffs/** - SA-to-DA handoff component specs per domain

## Domain Decomposition

This solution decomposes into 5 domains:

1. **Ecommerce Domain** - Product catalog, store location, inventory visibility
2. **Inventory Domain** - Inventory management, reservations, synchronization
3. **Order Domain** - Order lifecycle, status tracking
4. **Party Role Management Domain** - Store associate operations, pickup processing
5. **Notification Domain** - Email/SMS notifications

## Architecture Decision Records (ADRs)

- **ADR-001**: Microservices with API-First and Event-Driven Design
- **ADR-002**: Event-Driven Inventory Synchronization with Atomic Reservations
- **ADR-003**: QR Code Only Customer Verification

## Cascade State

- Current status: draft (Solution Architecture)
- Ready for advancement to proposed after stakeholder review

## Upstream Dependencies

- **Requirements Baseline**: architecture/requirements/requirements.yml (status: ready_for_advancement_review)
- **Stakeholder Map**: architecture/requirements/stakeholders.yml (all questions resolved)

## Downstream Handoffs

- Component specs ready for domain-architecture skill
- Domain teams will produce internal architecture/domains/<domain>/component-specs.yml

## Integration Points

- **HCL Commerce** - Product catalog and order processing
- **POS System** - Store transactions
- **Inventory Management System** - Stock synchronization
- **Email/SMS Providers** - Customer notifications

## Notes

- Solution architecture designed in Git-only mode (openarchitect MCP unavailable)
- Workspace/context registry not used - all artifacts local to this repo
- Enterprise validation skipped (enterprise-graph MCP unavailable)
- TMF alignment based on local knowledge (no MCP evidence)

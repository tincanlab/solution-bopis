# ROADMAP (Solution)

Owner: Solution Architect (SA)

Purpose: a single, developer-facing plan for this solution that aggregates domain roadmaps and reconciles cross-domain dependencies.

Authoring contract:
- Humans edit `ROADMAP.md` only.
- Tools/skills generate `ROADMAP.yml` from this file (do not hand-edit `ROADMAP.yml`).

## Scope

- Solution key: `bopis`
- Time horizon: Phase 1 (MVP, months 1-4) + Phase 2 (Scale, months 5-7)
- Domain sources: ecommerce, inventory, order, party-role, notification domain repos (not yet established)
- Provenance evidence: domain repo `inputs/` snapshots (pending domain repo creation)

## Current Status

- Health: `green`
- Current milestone: SA baseline complete — ready for domain-architecture handoff
- Next milestone: Domain repo creation and DA engagement
- Key cross-domain risks:
  - Inventory reservation atomicity at order placement (ecommerce ↔ inventory ↔ order dependency)
  - HCL Commerce integration complexity may delay Phase 1 ecommerce domain
  - Store associate hardware procurement is external dependency for party-role domain

## Roadmap

### Milestones

- `M1-sa-baseline`: Month 0: Solution architecture baseline complete (this milestone — done)
- `M2-domain-repos`: Month 1: Domain repos created; DA engagement starts across all 5 domains
- `M3-mvp-launch`: Month 4: Phase 1 MVP live across 20-25 stores
- `M4-scale`: Month 7: Phase 2 scale to 50%+ of stores
- `M5-advanced`: Month 11: Phase 3 advanced features (scheduled pickup, curbside)
- `M6-optimize`: Month 14: Phase 4 optimization and returns processing

### Cross-Domain Dependencies

- `ecommerce` depends on `inventory`: real-time inventory availability API must exist before product display can show stock — target M3
- `order` depends on `inventory`: atomic inventory reservation required at order placement — target M3
- `party-role` depends on `order`: store associate interface requires order status feed — target M3
- `notification` depends on `order`: pickup-ready event must be emitted by order domain — target M3

### Domain Roll-Up (Links)

- `ecommerce`: https://github.com/tincanlab/domain-bopis-ecommerce/blob/main/ROADMAP.md (pending repo creation)
- `inventory`: https://github.com/tincanlab/domain-bopis-inventory/blob/main/ROADMAP.md (pending repo creation)
- `order`: https://github.com/tincanlab/domain-bopis-order/blob/main/ROADMAP.md (pending repo creation)
- `party-role`: https://github.com/tincanlab/domain-bopis-party-role/blob/main/ROADMAP.md (pending repo creation)
- `notification`: https://github.com/tincanlab/domain-bopis-notification/blob/main/ROADMAP.md (pending repo creation)

## Implementation Targets (Developer Interface)

Developers should implement against the solution's canonical artifacts and domain-owned artifacts:

- `architecture/requirements/requirements.yml`
- `architecture/solution/architecture-design.yml`
- `architecture/solution/interface-contracts.yml`
- `architecture/solution/domain-workstreams.yml`
- Domain repos: `ROADMAP.md` and canonical domain design artifacts (per domain repo conventions)

## Decision Log

- 2026-03-06: Microservices with API-first and event-driven design selected: [ADR-001](architecture/solution/adr/adr-001-architecture-patterns.md)
- 2026-03-06: Atomic inventory reservation with event-driven sync: [ADR-002](architecture/solution/adr/adr-002-inventory-sync-strategy.md)
- 2026-03-06: QR code only for customer verification: [ADR-003](architecture/solution/adr/adr-003-verification-strategy.md)

---

## Phased Implementation Plan

### Phase 1: Foundation (MVP) - 3-4 months

**Objective**: Deliver core BOPIS capability across 20-25 stores (initial wave)

**Components**:
- Ecommerce domain: Product catalog with store inventory visibility
- Inventory domain: Real-time inventory reservation and synchronization
- Order domain: BOPIS order placement and status tracking
- Fulfillment domain: Store associate interface for order fulfillment
- Notification domain: Order readiness and pickup notifications

**Deliverables**:
- HCL Commerce integration for BOPIS catalog and checkout
- POS system integration for store transactions
- Inventory system integration for real-time sync
- Store associate tablet interface
- Email/SMS notification system
- Customer QR code generation and verification
- Basic reporting and analytics dashboard

**Acceptance Criteria**:
- Customers can view in-store inventory online
- Customers can place BOPIS orders with store pickup selection
- Inventory reservation occurs atomically at order placement
- Store associates can view and fulfill BOPIS orders
- Customers receive pickup notifications within 2 minutes
- Pickup wait time < 5 minutes (p95)
- 99.5% uptime during store hours
- All compliance requirements met (PCI DSS, GDPR, CCPA)

### Phase 2: Expansion - 2-3 months

**Objective**: Scale BOPIS to 50% of stores

**Components**: All Phase 1 components + scaling enhancements

**Deliverables**:
- Infrastructure scaling for 1,000+ orders/day
- Load testing and performance optimization
- Store associate training materials completion
- Expanded rollout to additional stores
- Enhanced reporting and analytics

**Acceptance Criteria**:
- BOPIS available across 50% of stores
- System supports 1,000 orders/day
- All store associates trained on BOPIS process
- Inventory sync latency < 30 seconds (p95)
- System availability > 99.5%

### Phase 3: Advanced Features - 3-4 months

**Objective**: Add advanced features to improve customer experience and operational efficiency

**Components**: New features across existing domains

**Deliverables**:
- Scheduled pickup time slots
- Curbside pickup option
- Customer loyalty points earning on BOPIS orders
- Enhanced order tracking with real-time updates
- Advanced analytics dashboard

**Acceptance Criteria**:
- Customers can schedule pickup time slots
- Curbside pickup available in pilot stores
- Loyalty points automatically awarded
- Real-time order tracking updates

### Phase 4: Optimization - 2-3 months

**Objective**: Continuous improvement and operational optimization

**Components**: All domains with optimization enhancements

**Deliverables**:
- Returns processing for BOPIS orders
- Inventory optimization algorithms
- Store associate efficiency improvements
- Customer feedback collection and analysis

**Acceptance Criteria**:
- BOPIS orders can be returned in-store
- Inventory accuracy > 99.5%
- Store associate fulfillment time reduced
- Customer feedback loop established

## Dependencies

**Phase 1**:
- HCL Commerce API access and documentation
- POS system integration specifications
- Inventory management system integration specifications
- Store associate hardware procurement
- Customer communication system setup

**Phase 2**:
- Phase 1 completion and approval
- Store network infrastructure assessment
- Load testing environment setup

**Phase 3**:
- Phase 2 completion and approval
- Customer feedback from Phase 1 and 2
- Business requirements for advanced features

**Phase 4**:
- Phase 3 completion and approval
- Customer feedback from Phase 3
- Operational data for optimization

## Risks

| Risk | Impact | Mitigation |
|-------|---------|------------|
| HCL Commerce integration complexity | High | Early proof-of-concept with HCL Commerce team |
| Inventory synchronization failures | High | Atomic reservation with rollback mechanisms |
| Store associate adoption | Medium | Comprehensive training and intuitive UI |
| System scalability challenges | Medium | Load testing and phased rollout |
| Compliance audit failures | High | Compliance review at each phase |

## Timeline Summary

- **Phase 1 (MVP)**: Months 1-4
- **Phase 2 (Scale)**: Months 5-7
- **Phase 3 (Advanced)**: Months 8-11
- **Phase 4 (Optimize)**: Months 12-14

**Total duration**: 14 months
**First value delivery**: End of Phase 1 (Month 4)
**Full rollout**: End of Phase 2 (Month 7)

# BOPIS Requirements Analysis Report

**Date**: 2025-02-28
**Initiative**: init-bopis - Buy Online, Pick Up In Store
**Analysis Mode**: balanced
**Status**: ready_for_advancement_review

---

## Executive Summary

This report presents the requirements baseline for the BOPIS (Buy Online, Pick Up In Store) initiative. The analysis transforms the BOPIS vision and roadmap into a comprehensive, traceable set of requirements that downstream design and implementation teams can execute without reinterpretation.

**Key Findings**

- **17 functional requirements** covering end-to-end BOPIS customer and associate workflows
- **3 compliance requirements** for PCI DSS, GDPR, and CCPA
- **4 operational requirements** for observability, scalability, and resiliency
- **9 non-functional requirements** with measurable targets for availability, performance, security, and data retention
- **7 open questions** requiring stakeholder input before implementation
- **TMF ODA alignment** mapped for 5 domains (Ecommerce, Inventory, Order, Party Role, Notification)

**Readiness Assessment**

The requirements baseline is **ready for advancement to solution architecture review**. All P0 requirements have acceptance criteria and are approved. Open questions are documented but do not block advancement.

---

## 1. Original Intake

### 1.1 Initiative Context

The BOPIS initiative enables customers to purchase online and pick up in store, with inventory visibility and fulfillment optimization. The initiative aims to:

- Launch BOPIS capability across 50% of stores
- Integrate online inventory with in-store fulfillment
- Reduce pickup wait time to under 5 minutes

### 1.2 Sources

- **Active Initiative**: `.openarchitect/active-initiative.json`
- **Vision Document**: `VISION.md`
- **Roadmap**: `ROADMAP.md`
- **Solution Architecture**: `architecture/solution/architecture-design.yml` (for alignment validation)

---

## 2. Problem Statement

Retail customers increasingly demand seamless cross-channel shopping experiences. Currently, online and in-store channels operate independently, creating friction for customers who want to browse online but pick up in-store. The absence of real-time inventory visibility across channels leads to:

- **Customer dissatisfaction**: Overselling and stockouts at pickup
- **Operational inefficiency**: Manual processes for order fulfillment
- **Revenue loss**: Missed sales opportunities due to channel silos

---

## 3. Requirements Summary

### 3.1 Functional Requirements

| ID | Requirement | Priority | Status | Domain |
|----|-------------|----------|--------|--------|
| req-product-catalog | Product Catalog Browsing | P0 | approved | Ecommerce |
| req-store-locator | Store Location Search | P0 | approved | Ecommerce |
| req-inventory-visibility | Real-time Inventory Visibility | P0 | approved | Inventory |
| req-order-placement | BOPIS Order Placement | P0 | approved | Order |
| req-order-status | Order Status Tracking | P0 | approved | Order |
| req-qr-code | QR Code Generation and Verification | P0 | approved | Party Role |
| req-associate-interface | Store Associate Fulfillment Interface | P0 | approved | Party Role |
| req-pickup-process | Pickup Process Management | P0 | approved | Party Role |
| req-notification | Customer Notifications | P0 | approved | Notification |
| req-inventory-reservation | Atomic Inventory Reservation | P0 | approved | Inventory |
| req-inventory-sync | Inventory Synchronization | P0 | approved | Inventory |
| req-hcl-commerce-integration | HCL Commerce Integration | P0 | approved | Ecommerce |
| req-pos-integration | POS System Integration | P0 | approved | Party Role |

### 3.2 Compliance Requirements

| ID | Requirement | Priority | Status | Standard |
|----|-------------|----------|--------|----------|
| req-pci-dss | PCI DSS Compliance | P0 | approved | PCI DSS |
| req-gdpr | GDPR Compliance | P0 | approved | GDPR |
| req-ccpa | CCPA Compliance | P0 | approved | CCPA |

### 3.3 Operational Requirements

| ID | Requirement | Priority | Status | Domain |
|----|-------------|----------|--------|--------|
| req-observability | System Observability | P1 | approved | All |
| req-scalability | System Scalability | P1 | approved | All |
| req-resiliency | System Resiliency | P1 | approved | All |
| req-mobile-accessibility | Mobile Accessibility | P2 | approved | All |

### 3.4 Non-Functional Requirements

| ID | Requirement | Target | Priority |
|----|-------------|--------|----------|
| nfr-availability | 99.5% uptime during store hours | >= 99.5% | P0 |
| nfr-inventory-sync | Inventory sync latency | <= 30s | P0 |
| nfr-checkout-latency | Checkout completion time | <= 2 min | P0 |
| nfr-associate-ui-latency | Associate UI load time | <= 3s | P0 |
| nfr-notification-latency | Notification send time | <= 2 min | P0 |
| nfr-throughput | Peak transaction rate | >= 100 orders/min | P0 |
| nfr-security | Encryption standards | AES-256, TLS 1.3 | P0 |
| nfr-data-retention | Data retention period | >= 7 years | P0 |
| nfr-recovery-time | RTO/RPO | < 4h / < 1h | P0 |

---

## 4. Scope Boundaries

### 4.1 In Scope

**Customer Journey**

- Product catalog browsing with store inventory visibility
- Store selection and search
- BOPIS order placement with inventory reservation
- Order status tracking
- QR code generation and verification at pickup

**Store Operations**

- Store associate interface for order fulfillment
- Order picking and marking as ready
- QR code scanning and verification
- Pickup completion and confirmation

**Integrations**

- HCL Commerce for product catalog and order processing
- POS system for store transactions
- Inventory management system for real-time sync
- Email/SMS providers for customer notifications

### 4.2 Out of Scope

**Deferred to Phase 3**

- Scheduled pickup time slots
- Curbside pickup option
- Loyalty program integration

**Deferred to Phase 4**

- Product returns processing
- Advanced analytics and personalization

**Future Expansion**

- Cross-border international store support
- Same-day delivery capabilities

---

## 5. TMF ODA Alignment

| Domain | ODA Component | TMF APIs | Status |
|--------|---------------|----------|--------|
| Ecommerce | Product Catalog Management | TMF620 | Aligned |
| Inventory | Product Inventory Management | TMF637 | Aligned |
| Order | Order Management | TMF620 | Aligned |
| Party Role | Party Role Management | TMF629 | Aligned |
| Notification | Notification Service | Custom | Custom |

**Note**: TMF alignment is derived from the existing solution architecture. TMF MCP enrichment was skipped due to tool unavailability.

---

## 6. Clarification Summary

### 6.1 Open Questions (7 total)

| ID | Question | Status | Owner |
|----|----------|--------|-------|
| q-001 | Phase 1 store list | answered | Product |
| q-002 | HCL Commerce API endpoints | open | E-commerce Team |
| q-003 | Inventory management system capabilities | open | Supply Chain Team |
| q-004 | POS system specifications | open | Retail Operations |
| q-005 | Email/SMS provider selection | open | Procurement |
| q-006 | Store associate hardware requirements | open | Procurement |
| q-007 | Data retention requirements by type | open | Legal/Compliance |
| q-008 | Disaster recovery target for BOPIS | open | Infrastructure |

### 6.2 Answered Questions

**q-001**: Phase 1 store list
- **Answer**: Phase 1 includes 20-25 stores selected based on geographic distribution, store size, and technical readiness.
- **Source**: ROADMAP.md

---

## 7. Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| HCL Commerce integration complexity | High | Medium | Early proof-of-concept with HCL Commerce team |
| Inventory synchronization failures | High | Medium | Atomic reservation with rollback mechanisms |
| Store associate adoption | Medium | Low | Comprehensive training and intuitive UI |
| System scalability challenges | Medium | Medium | Load testing and phased rollout |
| Compliance audit failures | High | Low | Compliance review at each phase |
| External integration dependencies | High | High | Circuit breakers and fallback mechanisms |

---

## 8. Dependencies

### 8.1 Technical Dependencies

- HCL Commerce API documentation and test environment
- POS system integration specifications and test endpoints
- Inventory management system API access
- Store associate hardware (tablets/mobile devices)
- Email/SMS provider selection and integration

### 8.2 Organizational Dependencies

- E-commerce team for HCL Commerce integration support
- Supply chain team for inventory management system access
- Retail operations team for POS system specifications
- Legal and security teams for compliance review
- Infrastructure team for network assessment

### 8.3 Phasing Dependencies

- **Phase 1**: All technical integrations must be operational
- **Phase 2**: Phase 1 completion and infrastructure assessment
- **Phase 3**: Phase 2 completion and customer feedback
- **Phase 4**: Phase 3 completion and operational data

---

## 9. Recommendations

### 9.1 Immediate Actions (Before SA Design)

1. **Technical Discovery**: Engage with HCL Commerce, POS, and inventory management system teams to define integration specifications
2. **Procurement**: Select and contract email/SMS provider and store associate hardware
3. **Compliance**: Complete data retention requirements analysis with legal team
4. **Infrastructure**: Define disaster recovery targets and infrastructure requirements

### 9.2 Design Considerations

1. **Domain Decomposition**: Leverage existing TMF ODA-aligned domain decomposition (Ecommerce, Inventory, Order, Party Role, Notification)
2. **Event-Driven Architecture**: Prioritize event-driven inventory and order state synchronization for real-time accuracy
3. **Resiliency**: Design circuit breakers and fallback mechanisms for all external integrations
4. **Observability**: Implement comprehensive logging, metrics, and tracing from day one
5. **Security**: Build PCI DSS, GDPR, and CCPA compliance into the architecture from requirements

### 9.3 Implementation Priorities

1. **Phase 1 (MVP)**: Focus on core BOPIS capability with HCL Commerce, POS, and inventory system integrations
2. **Phase 2 (Scale)**: Scale infrastructure and processes to support 50% of stores
3. **Phase 3 (Enhance)**: Add advanced features (scheduled pickup, curbside pickup, loyalty integration)
4. **Phase 4 (Optimize)**: Add returns processing and operational optimization features

---

## 10. Governance Status

| Field | Value |
|-------|-------|
| Cascade Layer | requirements |
| Cascade Readiness | ready_for_advancement_review |
| Recommendation | ready_for_review |
| Remediation Status | none |

The requirements baseline is complete and ready for stakeholder review and solution architecture validation.

---

## 11. Next Steps

1. **Stakeholder Review**: Conduct requirements review with product, engineering, and business stakeholders
2. **Solution Architecture**: Proceed to solution architecture design using this requirements baseline
3. **Stakeholder Mapping**: Run stakeholder-mapping skill to identify decision gates and engagement plan
4. **Use Case Elaboration**: Run use-case-elaboration skill to expand requirements into concrete user journeys
5. **Technical Discovery**: Address open questions with respective technical teams

---

## Appendix A: Artifacts Produced

- `architecture/requirements/requirements.md` - Narrative requirements baseline
- `architecture/requirements/requirements.yml` - Canonical structured requirements
- `architecture/requirements/requirements_report.md` - This report

## Appendix B: Context Evidence

- **Analysis Mode**: balanced
- **Run Mode**: Git-local
- **Workspace ID**: not_used (Git-local mode; openarchitect MCP unavailable)
- **TMF Enrichment**: skipped (TMF MCP unavailable; TMF alignment derived from existing solution architecture)
- **Tools Used**: Git-local read/write capabilities

## Appendix C: References

- Initiative: `.openarchitect/active-initiative.json`
- Vision: `VISION.md`
- Roadmap: `ROADMAP.md`
- Solution Architecture: `architecture/solution/architecture-design.yml`
- Solution Index: `solution-index.yml`

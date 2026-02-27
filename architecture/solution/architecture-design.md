# BOPIS Solution Architecture Design

## 1. Overview and Context

The Buy Online, Pick Up In Store (BOPIS) solution enables cross-channel shopping by integrating HCL Commerce e-commerce platform with POS and inventory management systems. Customers browse products online, view real-time store inventory, place BOPIS orders, and pick up in-store.

### Context Evidence

- **Workspace ID**: project (local Git mode)
- **Cascade State**: Solution Architecture (draft), Requirements (ready_for_advancement_review)
- **Requirements Baseline**: `architecture/requirements/requirements.yml`
- **Generated**: 2025-02-27

### System Overview Diagram

```mermaid
graph TB
    subgraph "Customer Channel"
        C[Customer]
        SF[Store Frontend]
    end

    subgraph "External Systems"
        HC[HCL Commerce]
        POS[POS System]
        IMS[Inventory Management]
    end

    subgraph "API Gateway Layer"
        GW[API Gateway<br/>99.9% Avail, 100ms Latency]
    end

    subgraph "Application Services"
        EC[Ecommerce Domain]
        IV[Inventory Domain]
        OR[Order Domain]
        PR[Party Role Domain]
        NT[Notification Domain]
    end

    subgraph "Data Layer"
        DB[(Relational DB)]
        EB[Event Bus]
        CH[(Cache)]
    end

    subgraph "Store Operations"
        SA[Store Associate Tablet]
    end

    C --> SF
    SF -->|Browsing| EC
    SF -->|Checkout| OR
    SA --> PR

    GW --> EC
    GW --> IV
    GW --> OR
    GW --> PR
    GW --> NT

    EC <-->|Product Data| HC
    EC <-->|Store Locations| HC
    OR <-->|Order Creation| HC
    PR <-->|Transactions| POS
    IV <-->|Stock Sync| IMS

    EC --> DB
    IV --> DB
    OR --> DB
    PR --> DB
    NT --> DB

    EC --> EB
    IV --> EB
    OR --> EB
    PR --> EB
    NT --> EB

    EC --> CH
    OR --> CH
```

## 2. Architectural Drivers

### Non-Functional Requirements (NFRs)

| ID | Requirement | Target | Source Req |
|----|-------------|--------|------------|
| nfr-availability | System must maintain 99.5% uptime during store operating hours (8am-10pm) | >= 99.5% | nfr-availability |
| nfr-inventory-sync | Inventory visibility updates must reflect within 30 seconds of reservation | <= 30 seconds | nfr-inventory-sync |
| nfr-checkout-latency | Checkout flow must complete within 2 minutes for BOPIS orders | <= 2 minutes | nfr-checkout-latency |
| nfr-associate-ui-latency | Store associate interface must load within 3 seconds | <= 3 seconds | nfr-associate-ui-latency |
| nfr-notification-latency | Customer pickup notifications must be sent within 2 minutes of order readiness | <= 2 minutes | nfr-notification-latency |
| nfr-throughput | System must support concurrent BOPIS transactions during peak periods | >= 100 orders/minute per store cluster | nfr-throughput |
| nfr-security | Customer data must be encrypted at rest and in transit | AES-256 encryption, TLS 1.3 | nfr-security |
| nfr-data-retention | BOPIS order data must be retained for compliance and audit purposes | >= 7 years | nfr-data-retention |
| nfr-recovery-time | System must recover from failures within acceptable timeframes | RTO < 4 hours, RPO < 1 hour | nfr-recovery-time |

### Constraints

- Must integrate with HCL Commerce e-commerce platform
- Must integrate with existing POS and inventory management systems
- Must comply with PCI DSS for payment processing
- Must comply with GDPR for customer data processing and storage
- Must comply with CCPA for California resident data privacy
- Must comply with local data protection regulations for international stores
- BOPIS capability must be available during store operating hours (8am-10pm)

### Regulatory Compliance

- PCI DSS
- GDPR
- CCPA
- Local data protection regulations (international stores)

### NFR Traceability Diagram

```mermaid
graph LR
    subgraph "Requirements"
        R1[nfr-availability]
        R2[nfr-inventory-sync]
        R3[nfr-checkout-latency]
        R4[nfr-associate-ui-latency]
        R5[nfr-notification-latency]
        R6[nfr-throughput]
        R7[nfr-security]
        R8[nfr-data-retention]
        R9[nfr-recovery-time]
    end

    subgraph "Architecture Patterns"
        P1[Microservices]
        P2[API-First]
        P3[Event-Driven]
        P4[CQRS]
    end

    R1 --> P1
    R1 --> P4
    R2 --> P3
    R3 --> P2
    R3 --> P4
    R4 --> P2
    R5 --> P3
    R6 --> P1
    R6 --> P4
    R7 --> P2
```

## 3. System Architecture

### Architecture Patterns

#### Microservices
- **Rationale**: Domain decomposition enables independent development, deployment, and scaling of Ecommerce, Inventory, Order, Fulfillment, and Notification domains
- **NFR Driver**: nfr-throughput, nfr-availability

#### API-First
- **Rationale**: All integrations between domains and external systems (HCL Commerce, POS, inventory, email/SMS) use well-defined REST APIs with clear contracts
- **NFR Driver**: nfr-checkout-latency, nfr-inventory-sync

#### Event-Driven
- **Rationale**: Inventory reservations, order state changes, and notifications propagate asynchronously via events for real-time accuracy without blocking
- **NFR Driver**: nfr-inventory-sync, nfr-notification-latency

#### CQRS
- **Rationale**: Order read (customer queries) and write (order placement) operations are separated to optimize performance and scalability
- **NFR Driver**: nfr-throughput, nfr-checkout-latency

### Deployment Topology

Multi-tier cloud deployment with:
- **API Gateway Layer**: Rate limiting, authentication, routing
- **Application Microservices Layer**: Ecommerce, Inventory, Order, Fulfillment, Notification domains
- **Data Layer**: Relational database, event bus, cache
- **External Integration Layer**: HCL Commerce, POS, inventory systems

Store associate tablets connect via mobile app to Party Role Management domain APIs. Customers access via HCL Commerce storefront.

### Architecture Patterns Diagram

```mermaid
graph TB
    subgraph "Architecture Patterns"
        direction TB
        MS[Microservices]
        AF[API-First]
        ED[Event-Driven]
        CQRS[CQRS]
    end

    subgraph "Benefits"
        B1[Independent Deployment]
        B2[Clear Contracts]
        B3[Real-time Updates]
        B4[Optimized Performance]
    end

    MS --> B1
    AF --> B2
    ED --> B3
    CQRS --> B4

    subgraph "NFR Drivers"
        N1[Throughput]
        N2[Availability]
        N3[Latency]
    end

    B1 --> N1
    B1 --> N2
    B2 --> N3
    B3 --> N3
    B4 --> N1
    B4 --> N3
```

## 4. Domain Decomposition

### Ecommerce Domain
- **Description**: Manages product catalog, store location search, and BOPIS inventory visibility for online customers. Integrates with HCL Commerce platform to provide product data and store inventory information.
- **Interface Contracts**: ifc-product-catalog-api, ifc-store-locator-api, ifc-inventory-visibility-api
- **Component Specs**: `architecture/solution/domain-handoffs/ecommerce/component-specs.yml`

### Inventory Domain
- **Description**: Manages product inventory across stores, handles real-time reservations, and synchronizes inventory with external systems.
- **Interface Contracts**: ifc-inventory-management-api, ifc-inventory-reservation-api, ifc-inventory-sync-event
- **Component Specs**: `architecture/solution/domain-handoffs/inventory/component-specs.yml`

### Order Domain
- **Description**: Manages BOPIS order lifecycle from placement through pickup completion. Handles order status tracking and customer queries.
- **Interface Contracts**: ifc-order-management-api, ifc-order-status-api, ifc-order-status-event
- **Component Specs**: `architecture/solution/domain-handoffs/order/component-specs.yml`

### Party Role Management Domain
- **Description**: Manages store associate interface for order fulfillment and pickup processing. Handles QR code verification and order completion.
- **Interface Contracts**: ifc-fulfillment-api, ifc-pickup-api, ifc-pickup-event
- **Component Specs**: `architecture/solution/domain-handoffs/party-role/component-specs.yml`

### Notification Domain
- **Description**: Manages customer notifications for order readiness and pickup instructions via email and SMS.
- **Interface Contracts**: ifc-notification-api
- **Component Specs**: `architecture/solution/domain-handoffs/notification/component-specs.yml`

### Domain Decomposition Diagram

```mermaid
graph TB
    subgraph "Ecommerce Domain"
        EC1[Product Catalog]
        EC2[Store Locator]
        EC3[Inventory Visibility]
    end

    subgraph "Inventory Domain"
        IV1[Inventory Management]
        IV2[Reservation Service]
        IV3[Sync Service]
    end

    subgraph "Order Domain"
        OR1[Order Management]
        OR2[Order Status]
    end

    subgraph "Party Role Domain"
        PR1[Fulfillment API]
        PR2[Pickup Service]
        PR3[QR Verification]
    end

    subgraph "Notification Domain"
        NT1[Notification Service]
        NT2[Template Manager]
    end

    EC3 <-->|API| IV1
    OR1 <-->|API| IV2
    PR1 <-->|API| OR1
    PR2 <-->|API| OR1
    NT1 <-->|Event| OR2

    IV3 -.->|Event| EC3
    IV3 -.->|Event| OR1
    OR2 -.->|Event| PR1
    OR2 -.->|Event| NT1
    PR2 -.->|Event| OR1
```

### Cross-Cutting Concerns

```mermaid
graph TB
    subgraph "Cross-Cutting Concerns"
        CC1[Authentication<br/>JWT, mTLS]
        CC2[Authorization<br/>Role-Based Access]
        CC3[Observability<br/>Metrics, Logging, Tracing]
        CC4[Security<br/>Encryption, Compliance]
        CC5[Resilience<br/>Circuit Breaker, Retry]
    end

    subgraph "Domains"
        EC[Ecommerce]
        IV[Inventory]
        OR[Order]
        PR[Party Role]
        NT[Notification]
    end

    CC1 --> EC
    CC1 --> IV
    CC1 --> OR
    CC1 --> PR
    CC1 --> NT

    CC2 --> EC
    CC2 --> IV
    CC2 --> OR
    CC2 --> PR
    CC2 --> NT

    CC3 --> EC
    CC3 --> IV
    CC3 --> OR
    CC3 --> PR
    CC3 --> NT

    CC4 --> EC
    CC4 --> IV
    CC4 --> OR
    CC4 --> PR
    CC4 --> NT

    CC5 --> EC
    CC5 --> IV
    CC5 --> OR
    CC5 --> PR
    CC5 --> NT
```

## 5. NFR Budget Allocation

### Per-Tier Budgets

| Tier | Latency Budget | Availability | Throughput (RPS) | Cost Envelope |
|------|----------------|-------------|------------------|---------------|
| API Gateway | 100ms | 99.9% | 1000 | M |
| Application Services | 200ms | 99.5% | 500 | L |
| Data Layer | 50ms | 99.9% | 1000 | XL |
| External Integrations | 500ms | 95.0% | 100 | M |

### NFR Budget Distribution Diagram

```mermaid
graph TB
    subgraph "NFR Budget Allocation"
        GW[API Gateway<br/>Latency: 100ms<br/>Avail: 99.9%<br/>Throughput: 1000 RPS<br/>Cost: M]
        AS[Application Services<br/>Latency: 200ms<br/>Avail: 99.5%<br/>Throughput: 500 RPS<br/>Cost: L]
        DL[Data Layer<br/>Latency: 50ms<br/>Avail: 99.9%<br/>Throughput: 1000 RPS<br/>Cost: XL]
        EI[External Integrations<br/>Latency: 500ms<br/>Avail: 95.0%<br/>Throughput: 100 RPS<br/>Cost: M]
    end

    subgraph "End-to-End Targets"
        ET1[Checkout: < 2 min]
        ET2[Inventory Sync: < 30 sec]
        ET3[Associate UI: < 3 sec]
        ET4[Notification: < 2 min]
        ET5[Availability: 99.5%]
    end

    GW --> ET5
    AS --> ET5
    DL --> ET5
    EI -.->|Non-Critical Path| ET5

    GW --> AS
    AS --> DL
    DL --> ET1
    AS --> ET3
    AS --> EI
    EI -.-> ET2
    AS --> ET4
```

## 6. TMF Alignment

### ODA Components

| Name | ODA Component ID | ODA Component | Functional Block | Confidence | Validation Status |
|------|------------------|---------------|-----------------|------------|-------------------|
| Product Catalog Management | TMFC001 | ProductCatalogManagement | CoreCommerce | mcp_verified | verified |
| Product Inventory Management | TMFC005 | ProductInventory | CoreCommerce | mcp_verified | verified |
| Order Management | TMFC003 | OrderManagement | Fulfillment | mcp_verified | verified |
| Party Role Management | TMFC006 | PartyRoleManagement | Fulfillment | local_knowledge | not_mapped |

### Open APIs

| ID | Version | API Name | Confidence | Validation Status |
|----|---------|----------|------------|-------------------|
| TMF620 | - | Product, ProductOffering | mcp_verified | verified |
| TMF637 | - | Product Inventory | mcp_verified | verified |
| TMF629 | - | Party Role | mcp_verified | verified |

### SID Entities

| Domain | Entity Name | ABE | Confidence | Validation Status |
|--------|-------------|-----|------------|-------------------|
| Order | CustomerProductOrder | Customer Product Order ABE | mcp_verified | verified |
| Order | CustomerProductOrderItem | Customer Product Order ABE | mcp_verified | verified |
| Order | BusinessPartnerProductOrderItem | Business Partner Product Order ABE | mcp_verified | verified |
| Ecommerce | ProductOrder | Product Order ABE | mcp_verified | verified |
| Inventory | ProductInventory | Product Inventory ABE | mcp_verified | verified |

### eTOM Processes by Domain

#### Ecommerce Domain
- 1.2.7.2.3 - Product Offering Cataloging (Level 4, Product Domain)
- 1.3.1.2.1 - Support Customer Order Management (Level 3, Customer Domain)
- 1.2.7.2.3.2 - Product Offering Lifecycle Management (Level 6, Product Domain)
- 1.2.7.2.2 - Associate Product Offering with Product Offering Catalog (Level 6, Product Domain)

#### Inventory Domain
- 1.2.11 - Product Inventory Management (Level 2, Product Domain)
- 1.2.11.4 - Ensure Product Inventory Quality (Level 3, Product Domain)
- 1.7.10.2.3 - Develop Stock/Inventory Management Policy (Level 4, Enterprise Domain)
- 1.7.5.4.4 - Managing inventory Transactions (Level 4, Enterprise Domain)
- 1.7.10.5.1 - Manage Inventory (Level 4, Enterprise Domain)

#### Order Domain
- 1.3.1.2 - Support Customer Order Management (Level 3, Customer Domain)
- 1.3.3.18.1 - Define Customer Order Policy (Level 4)
- 1.3.3.16 - Manage Customer Order Management Report (Level 3)
- 1.3.3.10 - Manage Customer Order Placement (Level 3)
- 1.3.20 - Customer Lifecycle Management (Level 2)

#### Fulfillment (Party Role) Domain
- 1.5.5.8 - Manage Resource Order Fulfillment (Level 3, Resource Domain)
- 1.3.3.12 - Manage Customer Order Fulfillment (Level 3)
- 1.7.10.6 - Manage Fulfillment (Level 3, Enterprise Domain)
- 1.3.19.3.2 - Deliver Customer Order Carry Through Capability (Level 4)
- 1.6.8.4.2 - Accept Business Partner Order (Level 4, Business Partner Domain)

### TMF Alignment Diagram

```mermaid
graph TB
    subgraph "ODA Components"
        ODA1[Product Catalog Management<br/>TMFC001]
        ODA2[Product Inventory Management<br/>TMFC005]
        ODA3[Order Management<br/>TMFC003]
        ODA4[Party Role Management<br/>TMFC006]
    end

    subgraph "Open APIs"
        API1[TMF620<br/>Product, ProductOffering]
        API2[TMF637<br/>Product Inventory]
        API3[TMF629<br/>Party Role]
    end

    subgraph "SID Entities"
        SID1[CustomerProductOrder]
        SID2[CustomerProductOrderItem]
        SID3[BusinessPartnerProductOrderItem]
        SID4[ProductOrder]
        SID5[ProductInventory]
    end

    subgraph "Solution Domains"
        SD1[Ecommerce]
        SD2[Inventory]
        SD3[Order]
        SD4[Party Role]
    end

    ODA1 --> SD1
    ODA2 --> SD2
    ODA3 --> SD3
    ODA4 --> SD4

    API1 --> SD1
    API1 --> SD3
    API2 --> SD2
    API3 --> SD4

    SID4 --> SD1
    SID5 --> SD2
    SID1 --> SD3
    SID2 --> SD3
    SID3 --> SD3
```

### TMF Validation Status

- **Validation Plan**: `architecture/solution/tmf-validation-plan.md`
- **Validation Status**: mcp_verified
- **Validation Date**: 2025-02-27

## 7. Architecture Decisions

### ADR-001: Architecture Pattern - Microservices with API-First and Event-Driven Design

**Status**: Proposed

**Context**: BOPIS requires real-time inventory visibility, order tracking across multiple systems (HCL Commerce, POS, inventory management), and low-latency customer/associate interfaces. Requirements specify 30-second inventory sync, 2-minute checkout, and support for 1,000 orders/day.

**Decision**: Adopt microservices architecture with API-first contracts between domains and event-driven synchronization for inventory and order state changes. Five domains (Ecommerce, Inventory, Order, Fulfillment, Notification) provide clear ownership boundaries and enable independent scaling.

**Consequences**:
- **Benefits**: Independent development/deployment per domain, clear ownership, better scalability
- **Trade-offs**: Increased operational complexity, requires robust API governance and event schema management

**Alternatives**:
- Monolithic application: Simpler deployment but harder to scale and maintain with multiple integration points
- Modular monolith: Middle ground but still has shared deployment and scaling constraints

---

### ADR-002: Inventory Synchronization Strategy - Event-Driven with Atomic Reservations

**Status**: Proposed

**Context**: Requirements specify inventory must reflect within 30 seconds of reservation and handle concurrent reservations without race conditions. 1,000 orders/day with peak loads require accurate inventory visibility.

**Decision**: Use atomic database transactions for inventory reservation at order placement, followed by event-driven synchronization to propagate inventory changes to all channels. Events published to event bus for real-time updates to Ecommerce, Order, and external systems.

**Consequences**:
- **Benefits**: Strong consistency for reservations, real-time channel updates, no overselling
- **Trade-offs**: Eventual consistency for channel sync, requires idempotent event consumers and replay capability

**Alternatives**:
- Polling sync: Simpler but higher latency and resource usage
- Direct API calls: Tight coupling, no decoupling, cascading failures

---

### ADR-003: Customer Verification - QR Code Only

**Status**: Proposed

**Context**: Requirements specify QR code only verification for BOPIS pickup. No additional ID or phone verification required. This balances security with customer convenience.

**Decision**: Generate unique QR code per order containing order identifier and cryptographic signature. Store associates scan QR code via tablet app to validate order and complete pickup.

**Consequences**:
- **Benefits**: Fast pickup experience, minimal customer friction, secure verification
- **Trade-offs**: Requires secure QR code generation and verification logic, lost device handling process needed

**Alternatives**:
- Order number + phone verification: More verification steps but no device requirement
- Government ID verification: Stronger security but poor customer experience

### ADR Decision Flow Diagram

```mermaid
graph TB
    subgraph "ADR-001: Architecture Pattern"
        A1[Context: Real-time needs<br/>30s sync, 2min checkout]
        A2[Decision: Microservices +<br/>API-First + Event-Driven]
        A3[Consequences: Independent<br/>scaling, operational complexity]
    end

    subgraph "ADR-002: Inventory Sync"
        B1[Context: 30s visibility,<br/>concurrent reservations]
        B2[Decision: Atomic reservations +<br/>event-driven channel sync]
        B3[Consequences: Strong consistency,<br/>eventual channel sync]
    end

    subgraph "ADR-003: Customer Verification"
        C1[Context: QR code only<br/>requirement]
        C2[Decision: Cryptographic QR<br/>code per order]
        C3[Consequences: Fast pickup,<br/>lost device handling]
    end

    A2 --> B2
    B2 --> C2

    A2 -->|Enables| B2
    B2 -->|Enables| A2

    style A2 fill:#90EE90
    style B2 fill:#90EE90
    style C2 fill:#90EE90
```

## 8. Mermaid Diagrams

### BOPIS Customer Journey

```mermaid
sequenceDiagram
    participant C as Customer
    participant SF as Store Frontend
    participant EC as Ecommerce Domain
    participant IV as Inventory Domain
    participant OR as Order Domain
    participant PR as Party Role Domain
    participant NT as Notification Domain
    participant SA as Store Associate

    C->>SF: Browse Products
    SF->>EC: Get Product Catalog
    EC-->>SF: Product Details
    SF-->>C: Display Products

    C->>SF: Select Store & Check Availability
    SF->>EC: Get Store Inventory
    EC->>IV: Query Store Inventory
    IV-->>EC: Stock Level
    EC-->>SF: Availability
    SF-->>C: Show Availability

    C->>SF: Place BOPIS Order
    SF->>OR: Create Order
    OR->>IV: Reserve Inventory
    IV-->>OR: Reservation Confirmed
    OR->>OR: Create Order
    OR-->>SF: Order Confirmed
    SF-->>C: Order Confirmation with QR Code

    OR->>NT: Order Status Event (RECEIVED)
    NT-->>C: Order Confirmation Email

    SA->>PR: View Pending Orders
    PR-->>SA: Order List
    SA->>PR: Start Picking
    PR->>PR: Update Status (PICKING)
    PR->>PR: Update Status (READY)
    PR->>NT: Order Status Event (READY)
    NT-->>C: Pickup Ready Notification

    C->>SA: Present QR Code
    SA->>PR: Scan QR Code
    PR->>PR: Verify Order
    PR-->>SA: Order Valid
    SA->>PR: Complete Pickup
    PR->>OR: Order Status Event (PICKED_UP)
    PR->>NT: Pickup Event
    NT-->>C: Order Completed
```

### Component Interaction Diagram

```mermaid
graph TB
    subgraph "Ecommerce Domain"
        direction TB
        EC_API[Product Catalog API<br/>ifc-product-catalog-api]
        EC_LOC[Store Locator API<br/>ifc-store-locator-api]
        EC_INV[Inventory Visibility API<br/>ifc-inventory-visibility-api]
    end

    subgraph "Inventory Domain"
        direction TB
        IV_MGMT[Inventory Management API<br/>ifc-inventory-management-api]
        IV_RES[Reservation API<br/>ifc-inventory-reservation-api]
        IV_SYNC[Inventory Sync Event<br/>ifc-inventory-sync-event]
    end

    subgraph "Order Domain"
        direction TB
        OR_MGMT[Order Management API<br/>ifc-order-management-api]
        OR_STATUS[Order Status API<br/>ifc-order-status-api]
        OR_EVT[Order Status Event<br/>ifc-order-status-event]
    end

    subgraph "Party Role Domain"
        direction TB
        PR_FUL[Fulfillment API<br/>ifc-fulfillment-api]
        PR_PICK[Pickup API<br/>ifc-pickup-api]
        PR_EVT[Pickup Event<br/>ifc-pickup-event]
    end

    subgraph "Notification Domain"
        direction TB
        NT_API[Notification API<br/>ifc-notification-api]
    end

    subgraph "External Systems"
        direction TB
        HCL[HCL Commerce Integration]
        POS[POS Integration]
        IMS[Inventory System Integration]
    end

    EC_INV <--> IV_MGMT
    OR_MGMT <--> IV_RES
    OR_MGMT <--> EC_API
    PR_FUL <--> OR_STATUS
    PR_PICK <--> OR_MGMT
    NT_API <--> OR_EVT

    IV_SYNC -.-> EC_INV
    IV_SYNC -.-> OR_STATUS
    OR_EVT -.-> PR_FUL
    OR_EVT -.-> NT_API
    PR_EVT -.-> OR_MGMT

    EC_API <--> HCL
    OR_MGMT <--> HCL
    PR_PICK <--> POS
    IV_MGMT <--> IMS
```

---

*This architecture design document is generated from the machine-authoritative YAML file at `architecture/solution/architecture-design.yml` and should be regenerated when the source YAML changes.*

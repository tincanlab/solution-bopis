# ADR-001: Architecture Pattern - Microservices with API-First and Event-Driven Design

## Status

**Proposed**

## Context

BOPIS requires real-time inventory visibility, order tracking across multiple systems (HCL Commerce, POS, inventory management), and low-latency customer/associate interfaces. Requirements specify:
- 30-second inventory sync latency
- 2-minute checkout completion
- Support for 1,000 BOPIS orders/day
- 99.5% uptime during store hours (8am-10pm)

The system must integrate with multiple external systems while maintaining high availability and scalability.

## Decision

Adopt microservices architecture with API-first contracts between domains and event-driven synchronization for inventory and order state changes. Five domains (Ecommerce, Inventory, Order, Fulfillment, Notification) provide clear ownership boundaries and enable independent scaling.

### Architecture Pattern Details

- **Microservices**: Each domain (Ecommerce, Inventory, Order, Fulfillment, Notification) deployed as independent services with separate data stores
- **API-First**: All inter-domain and external integrations use REST APIs with well-defined contracts (interface-contracts.yml)
- **Event-Driven**: Inventory reservations, order state changes, and notifications propagate asynchronously via event bus for real-time updates
- **CQRS**: Order domain separates read (customer queries) and write (order placement) operations for performance optimization

### Domain Decomposition

| Domain | Primary Function | Key Interfaces |
|---------|------------------|------------------|
| Ecommerce | Product catalog, store search, inventory visibility | Product Catalog API, Store Locator API |
| Inventory | Inventory reservations, synchronization | Inventory Management API, Inventory Sync Event |
| Order | Order lifecycle, status tracking | Order Management API, Order Status Event |
| Fulfillment | Store associate operations, pickup processing | Fulfillment API, Pickup API, Pickup Event |
| Notification | Email/SMS notifications | Notification API |

## Consequences

### Benefits

1. **Independent Development/Deployment**: Each domain team can develop, test, and deploy independently
2. **Clear Ownership**: Each domain has defined boundaries and responsibilities
3. **Scalability**: Individual domains can scale based on load patterns (e.g., high checkout traffic scales Order domain)
4. **Resilience**: Failure in one domain does not cascade to others due to event-driven decoupling
5. **Performance**: Event-driven inventory sync enables real-time updates without blocking customer transactions

### Trade-offs

1. **Operational Complexity**: Managing 5+ microservices requires observability, monitoring, and deployment automation
2. **API Governance**: Requires disciplined interface contract management and versioning
3. **Event Schema Management**: Event-driven architecture requires careful schema design and backward compatibility
4. **Eventual Consistency**: Channel updates via events are eventually consistent (within 30 seconds SLA)
5. **Distributed Transactions**: Cross-domain operations (order creation with inventory reservation) require distributed transaction patterns

## Alternatives Considered

### 1. Monolithic Application

**Description**: Single application containing all BOPIS functionality in one codebase.

**Pros**:
- Simpler deployment and operations
- Easier data transactions (single database)
- Lower operational overhead

**Cons**:
- Harder to scale individual components
- Single point of failure affects all domains
- Tight coupling between business functions
- Difficult to allocate ownership across teams

**Rejected**: Monolith cannot meet 1,000 orders/day throughput and 99.5% availability requirements without costly over-engineering.

### 2. Modular Monolith

**Description**: Single application with modular code organization but shared deployment and data layer.

**Pros**:
- Middle ground between monolith and microservices
- Simpler than full microservices
- Some decoupling benefits

**Cons**:
- Still has shared deployment and scaling constraints
- Teams share deployment pipeline
- Database contention at high load

**Rejected**: Modular monolith still has scaling bottlenecks that microservices avoid.

### 3. Service-Oriented Architecture (SOA)

**Description**: Coarse-grained services with shared infrastructure and ESB (Enterprise Service Bus).

**Pros**:
- Proven enterprise pattern
- Centralized governance via ESB

**Cons**:
- ESB single point of failure and performance bottleneck
- Tight coupling through ESB
- Vendor lock-in to ESB technology
- Slow event propagation through ESB

**Rejected**: Event-driven microservices with direct API communication provides better performance and lower latency.

## References

- Requirements: architecture/requirements/requirements.yml
- Interface Contracts: architecture/solution/interface-contracts.yml
- Component Specs: architecture/solution/domain-handoffs/*/component-specs.yml

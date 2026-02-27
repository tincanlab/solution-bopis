# ADR-002: Inventory Synchronization Strategy - Event-Driven with Atomic Reservations

## Status

**Proposed**

## Context

Requirements specify:
- Inventory must reflect within 30 seconds of reservation
- Handle concurrent reservations without race conditions
- 1,000 orders/day with peak loads requiring accurate inventory visibility
- Prevent overselling across channels

The inventory domain must integrate with external inventory management systems while maintaining real-time visibility across online and in-store channels.

## Decision

Use atomic database transactions for inventory reservation at order placement, followed by event-driven synchronization to propagate inventory changes to all channels. Events published to event bus for real-time updates to Ecommerce, Order, and external systems.

### Synchronization Flow

1. **Reservation (Atomic)**:
   - Order domain calls Inventory Management API to reserve stock
   - Inventory Management uses atomic database transaction with row-level locking
   - On success: Stock reserved, Inventory Sync Event published
   - On failure: Transaction rolled back, error returned to Order domain

2. **Synchronization (Event-Driven)**:
   - Inventory Sync Event contains: store_id, product_sku, quantity, event_type (RESERVED/RELEASED/ADJUSTED), order_id
   - Event published to message bus with partition_key = product_sku
   - Ecommerce domain consumes events to update inventory visibility on storefront
   - External inventory management system consumes events for stock adjustments
   - Event retention: 7 days with replay capability for recovery

3. **Cancellations and Adjustments**:
   - Order cancellation triggers inventory release event
   - External inventory adjustments (stock-in, stock-out) trigger inventory adjustment events
   - All events consumed by Ecommerce for channel updates

### Consistency Model

- **Strong Consistency**: Inventory reservation is strongly consistent (atomic transaction)
- **Eventual Consistency**: Channel visibility updates via events (within 30-second SLA)
- **Idempotency**: Event consumers use event_id for deduplication
- **Replay**: Event bus supports message replay for recovery scenarios

## Consequences

### Benefits

1. **No Overselling**: Atomic reservations with row-level locks prevent race conditions
2. **Real-Time Channel Sync**: Events propagate inventory changes within 30-second SLA
3. **Decoupling**: Ecommerce, external systems consume events without direct API dependency
4. **Resilience**: Event bus provides buffering and replay for consumer failures
5. **Scalability**: Event consumers scale independently based on load

### Trade-offs

1. **Eventual Consistency**: Channel updates are eventually consistent (acceptable within 30-second SLA)
2. **Event Schema Complexity**: Requires careful schema design and backward compatibility
3. **Duplicate Processing**: Event consumers must handle idempotency correctly
4. **Event Bus Dependency**: Failure in event bus affects channel updates but not reservations
5. **Monitoring Complexity**: Requires event bus monitoring (backlog, consumer lag, DLQ)

## Alternatives Considered

### 1. Polling Sync

**Description**: Inventory domain periodically queries external systems for stock levels and updates local cache.

**Pros**:
- Simpler implementation
- No event bus dependency
- Easier debugging

**Cons**:
- Higher latency (polling interval, typically 1-5 minutes)
- Resource intensive at scale (continuous queries)
- Stale data between polls
- Cannot meet 30-second sync SLA

**Rejected**: Polling cannot meet real-time visibility requirements and is resource inefficient.

### 2. Direct API Calls

**Description**: Ecommerce domain calls Inventory Management API directly for each inventory query.

**Pros**:
- Real-time data (no sync latency)
- Simple point-to-point integration

**Cons**:
- Tight coupling between domains
- Cascading failures (Inventory down = Ecommerce down)
- No decoupling benefit
- Harder to scale consumers independently

**Rejected**: Tight coupling and cascading failures violate resilience requirements.

### 3. Two-Phase Commit (2PC)

**Description**: Distributed transaction protocol with prepare/commit phases across Inventory and Order domains.

**Pros**:
- Strong consistency across domains
- No eventual consistency

**Cons**:
- Complex implementation
- Performance overhead (multiple round trips)
- Locks held longer during coordination
- Blocking coordination affects throughput
- Single point of failure (coordinator)

**Rejected**: 2PC adds complexity and performance overhead that event-driven pattern avoids while meeting requirements.

## References

- Requirements: nfr-inventory-sync, nfr-throughput
- Interface: ifc-inventory-sync-event
- Component: architecture/solution/domain-handoffs/inventory/component-specs.yml

# BOPIS Solution Architecture

Solution architecture repo for the Buy Online, Pick Up In Store (BOPIS) initiative.

## Expected Layout

```
SOLUTION.md                                        <- you are here
AGENTS.md                                          <- repo-specific agent instructions
VISION.md                                          <- solution intent and target outcomes
ROADMAP.md                                         <- implementation phases
solution-index.yml                                 <- machine-authoritative scope manifest
architecture/
|-- requirements/
|   `-- requirements.yml                           <- requirements baseline
|   `-- requirements.md                            <- narrative requirements
|   `-- stakeholders.yml                           <- stakeholder map
|-- solution/
|   |-- architecture-design.yml                    <- solution architecture baseline
|   |-- interface-contracts.yml                    <- canonical interfaces
|   `-- domain-handoffs/
|       |-- ecommerce/
|       |   `-- component-specs.yml            <- SA-to-DA handoff
|       |-- inventory/
|       |   `-- component-specs.yml            <- SA-to-DA handoff
|       |-- order/
|       |   `-- component-specs.yml            <- SA-to-DA handoff
|       |-- fulfillment/
|       |   `-- component-specs.yml            <- SA-to-DA handoff
|       `-- notification/
|           `-- component-specs.yml            <- SA-to-DA handoff
`-- adr/                                         <- architecture decision records
    `-- adr-001-architecture-patterns.md
    `-- adr-002-integration-strategy.md
    ...
```

## Scope

- **Solution key**: bopis
- **Owners**: SA: Zhong, Domains: Ecommerce, Inventory, Order, Fulfillment, Notification
- **Initiative**: init-bopis - Buy Online, Pick Up In Store
- **Status**: Solution Architecture Design in Progress

## Domains

This solution decomposes into 5 domains:

| Domain | ODA Component | TMF APIs | Repo | Status |
|---------|---------------|------------|--------|--------|
| Ecommerce | Product Catalog Management | TMF620 (Product, ProductOffering) | TBD | To be created |
| Inventory | Product Inventory Management | TMF637 (ProductInventory) | TBD | To be created |
| Order | Order Management | TMF620 (CustomerOrder) | TBD | To be created |
| Party Role Management | Party Role Management | TMF629 (PartyRole) | TBD | To be created |
| Notification | Notification Service | Custom | TBD | To be created |

## Adjacent Entrypoints

- `ENTERPRISE.md` in EA repo (upstream portfolio context)
- `DOMAIN.md` + `AGENTS.md` in each domain repo (downstream domain context)

## Quick Links

- [Requirements Baseline](architecture/requirements/requirements.md)
- [Requirements Report](architecture/requirements/requirements_report.md)
- [Stakeholder Map](architecture/requirements/stakeholders.md)
- [Architecture Design](architecture/solution/architecture-design.yml)
- [Interface Contracts](architecture/solution/interface-contracts.yml)

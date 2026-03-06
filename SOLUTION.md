# BOPIS Solution Architecture

Solution architecture repo for the Buy Online, Pick Up In Store (BOPIS) initiative.

## Read First

1. This file — solution context and navigation
2. [AGENTS.md](AGENTS.md) — repo-specific agent instructions
3. [solution-index.yml](solution-index.yml) — machine-authoritative scope manifest

## Parent

- [ENTERPRISE.md](<enterprise-repo-url>/blob/main/ENTERPRISE.md)
- If enterprise level is absent, replace with `Not applicable`.

## Critical File Contract

- Keep required section headings from this template.
- Do not rename or delete required sections.
- Keep this file concise: identity, routing semantics, and links.
- Put detailed/mutable operational values in canonical artifacts and link them here.
- If a required section has no content, keep it and write `Not applicable`.

## Knowledge Store Layout

```
SOLUTION.md                                        <- you are here
AGENTS.md                                          <- repo-specific agent instructions
VISION.md                                          <- solution intent and target outcomes
ROADMAP.md                                         <- implementation phases
solution-index.yml                                 <- machine-authoritative scope manifest
architecture/
|-- requirements/
|   |-- requirements.yml                           <- requirements baseline
|   |-- requirements.md                            <- narrative requirements
|   `-- stakeholders.yml                           <- stakeholder map
|-- solution/
|   |-- architecture-design.yml                    <- solution architecture baseline
|   |-- interface-contracts.yml                    <- canonical interfaces
|   |-- domain-workstreams.yml                     <- workstream selector catalog (WORKSTREAM_ID routing)
|   |-- domain-handoffs/
|   |   |-- ecommerce/component-specs.yml          <- SA-to-DA handoff
|   |   |-- inventory/component-specs.yml          <- SA-to-DA handoff
|   |   |-- order/component-specs.yml              <- SA-to-DA handoff
|   |   |-- party-role/component-specs.yml         <- SA-to-DA handoff
|   |   `-- notification/component-specs.yml       <- SA-to-DA handoff
|   `-- adr/                                       <- architecture decision records
|       |-- adr-001-architecture-patterns.md
|       |-- adr-002-inventory-sync-strategy.md
|       `-- adr-003-verification-strategy.md
`-- domains/
    `-- <domain_id>/
        `-- component-specs.yml                    <- (optional, co-located domain specs)
```

## Canonical Artifacts

- `solution-index.yml` (machine-authoritative solution scope and repo mapping)
- `architecture/solution/architecture-design.yml` (structured solution architecture)
- `architecture/solution/interface-contracts.yml` (canonical interfaces)
- `architecture/solution/domain-workstreams.yml` (workstream routing selector)
- `architecture/requirements/requirements.yml` (requirements baseline)

## Routing

`WORKSTREAM_ID` → `architecture/solution/domain-workstreams.yml` → `domain_id` + `workstream_entrypoint` + `workstream_git_ref`

## SA Container Context

When running in an SA container (`OPENARCHITECT_CONTAINER_ROLE=sa`), startup routing can write:
- `.openarchitect/active-initiative.json`

This file is a required initiative context reference and should be treated as the machine-readable source for active initiative routing context.

At minimum, `SOLUTION.md` should reference values from `.openarchitect/active-initiative.json` for:
- `initiative_id`
- `solution_repo_url`
- initiative name/description/objectives (when present)
- selector provenance (when present)

If `.openarchitect/active-initiative.json` is missing, explicitly state that initiative context could not be resolved from runtime routing metadata.

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
- [Stakeholder Map](architecture/requirements/stakeholders.yml)
- [Architecture Design](architecture/solution/architecture-design.yml)
- [Interface Contracts](architecture/solution/interface-contracts.yml)
- [Domain Workstreams](architecture/solution/domain-workstreams.yml)

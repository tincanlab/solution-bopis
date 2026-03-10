# BOPIS Solution Architecture

Solution architecture repo for the Buy Online, Pick Up In Store (BOPIS) initiative.

## Read First

1. This file - solution context and navigation
2. [AGENTS.md](AGENTS.md) - repo-specific agent instructions
3. [solution-index.yml](solution-index.yml) - machine-authoritative scope manifest
4. For point lookups by `domain_key`, prefer `python scripts/domain_info_cli.py <domain_key>` instead of reading the full `solution-index.yml`.

## Parent

- Not applicable

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
solution-index.yml                                 <- canonical machine-readable scope manifest; for single-domain lookup prefer `python scripts/domain_info_cli.py <domain_key>`
scripts/
`-- domain_info_cli.py                             <- preferred domain lookup interface for agents and automation
architecture/
|-- portfolio/
|   `-- initiatives.yml                            <- initiative selector catalog
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
- `architecture/portfolio/initiatives.yml` (initiative routing selector)
- `architecture/solution/architecture-design.yml` (structured solution architecture)
- `architecture/solution/interface-contracts.yml` (canonical interfaces)
- `architecture/solution/domain-workstreams.yml` (workstream routing selector)
- `architecture/requirements/requirements.yml` (requirements baseline)

## Agent Retrieval Guidance

- `solution-index.yml` remains the canonical source of truth.
- For retrieval of a single domain by `domain_key`, agents should prefer `python scripts/domain_info_cli.py <domain_key>` rather than loading the entire `solution-index.yml`.
- Read `solution-index.yml` directly only when validating schema, inspecting multiple domains, or making structural edits.

## Routing

`INITIATIVE_ID` -> `architecture/portfolio/initiatives.yml` -> `solution_repo_url` + `solution_entrypoint`

`WORKSTREAM_ID` -> `architecture/solution/domain-workstreams.yml` -> `domain_id` + `workstream_entrypoint` + `workstream_git_ref`

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
- **Owners**: SA: Zhong, Domains: Ecommerce, Inventory, Order, Party Role, Notification
- **Initiative**: init-bopis - Buy Online, Pick Up In Store
- **Status**: Solution Architecture Design in Progress

## Domains

This solution decomposes into 5 domains:

| Domain | ODA Component | TMF APIs | Repo | Status |
|---------|---------------|----------|------|--------|
| Ecommerce | Product Catalog Management | TMF620 (Product, ProductOffering) | TBD | To be created |
| Inventory | Product Inventory Management | TMF637 (ProductInventory) | TBD | To be created |
| Order | Order Management | TMF622 (ProductOrder) | TBD | To be created |
| Party Role Management | Party Role Management | TMF669 (PartyRole) | TBD | To be created |
| Notification | Notification Service | Custom | TBD | To be created |

## Adjacent Entrypoints

- `ENTERPRISE.md` in EA repo (upstream portfolio context)
- `DOMAIN.md` + `AGENTS.md` in each domain repo (downstream domain context)

## Quick Links

- [Requirements Baseline](architecture/requirements/requirements.md)
- [Requirements Report](architecture/requirements/requirements_report.md)
- [Stakeholder Map](architecture/requirements/stakeholders.yml)
- [Initiatives Selector](architecture/portfolio/initiatives.yml)
- [Architecture Design](architecture/solution/architecture-design.yml)
- [Interface Contracts](architecture/solution/interface-contracts.yml)
- [Domain Workstreams](architecture/solution/domain-workstreams.yml)

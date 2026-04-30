# Stakeholder Mapping Report - BOPIS Initiative

## 1. Workspace Resolution

- **Initiative ID**: init-bopis
- **Initiative Name**: Buy Online, Pick Up In Store
- **Workspace Context**: Loaded from `architecture/requirements/stakeholders.yml`
- **Cascade State**: requirements ready_for_advancement_review

## 2. Stakeholder Discovery Phase

### Stakeholders Identified (9 total)

| ID | Name | Role | Type | Organization | Status |
|----|------|------|------|-------------|--------|
| stakeholder-001 | Zhong | Solution Architect | technical | IT | active |
| stakeholder-002 | Nestor | Product Owner | business | Product | active |
| stakeholder-003 | VP Retail | Business Sponsor | business | Retail Operations | active |
| stakeholder-004 | E-commerce Team | Integration Partner | technical | IT | active |
| stakeholder-005 | Retail Operations Team | Operations Partner | business | Retail Operations | active |
| stakeholder-006 | Supply Chain Team | Integration Partner | technical | Supply Chain | active |
| stakeholder-007 | Legal and Security Team | Compliance Reviewer | governance | Legal & Security | active |
| stakeholder-008 | Infrastructure Team | Infrastructure Provider | technical | IT Infrastructure | active |
| stakeholder-009 | PM Team Retail | Project Manager | management | Program Management | active |

✅ **Quality Check**: All stakeholders are concrete (names/roles), not generic.

## 3. Influence Phase - Concerns & Decision Rights

### Decision Rights Matrix (RACI)

| Decision Gate | R | A | C | I |
|---------------|---|---|---|---|
| Requirements Baseline Approval | stakeholder-001, stakeholder-002 | stakeholder-003 | stakeholder-004, stakeholder-005, stakeholder-006 | stakeholder-007 |
| Architecture Design Review | stakeholder-001 | stakeholder-004, stakeholder-006 | stakeholder-002, stakeholder-005 | stakeholder-007, stakeholder-008 |
| Phase 1 Go-Live Decision | stakeholder-002 | stakeholder-003, stakeholder-009 | stakeholder-001, stakeholder-005 | stakeholder-007 |
| Compliance Review | stakeholder-007 | stakeholder-007 | stakeholder-001, stakeholder-002 | stakeholder-003 |
| Technical Architecture Decisions | stakeholder-001 | stakeholder-004, stakeholder-006, stakeholder-008 | stakeholder-002, stakeholder-005 | stakeholder-007 |

### Concerns Captured

| Stakeholder | Key Concerns |
|-------------|---------------|
| Zhong (SA) | Architecture patterns alignment, technical feasibility, scalability, resiliency |
| Nestor (PO) | Customer experience, time-to-market, business value, ROI |
| VP Retail | Operational impact, store associate adoption, ROI, business outcomes |
| E-commerce Team | HCL Commerce impact, API performance, data consistency |
| Retail Operations | Store operations impact, associate training, operational efficiency |
| Supply Chain | Inventory accuracy, real-time sync, inventory processes |
| Legal/Security | PCI DSS/GDPR/CCPA compliance, data privacy, liability |
| Infrastructure | Scalability, store network reliability, DR/backup |
| PM Team | On-time delivery, cross-functional coordination, resource allocation |

✅ **Quality Check**: At least one explicit architecture decision gate identified (4 gates defined).

## 4. Engagement Phase

### Engagement Cadence

| Stakeholder | Engagement Channel | Frequency | Notes |
|-------------|-------------------|-----------|-------|
| Zhong (SA) | Lead solution architecture, review technical designs, coordinate with domain teams | Weekly | Primary technical decision maker |
| Nestor (PO) | Define requirements, review user stories, manage backlog | Weekly | Primary product decision maker |
| VP Retail | Executive sponsorship, approve business case/budget | Monthly | Executive sponsor |
| E-commerce Team | Provide API docs, support integration development | As-needed | Critical dependency |
| Retail Operations | Define store processes, coordinate training/rollout | Bi-weekly | Critical for store adoption |
| Supply Chain | Provide inventory system docs, define sync requirements | As-needed | Critical for inventory accuracy |
| Legal/Security | Review compliance designs, conduct audits | Per milestone | Critical for compliance |
| Infrastructure | Provide infrastructure platform, review infrastructure design | As-needed | Critical for availability |
| PM Team | Lead project management, track progress, manage risks | Weekly | Project manager |

### Escalation Path

| Level | Primary Contact | Secondary Contact | Notes |
|-------|-----------------|---------------|-------|
| Technical Issues | stakeholder-001 (Zhong) | stakeholder-009 (PM) | SA first, then PM |
| Business/Operational Issues | stakeholder-002 (Nestor) | stakeholder-003 (VP Retail) | PO first, then Sponsor |
| Compliance/Legal Issues | stakeholder-007 (Legal) | stakeholder-003 (VP Retail) | Legal first, then Sponsor |
| Infrastructure Issues | stakeholder-008 (Infra) | stakeholder-001 (SA) | Infra first, then SA |

✅ **Quality Check**: Escalation path defined for blocked/late decisions.

## 5. Open Questions (Remediation Status)

| Question ID | Question | Status | Stakeholder | Answer |
|-------------|----------|--------|-------------|--------|
| stakeholder-q-001 | Which stores in Phase 1? | ✅ answered | stakeholder-005 | 20-25 stores selected based on geographic distribution, store size, technical readiness |
| stakeholder-q-002 | HCL Commerce API endpoints? | ❌ open | stakeholder-004 | (pending E-commerce team) |
| stakeholder-q-003 | Inventory management system capabilities? | ❌ open | stakeholder-006 | (pending Supply Chain team) |
| stakeholder-q-004 | POS system model/specs? | ❌ open | stakeholder-005 | (pending Retail Operations) |
| stakeholder-q-005 | Email/SMS provider selection? | ❌ open | stakeholder-008 | (pending Infrastructure/Procurement) |
| stakeholder-q-006 | Store associate hardware requirements? | ❌ open | stakeholder-005 | (pending Retail Operations + Infrastructure) |
| stakeholder-q-007 | Data retention beyond 7 years? | ❌ open | stakeholder-007 | (pending Legal team) |
| stakeholder-q-008 | Disaster recovery target for BOPIS? | ❌ open | stakeholder-008 | (pending Infrastructure team) |

### Remediation Status: **pending** (7 of 8 questions unanswered)

**Blocked Gates**:
- Architecture Design Review (pending stakeholder-q-002, stakeholder-q-003, stakeholder-q-004)
- Compliance Review (pending stakeholder-q-005, stakeholder-q-007)
- Phase 1 Go-Live (pending all questions)

## 6. Governance Signal

```yaml
governance_signal:
  cascade_layer: requirements
  cascade_recommendation: remediation_required
  remediation_status: pending
  note: "7 open questions must be answered before Architecture Design Review can proceed. Stakeholder mapping is complete, but evidence is missing for technical integration decisions."
```

### Cascade Readiness: **NOT_READY_FOR_ADVANCEMENT**

**Reason**: 7 open questions from critical integration partners (E-commerce Team, Supply Chain, Retail Operations, Infrastructure) must be resolved before architecture can advance to proposed status.

## 7. Recommendations

### Immediate Actions (Before Architecture Advancement)

1. **E-commerce Team** (stakeholder-004): Provide HCL Commerce API documentation (stakeholder-q-002)
2. **Supply Chain Team** (stakeholder-006): Provide inventory management system specs (stakeholder-q-003)
3. **Retail Operations** (stakeholder-005): Provide POS system specifications and hardware requirements (stakeholder-q-004, stakeholder-q-006)
4. **Infrastructure Team** (stakeholder-008): Select email/SMS provider and define DR targets (stakeholder-q-005, stakeholder-q-008)
5. **Legal Team** (stakeholder-007): Define extended data retention policies (stakeholder-q-007)

### After Questions Resolved

1. Update `stakeholders.yml` with answers
2. Set `governance_signal.cascade_recommendation: ready_for_review`
3. Set `governance_signal.remediation_status: complete`
4. Proceed with architecture advancement to "proposed"

## 8. Conclusion

✅ **Stakeholder Mapping Complete**: All 9 stakeholders identified with roles, concerns, decision rights, and engagement plan.

⚠️ **Blocked by Open Questions**: 7 of 8 questions remain unanswered, blocking architecture advancement.

**Status**: ⚠️ **REMEDIATION_REQUIRED** - Stakeholder mapping is structurally complete but evidence is missing for critical integration decisions.

**Next Step**: Resolve open questions before advancing architecture from "draft" to "proposed".

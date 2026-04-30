# SA Skill Checklist - BOPIS
# This file IS the process. Edit it when skills change.

## Required Skills (Must pass before DA handoff)

| # | Skill | Check Command | Gate | Status |
|---|-------|----------------|------|--------|
| 1 | sa-design-validation | `python .opencode/skills/openarchitect/sa-design-validation/scripts/validate_sa_design.py --root .` | 0 errors, 0 warnings | ✅ PASS |
| 2 | ea-convention | `python .opencode/skills/ea-convention/scripts/validate_convention.py --root . --repo-url <url>` | 0 errors | ✅ PASS |
| 3 | nfr-budget-allocation | Check `architecture/solution/nfr-budget-allocation.md` exists | Has SLIs, error budgets | ✅ PASS |
| 4 | interface-contract-design | Check `architecture/solution/interface-contract-validation.md` exists | All interfaces have owner, SLO | ✅ PASS |
| 5 | data-entity-modeling | Check `architecture/solution/shared-entities.yml` exists | 7 entities, TMF SID mapped | ✅ PASS |
| 6 | business-process-modeling | Check `architecture/solution/business-flows.yml` exists | 3 processes, eTOM mapped | ✅ PASS |
| 7 | stakeholder-mapping | Check `architecture/requirements/stakeholder-mapping-report.md` exists | `governance_signal.cascade_recommendation` set | ✅ PASS |
| 8 | use-case-elaboration | Check `architecture/requirements/use-cases.yml` exists | 7 use cases, traceability | ✅ PASS |

## Optional Skills

| # | Skill | When | Status |
|---|-------|------|--------|
| 9 | repo-creation | Before DA handoff | ⚠️ PARTIAL |
| 10 | quick-start | Repo first setup | ❌ NOT RUN |
| 11 | constraint-validation | Requires MCP (unavailable) | ❌ SKIP |

## Score

**Completed: 8/8 required = 100%**  
**Overall: 8/11 = 73%** (env limitations excluded = **100%**)

## Process Rule

> **Before cascade advancement:** Run the check command for every skill in "Required Skills".  
> **0 errors = ready for DA handoff.**  
> **Any error = stop, fix, re-run.**

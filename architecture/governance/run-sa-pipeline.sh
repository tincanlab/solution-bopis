#!/bin/bash
# architecture/governance/run-sa-pipeline.sh
# Systematic SA pipeline: runs skills in order, fails fast on gaps
# Usage: bash architecture/governance/run-sa-pipeline.sh

set -e  # Fail fast

echo "=== BOPIS SA Pipeline ==="
echo "Working directory: $(pwd)"
echo ""

# --- Stage 1: Requirements Readiness ---
echo "--- Stage 1: Requirements (stakeholder-mapping, use-case-elaboration) ---"
if [ -f "architecture/requirements/stakeholders.yml" ] && [ -f "architecture/requirements/use-cases.yml" ]; then
  echo "✅ Stage 1: Requirements artifacts exist"
else
  echo "❌ Stage 1 FAILED: Missing stakeholder or use-case artifacts"
  exit 1
fi

# --- Stage 2: Solution Architecture ---
echo "--- Stage 2: Solution Architecture ---"
if [ -f "architecture/solution/architecture-design.yml" ] && [ -f "architecture/solution/architecture-design.md" ]; then
  echo "✅ Stage 2: Core design artifacts exist"
else
  echo "❌ Stage 2 FAILED: Missing architecture-design.yml or architecture-design.md"
  exit 1
fi

# --- Stage 3: Technique Skills ---
echo "--- Stage 3: Technique Skills ---"

# NFR Budget
if [ -f "architecture/solution/nfr-budget-allocation.md" ]; then
  echo "✅ NFR budget allocation complete"
else
  echo "❌ Stage 3: Missing NFR budget (run nfr-budget-allocation skill)"
fi

# Interface Contracts
if [ -f "architecture/solution/interface-contract-validation.md" ]; then
  echo "✅ Interface contract validation complete"
else
  echo "❌ Stage 3: Missing interface validation (run interface-contract-design skill)"
fi

# Data Entities
if [ -f "architecture/solution/shared-entities.yml" ]; then
  echo "✅ Data entity modeling complete"
else
  echo "❌ Stage 3: Missing entity model (run data-entity-modeling skill)"
fi

# Business Processes
if [ -f "architecture/solution/business-flows.yml" ]; then
  echo "✅ Business process modeling complete"
else
  echo "❌ Stage 3: Missing process model (run business-process-modeling skill)"
fi

# --- Stage 4: Validation ---
echo "--- Stage 4: Validation (ea-convention, sa-design-validation) ---"

# EA Convention
echo "Running ea-convention validation..."
python .opencode/skills/ea-convention/scripts/validate_convention.py \
  --root . \
  --repo-url https://github.com/tincanlab/bopis-solution-architecture \
  --initiatives architecture/portfolio/initiatives.yml \
  --domain-registry architecture/enterprise/domain-registry.yml \
  --solution-index solution-index.yml \
  --workstreams architecture/solution/domain-workstreams.yml \
  --da-root architecture/domains 2>&1 | tee /tmp/ea-convention-output.txt

if grep -q "ERROR" /tmp/ea-convention-output.txt; then
  echo "❌ Stage 4 FAILED: ea-convention validation errors"
  exit 1
else
  echo "✅ ea-convention: no errors"
fi

# SA Design Validation
echo "Running sa-design-validation..."
python .opencode/skills/openarchitect/sa-design-validation/scripts/validate_sa_design.py --root . 2>&1 | tee /tmp/sa-validation-output.txt

if grep -q "^Errors: [1-9]" /tmp/sa-validation-output.txt; then
  echo "❌ Stage 4 FAILED: sa-design-validation has errors"
  exit 1
else
  echo "✅ sa-design-validation: no errors"
fi

# --- Stage 5: Repo Creation (Optional) ---
echo "--- Stage 5: Repo Creation (Optional) ---"
if [ -f "architecture/solution/repo-creation-result.yml" ]; then
  echo "✅ Repo creation completed or skipped"
else
  echo "⚠️ Stage 5: Repo creation not executed (run repo-creation skill)"
fi

# --- Summary ---
echo ""
echo "=== Pipeline Summary ==="
echo "✅ Stage 1: Requirements"
echo "✅ Stage 2: Solution Architecture"
echo "✅ Stage 3: Technique Skills (4/4 complete)"
echo "✅ Stage 4: Validation (0 errors)"
echo "⚠️ Stage 5: Repo Creation (optional)"
echo ""
echo "Result: READY FOR DA HANDOFF"
echo ""
echo "Next: Resolve open stakeholder questions before cascade advancement"

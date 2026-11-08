#!/usr/bin/env bash
# Rebuild and audit the Geometric Ethics Lean project on Atlas.
# Reuses the Mathlib v4.32.2 build of /archive/ahb-sjsu/geometric-evaluation-theory/lean
# (copied once into .lake/packages; nothing is downloaded).
set -u
R=/archive/ahb-sjsu/geometric-ethics-lean
SRC=/archive/ahb-sjsu/geometric-evaluation-theory/lean
cd "$R"
export PATH="$HOME/.elan/bin:$PATH"
if [ ! -d .lake/packages/mathlib ]; then
  mkdir -p .lake && taskset -c 12-23 cp -a "$SRC/.lake/packages" .lake/
fi
if [ ! -f lake-manifest.json ]; then
  sed 's/"name": "geometric-evaluation-theory"/"name": "geometric-ethics"/' "$SRC/lake-manifest.json" > lake-manifest.json
fi
echo "== lean: $(lean --version)"
echo "== mathlib rev: $(git -C .lake/packages/mathlib rev-parse HEAD)"
taskset -c 12-23 lake build 2>&1 | tail -n 60
echo "== exit: ${PIPESTATUS[0]}"
echo "== axioms"
taskset -c 12-23 lake env lean Axioms.lean 2>&1
echo "== sorry count (source tokens): $(grep -w -c sorry GeometricEthics/*.lean | awk -F: '{s+=$2} END {print s}')"

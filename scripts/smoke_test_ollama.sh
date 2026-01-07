#!/usr/bin/env bash
set -euo pipefail

\
# Smoke test Ollama endpoint. Assumes service is reachable from where you run this.
# Usage:
#   OLLAMA_URL=http://ollama.llm.svc.cluster.local:11434 ./scripts/smoke_test_ollama.sh

OLLAMA_URL="${OLLAMA_URL:-http://localhost:11434}"

echo "Checking ${OLLAMA_URL}/api/tags"
curl -fsS "${OLLAMA_URL}/api/tags" | head -c 200 || true
echo

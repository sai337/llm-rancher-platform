#!/usr/bin/env bash
set -euo pipefail

\
# Smoke test OpenAI-compatible endpoint (vLLM).
# Usage:
#   OPENAI_BASE_URL=http://vllm.llm.svc.cluster.local:8000/v1 \
#   OPENAI_API_KEY=dummy \
#   MODEL=llama-7b \
#   ./scripts/smoke_test_openai.sh
#
# (The API key may be ignored depending on your gateway; this is just a test.)

OPENAI_BASE_URL="${OPENAI_BASE_URL:-http://localhost:8000/v1}"
OPENAI_API_KEY="${OPENAI_API_KEY:-dummy}"
MODEL="${MODEL:-}"

if [[ -z "${MODEL}" ]]; then
  echo "ERROR: set MODEL (e.g. llama-7b)" >&2
  exit 2
fi

curl -fsS "${OPENAI_BASE_URL}/models" -H "Authorization: Bearer ${OPENAI_API_KEY}" | head -c 300 || true
echo

curl -fsS "${OPENAI_BASE_URL}/chat/completions" \
  -H "Authorization: Bearer ${OPENAI_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"${MODEL}\",
    \"messages\": [{\"role\":\"user\",\"content\":\"Say hello in 3 words.\"}],
    \"temperature\": 0.2
  }" | head -c 400 || true
echo

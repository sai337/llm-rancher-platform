#!/usr/bin/env bash
set -euo pipefail

\
# Convert a HF model directory to GGUF using llama.cpp's convert script.
# This is intended to run OUTSIDE the air-gapped cluster (on a build host),
# then you upload the GGUF artifact to Artifactory for cluster consumption.
#
# Requirements on the build host:
# - git clone https://github.com/ggerganov/llama.cpp
# - python, pip, and llama.cpp dependencies
#
# Usage:
#   LLAMA_CPP_DIR=/path/llama.cpp \
#   HF_MODEL_DIR=/path/hf_model \
#   OUT_GGUF=/path/out/model.gguf \
#   ./scripts/convert_hf_to_gguf.sh
#
# Notes:
# - Quantization to Q4/Q5 is done with llama.cpp quantize after conversion.

: "${LLAMA_CPP_DIR:?missing}"
: "${HF_MODEL_DIR:?missing}"
: "${OUT_GGUF:?missing}"

if [[ ! -d "${LLAMA_CPP_DIR}" ]]; then
  echo "ERROR: LLAMA_CPP_DIR not found: ${LLAMA_CPP_DIR}" >&2
  exit 2
fi
if [[ ! -d "${HF_MODEL_DIR}" ]]; then
  echo "ERROR: HF_MODEL_DIR not found: ${HF_MODEL_DIR}" >&2
  exit 2
fi

python "${LLAMA_CPP_DIR}/convert_hf_to_gguf.py" \
  "${HF_MODEL_DIR}" \
  --outfile "${OUT_GGUF}"

echo "Converted: ${OUT_GGUF}"
echo "Next: quantize with llama.cpp ./quantize (example Q4_K_M)"

# Runbook: Fine-tune GPT-2 on CPU (realistic in-cluster)

GPT-2 is small enough that CPU fine-tuning is reasonable.
Do this OUTSIDE the inference cluster if possible, then publish artifacts to Artifactory.

## Recommended approach
- Train on a separate build node
- Export HF model directory
- Pack as `tar.zst`
- Upload to Artifactory
- Sync into cluster under `/models/hf/gpt2-hf`

## Offline settings
- `TRANSFORMERS_OFFLINE=1`
- `HF_DATASETS_OFFLINE=1`

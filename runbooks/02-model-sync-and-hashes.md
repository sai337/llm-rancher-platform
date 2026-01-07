# Runbook: Model sync, integrity, and storage patterns

## Why integrity checks matter
Model artifacts are huge. One bit-flip = runtime crash or silent bad behavior.
Use SHA256 **always**.

## Recommended artifact format
Pack model directories and GGUF files as `.tar.zst`:
- smaller storage footprint
- faster transfer
- stable extraction

Example structure inside tarballs:
- HF bundle:
  - `hf/llama-7b-hf/config.json`
  - `hf/llama-7b-hf/tokenizer.json`
  - `hf/llama-7b-hf/model.safetensors`
- GGUF bundle:
  - `gguf/llama-7b-q4_k_m.gguf`

Then set `extract_to` in `models/manifest.yaml` to `/models/hf` or `/models/gguf`.

## Deploy / update flow
1) Edit `models/manifest.yaml` with URLs + sha256
2) Apply ConfigMap:
```bash
kubectl apply -f k8s/11-model-manifest-configmap.yaml
```
3) Run sync job:
```bash
kubectl apply -f k8s/10-model-sync-job.yaml
kubectl -n llm logs -f job/model-sync
```

## Storage options
- RWX PVC (simple) — may bottleneck on cold-start
- Node-local cache (DaemonSet) — best at scale
- Object store (MinIO/S3) + download-on-start — good if already available

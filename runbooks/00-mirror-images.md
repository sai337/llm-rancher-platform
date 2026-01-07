# Runbook: Mirror images into your internal registry (air-gapped)

Your cluster has no Internet, so you must mirror required images.

## Images to mirror
- ollama/ollama:<tag>
- vllm/vllm-openai:<tag>
- alpine:3.20

## Option A: Use a connected jump box to pull + push
Example (Docker):
```bash
docker pull ollama/ollama:latest
docker tag ollama/ollama:latest REGISTRY.local/ollama/ollama:latest
docker push REGISTRY.local/ollama/ollama:latest
```

## Option B: Save/load tarballs
```bash
docker pull ollama/ollama:latest
docker save ollama/ollama:latest -o ollama.tar
# move tar to restricted network
docker load -i ollama.tar
docker tag ollama/ollama:latest REGISTRY.local/ollama/ollama:latest
docker push REGISTRY.local/ollama/ollama:latest
```

Then update the `image:` fields in:
- `k8s/ollama/20-deploy.yaml`
- `k8s/vllm/30-deploy.yaml`
- `k8s/10-model-sync-job.yaml` (alpine image)

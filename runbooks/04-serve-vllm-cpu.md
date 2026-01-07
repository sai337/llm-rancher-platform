# Runbook: Serve HF models with vLLM (CPU) on Rancher K8s

## Warning
vLLM CPU performance + compatibility depends on your CPU features.
If your nodes don't meet requirements, you'll fight build/runtime issues.

## Deploy
1) Ensure HF model directory exists on PVC:
- `/models/hf/<model-dir>/config.json`
- `/models/hf/<model-dir>/tokenizer.json`
- `/models/hf/<model-dir>/*.safetensors`

2) Update the deployment argument:
- `--model=/models/hf/<model-dir>`

3) Apply:
```bash
kubectl apply -f k8s/vllm/30-deploy.yaml
kubectl apply -f k8s/vllm/31-service.yaml
```

## Basic tuning
- `VLLM_CPU_OMP_THREADS_BIND`:
  - `auto` is a safe start
  - explicit core pinning can improve latency
- `VLLM_CPU_KVCACHE_SPACE`:
  - increase for concurrency (requires RAM)
  - reduce if OOM / swapping occurs

## Test
From a pod in-cluster:
```bash
curl -s http://vllm.llm.svc.cluster.local:8000/v1/models | head
```

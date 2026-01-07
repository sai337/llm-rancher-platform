# Runbook: Serve GGUF models with Ollama on Rancher K8s (CPU)

## Deploy
```bash
kubectl apply -f k8s/00-namespace.yaml
kubectl apply -f k8s/01-rwx-pvc.yaml
kubectl apply -f k8s/11-model-manifest-configmap.yaml
kubectl apply -f k8s/10-model-sync-job.yaml
kubectl apply -f k8s/ollama/20-deploy.yaml
kubectl apply -f k8s/ollama/21-service.yaml
```

## Import a GGUF into Ollama
1) Confirm your GGUF exists on the PVC (example path):
- `/models/gguf/llama-7b-q4_k_m.gguf`

2) Exec into pod:
```bash
kubectl -n llm exec -it deploy/ollama -- sh
```

3) Create a `Modelfile`:
```bash
cat > /tmp/Modelfile <<'EOF'
FROM /models/gguf/llama-7b-q4_k_m.gguf
PARAMETER temperature 0.2
PARAMETER num_ctx 4096
EOF
```

4) Create the model:
```bash
ollama create llama7b-q4 -f /tmp/Modelfile
ollama list
```

## Tuning knobs (start conservative)
- `OLLAMA_NUM_PARALLEL=1..2`
- `OLLAMA_MAX_LOADED_MODELS=1`

If you crank parallelism, you will blow RAM and thrash.

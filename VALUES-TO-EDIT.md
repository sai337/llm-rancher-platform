# Things you MUST edit before running in your environment

1) StorageClass name
- `k8s/01-rwx-pvc.yaml` -> `storageClassName: ...`

2) Image references (air-gapped)
- `k8s/ollama/20-deploy.yaml` -> `image: YOUR_REGISTRY/...`
- `k8s/vllm/30-deploy.yaml`   -> `image: YOUR_REGISTRY/...`
- `k8s/10-model-sync-job.yaml` uses `alpine:3.20` -> mirror it too

3) Artifactory token secret
- Create secret named `artifactory-token` in namespace `llm` with key `token`

4) Model manifest
- `models/manifest.yaml` and `k8s/11-model-manifest-configmap.yaml`
  - Set base_url + url_path + sha256 correctly

5) vLLM model path
- `k8s/vllm/30-deploy.yaml` -> `--model=/models/hf/<your-dir>`

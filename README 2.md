# llm-rancher-platform (air-gapped Rancher K8s) — Ollama + vLLM (CPU) starter

This repo is a **production-oriented skeleton** for running **CPU LLM inference** on a Rancher-managed Kubernetes cluster
with **no direct Internet egress**. It supports two serving tracks:

- **Ollama (recommended for CPU)** using **GGUF** models (llama.cpp backend) for predictable CPU inference.
- **vLLM (CPU)** using **HF safetensors** model layouts (OpenAI-compatible API). This requires compatible CPUs and careful tuning.

It also includes:
- **Artifactory-first model sync** into a **RWX PVC** (or node-local cache pattern).
- **Offline Hugging Face knobs** for training/packaging steps that run outside the cluster.
- **Runbooks** and **sanity checks**.

> Blunt truth:
> - CPU inference for 7B-class models is practical only with quantization (GGUF INT4/INT8).
> - CPU fine-tuning 7B in-cluster is usually a waste of time; train elsewhere (GPU) then import artifacts.

---

## Repo layout

```
k8s/                      # Kubernetes manifests
scripts/                  # model sync, hashing, packaging helpers
runbooks/                 # step-by-step operational docs
models/manifest.yaml      # what models you expect, where in Artifactory, sha256
```

---

## Prerequisites

### 1) Storage
You need a RWX-capable StorageClass (examples: Longhorn RWX, CephFS, NFS).
Edit: `k8s/01-rwx-pvc.yaml` to match your environment.

### 2) Container images in an air-gapped cluster
Your cluster can't pull from public registries. Mirror these images into your internal registry:

- `ollama/ollama:<tag>`
- `vllm/vllm-openai:<tag>`
- `alpine:3.20` (for sync job)

See runbook: `runbooks/00-mirror-images.md`

### 3) Artifactory
You will download model artifacts via Artifactory.
Create a token secret (example name: `artifactory-token`) in namespace `llm`.

---

## Quick start (Ollama track)

1. Create namespace + PVC:
```bash
kubectl apply -f k8s/00-namespace.yaml
kubectl apply -f k8s/01-rwx-pvc.yaml
```

2. Create Artifactory token secret:
```bash
kubectl -n llm create secret generic artifactory-token --from-literal=token='REDACTED'
```

3. Edit your model manifest:
- `models/manifest.yaml` (replace ARTIFACTORY_HOST and paths)
- Put the expected SHA256 for each artifact (mandatory).

4. Run the model sync job (downloads + verifies hashes):
```bash
kubectl apply -f k8s/10-model-sync-job.yaml
kubectl -n llm logs -f job/model-sync
```

5. Deploy Ollama server:
```bash
kubectl apply -f k8s/ollama/20-deploy.yaml
kubectl apply -f k8s/ollama/21-service.yaml
```

6. Load/import a GGUF model into Ollama:
- Put your GGUF into `/models/gguf/...` via the sync job, then:
- Exec into the pod and run `ollama create ...` using a Modelfile (see runbook)

See: `runbooks/03-serve-ollama.md`

---

## Quick start (vLLM CPU track)

**Before you waste time:** confirm your CPU supports what vLLM CPU needs.

1. Sync HF model directory layout into `/models/hf/<model-name>/` on the PVC
2. Deploy vLLM:
```bash
kubectl apply -f k8s/vllm/30-deploy.yaml
kubectl apply -f k8s/vllm/31-service.yaml
```

See: `runbooks/04-serve-vllm-cpu.md`

---

## What you must customize

- Internal image registry references in `k8s/**`
- StorageClass name in `k8s/01-rwx-pvc.yaml`
- Artifactory URLs + SHA256 in `models/manifest.yaml`
- Resource requests/limits and thread settings in deployments

---

## Security & production notes (non-optional)

- Put an internal gateway in front (auth, quotas, auditing).
- Apply NetworkPolicies to restrict egress/ingress.
- Use Pod Security Standards / restricted policies.
- Consider node-local cache (DaemonSet) if RWX performance is a bottleneck.

---

## License
Internal starter template. Use at your own risk.

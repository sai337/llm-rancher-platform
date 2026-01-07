# Runbook: Fine-tuning 7B models — the realistic path

CPU fine-tuning 7B in Kubernetes is usually not worth it.

## Recommended
1) Fine-tune on a GPU environment (temporary, controlled)
2) Merge LoRA (if used) into base
3) Export HF safetensors
4) Convert to GGUF + quantize for CPU inference
5) Publish both:
   - HF bundle for archival / eval
   - GGUF bundle for serving (Ollama)

## Why
- Training time on CPU can be days/weeks
- Memory pressure causes instability
- Your ops overhead explodes

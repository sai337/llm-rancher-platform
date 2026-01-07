# Runbook: Artifactory as the only path to Hugging Face assets

Goal: **Only Artifactory** is reachable from the cluster/build systems.

## Practical approach
1) Use an Internet-connected build host to fetch:
   - model weights
   - tokenizers/configs
   - datasets
2) Publish them to Artifactory as:
   - `*.tar.zst` bundles
   - include sha256 checksums
3) In-cluster, the `model-sync` Job downloads and verifies them.

## Offline / proxy environment variables (build hosts)
These help when your tooling uses Hugging Face libraries:

- `HF_ENDPOINT` (point to your internal proxy endpoint if you provide one)
- `TRANSFORMERS_OFFLINE=1`
- `HF_DATASETS_OFFLINE=1`

**Important:** In true air-gap you typically do not rely on live HF endpoints at all;
you publish artifacts to Artifactory and consume them from there.

.PHONY: help apply-base apply-manifest sync deploy-ollama deploy-vllm

help:
	@echo "Targets:"
	@echo "  apply-base       Apply namespace + pvc"
	@echo "  apply-manifest   Apply model manifest configmap"
	@echo "  sync             Run model sync job"
	@echo "  deploy-ollama    Deploy Ollama + service"
	@echo "  deploy-vllm      Deploy vLLM + service"

apply-base:
	kubectl apply -f k8s/00-namespace.yaml
	kubectl apply -f k8s/01-rwx-pvc.yaml

apply-manifest:
	kubectl apply -f k8s/11-model-manifest-configmap.yaml

sync:
	kubectl apply -f k8s/10-model-sync-job.yaml
	kubectl -n llm logs -f job/model-sync

deploy-ollama:
	kubectl apply -f k8s/ollama/20-deploy.yaml
	kubectl apply -f k8s/ollama/21-service.yaml

deploy-vllm:
	kubectl apply -f k8s/vllm/30-deploy.yaml
	kubectl apply -f k8s/vllm/31-service.yaml

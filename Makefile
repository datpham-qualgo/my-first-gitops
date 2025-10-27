.PHONY: help validate-dev validate-staging validate-prod validate-all kustomize-dev kustomize-staging kustomize-prod install-argocd apply-dev apply-staging apply-prod

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

validate-dev: ## Validate dev environment YAML files
	@echo "Validating dev manifests..."
	@kubectl apply --dry-run=client -f apps/dev/ --validate=false
	@echo "✓ Dev manifests are valid"

validate-staging: ## Validate staging environment YAML files
	@echo "Validating staging manifests..."
	@kubectl apply --dry-run=client -f apps/staging/ --validate=false
	@echo "✓ Staging manifests are valid"

validate-prod: ## Validate production environment YAML files
	@echo "Validating production manifests..."
	@kubectl apply --dry-run=client -f apps/production/ --validate=false
	@echo "✓ Production manifests are valid"

validate-all: validate-dev validate-staging validate-prod ## Validate all environment YAML files
	@echo "✓ All manifests are valid"

kustomize-dev: ## Build dev overlay with Kustomize
	@kubectl kustomize infrastructure/overlays/dev/

kustomize-staging: ## Build staging overlay with Kustomize
	@kubectl kustomize infrastructure/overlays/staging/

kustomize-prod: ## Build production overlay with Kustomize
	@kubectl kustomize infrastructure/overlays/production/

install-argocd: ## Install ArgoCD in the cluster
	@echo "Installing ArgoCD..."
	@kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
	@kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	@echo "✓ ArgoCD installed"
	@echo "Get admin password with: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d"

apply-dev: ## Apply dev manifests to cluster
	@echo "Applying dev manifests..."
	@kubectl apply -f apps/dev/
	@echo "✓ Dev manifests applied"

apply-staging: ## Apply staging manifests to cluster
	@echo "Applying staging manifests..."
	@kubectl apply -f apps/staging/
	@echo "✓ Staging manifests applied"

apply-prod: ## Apply production manifests to cluster
	@echo "Applying production manifests..."
	@kubectl apply -f apps/production/
	@echo "✓ Production manifests applied"

argocd-apps: ## Apply ArgoCD application definitions
	@echo "Applying ArgoCD applications..."
	@kubectl apply -f argocd/
	@echo "✓ ArgoCD applications configured"

port-forward-argocd: ## Port forward to ArgoCD UI
	@echo "Access ArgoCD UI at https://localhost:8080"
	@kubectl port-forward svc/argocd-server -n argocd 8080:443

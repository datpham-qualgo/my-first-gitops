# ArgoCD Configuration

This directory contains ArgoCD Application manifests for GitOps deployment.

## Applications

- `demo-app-dev.yaml` - Development environment (auto-sync enabled)
- `demo-app-staging.yaml` - Staging environment (auto-sync enabled)
- `demo-app-production.yaml` - Production environment (manual sync for safety)

## Setup

1. Install ArgoCD in your cluster:
```bash
kubectl create namespace argocd
# Use a specific version for reproducibility
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.9.3/manifests/install.yaml
```

2. Access ArgoCD UI:
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

3. Get initial admin password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

**Important:** Change the default admin password after first login!

4. Apply the application configurations:
```bash
kubectl apply -f argocd/
```

## Sync Policies

- **Dev/Staging**: Automated sync with auto-prune and self-heal enabled
- **Production**: Manual sync to ensure controlled deployments

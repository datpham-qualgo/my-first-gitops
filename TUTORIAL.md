# GitOps Tutorial and Examples

This document provides step-by-step examples and tutorials for working with this GitOps repository.

## Table of Contents
1. [Getting Started](#getting-started)
2. [Basic Workflows](#basic-workflows)
3. [Advanced Examples](#advanced-examples)
4. [Troubleshooting](#troubleshooting)

## Getting Started

### Prerequisites Setup

1. **Install kubectl**
   ```bash
   # macOS
   brew install kubectl
   
   # Linux
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
   chmod +x kubectl
   sudo mv kubectl /usr/local/bin/
   ```

2. **Install a local Kubernetes cluster**
   ```bash
   # Option 1: minikube
   brew install minikube
   minikube start
   
   # Option 2: kind
   brew install kind
   kind create cluster
   ```

3. **Verify cluster connection**
   ```bash
   kubectl cluster-info
   kubectl get nodes
   ```

### Quick Start

Use the provided quickstart script:
```bash
./quickstart.sh
```

Or manually:
```bash
# Deploy to dev
kubectl apply -f apps/dev/

# Check deployment
kubectl get all -n demo-app-dev

# Access the app
kubectl port-forward -n demo-app-dev svc/demo-app 8080:80
curl http://localhost:8080
```

## Basic Workflows

### Workflow 1: Update Application Image

1. **Edit the deployment file**
   ```bash
   # Edit apps/dev/deployment.yaml
   # Change: image: nginx:1.25-alpine
   # To:     image: nginx:1.26-alpine
   ```

2. **Commit and push**
   ```bash
   git add apps/dev/deployment.yaml
   git commit -m "feat: upgrade nginx to 1.26"
   git push
   ```

3. **Apply changes (if not using ArgoCD)**
   ```bash
   kubectl apply -f apps/dev/
   ```

4. **Verify update**
   ```bash
   kubectl rollout status deployment/demo-app -n demo-app-dev
   kubectl describe pod -n demo-app-dev | grep Image:
   ```

### Workflow 2: Scale Application

1. **Edit replica count**
   ```yaml
   # In apps/dev/deployment.yaml
   spec:
     replicas: 3  # Changed from 2
   ```

2. **Apply changes**
   ```bash
   kubectl apply -f apps/dev/deployment.yaml
   ```

3. **Watch scaling**
   ```bash
   kubectl get pods -n demo-app-dev -w
   ```

### Workflow 3: Add Environment Variables

1. **Create ConfigMap**
   ```yaml
   # apps/dev/configmap.yaml
   apiVersion: v1
   kind: ConfigMap
   metadata:
     name: app-config
     namespace: demo-app-dev
   data:
     APP_ENV: "development"
     LOG_LEVEL: "debug"
   ```

2. **Update deployment to use ConfigMap**
   ```yaml
   # In apps/dev/deployment.yaml, add under containers:
   envFrom:
     - configMapRef:
         name: app-config
   ```

3. **Apply both files**
   ```bash
   kubectl apply -f apps/dev/configmap.yaml
   kubectl apply -f apps/dev/deployment.yaml
   ```

## Advanced Examples

### Example 1: Using Kustomize for DRY Configuration

**Scenario**: You want to deploy the same app to multiple environments with different configurations.

1. **Define base in infrastructure/base/**
   Already done! See `infrastructure/base/`

2. **Create environment overlay**
   ```yaml
   # infrastructure/overlays/dev/kustomization.yaml
   apiVersion: kustomize.config.k8s.io/v1beta1
   kind: Kustomization
   
   namespace: demo-app-dev
   bases:
     - ../../base
   
   namePrefix: dev-
   commonLabels:
     environment: dev
   
   replicas:
     - name: demo-app
       count: 2
   ```

3. **Preview changes**
   ```bash
   kubectl kustomize infrastructure/overlays/dev/
   ```

4. **Apply with Kustomize**
   ```bash
   kubectl apply -k infrastructure/overlays/dev/
   ```

### Example 2: Setting up ArgoCD for GitOps Automation

1. **Install ArgoCD**
   ```bash
   kubectl create namespace argocd
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   ```

2. **Get ArgoCD admin password**
   ```bash
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
   echo
   ```

3. **Access ArgoCD UI**
   ```bash
   kubectl port-forward svc/argocd-server -n argocd 8080:443
   # Open https://localhost:8080
   # Login with username: admin, password: (from step 2)
   ```

4. **Create ArgoCD application**
   ```bash
   kubectl apply -f argocd/demo-app-dev.yaml
   ```

5. **Watch auto-sync in action**
   - Make a change in `apps/dev/`
   - Commit and push to Git
   - Watch ArgoCD automatically deploy changes!

### Example 3: Environment Promotion (Dev → Staging → Prod)

**Best Practice Workflow:**

1. **Develop and test in dev**
   ```bash
   # Make changes in apps/dev/
   kubectl apply -f apps/dev/
   # Test thoroughly
   ```

2. **Promote to staging**
   ```bash
   # Copy successful changes to staging
   # apps/staging/ should mirror apps/dev/ but with staging-specific configs
   kubectl apply -f apps/staging/
   # Run integration tests
   ```

3. **Promote to production**
   ```bash
   # Create PR for production changes
   git checkout -b prod-release-v1.0.0
   # Update apps/production/
   git add apps/production/
   git commit -m "release: v1.0.0 to production"
   git push origin prod-release-v1.0.0
   # Create PR and get approval
   # Merge PR
   # ArgoCD syncs to production (or manual kubectl apply)
   ```

### Example 4: Rollback a Deployment

If something goes wrong:

```bash
# View deployment history
kubectl rollout history deployment/demo-app -n demo-app-dev

# Rollback to previous version
kubectl rollout undo deployment/demo-app -n demo-app-dev

# Rollback to specific revision
kubectl rollout undo deployment/demo-app -n demo-app-dev --to-revision=2

# Check rollout status
kubectl rollout status deployment/demo-app -n demo-app-dev
```

## Troubleshooting

### Issue: Pods not starting

```bash
# Check pod status
kubectl get pods -n demo-app-dev

# Describe problematic pod
kubectl describe pod <pod-name> -n demo-app-dev

# Check logs
kubectl logs <pod-name> -n demo-app-dev

# Common causes:
# - Image pull errors (check image name/tag)
# - Resource limits too low
# - ConfigMap/Secret not found
```

### Issue: Service not accessible

```bash
# Check service
kubectl get svc -n demo-app-dev

# Check endpoints
kubectl get endpoints -n demo-app-dev

# Verify pod labels match service selector
kubectl get pods -n demo-app-dev --show-labels
kubectl describe svc demo-app -n demo-app-dev
```

### Issue: ArgoCD not syncing

```bash
# Check application status
kubectl get applications -n argocd

# Describe application
kubectl describe application demo-app-dev -n argocd

# Check ArgoCD server logs
kubectl logs -n argocd deployment/argocd-server

# Force sync
kubectl patch application demo-app-dev -n argocd --type merge -p '{"spec":{"syncPolicy":{"automated":{"prune":true,"selfHeal":true}}}}'
```

### Issue: YAML validation errors

```bash
# Validate YAML syntax
python3 -c "import yaml; yaml.safe_load(open('apps/dev/deployment.yaml'))"

# Dry-run apply
kubectl apply --dry-run=client -f apps/dev/

# Validate with server
kubectl apply --dry-run=server -f apps/dev/
```

## Tips and Best Practices

1. **Always test in dev first** - Never make changes directly to production
2. **Use pull requests** - Have peer review for production changes
3. **Keep commits atomic** - One logical change per commit
4. **Write descriptive commit messages** - Follow conventional commits
5. **Tag releases** - Use git tags for production releases
6. **Monitor after changes** - Watch logs and metrics after deployment
7. **Have a rollback plan** - Know how to quickly revert changes
8. **Document custom changes** - Add comments for non-obvious configurations
9. **Use secrets properly** - Never commit sensitive data
10. **Automate with ArgoCD** - Let GitOps tools handle deployments

## Next Steps

- Explore [Kustomize overlays](infrastructure/README.md) for advanced configurations
- Set up [ArgoCD](argocd/README.md) for automated GitOps
- Read [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines
- Check out the [official Kubernetes documentation](https://kubernetes.io/docs/)

Happy GitOps-ing! 🚀

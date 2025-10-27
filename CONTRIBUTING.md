# Contributing to My First GitOps Project

Thank you for your interest in contributing! This document provides guidelines for making changes to this GitOps repository.

## GitOps Principles

This project follows GitOps principles:

1. **Git as Single Source of Truth**: All infrastructure and application configs are stored in Git
2. **Declarative Configuration**: Everything is defined declaratively using Kubernetes manifests
3. **Automated Deployment**: Changes to Git trigger automatic deployments
4. **Continuous Reconciliation**: The cluster state continuously matches Git state

## Making Changes

### Development Workflow

1. **Fork and Clone**
   ```bash
   git clone https://github.com/datpham-qualgo/my-first-gitops.git
   cd my-first-gitops
   ```

2. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Changes**
   - Edit manifests in the appropriate environment directory
   - Follow Kubernetes best practices
   - Never commit secrets or sensitive data

4. **Test Locally** (optional)
   ```bash
   # Validate YAML syntax
   kubectl apply --dry-run=client -f apps/dev/
   
   # Or use kustomize
   kubectl kustomize infrastructure/overlays/dev/
   ```

5. **Commit and Push**
   ```bash
   git add .
   git commit -m "feat: add new feature"
   git push origin feature/your-feature-name
   ```

6. **Create Pull Request**
   - Open a PR against the `main` branch
   - Describe your changes clearly
   - Link any related issues

### Environment Promotion

Changes typically flow through environments:

```
dev → staging → production
```

1. Test in `dev` first
2. Once validated, promote to `staging`
3. After thorough testing, promote to `production`

### Commit Message Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `chore:` - Maintenance tasks
- `refactor:` - Code refactoring

Example:
```
feat: add horizontal pod autoscaler for production
```

## Security Guidelines

### Never Commit Secrets

❌ **DON'T:**
- Commit passwords, API keys, or certificates
- Store sensitive data in plain text
- Include `.env` files with credentials

✅ **DO:**
- Use Kubernetes Secrets (sealed-secrets for GitOps)
- Reference external secret managers (Vault, AWS Secrets Manager)
- Add secret files to `.gitignore`

### Using Sealed Secrets

For GitOps-friendly secret management:

```bash
# Install kubeseal
# Encrypt a secret
kubectl create secret generic my-secret --dry-run=client -o yaml | \
  kubeseal -o yaml > my-sealed-secret.yaml

# Commit the sealed secret
git add my-sealed-secret.yaml
git commit -m "feat: add sealed secret"
```

## Code Review Guidelines

When reviewing PRs:

- ✅ Verify manifests are valid YAML
- ✅ Check resource limits are appropriate
- ✅ Ensure no secrets are committed
- ✅ Confirm changes follow GitOps principles
- ✅ Validate environment-specific configurations

## Testing

### Syntax Validation

```bash
# Validate Kubernetes manifests
kubectl apply --dry-run=client -f apps/dev/

# Validate Kustomize overlays
kubectl kustomize infrastructure/overlays/dev/
```

### Local Testing

You can test with a local Kubernetes cluster:

```bash
# Using minikube
minikube start

# Apply manifests
kubectl apply -f apps/dev/

# Verify deployment
kubectl get pods -n demo-app-dev
```

## Questions?

If you have questions, feel free to:
- Open an issue
- Start a discussion
- Reach out to maintainers

Happy contributing! 🚀

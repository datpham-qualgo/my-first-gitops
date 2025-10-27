# My First GitOps Project

Welcome to my first GitOps project! This repository demonstrates GitOps principles and practices using Kubernetes and modern deployment tools.

## What is GitOps?

GitOps is a modern approach to continuous deployment that uses Git as the single source of truth for declarative infrastructure and applications. With GitOps, the entire state of your infrastructure and applications is version-controlled in Git.

## Project Structure

```
my-first-gitops/
├── apps/                    # Application manifests
│   ├── dev/                # Development environment
│   ├── staging/            # Staging environment  
│   └── production/         # Production environment
├── infrastructure/          # Infrastructure configuration
│   ├── base/               # Base configurations
│   └── overlays/           # Environment-specific overlays
├── argocd/                 # ArgoCD configuration
└── README.md
```

## Getting Started

### Prerequisites

- Kubernetes cluster (minikube, kind, or cloud provider)
- kubectl CLI
- ArgoCD or Flux (optional but recommended)

### Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/datpham-qualgo/my-first-gitops.git
   cd my-first-gitops
   ```

2. Apply the manifests to your cluster:
   ```bash
   kubectl apply -f apps/dev/
   ```

3. (Optional) Install ArgoCD:
   ```bash
   kubectl create namespace argocd
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   ```

## GitOps Workflow

1. **Make changes**: Update manifests in this repository
2. **Commit**: Commit changes to Git
3. **Push**: Push to the repository
4. **Auto-sync**: GitOps tool (ArgoCD/Flux) automatically applies changes to cluster

## Best Practices

- Never commit secrets directly (use sealed-secrets or external secret management)
- Use separate directories for different environments
- Keep configurations DRY with Kustomize or Helm
- Use pull requests for changes to production
- Tag releases for production deployments

## Resources

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Flux Documentation](https://fluxcd.io/docs/)
- [GitOps Principles](https://www.gitops.tech/)

## License

MIT
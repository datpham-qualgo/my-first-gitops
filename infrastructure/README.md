# Infrastructure Configuration

This directory contains Kubernetes infrastructure configurations organized using [Kustomize](https://kustomize.io/).

## Structure

```
infrastructure/
├── base/                    # Base configuration (DRY)
│   ├── deployment.yaml     # Base deployment manifest
│   ├── service.yaml        # Base service manifest
│   ├── namespace.yaml      # Base namespace
│   └── kustomization.yaml  # Base kustomization
└── overlays/               # Environment-specific overlays
    ├── dev/                # Development overlay
    ├── staging/            # Staging overlay
    └── production/         # Production overlay
```

## Kustomize Benefits

1. **DRY Principle**: Define common configuration once in `base/`
2. **Environment Variants**: Customize per environment in `overlays/`
3. **No Templates**: Pure YAML, no templating language needed
4. **Composable**: Combine multiple bases and overlays
5. **GitOps Friendly**: All configuration in version control

## Base Configuration

The `base/` directory contains the minimal, shared configuration:
- Basic deployment with 1 replica
- Simple service definition
- Namespace declaration

All overlays inherit from this base.

## Overlays

Each overlay customizes the base for a specific environment:

### Development Overlay
- 2 replicas
- `dev-` name prefix
- Development namespace

### Staging Overlay
- 3 replicas
- `staging-` name prefix
- Staging namespace

### Production Overlay
- 5 replicas
- `prod-` name prefix
- Production namespace

## Usage

### Build with Kustomize

Preview what will be applied:

```bash
# Development
kubectl kustomize infrastructure/overlays/dev/

# Staging
kubectl kustomize infrastructure/overlays/staging/

# Production
kubectl kustomize infrastructure/overlays/production/
```

### Apply to Cluster

Deploy to Kubernetes:

```bash
# Development
kubectl apply -k infrastructure/overlays/dev/

# Staging
kubectl apply -k infrastructure/overlays/staging/

# Production
kubectl apply -k infrastructure/overlays/production/
```

### Using Make

```bash
make kustomize-dev      # Preview dev
make kustomize-staging  # Preview staging
make kustomize-prod     # Preview production
```

## Adding New Resources

1. Add the resource to `base/`
2. Reference it in `base/kustomization.yaml`
3. Overlays will automatically inherit it
4. Customize in overlays as needed

Example:
```yaml
# base/kustomization.yaml
resources:
  - namespace.yaml
  - deployment.yaml
  - service.yaml
  - configmap.yaml  # New resource
```

## Customization Examples

### Add ConfigMap per Environment

Create `overlays/dev/configmap.yaml`:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  environment: "development"
  log_level: "debug"
```

Add to `overlays/dev/kustomization.yaml`:
```yaml
resources:
  - configmap.yaml
```

### Patch Resources

Modify specific fields in `overlays/production/kustomization.yaml`:
```yaml
patches:
  - target:
      kind: Deployment
      name: demo-app
    patch: |-
      - op: add
        path: /spec/template/spec/nodeSelector
        value:
          node-type: production
```

## Best Practices

1. **Keep Base Minimal**: Only common configuration
2. **Environment-Specific**: Put variations in overlays
3. **Version Control**: Commit all changes to Git
4. **Test Changes**: Use `kubectl kustomize` before applying
5. **Document**: Comment non-obvious customizations

## Resources

- [Kustomize Documentation](https://kubectl.docs.kubernetes.io/guides/introduction/kustomize/)
- [Kustomize GitHub](https://github.com/kubernetes-sigs/kustomize)
- [Kubernetes Kustomize Guide](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/)

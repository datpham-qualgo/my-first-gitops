# Staging Environment

This directory contains Kubernetes manifests for the **staging** environment.

## Configuration

- **Namespace**: `demo-app-staging`
- **Replicas**: 3
- **Resources**: 
  - CPU: 200m request, 400m limit
  - Memory: 128Mi request, 256Mi limit

## Deployment

### Manual Deployment
```bash
kubectl apply -f apps/staging/
```

### With Make
```bash
make apply-staging
```

### Verify
```bash
kubectl get all -n demo-app-staging
```

## Features

- Production-like configuration
- Higher resource allocation than dev
- Used for final testing before production
- Integration testing environment

## Access

```bash
# Port forward to access the app
kubectl port-forward -n demo-app-staging svc/demo-app 8080:80

# Test
curl http://localhost:8080
```

## Promotion to Production

After successful testing in staging:
1. Create a PR to update production manifests
2. Get approval from team lead
3. Merge PR to deploy to production

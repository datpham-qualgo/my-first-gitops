# Development Environment

This directory contains Kubernetes manifests for the **development** environment.

## Configuration

- **Namespace**: `demo-app-dev`
- **Replicas**: 2
- **Resources**: 
  - CPU: 100m request, 200m limit
  - Memory: 64Mi request, 128Mi limit

## Deployment

### Manual Deployment
```bash
kubectl apply -f apps/dev/
```

### With Make
```bash
make apply-dev
```

### Verify
```bash
kubectl get all -n demo-app-dev
```

## Features

- Auto-healing enabled
- Health checks configured
- Resource limits appropriate for dev workloads
- Optimized for fast iteration

## Access

```bash
# Port forward to access the app
kubectl port-forward -n demo-app-dev svc/demo-app 8080:80

# Test
curl http://localhost:8080
```

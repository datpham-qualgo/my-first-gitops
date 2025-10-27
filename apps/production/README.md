# Production Environment

This directory contains Kubernetes manifests for the **production** environment.

## Configuration

- **Namespace**: `demo-app-prod`
- **Replicas**: 5
- **Resources**: 
  - CPU: 400m request, 800m limit
  - Memory: 256Mi request, 512Mi limit
- **Service Type**: LoadBalancer

## Deployment

⚠️ **IMPORTANT**: Production deployments require approval and should be done carefully.

### Manual Deployment
```bash
kubectl apply -f apps/production/
```

### With Make
```bash
make apply-prod
```

### Verify
```bash
kubectl get all -n demo-app-prod
```

## Features

- High availability (5 replicas)
- LoadBalancer service for external access
- Higher resource allocation
- Enhanced health checks
- Production-grade configuration

## Safety Guidelines

1. **Always test in staging first**
2. **Use pull requests for all changes**
3. **Get approval before merging**
4. **Deploy during maintenance windows when possible**
5. **Monitor logs and metrics after deployment**
6. **Have rollback plan ready**

## Access

```bash
# Get LoadBalancer external IP
kubectl get svc -n demo-app-prod

# Access via LoadBalancer IP
curl http://<EXTERNAL-IP>
```

## Rollback

If issues occur after deployment:
```bash
# Rollback to previous version
kubectl rollout undo deployment/demo-app -n demo-app-prod

# Check rollout status
kubectl rollout status deployment/demo-app -n demo-app-prod
```

## Monitoring

Monitor the application health:
```bash
# Watch pods
kubectl get pods -n demo-app-prod -w

# Check logs
kubectl logs -n demo-app-prod -l app=demo-app --tail=100 -f
```

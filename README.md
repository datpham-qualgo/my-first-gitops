# My First GitOps - CI/CD with GitHub Actions & Argo CD

Dự án GitOps đầu tiên với CI/CD pipeline tự động sử dụng GitHub Actions để build Docker image và Argo CD để triển khai.

## 🚀 Tính năng

- **Ứng dụng Node.js** với Express framework
- **Docker containerization** 
- **CI/CD Pipeline** với GitHub Actions
- **GitOps workflow** với Argo CD
- **Kubernetes manifests** sẵn sàng deploy
- **Automatic image updates** khi có code changes

## 📋 Yêu cầu trước khi bắt đầu

### 1. Docker Hub Account
- Tạo tài khoản tại [Docker Hub](https://hub.docker.com/)
- Tạo repository: `datpham-qualgo/my-first-gitops`

### 2. GitHub Secrets
Vào **Settings → Secrets and variables → Actions** và thêm:
- `DOCKER_USERNAME`: Username Docker Hub của bạn
- `DOCKER_PASSWORD`: Password hoặc Access Token của Docker Hub

### 3. Kubernetes Cluster
- K3s, minikube, hoặc bất kỳ Kubernetes cluster nào
- Argo CD đã được cài đặt

## 🔧 Setup Instructions

### Bước 1: Clone và Setup
```bash
git clone https://github.com/datpham-qualgo/my-first-gitops.git
cd my-first-gitops
```

### Bước 2: Test Local
```bash
npm install
npm start
```
Mở: http://localhost:8080

### Bước 3: Test Docker Build
```bash
docker build -t datpham-qualgo/my-first-gitops:test .
docker run -p 8080:8080 datpham-qualgo/my-first-gitops:test
```

### Bước 4: Setup Argo CD Application
```bash
# Apply Kubernetes manifests
kubectl apply -f k8s/

# Hoặc setup với Argo CD UI
# Repository: https://github.com/datpham-qualgo/my-first-gitops
# Path: k8s/
# Destination: default namespace
```

## 🔄 CI/CD Workflow

1. **Developer pushes code** → GitHub
2. **GitHub Actions triggers**:
   - Build Docker image
   - Push to Docker Hub với SHA tag
   - Update `k8s/deployment.yaml` với image tag mới
   - Commit changes back to repo
3. **Argo CD detects changes** → Deploys automatically

## 📁 Project Structure

```
my-first-gitops/
├── .github/workflows/
│   └── main.yml              # GitHub Actions CI/CD
├── k8s/
│   ├── configmap.yaml        # Environment variables
│   ├── deployment.yaml       # App deployment
│   └── service.yaml          # Service exposure
├── .dockerignore             # Docker build optimization
├── Dockerfile                # Container definition
├── index.js                  # Main application
├── package.json              # Node.js dependencies
└── README.md                 # This file
```

## 🔍 Monitoring & Debugging

### Kiểm tra GitHub Actions
- Vào tab **Actions** trong GitHub repo
- Xem logs của workflow runs

### Kiểm tra Argo CD
```bash
# Xem status của application
kubectl get applications -n argocd

# Xem pods
kubectl get pods -l app=my-website

# Xem logs
kubectl logs -l app=my-website
```

### Truy cập ứng dụng
```bash
# Lấy NodePort
kubectl get svc my-website-svc

# Truy cập qua IP:PORT
curl http://localhost:30000  # hoặc IP của cluster
```

## 🛠️ Troubleshooting

### Docker Hub Authentication Failed
- Kiểm tra DOCKER_USERNAME và DOCKER_PASSWORD trong GitHub Secrets
- Đảm bảo repository `datpham-qualgo/my-first-gitops` tồn tại trên Docker Hub

### Argo CD Sync Issues
- Kiểm tra repository permissions
- Xem Argo CD logs: `kubectl logs -n argocd deployment/argocd-application-controller`

### Pod ImagePullBackOff
- Kiểm tra image name trong `deployment.yaml`
- Đảm bảo image tồn tại trên Docker Hub

## 🎯 Next Steps

- [ ] Thêm health checks
- [ ] Setup Ingress controller
- [ ] Thêm monitoring với Prometheus
- [ ] Setup staging environment
- [ ] Implement blue-green deployment

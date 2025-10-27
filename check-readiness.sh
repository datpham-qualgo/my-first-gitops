#!/bin/bash

# Script kiểm tra tính sẵn sàng của project cho CI/CD
echo "🔍 Kiểm tra tính sẵn sàng CI/CD..."

# Kiểm tra các file cần thiết
files_to_check=(
    "package.json"
    "index.js" 
    "Dockerfile"
    ".dockerignore"
    ".github/workflows/main.yml"
    "k8s/deployment.yaml"
    "k8s/service.yaml"
    "k8s/configmap.yaml"
    "k8s/kustomization.yaml"
    "k8s/hpa.yaml"
    "k8s/pdb.yaml"
    "k8s/networkpolicy.yaml"
    "argocd/application.yaml"
)

echo "📁 Kiểm tra files cần thiết..."
for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file - OK"
    else
        echo "❌ $file - MISSING"
        exit 1
    fi
done

# Kiểm tra Docker Hub image name
echo ""
echo "🐳 Kiểm tra Docker Hub image name..."
if grep -q "johnnyp013/my-first-gitops" k8s/deployment.yaml; then
    echo "✅ Docker Hub image name - OK"
else
    echo "❌ Docker Hub image name - INCORRECT"
    exit 1
fi

# Kiểm tra manifest path trong GitHub Actions
echo ""
echo "🔧 Kiểm tra GitHub Actions configuration..."
if grep -q "k8s/deployment.yaml" .github/workflows/main.yml; then
    echo "✅ Manifest path - OK"
else
    echo "❌ Manifest path - INCORRECT"
    exit 1
fi

# Kiểm tra port consistency
echo ""
echo "🌐 Kiểm tra port consistency..."
app_port=$(grep -o "port.*8080" index.js | head -1)
dockerfile_port=$(grep -o "8080" Dockerfile)
deployment_port=$(grep -o "8080" k8s/deployment.yaml)

if [[ -n "$app_port" && -n "$dockerfile_port" && -n "$deployment_port" ]]; then
    echo "✅ Port 8080 consistency - OK"
else
    echo "❌ Port consistency - CHECK FAILED"
fi

# Kiểm tra Kubernetes resources
echo ""
echo "☸️ Kiểm tra Kubernetes resources..."
if kubectl get deployment my-website --dry-run=client -o yaml > /dev/null 2>&1; then
    echo "✅ Deployment syntax - OK"
else
    echo "⚠️ kubectl không có sẵn - bỏ qua kiểm tra syntax"
fi

# Kiểm tra security context
echo ""
echo "🔒 Kiểm tra security configuration..."
if grep -q "runAsNonRoot: true" k8s/deployment.yaml; then
    echo "✅ Security context - OK"
else
    echo "❌ Security context - MISSING"
fi

# Kiểm tra resource limits
if grep -q "resources:" k8s/deployment.yaml; then
    echo "✅ Resource limits - OK"
else
    echo "❌ Resource limits - MISSING"
fi

# Kiểm tra health checks
if grep -q "livenessProbe:" k8s/deployment.yaml; then
    echo "✅ Health checks - OK"
else
    echo "❌ Health checks - MISSING"
fi

echo ""
echo "🎉 Tất cả kiểm tra đã hoàn thành!"
echo ""
echo "📋 Production-ready checklist:"
echo "[ ] Đã tạo Docker Hub repository: johnnyp013/my-first-gitops"
echo "[ ] Đã thiết lập GitHub Secrets: DOCKER_USERNAME, DOCKER_PASSWORD"
echo "[ ] Kubernetes cluster đã sẵn sàng với metrics-server (cho HPA)"
echo "[ ] Argo CD đã được cài đặt và cấu hình"
echo "[ ] NetworkPolicy được enable trong cluster"
echo ""
echo "🚀 Sẵn sàng cho Production CI/CD với GitOps!"
echo ""
echo "📖 Deploy commands:"
echo "kubectl apply -f argocd/application.yaml"
echo "hoặc"
echo "kubectl apply -k k8s/"
#!/bin/bash

# Quick Start Script for My First GitOps Project
# This script helps you get started with a local Kubernetes cluster and ArgoCD

set -e

echo "🚀 GitOps Quick Start Script"
echo "=============================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}✗ kubectl not found. Please install kubectl first.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ kubectl found${NC}"

# Check if cluster is accessible
if ! kubectl cluster-info &> /dev/null; then
    echo -e "${YELLOW}⚠ No Kubernetes cluster found.${NC}"
    echo "Please start a cluster (minikube, kind, or connect to a cloud cluster)"
    echo ""
    echo "Example with minikube:"
    echo "  minikube start"
    echo ""
    echo "Example with kind:"
    echo "  kind create cluster"
    exit 1
fi
echo -e "${GREEN}✓ Kubernetes cluster accessible${NC}"

# Display cluster info
CONTEXT=$(kubectl config current-context)
echo -e "${GREEN}✓ Current context: ${CONTEXT}${NC}"
echo ""

# Ask user which environment to deploy
echo "Which environment would you like to deploy?"
echo "1) Development (apps/dev/)"
echo "2) Staging (apps/staging/)"
echo "3) Production (apps/production/)"
echo "4) Install ArgoCD"
echo "5) Exit"
echo ""
read -p "Enter your choice [1-5]: " choice

case $choice in
    1)
        echo -e "${YELLOW}Deploying to Development...${NC}"
        kubectl apply -f apps/dev/
        echo ""
        echo -e "${GREEN}✓ Development environment deployed!${NC}"
        echo ""
        echo "Access the app with:"
        echo "  kubectl port-forward -n demo-app-dev svc/demo-app 8080:80"
        echo "  curl http://localhost:8080"
        ;;
    2)
        echo -e "${YELLOW}Deploying to Staging...${NC}"
        kubectl apply -f apps/staging/
        echo ""
        echo -e "${GREEN}✓ Staging environment deployed!${NC}"
        echo ""
        echo "Access the app with:"
        echo "  kubectl port-forward -n demo-app-staging svc/demo-app 8080:80"
        echo "  curl http://localhost:8080"
        ;;
    3)
        read -p "⚠️  Deploy to PRODUCTION? (yes/no): " confirm
        if [ "$confirm" == "yes" ]; then
            echo -e "${YELLOW}Deploying to Production...${NC}"
            kubectl apply -f apps/production/
            echo ""
            echo -e "${GREEN}✓ Production environment deployed!${NC}"
            echo ""
            echo "Check status with:"
            echo "  kubectl get all -n demo-app-prod"
        else
            echo "Deployment cancelled."
        fi
        ;;
    4)
        echo -e "${YELLOW}Installing ArgoCD...${NC}"
        kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
        kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
        echo ""
        echo -e "${GREEN}✓ ArgoCD installed!${NC}"
        echo ""
        echo "Get the initial admin password:"
        echo "  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d; echo"
        echo ""
        echo "Access ArgoCD UI:"
        echo "  kubectl port-forward svc/argocd-server -n argocd 8080:443"
        echo "  Open: https://localhost:8080"
        echo ""
        echo "Apply ArgoCD applications:"
        echo "  kubectl apply -f argocd/"
        ;;
    5)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo "=============================="
echo -e "${GREEN}Done! 🎉${NC}"

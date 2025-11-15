# DevOps

## Application

Components:

- Frontend (ReactJS, Typescript)
- Backend (NodeJS, Typescript)

### Frontend

This React page checks if the backend is healthy and lets the user fetch a list of items (jokes) from the backend. It shows loading, error, and data states accordingly.

Components:

- ReactJS (Vite)
- NodeJS
- NPM
- Typescript
- Eslint
- Dockerfile

### Backend

This Express backend enables CORS, loads environment variables, and serves JSON responses including a jokes list while confirming the server’s health and status.

Routes:

- "/" -> Server running status
- "/api" -> Main server response
- "/healthy" -> For kubernetes probes checking
- "/api/jokes" -> Return list of jokes

Components:

- NodeJS
- NPM
- Typescript
- Eslint
- Dockerfile

# Helm and Kustomize

```bash
helm template frontend-app ./manifests/frontend > manifests/kustomize/base/frontend-resources.yaml

helm template backend-app ./manifests/backend > manifests/kustomize/base/backend-resources.yaml

kubectl kustomize ./manifests/kustomize/overlays/dev | kubectl replace -f -
```

## ArgoCD

Argo CD is a GitOps-based deployment tool for Kubernetes that continuously syncs your cluster with your Git repository and automates application delivery.

```bash
# Create namespace argo to create argocd resources
kubectl create ns argo

# Add Helm repo to deploy argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# Install argo-cd (release name: argocd)
helm upgrade --install argocd argo/argo-cd \
-n argo -f helm-values/argocd-values.yaml

# Check argocd resources
helm list -n argo
kubectl get all -n argo

# Get secret to access the dashboard
kubectl get secret -n argo argocd-initial-admin-secret -ojsonpath={.data.password} | base64 -d
```

## Monitoring

Monitoring setup using Prometheus, Grafana

```bash
# Create namespace monitoring to create monitoring resources
kubectl create ns monitoring

# Add Helm repo to deploy monitoring
helm repo add prom https://prometheus-community.github.io/helm-charts
helm repo update

# Install kube-prometheus-stack (release name: prometheus)
helm upgrade --install prometheus prom/kube-prometheus-stack \
-n monitoring -f helm-values/prom-values.yaml

# Check monitoring resources
helm list -n monitoring
kubectl get all -n monitoring

# Get admin-password to access the dashboard
kubectl get secret -n monitoring prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 -d

# Get admin-user to access the dashboard
kubectl get secret -n monitoring prometheus-grafana -o jsonpath="{.data.admin-user}" | base64 -d
```

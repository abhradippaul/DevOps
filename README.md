# DevOps

## Application

Components:

- Frontend (ReactJS, Typescript)
- Backend (NodeJS, Typescript)

### Frontend

This React page checks if the backend is healthy and lets the user fetch a list of items (jokes) from the backend. It shows loading, error, and data states accordingly.

FOLDERS:

- frontend
- backend

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

- / -> Server running status
- /api -> Main server response
- /healthy -> For kubernetes probes checking
- /api/jokes -> Return list of jokes

Components:

- NodeJS
- NPM
- Typescript
- Eslint
- Dockerfile

## Infrastructure

We will use terraform to provision infrastructure with remote backend store using **S3** and state locking using **DynamoDB**.

FOLDERS:

- terraform

Components:

- S3
- IAM
- ECR
- EKS

```bash
# To check terraform plan
terraform plan

# To create terraform resources
terraform apply -auto-approve

# To see list of resources
terraform show list

# To see outputs
terraform output

# To see sensitive outputs
terraform output <resource_name>
```

## Kubernetes

We will set up Kubernetes on AWS EKS. To do this, we need to configure EKS first.

Components:

- Helm
- Kustomize
- EKS
- Resources (Deployment, Service, ConfigMap, Secrets, Namespace, HPA Autoscaling)
- Metrics Server

### EKS

For use AWS EKS we need to configure kubectl

Components:

- EKS
- Kubectl
- ALB Add On
- Terraform

After depoying the EKS and ready state we need the kubeconfig for the cluster

```bash
# Run this command to get kubeconfig for eks cluster
aws eks update-kubeconfig --name <cluster_name> --region <cluster_region>

# Setup ALB Add on in EKS -> OIDC Provider -> Create Policy -> Deploy ALB controller
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks

helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system \
--set clusterName=<your-cluster-name> \
--set serviceAccount.create=false \
--set serviceAccount.name=aws-load-balancer-controller \
--set region=<your-region> \
--set vpcId=<your-vpc-id>

# Verify the ALB controller
kubectl get deployment -n kube-system aws-load-balancer-controller
```

```bash
apiVersion: v1
kind: ServiceAccount
metadata:
  name: aws-load-balancer-controller
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::936379345511:role/eks-alb-role
```

Create fargate profile -> Limit namespace
Public Subnet tag -> kubernetes.io/role/elb=1
Private Subnet tag -> kubernetes.io/role/internal-elb=1

### Metrics Server

We need to deploy metrics-server in kubernetes to monitor pod metrics and scale according this

```bash
# Create namespace metrics-server to create metrics-server resources
kubectl create ns metrics-server

# Add Helm repo to deploy metrics-server
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update

# Install metrics-server (release name: metrics-server)
helm upgrade --install metrics-server metrics-server/metrics-server \
-n metrics-server
```

### Helm and Kustomize

Using **Helm** we will create the charts for frontend and backend application.
Using **Kustomize** we will create the resources in different environment.

FOLDERS:

- manifests

```bash
# To create a single resource file from the frontend helm chart run this command
helm template frontend-app ./manifests/frontend > manifests/kustomize/base/frontend-resources.yaml

# To create a single resource file from the backend helm chart run this command
helm template backend-app ./manifests/backend > manifests/kustomize/base/backend-resources.yaml

# Mannual Deployment of resources in different environment
# kubectl kustomize ./manifests/kustomize/overlays/dev | kubectl replace -f -
# kubectl kustomize ./manifests/kustomize/overlays/stage | kubectl replace -f -
# kubectl kustomize ./manifests/kustomize/overlays/prod | kubectl replace -f -
```

## Monitoring

Monitoring setup using Prometheus, Grafana

FOLDERS:

- helm-values/prom-values.yaml

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
kubectl get secret -n monitoring prometheus-grafana \
-o jsonpath="{.data.admin-password}" | base64 -d

# Get admin-user to access the dashboard
kubectl get secret -n monitoring prometheus-grafana \
-o jsonpath="{.data.admin-user}" | base64 -d
```

Import **1860** dashboard to visualize node metrics

Import **15661** dashboard to visualize kubernetes cluster

## ArgoCD

Argo CD is a GitOps-based deployment tool for Kubernetes that continuously syncs your cluster with your Git repository and automates application delivery.

### ArgoCD Setup

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
kubectl get secret -n argo argocd-initial-admin-secret \
-ojsonpath={.data.password} | base64 -d
```

Default username for argocd is admin

### Application Setup

We create three ArgoCD Applications Dev, Stage, and Prod environments. ArgoCD continuously monitors the repo and automatically updates the Kubernetes resources whenever it detects changes — ensuring all environments stay in sync with Git.

```bash
# Create argocd application for dev environment
kubectl apply -f argocd-applications/argo-dev-env.yaml

# Create argocd application for stage environment
kubectl apply -f argocd-applications/argo-stage-env.yaml

# Create argocd application for prod environment
kubectl apply -f argocd-applications/argo-prod-env.yaml
```

## Monitoring

Monitoring setup using Prometheus, Grafana

```bash
# Add Prometheus Helm repo and update
helm repo add prom https://prometheus-community.github.io/helm-charts
helm repo update

# Create namespace for deploy monitoring resources
kubectl create ns monitoring

# Install kube-prometheus-stack (release name: prometheus)
helm upgrade --install prometheus prom/kube-prometheus-stack \
-n monitoring -f helm-values/prom-values.yaml

# List Helm releases
helm list -n monitoring

# Check the admin-password
kubectl get secret -n monitoring prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 -d

# Check the admin-user
kubectl get secret -n monitoring prometheus-grafana -o jsonpath="{.data.admin-user}" | base64 -d
```

```bash
helm template frontend-app ./manifests/frontend > manifests/kustomize/base/frontend-resources.yaml

helm template backend-app ./manifests/backend > manifests/kustomize/base/backend-resources.yaml

kubectl kustomize ./manifests/kustomize/overlays/dev | kubectl apply -f -
```

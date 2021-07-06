# Adding additional components to docker-desktop kubernetes

## Metrics Server

* To add metrics-server (so you can `kubectl top pod`, `kubectl top node`, etc.), apply `metrics-server.yaml` to docker desktop k8s.

* This is not required if you're running `aks` cluster as it already comes with metrics-server installed


For More info on metrics-server see: https://github.com/kubernetes-sigs/metrics-server

* Note that, Metrics server for k8s on Docker Desktop requires below flag to container args on its pod spec.

* If you're retrieving the yaml from official repo, then you may need to make this check to get it working on docker-desktop k8s.

Below is already added in metrics-server.yaml in this repo
```yaml
- --kubelet-insecure-tls
```

---

### Apply 
```
kubectl apply -f metrics-server.yaml
```

### Verify

```
kubectl get all -n kube-system
kubectl top po -n <your-namespace>
```


# Kustomize

## Setup

Set the current working directory on your terminal to `kubernetes\cw_app` (make sure you've completed until kuberentes lab 5)

---

## Exercise - 1 Kustomization.yaml

* Create a `kustomization.yaml` file and paste in the below manifest. 

> Make sure the manifest filenames for your `deployments`, `services` and `ingress` are matching. (update them if necessary)

```bash
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  - cw-app.yaml
  - cw-app-svc.yaml
  - cw-app-ingress.yaml
```

* Now you can just do `kubectl apply -k .` to deploy all your resources together. (if you're doing this from one level up (for e.g: `kubernetes` directory, then do `kubectl apply -k ./cw-app`)

```bash
# from cw_app folder
kubectl apply -k .

## Example
codespace:~/workspace/cw_lab/kuberentes/cw-app$ k apply -k .
service/cw-app-svc configured
deployment.apps/cw-app configured
ingress.extensions/cw-app-ingress unchanged
```

**Or if you have kustomize cli installed**
```
# see here - https://kubernetes-sigs.github.io/kustomize/installation/
kustomize build . | kubectl apply -f -
```

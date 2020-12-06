# Containerization Workshop 

## Dev Envrionment Tools

* VS Code 
* Git
* Azure CLI
* Recommended for Windows:
    *  Windows Terminal
    *  WSL2 if permitted 
    *  Chocolatey if permitted (makes it easier to install CLI tools on Windows)
---

## Docker

### 1. Install Docker Desktop in your development environment

* https://www.docker.com/products/docker-desktop
---

## Kubernetes / AKS

### 1. Install `Kubectl` if not already installed.

* https://kubernetes.io/docs/tasks/tools/install-kubectl/

### 2. Connect to your Kubernetes Cluster.

* For AKS, `az aks get-credentials -n <your-clustername> -g <resource-group-name>`

### 3. Setup your default namespace. (if you're sharing the cluster)

* Create a namespace with unique name. (for example, using a combination of your first-name and first-letter of your surname)

    > only use lower-case letters and dashes

```bash
    # for example, john-h or jane-s
    kubectl create namespace <your-firstname-and-initial> 
    
    # use your own namespace as a default 
    kubectl config set-context --current --namespace=<your-namespace-name>

    # test it. below should return `No resources found in <your-namespace>`
    kubectl get pods
```

----

### 4. Keep the lab guide open in a separate tab and use the online (github) version as source of truth

> Keep this link open in a separate tab or window: https://github.com/suren-m/cw/tree/master/labs

----

# Containerization Workshop 

## Dev Envrionment Tools

* VS Code 
* Recommended for Windows:
    *  Windows Terminal (https://github.com/microsoft/terminal#installing-and-running-windows-terminal)
    *  Windows Subsystem for Linux (WSL2) if permitted (https://docs.microsoft.com/en-us/windows/wsl/about)
    *  Chocolatey if permitted (makes it easier to install CLI tools on Windows)
* CLI Tools:
   *  Git
   *  Azure CLI
   *  Kubectl
   *  Helm
   *  Curl or Httpie
---

## Docker

### 1. Install Docker Desktop in your development environment

* https://www.docker.com/products/docker-desktop
---

## Kubernetes / AKS

### 1. Connect to your Kubernetes Cluster.

* For AKS, `az aks get-credentials -n <your-clustername> -g <resource-group-name>`

* The above will update the `config` file in your `~/.kube` directory.

   * It can be viewed by doing `kubectl config` or `cat ~/.kube/config`
   
* Check current context (the cluster you are connected to)

   * `kubectl config get-contexts` (notice the `*` under `current` column)

* Test connection to your cluster.

   * `kubectl cluster-info`
   * `kubectl get nodes`

### 2. Setup your default namespace. (if you're sharing the cluster)

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

# Containerization with Kubernetes Workshop

# Environment Setup

## Dev Environment Tools

* VS Code 
* Recommended for Windows:
    *  Windows Terminal 
         * https://github.com/microsoft/terminal#installing-and-running-windows-terminal

    *  Windows Subsystem for Linux (WSL2) if permitted 
         * https://docs.microsoft.com/en-us/windows/wsl/about
      
    *  Package Managers such as `winget` or `scoop` if permitted (makes it easier to install CLI tools on Windows)

    *  Preferred Shell of your choice: PowerShell Core (pwsh), GitBash, WSL2 Bash/ZSH, etc.
    
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

Make Sure Kubernetes is enabled, 

![image](https://user-images.githubusercontent.com/3830633/124665324-80b0b800-dea4-11eb-858f-840b6372e1a8.png)

If you're using WSL2, don't forget to enable it toset limits as shown below: (also you need to integrate docker with your wsl2 distro (see Resources option)
* https://docs.microsoft.com/en-us/windows/wsl/wsl-config#configure-global-options-with-wslconfig

---

## Kubernetes 

### 1. Getting Started with Docker Desktop Kubernetes

* Test connection to your cluster from terminal

   * `kubectl cluster-info`
   * `kubectl get nodes`
---
### 2. Setup your default namespace.

* Create your first namespace

    > only use lower-case letters and dashes

```bash
    # for example, john or jane
    kubectl create namespace <your-firstname> 
    
    # use your own namespace as a default 
    kubectl config set-context --current --namespace=<your-namespace-name>

    # test it. below should return `No resources found in <your-namespace>`
    kubectl get pods    
```
---

### 3. Setup your workspace / project directory for `docker` and `k8s` labs

* Create a directory in your local environment to do the labs. (for e.g: `cw_labs`)

* For e.g, below would create `cw_labs` directory in your `user_home`

   ```bash
   # run this from powershell, bash, gitbash, etc. depending on your local setup
   # feel free to change the location and name as you prefer
   mkdir ~/cw_labs
   ```

* Create `Docker` and `Kubernetes` directories with in your `project_directory`

* Your setup should looks somethign like below. 

    ```bash
    ├── cw_labs
        ├── docker              
        └── kubernetes
    ```

> Keep this repo link open in a separate tab or window: https://github.com/suren-m/cw/tree/master/labs and use it as a source of truth for upto date content.

---

### 4. Labs 

#### Take a look at `Labs` directory to get started with the labs for `01_Docker` and then move on to `02_kubernetes`.

Recommended:
* At least do until `04_docker_registry.md` lab before moving on to kubernetes.
* In Kubernetes, do at least till `03_deployments.md` before moving on to creating your own cluster.

---

### AKS (for those with MSDN subscription or azure dev/sandbox environment)

* If you have MSDN subscription and like to create and connect to AKS, see `04_aks_cluster` in `labs` directory. 

> If you're new to K8s, it is recommended to first familiarize yourself on local cluster a bit by doing a few of the labs from `01_docker` and `02_kubernetes` before moving to AKS. (perhaps on day/week 2)

* By all means, feel free to create it anytime if you don't have local kubernetes available.
----

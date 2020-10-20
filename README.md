# Containerization with Docker and Kubernetes Workshop

## 1. Environment Setup

Connect to remote lab environment from VS Code by following the instructions in below link

[VS Code Setup for Remote Workshop](https://github.com/suren-m/remote-workshop-env/blob/master/vscode/LabEnvSetup.pdf)

----

## 2. Setup your default namespace. (as we're sharing a cluster)

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

## 3. Keep the lab guide open in a separate tab and use the online (github) version as source of truth

> Keep this link open in a separate tab or window: https://github.com/suren-m/cw/tree/master/labs

----

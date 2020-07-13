# Lab 1 - Getting Started with Kubernetes

## Directory Setup

1. Make sure that you are well aware of the directory you will be using for your labs.

2. If you're on codespaces, note that `~/workspace` is the default directory that will open everytime you launch vs code.

3. Set your current working directory to `cw_labs\kubernetes`. We will be storing our `k8s` related labs inside this directory.


## Exercise 1 - Create a namespace for yourself as we are sharing a cluster.

Namespaces are also called `virtual clusters` in k8s and they are helpful to isolate workloads and environments. 

**Skip to next lab if you have already configured your namespace during lab environment setup**

Replace `<your-namespace>` with your `first-name` or `first-name with initial of surname`

1. Create new Namespace called `<your-namespace>`.
    
    ```bash
    kubectl create namespace <your-namespace>
    ```

2. Set your context so your new namespace is used as default. This will ensure you don't accidentally deploy to any other namespaces when you forget to specify `-n` or `--namespace` flag

    ```bash
    kubectl config set-context --current --namespace=<your-namespace>
    ```

    > Note: `kubectl config` points to the `config` file  in `~/.kube` directory

    ```bash
    # this will pretty much display the contents of your config file
    kubectl config view
    ```

3. Below should return `No resources found in <your-namespace>`. If you see anything else, get in touch with instructor as you may be pointing to another namespace.

    ```bash
    kubectl get pods

    # Note: when you don't specify a `-n ` flag, kubectl uses default namespace that you have configured in your context.
    ```

---

# Lab 1 - Getting Started with Kubernetes

## Exercise 1 - Deploy AKS
In this exercise, you will use the Azure CLI to deploy a Kubernetes cluster with Azure Kubernetes Service.

### Steps

Verify access by running below command against your Kubernetes cluster.

    ```bash
    kubectl get all
    ```

## Exercise 2 - Interfacing with Kubernetes
```kubectl```, said *Kube-Control*, is the  command line interface for running commands against a Kubernetes clusters. In this execise, you will explore some useful features of ```kubectl``` that you may find useful.

### Explore ```kubectl```

1. Get Cluster information.

    ```bash
    kubectl cluster-info
    ```

1. Write Cluster information to a file name 'cluster.txt'.

    ```bash
    kubectl cluster-info > cluster.txt
    ```

1. Get a list of nodes in the cluster.

    ```bash
    kubectl get nodes
    ```
 
1. Get a list of all namespaces in the cluster.

    ```bash
    kubectl get namespaces
    ```

1. Find out CPU and memory limits for the first node in the cluster

    ```bash
    # get list of nodes
    kubectl get nodes

    # using the first one, describe the node
    kubectl describe node <node-name>
    ```

    **or**

    ```bash
    # once you become more familar with jsonpath, you could do the same like this
    kubectl get nodes -o jsonpath='{.items[0].metadata.name}' | kubectl describe node
    ```

### Generate YAML

1. We can do the same for to define a pod:

    ```bash
    kubectl run nginx --image nginx --restart=Never --dry-run -o yaml > pod.yaml
    ```
    
    > **Note:** the use of ```--dry-run -o yaml``` to generate the yaml. 
    >
    > * ```--dry-run``` - prints the object that would be sent, without sending it. 
    > * ```-o yaml``` - changes the output format to yaml

2. Use ```kubectl``` to apply the configuration:

    ```bash 
    kubectl apply -f pod.yaml -n <your-namespace>
    ```
    Note: <your-namespace> is the namespace you created when configuring kubectl. It should be set to <your-namespace> by default when we did `kubectl set-context` but it's a good practice to pass namespace name when deploying workloads so we know exactly where it's going to.

### Explain
```kubectl explain``` will explain the given resource. For example, a top level API-object like Pod or a specific field like a Pod's container. 

1. Get the documentation of a Pod resource and its fields.

    ```bash
    kubectl explain pods
    ```

1. Get the documentation for a Pod's container specification.

    ```bash
    kubectl explain pods.spec.containers
    ```

    > **Note:** ```pods.spec.containers``` matches the yaml object structure:
    > ```yaml
    > apiVersion: v1
    > kind: Pod
    > metadata:
    > creationTimestamp: null
    > name: nginx
    > spec:
    >   containers:
    >   - image: nginx
    >     imagePullPolicy: IfNotPresent
    >     name: nginx
    >     resources: {}
    >   dnsPolicy: ClusterFirst
    >   restartPolicy: Never
    > ```

## Exercise 3 - Explore pods running in your namespace

```bash
    kubectl get pods 
```

> Note: if you don't pass in -n <namespace>, it will retrieve data from the default namespace you've configured.
    
> To see all namespaces, you can use `kubectl get pods --all-namespaces` but you may not be able to do this if your RBAC role doesn't have access.

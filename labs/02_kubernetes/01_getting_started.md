# Lab 1 - Getting Started with Kubernetes

## Exercise 1 - Create a namespace for yourself as we are sharing a cluster.

* Namespaces are also called `virtual clusters` in k8s and help to isolate resources.

## Namespaces 

**Skip to `Exercise 2` if you have already configured your namespace**

Replace `<your-namespace>` with your `first-name`. 

1. Create new Namespace called `<your-namespace>`.
    
    ```
    kubectl create namespace <your-namespace>
    ```

2. Set your context so your new namespace is used as default. This will ensure you don't accidentally deploy to any other namespaces when you forget to specify `-n` or `--namespace` flag

    ```
    kubectl config set-context --current --namespace=<your-namespace>
    ```

3. Below should return `No resources found in <your-namespace>`. If you see anything else, get in touch with instructor as you may be pointing to another namespace.

    ```
    kubectl get pods

    Note: when you don't specify a `-n ` flag, kubectl uses default namespace that you have configured in your context.
    ```

## Exercise 2 - Interacting with Kubernetes

```kubectl```, said *Kube-Control*, is the  command line interface for running commands against a Kubernetes clusters. In this execise, you will explore some useful features of ```kubectl``` that you may find useful.

### Explore ```kubectl```

1. Get Cluster information.

    ```bash
    kubectl cluster-info
    ```

2. Write Cluster information to a file name 'cluster.txt'.

    ```bash
    kubectl cluster-info > cluster.txt

    # view it using cat if you like
    cat cluster.txt
    ```

3. Get a list of nodes in the cluster.

    ```bash
    kubectl get nodes 
    ```
 
4. Get a list of all namespaces in the cluster. Here you will see other participants namespaces too. In real world, you may not have access to view other namespaces.

    ```bash
    kubectl get namespaces
    ```

5. Find out CPU and memory limits for the first node in the cluster

    ```bash
    # get list of nodes
    kubectl get nodes 

    # using the first one, describe the node. `-o` is output and `wide` will show additional columns
    kubectl describe node <node-name> -o wide
    ```

    **or**

    ```bash
    # once you become more familar with jsonpath, you could do the same like this
    kubectl get nodes -o jsonpath='{.items[0].metadata.name}' | kubectl describe node
    ```

> See here if you would like to know of how you are authenticated to use the cluster. https://kubernetes.io/docs/reference/access-authn-authz/authentication/#authentication-strategies

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

2. Get the documentation for a Pod's container specification.

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

## Advanced / Bonus: (Skip for now if you are on vs online)

Enable auto completion for your kubectl to improve the CLI experience. If you are not used to bash / shell environments, leave out for now.

https://kubernetes.io/docs/tasks/tools/install-kubectl/#optional-kubectl-configurations


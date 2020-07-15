# Lab - Getting Started with Kubernetes

## Exercise 1 - Interacting with Kubernetes using `kubectl`

```kubectl```, pronounced *Kube-Control*, is the  command line interface for running commands against a Kubernetes clusters. In this execise, you will explore some useful features of ```kubectl``` that you may find useful.

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

3. Get a list of all namespaces in the cluster. Here you will see other participants namespaces too. In real world, you may or may not have access to view other namespaces.

    ```bash
    kubectl get namespaces

    # or use the short-hand
    kubectl get ns

    # filter your namespace by using `grep`
    kubectl get ns | grep '<your-namespace-name>' 
    ```

4. Check your `default` namespace for your current context.

    ```bash
    kubectl config get-contexts     
    ```

    You should see an output such as below with your `your namespace name` appearing under NAMESPACE column. 

    ```bash
    # example output for above command
    CURRENT   NAME   CLUSTER   AUTHINFO               NAMESPACE
    *         cw     cw        clusterUser_cw-rg_cw   <your-namespace-name>
    ```

    > Important: If the NAMESPACE column is blank or doesn't contain your namespace name, it means you haven't configured your default namespace correctly. Reach out to the instructor for help.

4. Get a list of nodes in the cluster.

    ```bash
    kubectl get nodes 

    # see more info with -o wide
    kubectl get nodes -o wide

    ```
 ---

## Exercise 2 - Use `Explain` for docs

```kubectl explain``` will explain the given resource. For example, a top level API-object like Pod or a specific field like a Pod's container. 

1. Get the documentation of a Pod resource and its fields.

    ```bash
    kubectl explain node
    ```

2. Get the documentation for a Pod's container specification.

    ```bash
    # to just explain pod
    kubectl explain pod  

    # to further explain the properties and nested objects
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

---

## Exercise 3 - Retrieve CPU and Memory metrics from your nodes

1. See cpu and memory usage of all nodes

    ```bash    
    kubectl top nodes    
    ```

    If you're interested to know more about metrics in k8s, take a look at:   

    * [Metrics server in k8s](https://github.com/kubernetes-sigs/metrics-server)
    
    * [Cpu units in K8s](https://kubernetes.io/docs/tasks/configure-pod-container/assign-cpu-resource/#cpu-units)

    * [Memory units in K8s](https://kubernetes.io/docs/tasks/configure-pod-container/assign-memory-resource/#memory-units)

2. Find out `CPU` and `memory` limits on the first node in cluster

    The resource limits you see here were created by existing workloads such as dashboard, metrics-server, etc

    ```bash    
    # get list of nodes
    kubectl get nodes     
    # describe a particular node
    kubectl describe node <name-of-first-node> 
    ```

    **or**
    ```bash
    # once you become more familar with jsonpath, you could do the same like this
    kubectl get nodes -o jsonpath='{.items[0].metadata.name}' | kubectl describe node
    ```

    **or if you prefer to use tools like `jq`**
    ```bash
    kubectl get nodes -o json | jq '.items[0].metadata.name' | kubectl describe node
    ```
---

## Bonus

1. Take a quick look at `kuberenetes` cheatsheet. It's useful and will come in handy when diving deeper into `kubectl`.

    * [Kubernetes Cheatsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

 > **_Skip below two tasks for now if you are new to bash / linux command line_**

2. Setup an alias for `kubectl`

    * In `bash`, you can setup aliases, so that you don't have to type `kubectl` everytime and just use the shorthand.

        * For e.g. it's common to configure `k` for `kubectl`

    * This can be done by adding `alias k=kubectl` to your `.bashrc` file in your home directory.

        ```bash    
        # open .bashrc from your home directory using your editor of choice. 
        code ~/.bashrc

        # Go to end of the file and add the alias
        alias k=kubectl

        # Save and exit the editor
        # ctrl + s or file menu -> save
        ```  

    * Restart the shell or run a `source` from the terminal.

        ```bash
        source ~/.bashrc
        ```

2. Enable kubectl `autocompletion` for bash (or zsh)   

    Enable auto completion for your kubectl to improve the CLI experience. 

    https://kubernetes.io/docs/tasks/tools/install-kubectl/#optional-kubectl-configurations


# Lab 1 - Getting Started with Kubernetes

## Exercise 1 - Create a namespace for yourself as we are sharing a cluster.

Namespaces are also called `virtual clusters` in k8s and they are helpful to isolate workloads and environments. 

**Skip this exercise and go to `exercise 2` if you have already configured your namespace during lab setup**

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

## Exercise 2 - Interacting with Kubernetes using `kubectl`

```kubectl```, said *Kube-Control*, is the  command line interface for running commands against a Kubernetes clusters. In this execise, you will explore some useful features of ```kubectl``` that you may find useful.

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

    kubectl describe node <node-name> 
    ```

    **or**

    ```bash
    # once you become more familar with jsonpath, you could do the same like this
    kubectl get nodes -o jsonpath='{.items[0].metadata.name}' | kubectl describe node
    ```

> See [Authentication Strategies in K8s](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#authentication-strategies) if you would like to know of how you are authenticated to use the cluster. 

---

## Exercise 3 - Use `Explain` for docs

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

## Bonus

1. Take a quick look at `kuberenetes` cheatsheet. It's useful and will come in handy when diving deeper into `kubectl`.

    * [Kubernetes Cheatsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

 > **_Skip below two tasks for now if you are very new to bash / linux command line_**

2. Setup an alias for `kubectl`

    * In `bash`, you can setup aliases, so that you don't have to type `kubectl` everytime and just use the shorthand.

        * For e.g. it's common to configure `k` for `kubectl`

    * This can be done by adding `alias k=kubectl` to your `.bashrc` file.

        ```bash    
        # open .bashrc from your home directory using your editor of choice. 
        code ~/.bashrc

        # Go to end of the file and add the alias
        alias k=kubectl

        # Save and exit the editor
        ```  

    * Restart the shell or run a `source` from the terminal.

        ```bash
        source ~/.bashrc
        ```

2. Enable kubectl `autocompletion` for bash (or zsh)   

    Enable auto completion for your kubectl to improve the CLI experience. 

    https://kubernetes.io/docs/tasks/tools/install-kubectl/#optional-kubectl-configurations


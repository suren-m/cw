# Pods

A Pod represents a set of running containers on your cluster - it's the smallest and simplest Kubernetes object.

## Exercise 1 - Create and manage Pods with cli commands (Imperative approach)

1. Create new Pod called 'web1' running nginx image using command line        

    ```bash
    kubectl run web1 --image=nginx --restart=Never 
    ```   
   
2. Get the status, IP of the pod 'web1' using `wide` output. 

    ```
    kubectl get pod web1 -o wide 
    ```

    Now use describe to get detailed description of the pod , including related resources such as events  or controllers
    ```
    kubectl describe pod web1  
    ```

3. List all the pods in current namespace 
    
    ```
    kubectl get pod 
    ```
---

## Kubernetes `Manifest` files (.yaml files)

* The most common and recommended way to deploy workloads to kuberentes is using `.yaml` manifest files.
* This approach provides `declarative` and `idempotent` solution to deploy and manage workloads and resources in Kuberenetes.
* The manifest files are then `version controlled` and managed very much like application source code. 
    * For this reason, they **must not** contain any sensitive data

---

## Exercise 2 - Creating Pods using a `Manifest` file (declarative approach)

There are a few ways to create manifest files.
* Hand-code them from scratch
* Let an IDE such as `vs code kuberentes extension` generate the scaffold for us.
* Take advantage of `--dry-run` flag and `-o yaml` in `kubectl` to generate the initial yaml. (most common technique)

1. Generate a `yaml` file for a pod called `web2` from terminal.

    > **Important:** Notice how we've used `--dry-run` flag in combination with `-o yaml` and then saving the output to a `yaml` file.

    ```bash
        # Take a minute to understand what we are doing here.
        kubectl run web2 --image=nginx --restart=Never --dry-run -o yaml > web2-pod.yaml
        
        # Or use --dry-run=client (for newer version of kubectl >= 1.18)        
        kubectl run web2 --image=nginx --restart=Never --dry-run=client -o yaml > web2-pod.yaml
    ```

    * View the file using VS Code (or any editor of choice) or just type `cat web2-pod.yaml` from terminal

    * `web2-pod.yaml` should look like below

```yaml
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: web2
  name: web2
spec:
  containers:
  - image: nginx
    name: web2
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Never
status: {}
```

    * Explore the contents of `web2-pod.yaml`. Have a look at properties such as:
        * api-version
        * kind
        * labels
        * spec
        * restart-policy               

    * **Bonus**: Like to see the pod as it gets created / updated? Just setup a `watcher`
        * Open a second terminal / pane and then run `kubectl get pods -w`. 
        * You can now see the stages your new pod goes through in this pane / terminal. 
        * You can always do a `ctrl + c` to exit the `watcher` 

2. Create a pod from the manifest file using `kubectl apply`.    
    
    * Create the pod from your main terminal / pane.

      ```bash
      kubectl apply -f web2-pod.yaml -n <your-namespace>

      # Or Skip the -n flag if you have correctly set your default namespace

      kubectl apply -f web2-pod.yaml
      ```

    > BONUS: Find out the difference between `kubectl apply` and `kubectl create`

3. Get the status, IP of the pod 'web2' 

    ```bash
    # Notice the use of `-o wide`    
    kubectl get pod web2 -o wide -n <your-namespace> 
    ```

---

## Exercise 3 - Fixing a faulty image

1. Open `web2-pod.yaml` file in `vs code`

    ```bash
    # with the present working directory pointing to file location
    code web2-pod.yaml
    ```

2. Introduce a fault by changing the value of `image` field from `nginx` to `ngiinx:1.19.0` 

    > Notice the typo in image name

3. Deploy the pod with faulty image name.

    ```bash
    kubectl apply -f web2-pod.yaml
    ```

4. Check the status of `web2` pod. 

    ```bash    
    kubectl describe pod/web2     
    ```

    * It should state something like `Failed to Pull Image` or `ImagePullBackOff`
    * This is because there is no such image. (due to our typo)

5. Fix the `manifest` with correct value to image. 

    * Open `web2-pod.yaml` and change the image to correct value `nginx:1.19.0` (typo fix)

6. Delete the existing faulty pod and do an apply

    ```bash
    # delete
    kubectl delete pod web2

    # apply
    kubectl apply -f web2-pod.yaml    
    # or (alternate approach using stdin)
    cat web2-pod.yaml | kubectl apply -f -
    ```

7. Do a status check and Make sure that the pods are `running` as expected.

    ```bash
    kubectl get po -o wide
    ```
---

## Exercise - 4 Port-Forward

1. Hit the default nginx page of `web1` or `web2` pod by doing a `Port-forward` to localhost. 

    > This is a relly useuful feature to quickly test out web apps or apis on `K8s` and is very similar to `-p` flag in `Docker`.

    ```bash
        # make sure you use a port number that is not in use. (e.g: 9000)
        kubectl port-forward web1 9000:80         
    ```

2. Now, open your second `pane` or terminal and type the following. (do a `ctrl+c` if you have watcher running on it)

    ```bash
    http http://localhost:9000

    # or use curl if you don't have httpie installed.
    curl http://localhost:9000

    # observe the html output. 
    # If you are running `kubectl` from local machine, you'd be able to run it on a browser.
    ```

3. From first pane / terminal, use `ctrl + c` to exit from port-forwarding. 

---

## Exercise 5 - Logs and Execs in Pods

> Remember `logs` and `exec` commands from docker labs?

1. Get logs of nginx container in 'web1' pod (just use the same pod that was pinged in previous exercise)

    ```bash
    kubectl logs web1 -n <your-namespace> 
    ```

    > Bonus: See `kubectl logs -h` for more options such as `--follow`

2. List the directories within of nginx container nginx in 'web1' pod

    ```
    kubectl exec web1 -n <your-namespace> -- ls
    ```
---

## Exercise 6 - Events

You can see all events from your namespace using below command

```bash
kubectl get events -n <your-namespace>
```

Additionally, you can filter them to a specific object or have a watcher attached (`-w`) 

---

## Bonus

1. See if you can connect to the shell in running pod like we did with docker. 
    * **Hint:** Remember `-it` flag in docker?

2. `Pods` can have multiple containers. How can you specify the container you wish to `exec`? 
    * **Hint:** See `kubectl exec -h` and look for `-c` flag.

3. Take a look at `cpu units` and `memory units` in k8s.
    > [Cpu units in K8s](https://kubernetes.io/docs/tasks/configure-pod-container/assign-cpu-resource/#cpu-units)

    > [Memory units in K8s](https://kubernetes.io/docs/tasks/configure-pod-container/assign-memory-resource/#memory-units)
---

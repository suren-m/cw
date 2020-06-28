# Pods

A Pod represents a set of running containers on your cluster - it's the smallest and simplest Kubernetes object.

## Exercise 1 - Create and manage Pods with cli commands (Imperative approach)

1. Create new Pod called 'web1' running nginx image using command line 

    > **Bonus**: Like to see the pod as it gets created? Run `kubectl get pods -w`. Now open a another pane / terminal and run the below command. Your new pod should appear in first pane / terminal and you can see the stages it goes through. `ctrl + c` to exit `watcher` (-w)

    ```bash
        kubectl run web1 --image=nginx --restart=Never 
    ```
    
    Do a `Port-forward` to localhost to see the webpage. (handy feature to test out simple web apps / apis on k8s)
    ```bash
        # make sure you use a port number that is not in use. (e.g: 9000)
        kubectl port-forward web1 9000:80         
    ```

    ** If you are on `vs-online`, open another terminal or pane, and type the following
    ```bash
       http http://localhost:9000
       # or use curl if you don't have httpie installed.
       curl http://localhost:9000
       
       # observe the html output. If this was local machine, you'd be able to run it on browser.
    ```

    Use `ctrl + c` to exit from port-forwarding.    

2. Get the status, IP of the pod 'web1' using `wide` output. 

    ```
    kubectl get pod web1 -o wide 
    ```

    Now use describe to get detailed description of the pod , including related resources such as events  or controllers
    ```
    kubectl describe pod web1  
    ```

3. Delete pod 'web1' 
    
    ```
    kubectl delete pod web1
    ```

4. List all the pods in current namespace 
    
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
        
        # Or use --dry-run=client (for newer version of kubectl)        
        kubectl run web2 --image=nginx --restart=Never --dry-run=client -o yaml > web2-pod.yaml
    ```

    * View the file using VS Code (or any editor of choice) or just type `cat web2-pod.yaml` from terminal

    * Explore the contents of `web2-pod.yaml`. Have a look at properties such as:
        * api-version
        * kind
        * labels
        * spec
        * restart-policy

2. Create a pod from the manifest file using `kubectl apply`.
    
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

2. Introduce a fault by changing the value of `image` field to `ngiinx:1.19.0` 

    > Notice the typo in image name

3. Deploy the pod with faulty image name.

    ```bash
    kubectl apply -f web2-pod.yaml
    ```

4. Check the status of `web2` pod. 

    ```bash
    kubectl get pod -o wide
    ```

    * It should return something like `ImagePullBackOff` for `web2` pod.
    * This is because there is no such image. (due to our typo)

5. Fix the `manifest` with correct value to image. 

    * Open `web2-pod.yaml` and change the image to correct value `nginx:1.19.0` (typo fix)

6. Deploy the pod

    ```bash
    kubectl apply -f web2-pod.yaml
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
        kubectl port-forward web2 9000:80         
    ```

2. Now, open a second `pane` or new terminal and type the following.

    ```bash
    http http://localhost:9000

    # or use curl if you don't have httpie installed.
    curl http://localhost:9000

    # observe the html output. 
    # If you are running `kubectl` from local machine, you'd be able to run it on a browser.
    ```

3. From first pane / terminal, use `ctrl + c` to exit from port-forwarding. 

---

## Exercise - 5 Logs and Execs in Pods

> Remember `logs` and `exec` commands from docker labs?

1. Get 'web2' pod logs (just use the same pod that was pinged in previous exercise)

    ```bash
    kubectl logs web2 -n <your-namespace> 
    ```

    > Bonus: See `kubectl logs -h` for more options such as `--follow`

2. Run list all the files within container nginx running on 'web2' pod

    ```
    kubectl exec web2 -n <your-namespace> -- ls
    ```
---

## Bonus

1. See if you can connect to the shell in running pod like we did with docker. 
    * **Hint:** Remember `-it` flag in docker?

2. `Pods` can have multiple containers. How can you specify the container you wish to `exec`? 
    * **Hint:** See `kubectl exec -h` and look for `-c` flag.
---

# Pods

A Pod represents a set of running containers on your cluster - it's the smallest and simplest Kubernetes object.

## Create and manage Pods with cli commands (Imperative approach)

1. Create new Pod called 'webserver' running nginx image using command line 

    > **Bonus**: Like to see the pod as it gets created? Run `kubectl get pods -w`. Now open a another pane / terminal and run the below command. Your new pod should appear in first pane / terminal and you can see the stages it goes through. `ctrl + c` to exit `watcher` (-w)

    ```bash
        kubectl run webserver --image=nginx --restart=Never 
    ```
    
    Do a `Port-forward` to localhost to see the webpage. (handy feature to test out simple web apps / apis on k8s)
    ```bash
        # make sure you use a port number that is not in use. (e.g: 9000)
        kubectl port-forward webserver 9000:80         
    ```

    ** If you are on `vs-online`, open another terminal or pane, and type the following
    ```bash
       http http://localhost:9000
       # or use curl if you don't have httpie installed.
       curl http://localhost:9000
       
       # observe the html output. If this was local machine, you'd be able to run it on browser.
    ```

    Use `ctrl + c` to exit from port-forwarding.    

2. Get the status, IP of the pod 'webserver' using `wide` output. 

    ```
    kubectl get pod webserver -o wide 
    ```

    Now use describe to get detailed description of the pod , including related resources such as events  or controllers
    ```
    kubectl describe pod webserver  
    ```

3. Delete pod 'webserver' 
    
    ```
    kubectl delete pod webserver
    ```

4. List all the pods in current namespace 
    
    ```
    kubectl get pod 
    ```

5. Create new Pod called 'faultywebserver' running nnginx image using command line. (**notice the typo in image name**)

    ```kubernetes
    kubectl run faultywebserver --image=nnginx --restart=Never 
    ```

6. Get the status, IP of the pod 'faultywebserver' 

    ```
    kubectl get pod faultywebserver -o wide 
    ```

   Use describe command to identify the issue 
    ```
    kubectl describe pod faultywebserver 
    ```

7. Now fix the pod and verify it runs correctly 
    
    > **Note**: If you are running below in linux / vs online but not used to `vi` / `vim` editor, reach out to instructor for help. This is because vim is the default text editor in most linux environments.
    
    > `vim` tips: 
        > *   `i` for insert mode
        > *   `esc` to go back to normal mode
        > *   When in normal mode, type `:wq` to save or `:q!` to quit without saving.        

    ```
    # IMPORTANT: this will open `yaml` config in vim if you are in linux / vs online. 

    kubectl edit pod faultywebserver    
    ```   

    * Edit file and change the following ```image: nnginx``` to be ```image: nginx```
    * Save and close the file (`esc` and then `:wq` on vim)
    * verify that changes worked

        ```
        kubectl get pod faultywebserver -o wide 
        ```

8. Delete all Pods in current namespace 

    ``` 
    kubectl delete po --all
    ```

## Creating Pods using YAML (declarative approach)

1. Create new Pod called 'webserver' described using YAML into <your-namespace>

    Notice we used --dry-run flag 

    ```
        kubectl run webserver --image=nginx --restart=Never --dry-run -o yaml > nginx-pod.yaml
    ```

    * View the file using VS Code (or any editor of choice) or just type `cat nginx-pod.yaml`

    * Explore the contents of `nginx-pod.yaml`. Have a look at properties such as:
        * api-version
        * kind
        * labels
        * spec
        * restart-policy

    * Now create a pod using the YAML file 
      ```
      kubectl apply -f nginx-pod.yaml -n <your-namespace>

      # Or if you have correctly set your default namespace, skip the -n flag

      kubectl apply -f nginx-pod.yaml

      ```

> BONUS: Find out the difference between `kubectl apply` and `kubectl create`

3. Get the status, IP of the pod 'webserver' 

    ```
    kubectl get pod webserver -o wide -n <your-namespace> 
    ```

4. change the image nginx in 'webserver' pod to use tag 1.16.0 

    * edit the image field to include tag e.g. nginx:1.16.0 in the nginx-pod.yaml
    * Save the file 

    ```bash
     kubectl apply -f nginx-pod.yaml -n <your-namespace>
    ```

## Pod Logs and Execs 

> Note: Remember logs and Exec in docker labs?

1. Get 'webserver' pod logs

    ```
    kubectl logs webserver -n <your-namespace> 
    ```

> Bonus: See `kubectl logs -h` for more options such as `--follow`

2. Run list all the files within container nginx running on 'webserver' pod

    ```
    kubectl exec webserver -n <your-namespace> -- ls
    ```

> Bonus: See if you can connect to the shell in running pod like we did with docker. **Hint:** Remember `-it` flag in docker?

> Bonus 2: `Pods` can have multiple containers. How can you specify the container? **Hint:** See `kubectl exec -h` and look for `-c` flag.

### Delete all resources in the current namespace 

> **IMPORTANT:** Only clean up your resources. 

```bash
kubectl delete all --all 
    or
kubectl delete all --all -n <your_namespace> 
```
> **Warning:** There is an `--all-namespaces` flag that will run a comamnd against all namespaces! **Please Don't** use this flag for anything apart from simple `get` operations.

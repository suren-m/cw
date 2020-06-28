
# Services

## Exercise -1 Expose both `web1` and `web2` pods as services

1. For web1, we use command-line approach

    * Use `kubectl expose` command to create a service called `web1-svc` for `web1` pod

    ```bash
    kubectl expose po web1 --name=web1-svc --port=80 --target-port=80

    # verify
    kubectl get svc web1-svc
    kubectl describe svc web1-svc
    ```

    >  Note that default service type is `cluster-ip`


2. For web2, we use declarative approach using a manifest file

    * Take advantage of `--dry-run` with `-o yaml` for generating the manifest.

        ```bash
        kubectl expose po web2 --name=web2-svc --port=80 --target-port=80 --type=ClusterIP --dry-run -o yaml > web2-svc.yaml
        ```

    * Take a look at the manifest file and understand what it's doing. It should look something like below.

        > Pay extra attention to the `selector` field

        ```bash
        apiVersion: v1
        kind: Service
        metadata:
        creationTimestamp: null
        labels:
            run: web2
        name: web2-svc
        spec:
        ports:
        - port: 80
            protocol: TCP
            targetPort: 80
        selector: # target resource(s) label(s)
            run: web2 
        type: ClusterIP
        status:
        loadBalancer: {}
        ```

    * Do a `kubectl apply`

        ```bash
        kubectl apply -f web2-svc.yaml
        ```

3. Confirm that both services have been created and check their target endpoints (in this case, ip address of pods)

    ```bash
    # services
    kubectl get svc 
    # endpoints
    kubectl get ep 
    ```

---

## Exercise 2 - Port-forward to a service

We can do a `port-forward` on the service as well. This will particulary be useful later when we have many pods running behind a single service where the service acts as a `reverse proxy` and provides a unified entry-point.

```bash
kubectl port-forward service/web1-svc 9001:80 

# Do a port-forward for web2-svc as well if you prefer
```

---

## Exercise 3 - Call service by thier names from another Pod. 

Resources within the cluster can take advantage of built-in `service discovery` in `Kubernetes` communicate with services using their names.

For this, we first need to create a pod using `busybox` as it provides tools such as `wget`

```bash    
# run a busybox and launch its shell 
kubectl run busybox --rm --image=busybox -it --restart=Never -- sh    

# Call web1-svc. Below would print out the html page.
wget -q -O - web1-svc

# call web2-svc using the namespace suffix.
# This will be helpful when calling services from other namespaces
wget -q -O - web2-svc.<your-namespace>

# Alternatively, you can use the service's cluster-ip as well if needed.
wget -q -O - <cluster-ip-of-web2-svc>:80

exit    
```

Here, We've ensured that we can hit our service from another pod inside the same cluster.    

---

> Note: Changing the service(s) to type `LoadBalancer` will creates a public ip on the cloud and expose them to the internet. This is not `recommended` as it poses security risks. Just use `port-forwarding` to a `ClusterIP` instead whenever you need to access a service on the cluster from local machine.

> We will take a look at `ingress-controller` later which will allow us to expose services to the internet in a controlled way.
---

## Bonus:

1. Convert the type of `web1-svc` from ClusterIP to NodePort 

    **Note**: below will open in `vim` if you're in `vs-online` or `linux`. 

    To enter `insert` mode in `vim` type `i` and it should say `INSERT` at bottom left 

    ```bash
    kubectl edit svc web1-svc
    # Change `type: ClusterIP` to `type: NodePort` (3 lines from the bottom)       
    ```

    **To save and quit Vim**, press `Esc` to make sure you are in `normal` mode. (it should no longer say `INSERT`) 
    
    And then, use one of the below options:
    
    * Press `:` to go into command mode, and then type `wq` and hit enter.
    * Or, just hit `ZZ` from normal mode. (upper-case Z)

2. Make sure that `web1-svc` is now of type `NodePort`. 

    ```bash
    kubectl get svc web1-svc

    # Output should look something like below
    NAME       TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
    web1-svc   NodePort   10.0.137.154   <none>        80:30904/TCP   41m
    ```
---



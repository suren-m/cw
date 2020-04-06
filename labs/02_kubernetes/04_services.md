
# Services

### Create a pod with image nginx called webapp and expose its port 80

```bash
    kubectl run webapp --image=nginx --restart=Never --port=80 --expose
    # Observe that a pod as well as a service are created. 
    # Service Defaults to cluster-ip if nothing specified after --expose
```

### Confirm that ClusterIP has been created. Also check endpoints

```bash
    # services
    kubectl get svc webapp 
    # endpoints
    kubectl get ep 
```

### Get pod's ClusterIP, create a temp busybox pod and 'hit' that IP with wget

```bash
    # get the <svc-cluster-ip> from below (something like 10.108.93.130)
    kubectl get svc webapp 
    kubectl run busybox --rm --image=busybox -it --restart=Never -- sh    
    wget -O- <svc-cluster-ip>:80
    exit

    # We've ensured that we can hit our service from another pod inside the same cluster.    
```

### Convert the ClusterIP to NodePort and find the NodePort port.

**Note**: this will open in `vim` if you're in `vs-online` or `linux`

```bash
    kubectl edit svc webapp
    # Change `type: ClusterIP` to `type: NodePort` (3 lines from the bottom)
    kubectl get svc 
    # Observe the change in service type
```

### Convert the NodePort to LoadBalancer and find the Public IP 
```bash
    kubectl edit svc nginx
    # Change `type: NodePort` to `type: LoadBalancer` (3 lines from the bottom)
    # External-IP will take a few minutes to be allocated.
    # If you get any errors with ip provisioning, speak to the instructor as this may be due to subscription limits
    kubectl get svc 
```
### Access the Service from your browser!

* Goto Browser -> http://<external-ip-of-webapp>

Notice the `Nginx` default webpage on your browser.

### Delete all resources in your current namespace as before.

> As always, be cautious during delete operations.

```bash
    kubectl delete all --all
```


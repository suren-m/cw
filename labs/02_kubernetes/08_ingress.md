## Ingress Lab - Create an Ingress resource and Attach your backend service to existing ingress controller

---

## Very important:

* **Don't attempt to do this lab if you haven't attended the sessions for Kubernetes Ingress controller and Ingress Objects.**

**Docker Desktop Kubernetes**
> If you're using docker-desktop kubernetes, creating an ingress controller will take over your `192.168.1.1` and may cause your non-k8s web apps to stop working. In which case, you'd need to delete the ingress controller (or reset your local k8s cluster) 

**Internal Ingress Controller for AKS**
> If you're on AKS, you'd need an **internal ingress controller** to avoid exposing your cluster to the internet, see below link. For that to work, you'd need your cluster located in a subnet that is part of an existing vnet that you can access from your dev environment. 

See: https://docs.microsoft.com/en-us/azure/aks/ingress-internal-ip

> If you're new to Azure and concepts such as vnet, subnets, vnet gateway, etc, then it's recommended to just follow the demos for now and look into this on separate sessions tailored for AKS Networking.

---

## Exercise -1 Create an ingress resource and attach your `cw-app` service as a backend to it. 

#### Below would work only if you have `nginx` ingress controller provisioned in your environment.

Save the below manifest for ingress as `cw-app-ingress.yaml` (feel free to paste it into vs code editor and save it but make sure the indentation is intact)

> Make sure to replace **`<your-namespace>`** in the last line with your name or your namespace's name. so, we can match paths such as `/john-cw-app` or `/jane-h-cw-app` 

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: cw-app-ingress   
  annotations:
    kubernetes.io/ingress.class: nginx          
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:  
  rules:
  - http:
      paths:
      - path: /<your-namespace>-cw-app
        pathType: Prefix
        backend:
          service:
            name: cw-app-svc # name of your cw-app service
            port:
              number: 80    
```
Take a moment to understand the usage of `annotations` here. It gets used by the client, in this case the `nginx` ingress controller.  

#### Apply the ingress

```bash
kubectl apply -f cw-app-ingress.yaml -n <your-namespace>
```
#### Access your service via Ingress

1. Take note of the **`External-IP`** from below query 

```bash
# The ingress controller of the cluster is located in `ingress-basic` (or your ingress-controller namespace)
# use relevant svc-name if you're not using nginx-ingress-controller
kubectl get svc nginx-ingress-controller -n ingress-basic 
```

2. Now on the browser, paste that external-ip and append your path from above ingress resource to it. (for e.g: `x.x.x.x/jane-h-cw-app`)

3. You should now see the output of your `cw-app-svc` on your browser!

4. If you're having any issues, just reach out to the instructor to clarify concepts regarding this.

---

## Bonus

1. Take a look at how `nginx-ingress-controller` can be used for ssl termination.

https://kubernetes.github.io/ingress-nginx/examples/tls-termination/

2. Creating an Ingress Controller on AKS with internal-ip 

https://docs.microsoft.com/en-us/azure/aks/ingress-internal-ip

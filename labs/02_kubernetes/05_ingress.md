## Ingress Lab - Create an Ingress resource and Attach your backend service to existing ingress controller

## Setup
For this lab, continue using the same `cw-app` directory.

---

> **Note: An ingress controller has already been setup for you on the shared cluster in `ingress-demo` namespace. However, if you're doing this lab in your own cluster, make sure to setup an ingress controller by following [this link](https://docs.microsoft.com/en-us/azure/aks/ingress-basic#create-an-ingress-controller)**

## Exercise -1 Create an ingress resource and attach your `cw-app` service as a backend to it. 

Save the below manifest for ingress as `cw-app-ingress.yaml` (feel free to paste it into vs code editor and save it but make sure the indentation is intact)

> Make sure to replace **`<your-namespace>`** in the last line with your name or your namespace's name. so, we can match paths such as `/john-cw-app` or `/jane-h-cw-app` 

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: cw-app-ingress   
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/rewrite-target: /$2
spec:
  rules:
  - http:
      paths:
      - backend:
          serviceName: cw-app-svc # name of your cw-app service
          servicePort: 80
        path: /<your-namespace>-cw-app(/|$)(.*) # for example, path: /john-cw-app(/|$)(.*)        
```
Take a moment to understand the usage of `annotations` here. It gets used by the client, in this case the `nginx` ingress controller.  

#### Apply the ingress

```bash
kubectl apply -f cw-app-ingress.yaml -n <your-namespace>
```
#### Access your service via Ingress

1. Take note of the **`External-IP`** from below query 

```bash
# The ingress controller of the cluster is located in `ingress-demo` namespace
kubectl get svc nginx-ingress-controller -n ingress-demo 
```

2. Now on the browser, paste that external-ip and append your path from above ingress resource to it. (for e.g: `50.x.x.x/jane-h-cw-app`)

3. You should now see the output of your `cw-app-svc` on your browser!

4. If you're having any issues, just reach out to the instructor.

---

## Bonus

1. Take a look at how `nginx-ingress-controller` can be used for ssl termination.

https://kubernetes.github.io/ingress-nginx/examples/tls-termination/

2. Creating an Ingress Controller on AKS with static-ip (do this in your own cluster)

https://docs.microsoft.com/en-us/azure/aks/ingress-static-ip

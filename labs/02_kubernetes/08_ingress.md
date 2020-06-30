## Ingress Lab - Create an Ingress resource and Attach your backend service to existing ingress controller

## Exercise -1 Create an ingress resource and attach your `cw-app` service as a backend to it. 

Save the below manifest for ingress as `cw-app-ingress.yaml`

>**Make sure to replace `{your-firstname-cw-app}` in the last line with your name. so, we can match path such as `/john-cw-app`**
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
        path: /{your-firstname-cw-app}(/|$)(.*) # for example, path: /john-cw-app(/|$)(.*)        
```
Take a moment to understand the usage of `annotations` here. It gets used by the client, in this case the `nginx` ingress controller.  

#### Apply the ingress

```bash
kubectl apply -f cw-app-ingress.yaml -n <your-namespace>
```
#### Access your service via Ingress

Take note of the public-ip from below query and then append your path from above ingress resource for e.g: `50.x.x.x/jane-cw-app` will redirect you to your `cw-app-svc` service

```bash
kubectl get svc nginx-ingress-controller -n ingress-demo 
```

## Bonus

1. Take a look at how `nginx-ingress-controller` can be used for ssl termination.

https://kubernetes.github.io/ingress-nginx/examples/tls-termination/

2. Creating an Ingress Controller on AKS with static-ip

https://docs.microsoft.com/en-us/azure/aks/ingress-static-ip

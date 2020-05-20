## Ingress Lab - Create an Ingress resource and Attach your backend service to existing ingress controller

### 1. First, create a deployment and a service from below manifest. Save the file in your dev environment with a name of your choice.

**Note: Do not copy/paste the below file.** Take your time to read through the below yaml and make sure to replace the values accordingly. Replace `image name`, `app name`, `deployment name` and `service name` with respective values.

```yaml
apiVersion: apps/v1 
kind: Deployment 
metadata:
  name: yourfirstname+initial-deploy # for e.g: jane-deploy or mattc-deploy
  namespace: ingress-demo
  labels:
    owner: yourfirstname+initial # for e.g: jane
spec:
  selector:
    matchLabels:
      app: yourfirstname+initial-app # for e.g: jane-app
  replicas: 2
  template:
    metadata:
      labels:
        app: yourfirstname+initial-app    # for e.g: jane-app  
        owner: yourfirstname+initial # for e.g: jane
    spec:
      containers:
      - name: yourfirstname+initial-app
        image: your-username/your-imagename:tag # replace it with your image and correct tag version
        ports:
        - containerPort: 80

---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: yourfirstname+initial-app # for e.g: jane-app  
    owner: yourfirstname+initial  # for e.g: jane
  name: yourfirstname+initial-svc  # for e.g: jane-svc
  namespace: ingress-demo
spec:
  ports:
  - port: 80
  selector:
    app: yourfirstname+initial-app  # for e.g: jane-app  
  type: ClusterIP

```

#### Do a `kubectl apply -f <your-filename>.yaml`

#### Ensure your resources are appearing correctly in the `ingress-demo` namespace. Take advantage of labels to filter your resources

```bash
kubectl get all --selector owner=<yourfirstname+initial> -n ingress-basic 
# make sure that the firstname+initial is the same as the one in owner label on above manifest 
```

### Create an ingress resource and attach your service as a backend to it. 

### Replace the value for your ingress-name

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: yourname-ingress # e.g: jane-ingress
  namespace: ingress-demo
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/rewrite-target: /$2
spec:
  rules:
  - http:
      paths:
      - backend:
          serviceName: yourservice-svc # replace this with your service name. for e.g: jane-svc
          servicePort: 80
        path: /owner-name(/|$)(.*) # replace owner-name with a unique path to your service for e.g: jane
```

#### Access your service via Ingress

Take note of the public-ip from below query and then append your path from above ingress resource for e.g: `50.x.x.x/jane` will redirect you to your service

```bash
kubectl get svc nginx-ingress-controller -n ingress-demo 
```

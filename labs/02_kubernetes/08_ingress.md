## Ingress Lab - Create an Ingress resource and Attach your backend service to existing ingress controller

### 1. First, create a deployment and a service from below manifest. Save the file in your dev environment with a name of your choice.

**Note: Make sure to replace the `image name`, `app name`, `deployment name` and `service name` with respective values.

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
        app: yourfirstname+initial-app      
        owner: yourfirstname+initial
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
    app: yourfirstname+initial-app
    owner: yourfirstname+initial
  name: yourfirstname+initial-svc  # for e.g: jane-svc
  namespace: ingress-demo
spec:
  ports:
  - port: 80
  selector:
    app: yourfirstname+initial-app  
  type: ClusterIP

```

#### Do a `kubectl apply -f <your-filename>.yaml`

#### Ensure your resources are appearing correctly in the `ingress-demo` namespace

```bash
kubectl get all -n ingress-basic 


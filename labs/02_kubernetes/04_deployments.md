# Deployments

In this lab, we will create deployments with replica sets and apply everything else we've learnt so far along with it.

> **Important : This is one of the most important labs in our workshop. Please make sure to take your time to understand the content and complete it. The exercises here will also incorporate various other things we have learnt thus far. Feel free to re-visit them and practice again till you're fully comfortable with the concepts covered here**

* For this lab, we will be using a simple web app called `cw-app`. 

* First, we will create `three versions` of cw-app docker images and push it to Docker Hub. It would do something like below:

    ```bash
        Docker Hub Image                   Web Page Output

    <your-username>:cw-app:1.0 ---> "Hello World - V1.0 (stable)"
    <your-username>:cw-app:2.0 ---> "Hello World - V2.0 (unstable)"
    <your-username>:cw-app:2.1 ---> "Hello World - V2.1 (patched)"
    ```
---

## Setup

1. For Setup, first start with creating a directory called `cw-app` inside `kubernetes` directory. 

```bash
    # clone the app repo
    git clone https://github.com/suren-m/cw-app.git
    
    # cd into that directory
    cd cw-app
```

2. Your setup should look like below.

    ```bash
    ├── cw_labs
    │   ├── docker
    │   └── kubernetes
    │       ├── cw-app
    |           └── ...<your cw-app manifests will go here>...
    │       └── pods
    │           └── web2-pod.yaml

    ```

3. Make sure you're already logged into DockerHub by doing a **docker login** on the terminal (see docker registry lab if in doubt)

4. Download and run the below setup script. This will build the `app image` and push it to your docker hub repository.

    > **Important:** When prompoted, provide your **dockerhub username** (not your namespace name)
    ```bash            
    # set execution permissions    
    chmod +x setup.sh 
    
    # execute
    ./setup.sh
    ```
    
5. Verify the image is successfully pushed to your dockerhub repository. **Replace `<your-username>`** with your docker hub username.

    > Navigate to `https://hub.docker.com/r/<your-username>/cw-app/tags` on your browser and make sure all three versions (tags) of your app exists.
       
    If you get a `404` above, it means you haven't correctly pushed your app to your docker hub account. Spend a couple of minutes and see if you can fix it or else you can just use the images in https://hub.docker.com/r/surenmcode/cw-app/tags instead
---

## Exercise 1 - Create a Deployment manifest file for `cw-app:1.0`

1. Create a manifest file using `--dry-run` and `-o yaml`

    ```bash
    # Make sure you're in `cw-app` directory
    
    # Make sure to replace <your-username> with your docker hub username (or surenmcode if you're having problems with docker hub)
    kubectl create deploy cw-app --image=<your-username>/cw-app:1.0 -o yaml --dry-run > cw-app.yaml    
    ```

2. Open `cw-app.yaml` and change the number of replicas to `3`. Also, Make sure the value for image looks correct.

    > Take a few minutes to understand the deployment manifest. Notice the creation of default label called `app`

  Your `cw-app.yaml` should look like below.
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: cw-app
  name: cw-app
spec:
  replicas: 3 # Number of pods for replica set
  selector:
    matchLabels:
      app: cw-app
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: cw-app
    spec:
      containers:
      - image: <your-username>/cw-app:1.0
        name: cw-app
        resources: {}
status: {}
```

3. Deploy your app.

    ```bash
    kubectl apply -f cw-app.yaml
    ```

    At this stage, if you're still having issues with your app image or manifest file, just deploy the one below or reach out to the instructor.

    ```bash
    # Only if you can't get the above steps to work
    kubectl apply -f https://raw.githubusercontent.com/suren-m/cw-app/master/cw-app.yaml
    ```

4. View the Deployment and Replica Sets of cw-app. Notice the use of commas to query more objects and usage of labels

    ```bash
    kubectl get deploy,rs,po -l app=cw-app
    ```

5. Access your app by `Port-Forwarding` to your deployment

```bash
# Notice how in this case, backend port points to 8080 of app container inside the pod
kubectl port-forward deployment.apps/cw-app 9003:8080

http localhost:9003 # or the port that you forwarded to
```
---

## Exercise 2 -Expose the `cw-app` deployment as a Service

1. Generate a manifest for a `cluster-ip` service that exposes the `cw-app` deployment. 

> Spend a minute to understand what we're doing here.

```bash
kubectl expose deploy cw-app --name cw-app-svc --port=80 --target-port=8080 --type=ClusterIP --dry-run -o yaml > cw-app-svc.yaml
```

2. Take a look at `cw-app-svc.yaml` and make sure you know what it's doing. It should look like below:

```yaml
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: cw-app
  name: cw-app-svc
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 8080
  selector: # this is how service knows where to send the traffic to. (using selector on labels)
    app: cw-app 
  type: ClusterIP
status:
  loadBalancer: {}
```

3. Apply the Service

    ```bash
    kubectl apply -f cw-app-svc.yaml
    ```

4. Port-forward to the Service to make sure it's working as intended.

```bash
# We're forwarding from port 80 because the service itself runs on port 80. It's the backend app container that runs on 8080.
kubectl port-forward service/cw-app-svc 9004:80

http localhost:9004 # or the port that was forwarded to
```

5. Take a look at all the objects that are related to our `cw-app`. (labels greatly help us here too!)

```bash
k get all -o wide -l app=cw-app
```
---

## Exercise - 3 Deploy a newer version of the app

1. In order to observe how the update gets applied, open a second pane / terminal and set a watcher on replica sets. 

    ```bash
    kubectl get rs -w
    ```       

2. Update the image used by 'cw-app' to use version `2.0`

There are two ways to do this: (choose one you feel comfortable for now)

* Command-line approach
    ```bash
    # set the deployment image    
    kubectl set image deployment cw-app cw-app=<your-username>/cw-app:2.0    

    # Notice how the desired, current and ready states change on replica set watcher.
    ```
* **Or** using the manifest file 

    * Update the `image` field of `cw-app.yaml` to point to `2.0`
    * And then do a `kubectl apply -f cw-app.yaml`

3. Take a look at the replica sets. Notice the new one that's created and the number of pods in Ready state. Also notice `the images` column for version of image that was used.

    ```bash
    k get rs -o wide
    ```

4. Port-forward again to the `cw-app-svc`. This time, it will display `internal server error` or `hello world - version 2` of the app.

```bash
kubectl port-forward service/cw-app-svc 9005:80

# Run a loop to hit it every second. Feel free to copy and paste this into the terminal
while (http localhost:9005) do { sleep 1; } done
```

> **Note: You will see `internal server error` often on `v2.0` of the app. It is deliberately to programmed to throw a `500` status 70% of the time. (unstable version example)**

Exit the loop with `ctrl + c`

---

## Exercise - 4 Rollback to Previous Version

1. View the rollout history for 'mydeploy' and roll back to the previous revision.

```bash
    # view previous rollout revisions and configurations.
    kubectl rollout history deploy cw-app

    # Make sure you've setup the watcher on second pane to observe how rollback happens
    kubectl get rs -w

    # From main pane, rollback to the previous rollout.
    kubectl rollout undo deploy cw-app    
```

## Exercise - 5 Access the service from within the cluster.

1. The service is only visible within the cluster. To hit it by its `dns name`, just create a busybox container and hit the `cw-app-svc` service by its name as below. 

```bash
# delete any busybox pods if you have anything that's already running.
kubectl delete po busybox

# run a busybox pod and launch its shell 
kubectl run busybox --rm --image=busybox -it --restart=Never -- sh    

# Call cw-app-svc using `wget`. Below would print out the output `Hello from CW app - V1.0 (stable)`
wget -q -O - cw-app-svc

# or 

wget -q -O - cw-app-svc.<your-namespace>
# Above is the recommended approach to call a service running on someone else's namespace as well.
# You can provide protocol and port-number as well if needed. (such as, http://cw-app-svc.john:80/)

exit
```
---

## Bonus Challenge:

* Try to do a simple `blue-green` or `canary` deployment by taking advantage of `labels` and `selectors` on the `service`

    * Remember that a `service` can point to two deployments as long as they have the same label.
    
    


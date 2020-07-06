## Exercise 2 - Liveness and Readiness Probe

Here we will create a web-app, that takes a while to "warm up" and it may occasionally crash when receiving requests.

1. It's best to create a directory first for this app

```bash
mkdir crash-test-app 
cd crash-test-app 
```

1. Create an `app.py` file from below python code. 

    * Here we have a simple `flask` app with two endpoints called `readiness` and `liveliness` which will be used by the probes. 
    * The liveliness endpoint will fail 10% of the time causing a container restart. 
    * The readiness endpoint will take 5 seconds upon first hit to simulate "warm up" scenario

```python
#!/usr/bin/env python
from random import randrange
from flask import Flask
import time

app = Flask('crash-test-app')
success_rate = 90
hit_count = 0

# used by readiness probe
@app.route('/readiness')
def warm_up():
    global hit_count
    if hit_count < 1:
        time.sleep(5)

    hit_count = hit_count + 1
    return "success\n", 200

# used by liveliness probe
@app.route('/liveliness')
def health_check():
    if randrange(1, 100) < success_rate:        
        return "success\n", 200        
    else:        
        return "crash\n", 500

app.run(host = '0.0.0.0', port = 8080)
```

2. Create a `Dockerfile` from below content

```Dockerfile
FROM python:3-slim
WORKDIR /

RUN pip install flask 
COPY app.py /app.py

STOPSIGNAL SIGINT
CMD ["python", "/app.py"]
```

3. Build and push that image to your registry. (make sure you've already done a `docker login`)

```bash
docker build . -t <your-dockerhub-username>/crash-test-app:1.0
docker push <your-dockerhub-username>/crash-test-app:1.0
```

4. Create a `crash-test-app.yaml` from below manifest

**Please take a few minutes to understand what we are doing here with `readiness` and `liveliness` probes**

> Make sure to replace with your `docker-hub-username`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: crash-test-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: crash-test-app
  template:
    metadata:
      labels:
        app: crash-test-app
    spec:
      containers:
      - name: crash-test-app
        image: <your-dockerhub-username>/crash-test-app:1.0
        imagePullPolicy: Always
        resources:
          limits:
            memory: "64Mi"
            cpu: "50m"
        ports:
        - containerPort: 8080        
        readinessProbe:
          httpGet:
            path: /readiness
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
        livenessProbe:
          httpGet:
            path: /liveliness
            port: 8080
          initialDelaySeconds: 10
          periodSeconds: 5
          failureThreshold: 1
```

5. Do an apply

```bash
    kubectl apply -f crash-test-app.yaml
```

> Note: If you're unsure, take a look at `crash-test-app` folder on lab guide for reference.

6. Open two separate terminals or panes

    * on first pane/terminal, have a watcher on pods
    ```bash
    kubectl get po -w
    ```

    * on second pane/terminal, set a `--follow` on deployment
    ```bash
    kubectl logs deployment.apps/crash-test-app --follow
    ```

7. Observe on the logs how kuberentes sends `probes` and how the pods are affected.

    > Note that our requests to `/liveliness` has a 10% chance of failure

    > Notice how the container in pod doesn't show up as `READY` until the readiness probe is successful. This means it won't receive any requests from a service till its Ready.

    ```bash
    # example output logs
    10.244.2.1 - - [06/Jul/2020 23:22:33] "GET /liveliness HTTP/1.1" 200 -
    10.244.2.1 - - [06/Jul/2020 23:22:35] "GET /readiness HTTP/1.1" 200 -
    10.244.2.1 - - [06/Jul/2020 23:22:38] "GET /liveliness HTTP/1.1" 500 -

    # example pod watcher output
    k get po -w
    NAME                              READY   STATUS    RESTARTS   AGE
    crash-test-app-59f6d896f6-vxllx   0/1     Running   6          7m26s
    crash-test-app-59f6d896f6-vxllx   1/1     Running   6          7m36s
    ```
---

Take a look at below docs for more details:
* https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/


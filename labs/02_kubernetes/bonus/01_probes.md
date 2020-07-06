# Configuring Pod Lifecycle using Probes

>*Note: Make sure you've covered the basics and comfortable working with `manifest files` and deploying pods before doing this exercise.**

There are three types of probes that can be configured for a pod:

* Liveness Probe - kubelet uses this to know when to restart a container (for e.g, during a deadlock)
* Readiness Probe - kubelet uses this to know when a container is ready to start accepting traffic
* Startup Probe - kubelet uses this to know when a container application has started

    > Note, If startup probe is configured, it disables liveness and readiness checks until it succeeds, making sure those probes don't interfere with the application startup. 

---

## Exercise 1 - Liveness Probe.

1. Create a `pod-liveness-probe.yaml` file from below manifest

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    test: liveness
  name: pod-liveness-probe
spec:
  containers:
  - name: liveness
    image: k8s.gcr.io/busybox
    args:
    - /bin/sh
    - -c
    - touch /tmp/healthy; sleep 30; rm -rf /tmp/healthy; sleep 600
    livenessProbe:
      exec:
        command:
        - cat
        - /tmp/healthy
      initialDelaySeconds: 5
      periodSeconds: 5
```

2. Take a few minutes to understand what we are doing here.

    * The liveness probe uses the existence of `/tmp/healthy` file to check if the container needs to be restarted. 

    * If the file exists and `cat /tmp/healthy` is successful, then the container will not be restarted.

    * However, as you can see that after `30 seconds`, we are doing a `rm -rf /tmp/healthy` which will delete that file. So the container will be restarted when the probe notices this.

    * Here, we've configured the probe to check for liveliness every `5` seconds after an initial delay of 5 seconds.

3. When ready, do an apply.

    ```bash
    kubectl apply -f pod-liveness-probe.yaml
    ```

4. Run a watcher on the above pod 

    ```bash
    kubectl get po pod-liveness-probe -w
    ```

5. The container will be restarted after around a minute or so and will continue to do so everytime the probe fails `liveliness check`.

    ```bash
    # output - notice the container restarts and a `crashloopbackoff` in the end
    kubectl get po pod-liveness-probe -w
    NAME                 READY   STATUS    RESTARTS   AGE
    pod-liveness-probe   1/1     Running   0          6s
    pod-liveness-probe   1/1     Running   1          79s
    pod-liveness-probe   1/1     Running   2          2m33s
    pod-liveness-probe   1/1     Running   3          3m49s
    pod-liveness-probe   1/1     Running   4          5m3s
    pod-liveness-probe   1/1     Running   5          6m19s
    pod-liveness-probe   0/1     CrashLoopBackOff   5          7m33s
    pod-liveness-probe   1/1     Running            6          8m54s
    pod-liveness-probe   0/1     CrashLoopBackOff   6          10m
    ....
    ```

6. Do a describe on the pod to see more about events

    ```bash
    kubectl describe pod pod-liveness-probe     
    ```

7. Delete the pod

    ```bash
    kubectl delete po pod-liveness-probe -n <your-namespace>
    ```
---

In the next bonus lab, we will introduce `readiness` probe along with `liveness` probe and will use a `http` based approach.
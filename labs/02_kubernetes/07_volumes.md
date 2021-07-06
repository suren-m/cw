
## Note for `Docker desktop users'

---
> If you're still on docker desktop, then below may or may not work depending on yoru configuration. As discussed during sessions, you can use `Hostpath` volumes for learning /lab scenarios. `EmptyDir` will lose its data when the pod is destroyed.

You should be familiar with some of the concepts below: 

    * https://kubernetes.io/docs/concepts/storage/volumes/
    * https://kubernetes.io/docs/concepts/storage/persistent-volumes/

---

## Exercise - 1 Persistent Volume Claim (creates an azure disk when applied to an AKS cluster)

1. Create a persistent volume claim for 1GB of storage. Save the below manifest as `pvc.yaml`

> Make sure to replace `<your-name>` with your `name`
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: <your-name>-claim
spec:
  accessModes:
    - ReadWriteOnce 
  resources:
    requests:
      storage: 1Gi
```

2. Apply the claim and make sure it's bound to a `persistent volume`

```bash
kubectl apply -f pvc.yaml

# get pv and pvc
kubectl get pv,pvc
```

3. Create a Pod for testing. Save the below manifest as `volume-pod.yaml`

>Note that it may take a while for container to be ready because the cloud-backed volume has to be attached. Notice the use of `limits` here as well on the container spec.

> Make sure to replace **`<your-name>`** in `claimName` field accordingly

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: volumepod
  labels:
    name: volumepod
spec:
  volumes:
    - name: my-volume               
      persistentVolumeClaim:
          claimName: <you-name>-claim
  containers:
  - name: volumepod
    image: nginx:1.19.0
    resources:
      limits:
        memory: "128Mi"
        cpu: "50m"    
    volumeMounts:
      - mountPath: /mnt/my-persistent-storage/
        name: my-volume
```

4. Create the Pod with `kubectl apply -f volume-pod.yaml` 

  > It may take a minute for the container to be running as kubernetes needs to attach our persistent volume.

5. `Exec` into the container and create a file inside the mounted storage.

    ```bash
    # exec into the container
    kubectl exec pod/volumepod -it -- sh
    
    # cd into mounted storage
    cd /mnt/my-persistent-storage/
    
    # create a file with some text
    echo "hello world" > hello.txt
    
    # verify below prints file contents as expected
    cat hello.txt
    
    # exit the container shell
    exit
    ```
    
6. Delete the Pod

    ```bash
    kubectl delete pod volumepod
    ```

7. Create the pod again using the same manifest

    ```bash
    kubectl apply -f volume-pod.yaml
    ```
8. Exec into the pod and observe that the file is still there because it is backed by `Azure Disk` (or `HostPath` if on docker-desktop) as the persistent volume.

    ```bash
    kubectl exec pod/volumepod -it -- sh
    cd /mnt/my-persistent-storage/
    ls
    cat hello.txt
    exit
    ```
---
# Volumes, Config Maps and Secrets

## Exercise - 1 Persistent Volume Claim

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
          claimName: my-1gb-claim
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

5. `Exec` into the container and create a file inside the mounted storage.

    ```bash
    kubectl exec pod/volumepod -it -- sh
    cd /mnt/my-persistent-storage/
    touch "hello world" > hello.txt
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
8. Exec into the pod and observe that the file is still there because it is backed by `Azure Disk` as the persistent volume

    ```bash
    kubectl exec pod/volumepod -it -- sh
    cd /mnt/my-persistent-storage/
    ls
    cat hello.txt
    exit
    ```
---

## Exercise - 2 Config Maps and Secrets

1. Create a configmap named myconfig with values `<your-firstname>-1=lala,<your-firstname>-2=lolo`

    ```bash
        kubectl create configmap <your-firstname>-myconfig --from-literal=<your-firstname>-1=lala --from-literal=<your-firstname>-2=lolo
    ```

>Bonus: Where is this config Map located? Hint: It's not in your namespace. (see configuration on vs extension)

### IMPORTANT: In the lab environment, every participant has full access to the shared cluster, so please do not put anything sensitive in the secrets as others will be able to see it too. Just put some dummy text as in example below.


2. Create a secret called mysecret with the values <your-firstname>-password=mypass

    ```bash
        kubectl create secret generic <your-firstname>-mysecret --from-literal=<your-firstname>-password=mypass
    ```

3. Follow below steps to create a new nginx pod that loads the value from configmap ```<your-firstname>-myconfig``` ->  ```<your-firstname>-1``` in an env variable called 'option'. Also load secret '<your-firstname>-mysecret' as a volume inside an nginx pod on path ```/etc/secrets```.

    ```bash
    # review the manifest and look how the configMap and secret is referenced    
    # make sure your terminal's directory is set to yaml_files folder located in 02_kubernetes folder of the repo. 
    # `cd` into  or `cd ..` as needed. 

    # open `config-and-secrets.yaml` in `yaml_files` folder with vs-code or with nano   
    code config-and-secrets.yaml
    
    # Update the <your-firstname> part with your name and save the file

    # Create Pod from the script file
    # If you get file not found, make sure your terminal is set to right directory.    
    kubectl apply -f config-and-secrets.yaml

    # Or you can pass full path. 
    # For example, if your terminal is at `cw` folder, then 
    # `kubectl apply -f ./labs/02_kubernetes/yaml_files/config-and-secrets.yaml`
    ```

4. Check environment variable ```option``` and ```/etc/secrets``` has expected values

    ```bash
    kubectl exec -it nginx -- env | grep option
    kubectl exec -it nginx -- ls /etc/secrets
    ```
    or 

    ```bash
    kubectl exec -it nginx -- sh
    # And from within the container's shell
    env 
    # Look for the `option` env variable in the list
    cd /etc/secrets && ls
    cat <your-name>-password
    exit

---


# Config Maps and Secrets

## Setup

* Create a directory called `state_persistence` within `cw_labs\kubernetes` directory and `cd` into it.

---

## Exercise - 1 Config Maps and Secrets

1. Create a configmap named myconfig with values `<your-firstname>-1=lala,<your-firstname>-2=lolo`. Replace `<your-firstname> accordingly`.

    ```bash
    kubectl create configmap <your-firstname>-myconfig --from-literal=<your-firstname>-1=lala --from-literal=<your-firstname>-2=lolo
    ```

>Bonus: Where is this config Map located? Hint: It's not bound to a node. Also, how to look at someone else's config map provided you have access? 
    ```bash
      kubectl get cm --all-namespaces
    ```

> **IMPORTANT**: In the lab environment, every participant has full access to the shared cluster, so please do not put anything sensitive in the secrets as others will be able to see it too. Just put some dummy text as in example below.


2. Create a secret called mysecret with the values `<your-firstname>-password=mypass`

    ```bash
    kubectl create secret generic <your-firstname>-mysecret --from-literal=<your-firstname>-password=mypass
    ```

3. Follow below steps to create a new `test` pod that loads the values as below

  * Load from configmap ```<your-firstname>-myconfig``` ->  ```<your-firstname>-1``` in an environment variable called 'option'.    
  * Load secret '<your-firstname>-mysecret' as a volume inside an nginx pod on path ```/etc/secrets```.

4. Create a new manifest file so we can test our `configmap` and our `secret`. Let's call the manifest `config-and-secrets.yaml` (Do a `New File` or open it on the editor from terminal as below)

    ```bash    
    code config-and-secrets.yaml
    ```

5. Pasting in the below yaml manifest and save the file.

> **Make sure to update `<your-firstname>` accordingly**

> Spend a few minutes to fully understand the below manifest before proceeding further. As always, pay extra attention to indentation when pasting in.
    
```bash
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  volumes: # specify the volumes
  - name: myvolume # this name will be used for reference inside the container
    secret: 
      secretName: <your-firstname>-mysecret # name of the secret - this must already exist on pod creation

  containers:
  - image: nginx:1.19.0
    imagePullPolicy: IfNotPresent
    name: nginx

    volumeMounts: # your volume mounts are listed here
    - name: myvolume # the name that you specified in pod.spec.volumes.name
      mountPath: /etc/secrets # the path inside your container   

    env:
    - name: option # name of the env variable
      valueFrom:
        configMapKeyRef:
          name: <your-firstname>-myconfig # name of config map
          key: <your-firstname>-1 # name of the entity in config map

    resources:
      limits: # resource limits for this container
       memory: "64Mi"
       cpu: "100m"
```

7. When ready, do a `kubectl` apply. If you get file not found, make sure your terminal is set to the right directory.    

```bash    
kubectl apply -f config-and-secrets.yaml    
```

8. Check environment variable ```option``` and ```/etc/secrets``` has expected values
    
  ```bash
  kubectl exec -it test-pod -- sh

  # And from within the container's shell
  # Look for the `option` env variable in the list
  env | grep 'option'
  
  # Check out the volume that's mounted for our secret
  cd /etc/secrets && ls
  cat <your-name>-password

  # exit
  exit
  ```
  **or**

  ```bash
  kubectl exec -it test-pod -- env | grep option
  kubectl exec -it test-pod -- ls /etc/secrets
  ```

---


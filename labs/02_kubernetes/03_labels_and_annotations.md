# Labels and Annotations

## Exercise 1 - Labels - can be used for selection and querying

1. Show all labels of the existing pods in your namespace 

    > Note: `po` is just short for `pod` or `pods`

    ```bash
    kubectl get po --show-labels
    ```

    The result would look something like this with just the default `run` label
    ```bash
    NAME   READY   STATUS    RESTARTS   AGE   LABELS
    web1   1/1     Running   0          38m   run=web1
    web2   1/1     Running   1          17m   run=web2
    ```

2. Add a label called `app` and set it to `v1`

    * For pod `web1` - using `command-line` approach 

        ```bash
        kubectl label po web1 app=v1

        # The output should say "pod/web1 labeled"
        ```

    * For pod `web2` - using the `manifest file` 

        * Open the manifest file `web2-pod.yaml`
        * Add a new label to the pod `metadata`, so the `labels` field looks such as below. 
        * Make sure it's indented correctly.
            ```yaml
            metadata:
                ... # other fields
                labels:
                    run: web2  
                    app: v1 # new label
                ...
            ```
        * Do a `kubectl apply`
            ```bash
            kubectl apply -f web2-pod.yaml
            ```

3. Query the pods with app labels. It should look such as below

    ```bash
    kubectl get po --show-labels

    # output

    NAME   READY   STATUS    RESTARTS   AGE   LABELS
    web1   1/1     Running   0          52m   app=v1,run=web1
    web2   1/1     Running   1          31m   app=v1,run=web2
    ```
  
4. Change the app label of pod 'web1' from `v1` to `v2`

    ```bash
    kubectl label po web1 app=v2 --overwrite

    kubectl get po --show-labels

    # output

    NAME   READY   STATUS    RESTARTS   AGE   LABELS
    web1   1/1     Running   0          55m   app=v2,run=web1
    web2   1/1     Running   1          33m   app=v1,run=web2
    ```

5. Get the label 'app' for the pods. 

    > Note the uppercase `-L` flag

    ```bash
    kubectl get po -L app

    # output 
    NAME   READY   STATUS    RESTARTS   AGE   APP
    web1   1/1     Running   0          56m   v2
    web2   1/1     Running   1          34m   v1
    ```

6. Get pods that only have label `app=v2` (filter by version example)

    > Note the lowercase `-l` flag

    ```bash
    kubectl get po -l app=v2
    # or
    kubectl get po -l 'app in (v2)'

    # output

    NAME   READY   STATUS    RESTARTS   AGE
    web1   1/1     Running   0          59m
    ```

7. Remove the 'app' label from the pods we created before

    ```bash
    kubectl label po web1 app-

    # Make sure only web1 pod is affected
    kubectl get po --show-labels    
    
    # To remove `app` label from all pods
    kubectl label po -l app app-
    # or if on linux
    kubectl label po web{1..2} app-        

    # Make sure now both web1 and web2 don't have `app` label
    kubectl get po --show-labels    
    ```
> Note: For `web2`, ideally we should be treating the `manifest file` as single source of truth and version control it. But for purpose of this particular exercise, command-line is quick and easier. 

> We will be moving more and more towards declarative approach (`manifest file as source of truth`) from next lab onwards.

---

## Exercise 2 - Annotations - used for metadata. Clients such as tools and libraries can retrieve this metadata.

1. Annotate pods web1, web2 with "description='my description'" value

    * For web1, command-line approach

        ```bash
        kubectl annotate po web1 description="my description"

        # output 
        pod/web1 annotated
        ```

    * For web2, using the `manifest` file

        * Open the manifest file `web2-pod.yaml`
        * Add a new annotation to the pod `metadata`, so the `annotations` field looks such as below. 
        * Make sure it's indented correctly.
            ```yaml
            metadata:
                annotations:
                    description: my description
                ... # other fields
            ```
        * Do a `kubectl apply`
            ```bash
            kubectl apply -f web2-pod.yaml
            ```

2. Check the annotations for pods web1 and web2

    ```bash
    kubectl describe po web1 
    # or if on linux, take advantage of grep
    kubectl describe po web1 web2 | grep -i "annotations"
    ```

3. Remove the annotations for these two pods. (notice the `-` operation in the end)

    ```bash
    kubectl annotate po web1 web2 description-
    # or if on linux
    kubectl annotate po web{1..2} description-
    ```

---

## Bonus

Take a look at `Field Selectors` and how they can help you query resources based on value of one or more resource fields. 

For example, to show all pods that are `running`, you can use the `status.phase` as field selector.

```bash
kubectl get pods --field-selector status.phase=Running
```

To show all pods whose names are not `web1` (note the usage of `!=`)

```bash
kubectl get pods --field-selector metadata.name!=web2
```







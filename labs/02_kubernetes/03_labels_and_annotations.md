## Labels and Annotations

## Labels - can be used for selection

### Create a couple of pods called `web1` and `web2`
```
   kubectl run web1 --image=nginx --restart=Never   
   kubectl run web2 --image=nginx --restart=Never   
```

### Show all labels of the pods (note: `po` is just short for `pod`. Use `pod` if you prefer that)
```bash
   kubectl get po --show-labels
```

### Add another label to the webserver pod
```bash
    kubectl label po web1 app=v1 --overwrite
    kubectl get po --show-labels
```

### Change the app label of pod 'webserver' from `v1` to `v2`
```bash
    kubectl label po web1 app=v2 --overwrite
    kubectl get po --show-labels
```

### Get the label 'app' for the pods. Note the uppercase `L`
```bash
    kubectl get po -L app
```

### Get only the 'app=v2' pods

```bash
    kubectl get po -l app=v2
    # or
    kubectl get po -l 'app in (v2)'
```

### Remove the 'app' label from the pods we created before

```bash
    kubectl label po web1 app-
    # or
    kubectl label po -l app app-
    # or if on linux 
    kubectl label po web{1..2} app-
```

## Annotations - used for metadata. Not an object identifier / selector

### Annotate pods web1, web2 with "description='my description'" value

```bash
    kubectl annotate po web1 web2 description="my description"
```

### Check the annotations for pod web1

```bash
    kubectl describe po web1 
    # or if on linux, take advantage of grep
    kubectl describe po web1 | grep -i "annotations"
```

### Remove the annotations for these three pods. (notice the `-` operation in the end)

```bash
    kubectl annotate po web1 web2 description-
    # or if on linux
    kubectl annotate po web{1..2} description-
```

### Remove these pods to have a clean state in your namespace / cluster

```bash
    kubectl delete po web1 web2 
    # or if on linux
    kubectl delete po web{1..3}
```

> **Bonus**: Try doing some of the operations using a declarative approach. Create a `yaml` file and make changes to it. And then `apply` those changes.
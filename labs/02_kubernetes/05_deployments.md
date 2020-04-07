# Deployments

## Create a yaml file for a Deployment running an nginx container with five replicas and save it as `mydeploy.yaml`

> Like to use something other than an nginx image? Try `mcr.microsoft.com/dotnet/core/samples:aspnetapp` for a simple aspnet core app
> Make sure to name the image and container correctly too.

```bash
    # Tip use command to generate yaml and then update replica counts in the yaml
    kubectl create deploy mydeploy --image=nginx -o yaml --dry-run > mydeploy.yaml
```
> The above is another great example where you can use --dry-run -o yaml to generate the required yaml.

If you need more assistance or having any issues, take a look at `yaml_files` folder. There is a `webappdemo.yaml` for reference as well as a `mydeploy.yaml` file.

## Create Deployment using mydeploy.yaml

**Make sure you have `cd` into the directory where you have `mydeploy.yaml`. Or else, you will get a file not found error.

```bash
    kubectl apply -f mydeploy.yaml
```

## View the Deployment and Replica Sets. Notice the use of commas to query more objects

```bash
    kubectl get deploy,rs,po
```

## Modify the image used by 'mydeploy' to use image ```nginx:1.16.0``` and observe the update as it's applied. 

```bash
    # set the deployment image
    # Note: You can do this declaratively too by making changes to yaml file and doing an `apply`.
    kubectl set image deployment mydeploy nginx=nginx:1.16.0

    # observe how the update gets applied. Have this open in separate terminal / pane if you want. 
    # Notice how the `desired, current, ready` state changes from previous `rs` to new `rs`
    kubectl get rs -w
```

## View the rollout history for 'mydeploy' and roll back to the previous revision.

```bash
    # view previous rollout revisions and configurations.
    kubectl rollout history deploy mydeploy

    # rollback to the previous rollout.
    kubectl rollout undo deploy mydeploy

    # observe how rollowing update gets applied. Similar to previous section. 
    kubectl get rs -w
```

## Scale 'mydeploy' to 1 instance 

```
    kubectl scale deploy mydeploy --replicas=1
```

## Expose the deployment 'mydeploy' on port 80 (ClusterIP). Observe that a service is created.

```bash
    # Tip try writing the yaml file instead of command below
    kubectl expose deployment mydeploy --port 80
    kubectl get svc mydeploy
```

## Confirm that a Cluster IP has been created.

```bash
    kubectl get svc mydeploy -o jsonpath='{.spec.clusterIP}'
```

## Using the Pod's Cluster IP, create a new temporary Pod using busybox and 'hit' the IP with wget:

```bash
# get the service's Cluster IP
kubectl get svc mydeploy -o jsonpath='{.spec.clusterIP}'

# run busybox
kubectl run busybox --rm --image=busybox -it --restart=Never -- sh

# from inside the container
wget -O- <cluster-ip>:80
exit
```

## Change to service type of 'mydeploy' from the ClusterIP to LoadBalancer. Find the Public IP address and browse to the application.

> Note: This will open in `vim` on `vs-online`

```bash
# edit the service
kubectl edit svc mydeploy

# change "type: ClusterIP" to "type: LoadBalancer"

# get the assigned external IP
kubectl get svc -w
```
> Note: This may take a few minutes to complete.

## Delete all resources in the current namespace 

```bash
kubectl delete all --all
```

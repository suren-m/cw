# Lab 1 - Getting Started with Helm

## Exercise 1 - Get started using Helm
In this exercise, you will start to explore how Helm can be used to simplify complex deployments in Kubernetes. For this, you will deploy an instance of WordPress into Kubernetes.

### Steps

If Helm cli is not installed, please install it using

```
sudo snap install helm --classic
```


1. Clear up all your resources in your existing namespace or create yourself a new namespace for helm lab.

    ```bash
    kubectl delete all --all

    or 

    kubectl create namespace <your-firstname>-helmlab
    # Set that as a default for your context. Change it back to your other one as needed or pass the `-n flag` when executing commands
    kubectl config set-context --current --namespace=<your-firstname>-helmlab
    ```

2. Add a the official repository for Helm stable charts:

    ```bash
    helm repo add stable https://kubernetes-charts.storage.googleapis.com/
    ```

3. Once this is installed, you will be able to list the charts you can install:

    ```bash
    helm search repo stable
    ```

4. Search for "stable/wordpress":

    ```bash
    helm search repo stable/wordpress
    ```

5. Install "stable/wordpress". To install a chart, you can run the ```helm install``` command. In this example you will use use one of the official stable charts.

    ```bash
    helm install wp-release stable/wordpress 

    or 
    # Which approach you take with namespace, just keep it consistent.
    helm install wp-release stable/worpress --namespace <your-namespace-for-helm>
    ```

    > During installation, the helm client will print useful information about which resources were created, what the state of the release is, and also whether there are additional configuration steps you can or should take.
    >
    >Helm does not wait until all of the resources are running before it exits. Many charts require Docker images that are over 600M in size, and may take a long time to install into the cluster.

6. While your release finalises use the ```helm show chart``` command to display the contents of the Charts.yaml file:

    ```bash
    helm show chart stable/wordpress
    ```

7. To keep track of a release’s state, or to re-read configuration information, you can use helm status:

    ```bash
    helm status wp-release 
    ```

8. You can check the deployment status with the ```helm list``` command:

    ```bash
    helm list 
    ```

9. Take a look at what was released in step 5.

    ```bash
    kubectl get all 
    ```

7. Once your release is complete, navigate to the external IP address for the ```wordpress``` service.
    
    ```bash
    kubectl get svc 
    ```

8. You can now use the ```helm uninstall``` command to uninstall the ```wordpress``` release.

    ```bash
    helm uninstall wp-release 
    ```

## Exercise 2 - Working with Helm
In this exercise, you will override the default configuration for a WordPress chart and explore using Helm to upgrade and rollback a release.

### Override Values

1. The installation made in Exercise 3 will use the default configuration options for the ```wordpress``` chart. Many times, you will want to customize the chart to use your preferred configuration. To see what options are configurable on a chart, use ```helm show values```:

    ```bash
    helm show values stable/wordpress
    ```

2. You can then override any of these settings in a YAML formatted file, and then pass that file during installation. Create a file called "config.yaml" to override "service.type". 

    ```bash
    echo '{ service: { type: "ClusterIP" } }' > config.yaml
    ```

3. Create a new release and use this file to override the default values:

    ```bash
    helm install my-cool-blog stable/wordpress -f config.yaml 
    ```

4. Run ```kubectl get all``` to see your new release.

    > Note that ```service/my-cool-blog-wordpress``` has deployed with a ClusterIP and has no External IP address.

### Upgrade a release

1. Use ```helm get``` to retrieve a list of user-supplied values for the ```my-cool-blog``` release.

    ```bash
    helm get values my-cool-blog
    ```

2. Create a new file called "config2.yaml" to override "service.type". 

    ```bash
    echo '{ service: { type: "LoadBalancer" } }' > config2.yaml
    ```

3. Use the ```helm upgrade``` command to upgrade ```my-cool-blog``` with the same chart, but with the new values file.

    ```bash
    helm upgrade -f config2.yaml my-cool-blog stable/wordpress 
    ```

    > An upgrade takes an existing release and upgrades it according to the information you provide. Because Kubernetes charts can be large and complex, Helm tries to perform the least invasive upgrade. It will only update things that have changed since the last release.

4. Once again, retrieve a list of user-supplied values for the ```my-cool-blog``` release. Note that the value for ```service.type``` have been updated.

    ```bash
    helm get values my-cool-blog 
    ```

5. Follow the configuration notes to obtain the external IP address, navigate to the site and verify the update was successful.

    ```bash
    kubectl get svc my-cool-blog-wordpress 
    ```

    > You might need to wait serveral minutes for the external IP to be assigned and for the Wordpress site to go up.

6. Use the ```helm history``` command to print historical revisions for a given release.

    ```bash
    helm history my-cool-blog 
    ```

7. Use the ```helm rollback``` command to revert to the previous revision.

    ```bash
    helm rollback my-cool-blog 1 
    ```

7. Verify the rollback was successful by checking service type.

    ```bash
    kubectl get svc my-cool-blog-wordpress
    ```

9. Use the ```helm history``` command to print historical revisions for a given release.

    ```bash
    helm history my-cool-blog 
    ```

## Exercise 3 - Creating your first Helm Chart
In this exercise, you will explore the ```helm create``` command to create your first Helm chart. You will also look at the construct of a chart.

### Steps

1. You can get started with your first Helm chart by using the ```helm create``` command:

    ```bash
    helm create my-first-chart
    ```

2. Explore your new Helm chart.

    ```    
    tree ./my-first-chart
    ```

3. Open the `my-first-chart` folder in vs code. Use the Code editor to take a look at:

    * ./Chart.yaml
    * ./values.yaml
    * ./templates/deployment.yaml
    * ./templates/service.yaml
    * ./_helpers.tpl

4. Update the "values.yaml" file to set ```service.type``` to "LoadBalancer".

    > As you edit your chart, you can validate that it is well-formed by running ```helm lint my-first-chart```. 
    
    Note : You will need to validate it from the folder one level up or else you will get errors. 
    If you have already `cd` into `my-first-cahrt`, then do a `cd ..` to go back one level and then do `helm lint my-first-chart` (my-first-chart refers to the package/folder here)

4. To package the chart up for distribution, you can run the ```helm package``` command:

    ```bash
    helm package my-first-chart
    ```

    > This will generate an archive called "my-first-chart-0.1.0.tgz"

5. And that chart can now easily be installed by ```helm install```:

    ```bash
    helm install my-release ./my-first-chart-0.1.0.tgz 
    ```

6. Review the help text. Retrieve the application URL and verify your release was successful.
    > The load balancer will take a while to deploy and provide the external IP. So if you get an error while yor try and execute the command to retrieve the IP, just wait a while and try again.

    ```bash
    kubectl get svc my-release-my-first-chart

    or 
    # locate the ip from    
    kubectl get svc

7. Clean-up your resources.

    ```bash
    helm uninstall my-release -n yournamespace
    kubectl delete all --all    
    ```

    If you have created additional namespaces, do the same on those namespaces too by passing in the correct `-n <your-namespace>` flag

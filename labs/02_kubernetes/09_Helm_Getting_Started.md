 Exercise 3 - Creating your first Helm Chart
In this exercise, you will explore the ```helm create``` command to create your first Helm chart. You will also look at the construct of a chart.

#### Create and setup a new namespace for this lab, something like below:
```
kubectl create ns helm-lab
kubectl config set-context --current --namespace=helm-lab
```

### Steps

1. You can get started with your first Helm chart by using the ```helm create``` command:

    ```bash
    # The below will create a template / scaffolding with a few pre-configured manifests that can be removed / modified later.
    helm create my-first-chart    
    ```

2. Explore your new Helm chart in `my-first-chart` directory.   

3. Open the `my-first-chart` folder in vs code. Use the Code editor to take a look at:

    * ./Chart.yaml
    * ./values.yaml
    * ./templates/deployment.yaml
    * ./templates/service.yaml
    * ./_helpers.tpl

4. Update the "values.yaml" file to set ```replicaCount``` to 2. Feel free to edit other values like `image.repository` if needed

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

6. Review the help text. Retrieve the application components to ensure the deployment was successful

    ```bash
    kubectl get all -n helm-lab
    ```    

7. Clean-up your resources.

    ```bash
    helm uninstall my-release -n helm-lab    
    ```

---

For more, take a look at below links:
https://docs.microsoft.com/en-us/azure/aks/quickstart-helm
https://helm.sh/docs/intro/quickstart/
And also examples such as https://docs.microsoft.com/en-us/azure/aks/ingress-internal-ip

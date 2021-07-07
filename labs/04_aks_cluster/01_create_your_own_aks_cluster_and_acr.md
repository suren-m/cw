### Note: For this section, you have to know some k8s basics and also be somewhat familiar with Azure (beginner level would be fine)

## Setup - Login to your Azure CLI (only if you're not already logged in)

  * If you're using azure cloud shell you're most likely already logged in, so feel free to move to next step.  
  * An easy way to check is to do a `az account show` or `az group list`. If you get successful response with some data, it means you're already logged in.  

  ```bash  
  # Login
  az login
  
  # you will be prompted to open a link on the browser and sign-in with a code. Just follow the instructions on the terminal or reach out to instructor for help.
  
  # check if you're sucessfully logged in
  az account list
  
  # do this only if you have multiple subscriptions. If you're on free subscription account, you likely have just one subscription, so feel free to skip
  az account set --subscription 'my-subscription-name'
  ```
---

## Exercise 1 - Create your AKS Cluster and connect to it

1. Create a resource group. Feel free to replace "my-aks-rg" with a name you prefer. (choose `uksouth` or `northeurope` for region)

  ```bash
  az group create -n my-aks-rg -l uksouth
  ```

2. Run the following command to deploy Kubernetes cluster with AKS using `basic` and `default` configuration.

Feel free to replace "my-aks-cluster" with a name you prefer. Make sure to use the same resource-group name from above.

> Note: `Standard_B2s` is used here since it's a small sized vm. It is ideal for `dev/lab` environments runnign simple workloads, especially if for those on a limited budget or on MSDN subscription. 

> Check pricing before choosing larger vms

  ```bash
  az aks create -n my-aks-cluster -g my-aks-rg --node-count 3 --node-vm-size "Standard_B2s" --generate-ssh-keys
  ```
  
  > This may take a short while to complete.


#### Retrieve credentials for your own cluster. This will merge its config to the `~/.kube/config` file

```
 az aks get-credentials -n my-aks-cluster -g my-aks-rg 
```

```
# below returns info about your current cluster
kubectl cluster-info

# retrieve nodes (you should see 3)
kubectl get nodes
```

# make sure your default namespace is correct on shared cluster (current context)
```
kubectl get contexts
```

# Now you can do labs / hands-on work on your own aks cluster

* Note that slightly more advanced scenarios such as Multiple NodePools, VNET integration, AKS Policies, Azure AD for AKS, etc. would require additional configuration when creating the cluster.

* It's best to use `infrastructure-as-code` approach via Bicep / ARM Templates or Terraform when configuring advanced clusters.

----   
    
# Bonus - Deploy ACR

In this exercise, you will create an Azure Container Registry instance using the Azure CLI and setup integration between ACR and AKS. 

### Steps

1. Create a resource group, replace "\<acr-resource-group>" with the name of the Resource Group you want to create:

    ```bash
    az group create --name=<acr-resource-group> --location=northeurope
    ```

2. Create an ACR instance using the ```az acr create``` command. Replace "\<acr-resource-group>" and "\<acr-name>" with the Resource Group name and the Azure Container Registry name you wish to create.

    ```bash
    az acr create --resource-group <acr-resource-group> --name <acr-name> --sku Basic
    ```

3. When you're using Azure Container Registry (ACR) with Azure Kubernetes Service (AKS), an authentication mechanism needs to be established. Use the ```az aks update``` command to integrate with your newly created Container Registry.

    ```bash
    az aks update -n <aks-name> -g <aks-resource-group> --attach-acr <acr-name>
    ``` 

> Now you can do your labs or practice k8s on your own cluster with your own private registry even after the completion of workshop. 

For instructions on connecting to ACR (instead of docker hub), see below

https://docs.microsoft.com/en-us/cli/azure/acr?view=azure-cli-latest#az-acr-login



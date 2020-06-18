### Note: For this section, you have to know some k8s basics and also be somewhat familiar with Azure (beginner level would be fine)

#### For best experience (such as accessing dashboard), try doing this from your cloud-shell.

> see [cloud-shell-setup](https://github.com/suren-m/remote-workshop-env/blob/master/cloud_shell/cloud_shell_setup.md)


## Exercise 1 - Create your AKS Cluster and connect to it

1. Log into your azure account and make sure to set your correct subscription (if not done already)

  ```bash
  az login
  az account list
  az account set --subscription 'my-subscription-name'
  ```

2. Create a resource group, replace "\<aks-resource-group>" with the name of the Resource Group you want to create:

  ```bash
  az group create --name=<aks-resource-group> --location=northeurope
  ```

3. Run the following command to deploy Kubernetes cluster with AKS. Replace "\<aks-resource-group>" and "\<aks-name>" with the name of the Resource Group you created and the AKS cluster name you want to create:

  ```bash
  az aks create --resource-group <aks-resource-group> --name <aks-name> --node-count 2 --node-vm-size "Standard_DS2_v2" --generate-ssh-keys
  ```
  
  > This may take a short while to complete.
 
4. Use the Azure CLI to get the credentials to connect kubectl to your AKS cluster:

  ```bash
  az aks get-credentials --resource-group <aks-resource-group> --name <aks-name>
  ```

5. Verify everything worked as expect by running a command against your Kubernetes cluster.

  ```bash
  kubectl get all
  ```

## Exercise 2 - Deploy ACR
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
    
# Exercise 3 - Explore the Kubernetes Dashboard

### Steps

1. By default, the AKS cluster we created was deployed with Role Based Access Control (RBAC) enabled. This will cause errors when you first browse the dashboard, which is deployed with minimal read permissions. To get access to the dashboard, run the following command to create a `ClusterRoleBinding`:

    ```bash
    kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard
    ```

1. Run the following command to access the dashboard:

    ```bash
    az aks browse --resource-group <aks-resource-group> --name <aks-cluster-name>
    ``` 
    
 #### Now you can do your labs or practice k8s on your own cluster

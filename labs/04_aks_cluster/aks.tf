#IMPORTANT: This template is intended for learning and shouldn't be used anywhere outside a personal lab environment. 
# Terraform conventions are kept minimal to favour simplicity and ease of deployment from a single file.

# This also assumes the user is familiar with terraform.

# If you're not familiar with Terraform, feel free to skip this but just have a look at the aks configuration further below to get an understanding of different items involved.

# Steps: 
#   terraform init
#   terraform plan
#   terraform apply
#   ...After finishing the lab..
#   terraform destroy
#   Note: destroy depends on location `.tfstate` file 

# Provider
terraform {
  # use a tf-backend if / as required
  # backend "azurerm" {
  # }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.65.0"
    }
  }
}
provider "azurerm" {
  features {}
}

# ----
# Resources

# Resource group to hold all the demo resources
resource "azurerm_resource_group" "rg" {
  name = "demo-rg"
  location = "uksouth"
}

# Vnet (aks cluster will use the 'demo-aks' subnet)
resource "azurerm_virtual_network" "vnet" {
  name                = "demo-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.5.0.0/16"]    
}

# subnet /22 (1019 available addresses)
resource "azurerm_subnet" "aks" {
  name                 = "demo-aks"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.5.0.0/22"]  
}

# User Identity for the AKS cluster (control plane)
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster#identity
resource "azurerm_user_assigned_identity" "aks_controlplane_ua_mi" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name = "demo-aks-controlplane-ua-mi"  
}

# Network contributor role assignment (needed for cluster to work with the subnet)
# https://docs.microsoft.com/en-us/azure/aks/use-managed-identity#summary-of-managed-identities
resource "azurerm_role_assignment" "network_contributor" {
  scope                = azurerm_virtual_network.vnet.id # restrict to subnet-level scope if required
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_controlplane_ua_mi.principal_id
}



# Log analytics workspace for the cluster to send metrics to
resource "random_integer" "suffix" {
  min = 100
  max = 10000
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "demo-law-${random_integer.suffix.result}" # create a unique name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Create a cluster
# Change the VM sizes and count to fit the budget
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "demo-aks" 
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku_tier            = "Free"
  kubernetes_version  = "1.20.7"

  dns_prefix = "demo-aks"
  # private_cluster_enabled = true
  # node_resource_group = "aks-mc-${azurerm_resource_group.rg.name}"

  # system node pool
  default_node_pool {
    name                 = "default"
    type                 = "VirtualMachineScaleSets"
    vm_size              = "Standard_B2s"
    availability_zones   = ["1", "2", "3"]
    enable_auto_scaling  = true
    node_count           = 1
    max_count            = 2
    min_count            = 1
    orchestrator_version = "1.20.7"
    vnet_subnet_id       = azurerm_subnet.aks.id
  }

  auto_scaler_profile {
    balance_similar_node_groups = true
  }

  network_profile {
    network_plugin     = "azure"
    dns_service_ip     = "10.2.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr       = "10.2.0.0/24"
  }

  role_based_access_control {
    enabled = true
    azure_active_directory {
      managed = true
    }
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
    }
    azure_policy {
      enabled = true
    }
  }

  # https://docs.microsoft.com/en-us/azure/aks/use-managed-identity#bring-your-own-control-plane-mi
  # or use System assigned MI and assign permissions after
  identity {
    type                      = "UserAssigned"
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_controlplane_ua_mi.id
  }

  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster (see identity)
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity
  # kubelet_identity {
  #   user_assigned_identity_id = data.azurerm_user_assigned_identity.aks_kubelet_ua_mi.id
  #   client_id                 = data.azurerm_user_assigned_identity.aks_kubelet_ua_mi.client_id
  #   object_id                 = data.azurerm_user_assigned_identity.aks_kubelet_ua_mi.principal_id
  # }

}

# User Nodepool 
resource "azurerm_kubernetes_cluster_node_pool" "common" {
  name                  = "common"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  enable_auto_scaling   = true
  vm_size               = "Standard_B2s"
  node_count            = 1
  max_count             = 3
  min_count             = 1
  max_pods              = 20
  orchestrator_version  = "1.20.7"
  availability_zones    = [1, 2, 3]
  mode                  = "User"
  node_labels           = { workloads = "general" }
  vnet_subnet_id        = azurerm_subnet.aks.id
}

# Follow-up and docs:
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster
# https://docs.microsoft.com/en-us/azure/aks/best-practices

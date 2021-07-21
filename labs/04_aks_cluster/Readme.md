# AKS cluster creation


#### Note: The `aks.tf` example here uses `user-assigned managed Identity` for control plane that is also configured to get `network contributor` access to subnet. ([BYO Control Plane feature](https://azure.microsoft.com/en-us/updates/azure-kubernetes-service-aks-now-supports-bringyourown-control-plane-managed-identity/))

#### If you had created the cluster via portal and had used `system-assigned managed identity`, then you'd need to ensure that it has access to the subnet in order to create `internal` services or `ingress controllers` on internal network
```
# az aks show -n <clustername> -g <rgname> --query=identity (or identityProfile for kubeletIdentity)
# az role assignment list --assignee <Id> --all -o table
# az role assignment create --assignee $ASSIGNEE --role 'Network Contributor' --scope $SUBNETID ($VNETID for wider scope)

# Make sure the SP executing this template has access for role assignment (owner on that RG)
resource "azurerm_role_assignment" "assignment" {
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  role_definition_name = "Network Contributor"  
 
  # Increase the scope to VNET or RG level Only if subnet-level is insufficient (likewise for NSG)
  scope                = azurerm_subnet.aks.id
}

# Check with az and jq
# az aks show -n cndev -g azenv-uks --query=identity | jq '.principalId' | xargs az role assignment list --all -o table --assignee
```


### Have a look at `aks.tf` to get a better understanding of additional configuration items for AKS.


`aks.tf` will create the following resources

Once the cluster is created, you may need to use `-a` flag with `az aks get-credentials` to access it as a `cluster-admin`. 

```
Terraform will perform the following actions:

  # azurerm_kubernetes_cluster.aks will be created
  + resource "azurerm_kubernetes_cluster" "aks" {
      + dns_prefix              = "demo-aks"
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + kube_admin_config       = (known after apply)
      + kube_admin_config_raw   = (sensitive value)
      + kube_config             = (known after apply)
      + kube_config_raw         = (sensitive value)
      + kubernetes_version      = "1.20.7"
      + location                = "uksouth"
      + name                    = "demo-aks"
      + node_resource_group     = (known after apply)
      + private_cluster_enabled = (known after apply)
      + private_dns_zone_id     = (known after apply)
      + private_fqdn            = (known after apply)
      + private_link_enabled    = (known after apply)
      + resource_group_name     = "demo-rg"
      + sku_tier                = "Free"

      + addon_profile {

          + azure_policy {
              + enabled = true
            }

          + oms_agent {
              + enabled                    = true
              + log_analytics_workspace_id = (known after apply)
              + oms_agent_identity         = (known after apply)
            }
        }

      + auto_scaler_profile {
          + balance_similar_node_groups      = true
          + empty_bulk_delete_max            = (known after apply)
          + expander                         = (known after apply)
          + max_graceful_termination_sec     = (known after apply)
          + max_node_provisioning_time       = "15m"
          + max_unready_nodes                = 3
          + max_unready_percentage           = 45
          + new_pod_scale_up_delay           = (known after apply)
          + scale_down_delay_after_add       = (known after apply)
          + scale_down_delay_after_delete    = (known after apply)
          + scale_down_delay_after_failure   = (known after apply)
          + scale_down_unneeded              = (known after apply)
          + scale_down_unready               = (known after apply)
          + scale_down_utilization_threshold = (known after apply)
          + scan_interval                    = (known after apply)
          + skip_nodes_with_local_storage    = true
          + skip_nodes_with_system_pods      = true
        }

      + default_node_pool {
          + availability_zones   = [
              + "1",
              + "2",
              + "3",
            ]
          + enable_auto_scaling  = true
          + max_count            = 2
          + max_pods             = (known after apply)
          + min_count            = 1
          + name                 = "default"
          + node_count           = 1
          + orchestrator_version = "1.20.7"
          + os_disk_size_gb      = (known after apply)
          + os_disk_type         = "Managed"
          + type                 = "VirtualMachineScaleSets"
          + vm_size              = "Standard_B2s"
          + vnet_subnet_id       = (known after apply)
        }

      + identity {
          + principal_id              = (known after apply)
          + tenant_id                 = (known after apply)
          + type                      = "UserAssigned"
          + user_assigned_identity_id = (known after apply)
        }

      + kubelet_identity {
          + client_id                 = (known after apply)
          + object_id                 = (known after apply)
          + user_assigned_identity_id = (known after apply)
        }

      + network_profile {
          + dns_service_ip     = "10.2.0.10"
          + docker_bridge_cidr = "172.17.0.1/16"
          + load_balancer_sku  = "standard"
          + network_mode       = (known after apply)
          + network_plugin     = "azure"
          + network_policy     = (known after apply)
          + outbound_type      = "loadBalancer"
          + pod_cidr           = (known after apply)
          + service_cidr       = "10.2.0.0/24"

          + load_balancer_profile {
              + effective_outbound_ips    = (known after apply)
              + idle_timeout_in_minutes   = (known after apply)
              + managed_outbound_ip_count = (known after apply)
              + outbound_ip_address_ids   = (known after apply)
              + outbound_ip_prefix_ids    = (known after apply)
              + outbound_ports_allocated  = (known after apply)
            }
        }

      + role_based_access_control {
          + enabled = true

          + azure_active_directory {
              + managed   = true
              + tenant_id = (known after apply)
            }
        }

      + windows_profile {
          + admin_password = (sensitive value)
          + admin_username = (known after apply)
        }
    }

  # azurerm_kubernetes_cluster_node_pool.common will be created
  + resource "azurerm_kubernetes_cluster_node_pool" "common" {
      + availability_zones    = [
          + "1",
          + "2",
          + "3",
        ]
      + enable_auto_scaling   = true
      + id                    = (known after apply)
      + kubernetes_cluster_id = (known after apply)
      + max_count             = 3
      + max_pods              = 20
      + min_count             = 1
      + mode                  = "User"
      + name                  = "common"
      + node_count            = 1
      + node_labels           = {
          + "workloads" = "general"
        }
      + orchestrator_version  = "1.20.7"
      + os_disk_size_gb       = (known after apply)
      + os_disk_type          = "Managed"
      + os_type               = "Linux"
      + priority              = "Regular"
      + spot_max_price        = -1
      + vm_size               = "Standard_B2s"
      + vnet_subnet_id        = (known after apply)
    }

  # azurerm_log_analytics_workspace.law will be created
  + resource "azurerm_log_analytics_workspace" "law" {
      + daily_quota_gb             = -1
      + id                         = (known after apply)
      + internet_ingestion_enabled = true
      + internet_query_enabled     = true
      + location                   = "uksouth"
      + name                       = (known after apply)
      + portal_url                 = (known after apply)
      + primary_shared_key         = (sensitive value)
      + resource_group_name        = "demo-rg"
      + retention_in_days          = 30
      + secondary_shared_key       = (sensitive value)
      + sku                        = "PerGB2018"
      + workspace_id               = (known after apply)
    }

  # azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
      + id       = (known after apply)
      + location = "uksouth"
      + name     = "demo-rg"
    }

  # azurerm_role_assignment.network_contributor will be created
  + resource "azurerm_role_assignment" "network_contributor" {
      + id                               = (known after apply)
      + name                             = (known after apply)
      + principal_id                     = (known after apply)
      + principal_type                   = (known after apply)
      + role_definition_id               = (known after apply)
      + role_definition_name             = "Network Contributor"
      + scope                            = (known after apply)
      + skip_service_principal_aad_check = (known after apply)
    }

  # azurerm_subnet.aks will be created
  + resource "azurerm_subnet" "aks" {
      + address_prefix                                 = (known after apply)
      + address_prefixes                               = [
          + "10.5.0.0/22",
        ]
      + enforce_private_link_endpoint_network_policies = false
      + enforce_private_link_service_network_policies  = false
      + id                                             = (known after apply)
      + name                                           = "demo-aks"
      + resource_group_name                            = "demo-rg"
      + virtual_network_name                           = "demo-vnet"
    }

  # azurerm_user_assigned_identity.aks_controlplane_ua_mi will be created
  + resource "azurerm_user_assigned_identity" "aks_controlplane_ua_mi" {
      + client_id           = (known after apply)
      + id                  = (known after apply)
      + location            = "uksouth"
      + name                = "demo-aks-controlplane-ua-mi"
      + principal_id        = (known after apply)
      + resource_group_name = "demo-rg"
      + tenant_id           = (known after apply)
    }

  # azurerm_virtual_network.vnet will be created
  + resource "azurerm_virtual_network" "vnet" {
      + address_space         = [
          + "10.5.0.0/16",
        ]
      + guid                  = (known after apply)
      + id                    = (known after apply)
      + location              = "uksouth"
      + name                  = "demo-vnet"
      + resource_group_name   = "demo-rg"
      + subnet                = (known after apply)
      + vm_protection_enabled = false
    }

  # random_integer.suffix will be created
  + resource "random_integer" "suffix" {
      + id     = (known after apply)
      + max    = 10000
      + min    = 100
      + result = (known after apply)
    }

Plan: 9 to add, 0 to change, 0 to destroy
```


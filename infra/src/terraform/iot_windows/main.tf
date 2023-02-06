provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}

locals {
  resource_group_name           = var.resource_group_name
  location                      = var.location
  admin_username                = var.admin_username
  admin_password                = var.admin_password
  subnet_name                   = var.subnet_name
  vnet_name                     = var.vnet_name
  machine_name                  = var.machine_name
  machine_size                  = var.machine_size 
  ansible_winrm_script_file_url = var.ansible_winrm_script_file_url 
  resource_level_tags = {
    # modified_at        = timestamp()
    environment        = var.environment
  }
}

data "azurerm_subnet" "subnet" {
  name                 = local.subnet_name
  virtual_network_name = local.vnet_name
  resource_group_name  = local.resource_group_name
}

locals {
  subnet_id = data.azurerm_subnet.subnet.id
}

#############################
# Deployments               #
#############################

module "worker_deployment" {
  source                  = "./worker"
  admin_username          = local.admin_username
  admin_password          = local.admin_password
  resource_group_name     = local.resource_group_name
  resource_group_location = local.location
  subnet_id               = local.subnet_id
  machine_name            = local.machine_name
  machine_size            = local.machine_size
  tags                    = local.resource_level_tags
}

resource "azurerm_virtual_machine_extension" "worker_extension" {
  name                 = module.worker_deployment.virtual_machine_names[count.index]
  count                = 1 # length(module.worker_deployment.virtual_machine_names)
  virtual_machine_id   = module.worker_deployment.virtual_machine_ids[count.index]
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  depends_on           = [module.worker_deployment]
  tags                 = local.resource_level_tags

  # CustomVMExtension Documentation: https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows
  settings           = <<SETTINGS
    {
        "fileUris": ["${local.ansible_winrm_script_file_url}"],
        "sanityCheck": 123456789
    }
SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell.exe -ExecutionPolicy Unrestricted -File ConfigureRemotingForAnsible.ps1"
    }
  PROTECTED_SETTINGS
}

# resource "azurerm_virtual_machine_extension" "monitor-DependencyAgent-agent" {
#   count                 = length(module.worker_deployment.virtual_machine_names)
#   name                  = "vmext-monitorDepAgent-${module.worker_deployment.virtual_machine_names[count.index]}"
#   virtual_machine_id    = module.worker_deployment.virtual_machine_ids[count.index]
#   publisher             = "Microsoft.Azure.Monitoring.DependencyAgent"
#   type                  = "DependencyAgentWindows"
#   type_handler_version  = "9.5"
#   auto_upgrade_minor_version = true
#  
#   settings = <<SETTINGS
#         {
#           "workspaceId": "${local.workspaceId}"
#         }
# SETTINGS
#  
#   protected_settings = <<PROTECTED_SETTINGS
#         {
#           "workspaceKey": "${local.workspaceKey}"
#         }
# PROTECTED_SETTINGS
# 
# }
#  
# resource "azurerm_virtual_machine_extension" "monitor-agent" {
#   count                 = length(module.worker_deployment.virtual_machine_names)
#   name                  = "vmext-monitorAgent-${module.worker_deployment.virtual_machine_names[count.index]}"
#   virtual_machine_id    = module.worker_deployment.virtual_machine_ids[count.index]
#   publisher             = "Microsoft.EnterpriseCloud.Monitoring"
#   type                  = "MicrosoftMonitoringAgent"
#   type_handler_version  = "1.0"
#   auto_upgrade_minor_version = true
#  
#   settings = <<SETTINGS
#         {
#           "workspaceId": "${local.workspaceId}"
#         }
# SETTINGS
#  
#   protected_settings = <<PROTECTED_SETTINGS
#         {
#           "workspaceKey": "${local.workspaceKey}"
#         }
# PROTECTED_SETTINGS
#  
# }
# 
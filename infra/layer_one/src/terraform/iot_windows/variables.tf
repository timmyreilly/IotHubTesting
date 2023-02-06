#########################
# General               #
#########################
resource "random_string" "general" {
  length  = 5
  special = false
  upper   = false
}

variable "subscription_id" {
  description = "Azure Subscription ID to deploy to"
}

variable "client_id" {
  description = "Azure Client ID to deploy to"
}

variable "client_secret" {
  description = "Azure Client Secret to deploy to"
}

variable "tenant_id" {
  description = "Azure Tenant ID to deploy to"
}

variable "resource_group_name" {
  description = "Target Resource Group Name for deployment"
}

variable "location" {
  description = "Target Azure Region for deployment"
}

variable "admin_username" {
  description = "Admin Username for deployed VM"
}

variable "admin_password" {
  description = "Admin Password for deployed VM"
}

variable "subnet_name" {
  description = "Subnet Name where the VM is deployed"
}

variable "vnet_name" {
  description = "VNET Name where the VM is deployed"
}

variable "machine_name" { 
  description = "Name of machine" 
  type        = string 
}

variable "machine_size" { 
  description = "size of machine" 
  type        = string 
}

variable "environment" {
  description = "How critical is the environment"
  type        = string
}

variable "tag_module_id" { 
    description = "id to track state of module deployment"
    type        = string 
}

variable "tag_module_type" {
  description = "type of module represented" 
  type        = string 
}

variable "ansible_winrm_script_file_url" {
  description = "Script that prepares the Windows VM for WinRM"
  type        = string
  default     = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
}

 # "https://corestorageaccountwus.file.core.windows.net/installationmedia/ConfigureRemotingForAnsible.ps1?sp=rl&st=2020-10-06T18:05:30Z&se=2024-10-22T18:05:00Z&sv=2019-12-12&sig=GP9Qxx543RGCKru2T9uJ8wLjTOo0qCOdzt4rehex%2F%2BM%3D&sr=f"
# https://corestorageaccountwus.file.core.windows.net/installationmedia/ConfigureRemotingForAnsible.ps1?sp=rl&st=2020-10-06T18:05:30Z&se=2024-10-22T18:05:00Z&sv=2019-12-12&sig=GP9Qxx543RGCKru2T9uJ8wLjTOo0qCOdzt4rehex%2F%2BM%3D&sr=f

# variable "workspaceId" {
#   description = "The id used for the Azure Monitor agent"
#   type        = string
# }
# 
# variable "workspaceKey" {
#   description = "The key used for the Azure Monitor agent"
#   type        = string
# }
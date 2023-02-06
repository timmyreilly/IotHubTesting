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

# variable "workers" {
#   description = "JSON string array that represents the hostname and vm sizes for workers to be deployed."
#   type        = string
# }
# 
# variable "ubuntu_info" {
#   description = "JSON string array that represents the hostname and vm sizes for workers to be deployed."
#   type        = string
# }


variable "environment" {
  description = "How critical is the environment"
  type        = string
}

variable "tag_module_id" { 
    description = "id to track state of module deployment"
    type        = string 
    default =  "dev123" 
}

variable "tag_module_type" {
  description = "type of module represented" 
  type        = string 
  default     = "basic_ubuntu" 
}
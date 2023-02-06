#--------------------------------------------------------------
# Input Variables
#--------------------------------------------------------------

variable "resource_group_name" {
  description = "Resource group name for the module"
  type        = string
}

variable "name" {
  description = "Resource group name for the module"
  type        = string
}

variable "region" {
  description = "The region to deploy the resources to"
  type        = string
  default     = "westus"
}

variable "subscription_id" {
  description = "Azure Subscription ID to deploy to"
  type        = string
}

variable "client_id" {
  description = "Azure Client ID to deploy to"
  type        = string
}

variable "client_secret" {
  description = "Azure Client Secret to deploy to"
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID to deploy to"
  type        = string
}

variable "vnet_name" {
  description = "The name of the resource virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "The address spaces for the vnet in bracketed list form"
  type        = list
}

variable "subnets" {
  description = "The subnets to create within the VNET"
  type        = list
}

variable "service_endpoints" {
  description = "The list of Service endpoints to associate with the subnet. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage and Microsoft.Web."
  type        = list
  default     = ["Microsoft.Storage"]
}

#variable "dns_servers" {
#  description = "List of valid DNS Server IP addresses"
#  type        = list(string)
#  default     = []
#}

variable "custom_inbound_rules" {
  description = "Custom inbound rules to add to the default rules applied in the Network Security Group"
  type        = list(map(string))
  default = [
    {
      name                       = "allow_all_inbound"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "Allow all inbound requests"
    }
  ]
}

variable "custom_outbound_rules" {
  description = "Custom outbound rules to add to the default rules applied in the Network Security Group"
  type        = list(map(string))
  default = [
    {
      name                       = "allow_all_outbound"
      priority                   = 200
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "Allow all outbound requests"
    }
  ]
}

variable "rg_type" {
  description = "Resource group type tag (eg. resource)"
  type        = string
  default     = "resource"
}

variable "tag_environment" {
  description = "Environment tag (eg. prod)"
  type        = string
  default      = "dev" 
}

variable "tag_module_id" {
  description = "module_id tag (eg. type_and_random_number?)"
  type        = string
}

variable "tag_module_type" {
  description = "module_type tag (eg. type_and_random_number?)"
  type        = string
}
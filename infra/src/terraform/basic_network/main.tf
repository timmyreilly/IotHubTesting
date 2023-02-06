provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}

locals {
  resource_level_tags = {
    # modified_at        = timestamp()
    environment        = var.tag_environment
    module_id          = var.tag_module_id
    module_type        = var.tag_module_type
  }
}

#--------------------------------------------------------------
# Local Vars
#--------------------------------------------------------------
locals {
  default_inbound_allow_rules = [
    {
      name = "allow_rdp"
      priority = 123
      direction = "Inbound"
      protocol = "All"
      source_port_range = "*"
      destination_port_range = "3389"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "Allow RDP to anywhere"
    }
  ]

  default_inbound_deny_rules = []

  default_outbound_allow_rules = [
    {
      name                       = "allow_icmp"
      priority                   = 100
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Icmp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "Allow ICMP to anywhere"
    },
    {
      name                       = "allow_dns"
      priority                   = 101
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "53"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "Allow DNS requests to anywhere"
    },
    {
      name                       = "allow_azure_fabric_1"
      priority                   = 102
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "168.63.129.16/32"
      description                = "Allow VMs to communicate with Azure metadata fabric"
    },
    {
      name                       = "allow_azure_fabric_2"
      priority                   = 103
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "32526"
      source_address_prefix      = "*"
      destination_address_prefix = "168.63.129.16/32"
      description                = "Allow VMs to communicate with Azure metadata fabric"
    },
    {
      name                       = "allow_azure_fabric_3"
      priority                   = 104
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "169.254.169.254/32"
      description                = "Allow VMs to communicate with Azure metadata fabric"
    }
  ]

  default_outbound_deny_rules = [
    {
      name                       = "deny_outbound_internet"
      priority                   = 4096
      direction                  = "Outbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "Internet"
      description                = "Deny all outbound internet requests"
    }
  ]
}

#----------------------------------------------------------------
# Resource Group
#----------------------------------------------------------------
resource "azurerm_resource_group" "resource_group" {
  name     = var.name
  location = var.region

  tags = local.resource_level_tags
}

#--------------------------------------------------------------
# Network Security Groups
#--------------------------------------------------------------
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.name}-nsg"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  tags                = local.resource_level_tags

  dynamic "security_rule" {
    for_each = [for s in concat(local.default_inbound_allow_rules, var.custom_inbound_rules, local.default_inbound_deny_rules) : {
      name                       = s.name
      priority                   = s.priority
      direction                  = s.direction
      access                     = s.access
      protocol                   = s.protocol
      source_port_range          = s.source_port_range
      destination_port_range     = s.destination_port_range
      source_address_prefix      = s.source_address_prefix
      destination_address_prefix = s.destination_address_prefix
      description                = s.description
    }]
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
      description                = security_rule.value.description
    }
  }

  dynamic "security_rule" {
    for_each = [for s in concat(local.default_outbound_allow_rules, var.custom_outbound_rules, local.default_outbound_deny_rules) : {
      name                       = s.name
      priority                   = s.priority
      direction                  = s.direction
      access                     = s.access
      protocol                   = s.protocol
      source_port_range          = s.source_port_range
      destination_port_range     = s.destination_port_range
      source_address_prefix      = s.source_address_prefix
      destination_address_prefix = s.destination_address_prefix
      description                = s.description
    }]
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
      description                = security_rule.value.description
    }
  }
}

#----------------------------------------------------------------
# Virtual Network
#----------------------------------------------------------------
resource "azurerm_virtual_network" "virtual_network" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  # dns_servers         = var.dns_servers
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  tags = local.resource_level_tags
}

#----------------------------------------------------------------
# Route Table
#----------------------------------------------------------------
resource "azurerm_route_table" "route_table" {
  name                          = "${var.name}-rt"
  location                      = azurerm_resource_group.resource_group.location
  resource_group_name           = azurerm_resource_group.resource_group.name
  disable_bgp_route_propagation = false

  tags = local.resource_level_tags
}

#----------------------------------------------------------------
# Subnets
#----------------------------------------------------------------
resource "azurerm_subnet" "subnet" {
  count                                          = length(var.subnets)
  name                                           = "${var.name}-subnet-${count.index}"
  resource_group_name                            = azurerm_resource_group.resource_group.name
  virtual_network_name                           = azurerm_virtual_network.virtual_network.name
  address_prefixes                               = ["${var.subnets[count.index]}"]
  # enforce_private_link_endpoint_network_policies = true
  # enforce_private_link_service_network_policies  = true
  private_endpoint_network_policies_enabled = true 
  # service_endpoints                              = var.service_endpoints
}

locals {
  subnet_ids = azurerm_subnet.subnet.*.id
}

resource "azurerm_subnet_network_security_group_association" "main" {
  count                     = length(local.subnet_ids)
  subnet_id                 = local.subnet_ids[count.index]
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_route_table_association" "main" {
  count          = length(local.subnet_ids)
  subnet_id      = local.subnet_ids[count.index]
  route_table_id = azurerm_route_table.route_table.id
}

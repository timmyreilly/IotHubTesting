provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}

locals {
  resource_level_tags   = {
    # modified_at         = timestamp()
    environment         = var.environment
    module_type         = var.tag_module_type
    module_id           = var.tag_module_id 
  }
}

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

data "azurerm_subnet" "target_subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}

resource "azurerm_public_ip" "public_ip" {
  name              = "${var.machine_name}-public-ip"
  resource_group_name = var.resource_group_name 
  location = data.azurerm_resource_group.resource_group.location
  allocation_method = "Dynamic" 
}

resource "azurerm_network_interface" "main" {
  name                = "${var.machine_name}-core-nic"
  location            =  data.azurerm_resource_group.resource_group.location
  resource_group_name =  var.resource_group_name

  ip_configuration {
    name                          = "${var.machine_name}-private-ip"
    subnet_id                     = data.azurerm_subnet.target_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
    
}

resource "azurerm_virtual_machine" "main" {
  name                  = var.machine_name
  location              = data.azurerm_resource_group.resource_group.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.machine_size

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.machine_name}osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = var.admin_username
    #TODO: secure password 
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = local.resource_level_tags
}

data "azurerm_public_ip" "waited_public_ip" { 
  name = azurerm_public_ip.public_ip.name
  resource_group_name = var.resource_group_name
  depends_on = [azurerm_virtual_machine.main]
}
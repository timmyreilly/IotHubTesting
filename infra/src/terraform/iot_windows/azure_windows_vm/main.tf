module "os" {
  source       = "./os"
  vm_os_simple = var.vm_os_simple
}

resource "random_id" "vm-sa" {
  keepers = {
    resource_type = "windows"
  }

  byte_length = 6
}

resource "azurerm_storage_account" "vm-sa" {
  count                    = var.boot_diagnostics ? 1 : 0
  name                     = "bootdiag${lower(random_id.vm-sa.hex)}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = element(split("_", var.boot_diagnostics_sa_type), 0)
  account_replication_type = element(split("_", var.boot_diagnostics_sa_type), 1)
  tags                     = var.tags
}

resource "azurerm_public_ip" "public_ip" {
  name                = "${var.machine_name}-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"
  tags                = var.tags
}

# Since the public IP takes a while... we need to wait for the vm to get an IP address back. 
data "azurerm_public_ip" "waited_public_ip" { 
  name = azurerm_public_ip.public_ip.name
  resource_group_name = var.resource_group_name
  depends_on = [azurerm_windows_virtual_machine.vm-windows]
}

resource "azurerm_network_interface" "vm" {
  count                         = var.nb_instances
  name                          = "nic-${var.machine_name}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enable_accelerated_networking = var.enable_accelerated_networking

  ip_configuration {
    name                          = "ipconfig${count.index}"
    subnet_id                     = var.vnet_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "vm-windows" {
  count                 = var.data_disk ? 0 : var.nb_instances
  name                  = var.machine_name
  computer_name         = var.machine_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  size                  = var.machine_size
  network_interface_ids = [element(azurerm_network_interface.vm.*.id, count.index)]
  provision_vm_agent    = true

#  source_image_reference {
#    publisher = coalesce(var.vm_os_publisher, module.os.calculated_value_os_publisher)
#    offer     = coalesce(var.vm_os_offer, module.os.calculated_value_os_offer)
#    sku       = coalesce(var.vm_os_sku, module.os.calculated_value_os_sku)
#    version   = var.vm_os_version
#  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-22h2-pro"
    version   = "latest"
  }



  os_disk {
    name                 = "osdisk-${var.machine_name}"
    caching              = "ReadWrite"
    storage_account_type = var.storage_account_type
    disk_size_gb         = var.os_disk_size_gb
  }

  tags = var.tags

}

resource "azurerm_windows_virtual_machine" "vm-windows-with-datadisk" {
  count                 = var.data_disk ? var.nb_instances : 0
  name                  = var.machine_name
  computer_name         = var.machine_name
  location              = var.location
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  resource_group_name   = var.resource_group_name
  size                  = var.machine_size
  network_interface_ids = [element(azurerm_network_interface.vm.*.id, count.index)]
  provision_vm_agent    = true

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "rs5-pro"
    version   = "latest"
  }

#  source_image_reference {
#    publisher = coalesce(var.vm_os_publisher, module.os.calculated_value_os_publisher)
#    offer     = coalesce(var.vm_os_offer, module.os.calculated_value_os_offer)
#    sku       = coalesce(var.vm_os_sku, module.os.calculated_value_os_sku)
#    version   = var.vm_os_version
#  }

  os_disk {
    name                 = "osdisk-${var.machine_name}"
    caching              = "ReadWrite"
    storage_account_type = var.storage_account_type
    disk_size_gb         = var.os_disk_size_gb
  }

  tags = var.tags

}

resource "azurerm_managed_disk" "example" {
  name                 = "datadisk-${var.machine_name}"
  count                = var.data_disk ? var.nb_instances : 0
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = var.data_sa_type
  create_option        = "Empty"
  disk_size_gb         = var.data_disk_size_gb
}

resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  count              = var.data_disk ? var.nb_instances : 0
  managed_disk_id    = element(azurerm_managed_disk.example.*.id, count.index)
  virtual_machine_id = element(azurerm_windows_virtual_machine.vm-windows.*.id, count.index)
  lun                = "10"
  caching            = "ReadWrite"
}
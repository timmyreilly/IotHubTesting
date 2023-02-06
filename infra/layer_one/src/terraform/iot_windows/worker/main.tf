
#################################
# Window VM(s) for workers #
#################################
module "worker" {
  source                        = "../azure_windows_vm"
  resource_group_name           = var.resource_group_name
  location                      = var.resource_group_location
  admin_password                = var.admin_password
  admin_username                = var.admin_username
  vm_os_simple                  = var.worker_vm_os_simple
  remote_port                   = var.worker_vm_remote_port
  nb_instances                  = 1
  machine_name                  = var.machine_name 
  machine_size                  = var.machine_size
  vnet_subnet_id                = var.subnet_id
  boot_diagnostics              = "false"
  delete_os_disk_on_termination = "true"
  enable_accelerated_networking = "true"
  is_windows_image              = "true"
  tags                          = var.tags
}

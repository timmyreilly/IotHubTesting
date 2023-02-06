output "vm_id" {
  description = "Virtual machine ids created."
  value       = "${azurerm_virtual_machine.main.id}"
}

output "network_interface_id" {
  description = "ids of the vm nics provisoned."
  value       = "${azurerm_network_interface.main.id}"
}

output "network_interface_private_ip" {
  description = "private ip address of the vm nic"
  value       = "${azurerm_network_interface.main.private_ip_address}"
}

output "network_interface_public_ip" {
  description = "public ip address of the vm nic"
  value         = data.azurerm_public_ip.waited_public_ip.ip_address
}

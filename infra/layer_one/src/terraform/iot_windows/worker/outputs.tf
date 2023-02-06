output "virtual_machine_ids" {
  value = "${module.worker.vm_ids}"
}

output "virtual_machine_names" {
  value = "${module.worker.vm_names}"
}

output "virtual_machine_private_ips" {
  value = "${module.worker.network_interface_private_ip}"
}

output "virtual_machine_public_ips" {
  value = "${module.worker.public_ip_address}"
}

output "virtual_machine_public_ip_dns_name" {
  value = "${module.worker.public_ip_dns_name}"
}
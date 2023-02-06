output "host_ip_addresses" {
  value = module.worker_deployment.virtual_machine_private_ips
}

output "virtual_machine_ids" {
  value = module.worker_deployment.virtual_machine_ids
}

output "virtual_machine_names" {
  value = module.worker_deployment.virtual_machine_names
}

output "public_ip_address" {
  description = "The actual ip address allocated for the resource."
  value       = "${module.worker_deployment.virtual_machine_public_ips}"
}
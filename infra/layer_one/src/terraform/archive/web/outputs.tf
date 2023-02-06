output "app_service_name_api" {
  value = "${azurerm_app_service.api.name}"
}

output "app_service_default_hostname_api" {
  value = "https://${azurerm_app_service.api.default_site_hostname}"
}
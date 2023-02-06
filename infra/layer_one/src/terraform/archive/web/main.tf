/*
Creates: 
- Web Resource Group
- App Service Plan
- Azure Container Registry
- WebApp (API)
*/
provider "azurerm" {
  version         = "=2.0.0"
  subscription_id = var.subscription_id
  features{}
}

#Configure azuredevops provider to point to ADO specified instance
provider "azuredevops" {
  version = ">= 0.0.1"
  personal_access_token = var.service_connection_pat
  org_service_url = var.ado_org_service_url
}

#If you would like to add a random string uncomment lines 28-36
#You will then be able to add a random string to your naming convention 
#This will be helpful to ensure naming conventions do not overlap
#ex ${random_string.general.result}

# provider "random" {
#   version = "~> 2.2"
# }

# resource "random_string" "general" {
#     length  = 2
#     special = false
#     upper   = false
# }

#Import azuredevops project via 
data "azuredevops_project" "main" {
  project_name = var.ado_project_name
}

#Initialize local variables for azuredevops project_id and web resource naming conventions
locals {
  project_id = data.azuredevops_project.main.id

}

#Create resource group for web resources
resource "azurerm_resource_group" "api" {
  name     = "${var.prefix}-web-rg"
  location = var.location
}

#Create app service plan that the services use
resource "azurerm_app_service_plan" "api" {
  name                = "${var.prefix}-appserviceplan"
  location            = azurerm_resource_group.api.location
  resource_group_name = azurerm_resource_group.api.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

#Create container registry
resource "azurerm_container_registry" "api" {
  name                     = "${var.prefix}webcontainerregistry"
  location                 = azurerm_resource_group.api.location
  resource_group_name      = azurerm_resource_group.api.name
  sku                      = "Premium"
  admin_enabled            = true
}

#Create api app service
resource "azurerm_app_service" "api" {
  name                = "${var.prefix}-web-api-appservice"
  location            = azurerm_resource_group.api.location
  resource_group_name = azurerm_resource_group.api.name
  app_service_plan_id = azurerm_app_service_plan.api.id
  
  site_config {
    app_command_line = ""
    linux_fx_version = "DOCKER|appsvcsample/python-helloworld:latest"
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE"     = "false"
    "DOCKER_REGISTRY_SERVER_URL"              = "https://index.docker.io"
    "ASPNETCORE_URLS"                         = "http://*:5000"
    "WEBSITES_PORT"                           = "5000"
    "ClientId"                                = var.client_id
    "ClientSecret"                            = var.client_secret
    "TenantId"                                = var.tenant_id
    "SubscriptionId"                          = var.subscription_id
  }
}

resource "azuredevops_variable_group" "variablegroup" {
  project_id   = local.project_id
  name         = "web-api-variables"
  description  = "Web CI/CD pipeline variables"
  allow_access = true

  variable {
    name      = "appServiceNameApi"
    value     = azurerm_app_service.api.name
    is_secret = false
  }
  variable {
    name      = "azureContainerRegistry"
    value     = azurerm_container_registry.api.name
    is_secret = false
  }
  variable {
    name      = "webResourceGroupName"
    value     = azurerm_resource_group.api.name
    is_secret = false
  }
}



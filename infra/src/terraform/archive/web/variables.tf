#--------------------------------------------------------------
# Project variable definitions
# Variables can be passed in manually or through a .tfvars file
# For more information see ./docs/terraform.md 
#--------------------------------------------------------------

variable "subscription_id" {
  description = "Subscription ID"
  type        = string
}
variable "prefix" {
  description = "Prefix for naming convention ex 'studiolab' 'twds'"
  type        = string
}
variable "location" {
  description = "Azure location for the resoureces to be spun up"
  type        = string
}
variable "tenant_id" {
  description = "Service Principal Tenant ID"
  type        = string
}
variable "client_id" {
  description = "Service Principal Client ID"
  type        = string
}
variable "client_secret" {
  description = "Service Principal Client secret"
  type        = string
}
variable "ado_project_name" {
  description = "AzureDevOps Project Name"
  type        = string
}
variable "service_connection_pat" {
  description = "AzureDevOps PAT"
  type        = string
}
variable "ado_org_service_url" {
  description = "AzureDevOps Org Service URL"
  type        = string
}

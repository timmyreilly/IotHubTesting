#########################
# Input Variables       #
#########################
variable "admin_password" {
  description = "Admin Password for Virtual Machines"
}

variable "admin_username" {
  description = "Admin Username for Virtual Machines"
}

variable "worker_vm_remote_port" {
  description = "RDP port for remote access"
  default     = 3389
}

variable "machine_name" { 
  description = "Name of machine" 
  type        = string 
}

variable "machine_size" { 
  description = "size of machine" 
  type        = string 
}

variable "worker_vm_os_simple" {
  description = "VM OS base"
  default     = "WindowsServer"
}

variable "resource_group_name" {
  description = "Target Resource Group Name for deployment"
}

variable "resource_group_location" {
  description = "Target Azure Region for deployment"
}

variable "subnet_id" {
  description = "Target Azure Region for deployment"
}

variable "tags" {
  description = "Azure Tags"
}


#########################
# General Variables     #
#########################
resource "random_string" "m_worker" {
  length  = 5
  special = false
  upper   = false
}

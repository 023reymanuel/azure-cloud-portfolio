variable "resource_group_name" {
  description = "Resource group where VMs will be created"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "public_subnet_id" {
  description = "Subnet ID where public VM will be placed"
  type        = string
}

variable "private_subnet_id" {
  description = "Subnet ID where private VM will be placed"
  type        = string
}

variable "admin_username" {
  description = "Admin username for VMs - never use root or admin"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key for VM authentication - more secure than passwords"
  type        = string
}

variable "public_vm_size" {
  description = "VM size for public web server"
  type        = string
  default     = "Standard_B2s"
}

variable "private_vm_size" {
  description = "VM size for private backend server"
  type        = string
  default     = "Standard_B1s"
}

variable "tags" {
  description = "Tags for all compute resources"
  type        = map(string)
  default     = {}
}

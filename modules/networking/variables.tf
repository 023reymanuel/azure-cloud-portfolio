variable "resource_group_name" {
  description = "Resource group where networking resources will be created"
  type        = string
}

variable "location" {
  description = "Azure region for networking resources"
  type        = string
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "vnet_address_space" {
  description = "CIDR range for the entire VNet - all subnets must fit within this"
  type        = list(string)
}

variable "public_subnet_name" {
  description = "Name of the public-facing subnet"
  type        = string
}

variable "public_subnet_prefix" {
  description = "CIDR range for public subnet"
  type        = string
}

variable "private_subnet_name" {
  description = "Name of the private/backend subnet"
  type        = string
}

variable "private_subnet_prefix" {
  description = "CIDR range for private subnet"
  type        = string
}

variable "bastion_subnet_prefix" {
  description = "CIDR for Bastion - Azure requires this be named AzureBastionSubnet and minimum /26"
  type        = string
}

variable "tags" {
  description = "Tags applied to all networking resources"
  type        = map(string)
  default     = {}
}

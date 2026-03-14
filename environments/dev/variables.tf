variable "resource_group_name" {
  description = "Name of the resource group that contains all project resources"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
  default     = "East US"
}

variable "tags" {
  description = "Tags applied to all resources — this is how companies track cost and ownership"
  type        = map(string)
  default     = {}
}

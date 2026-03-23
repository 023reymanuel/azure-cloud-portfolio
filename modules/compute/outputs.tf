output "public_vm_id" {
  description = "ID of the public web server VM"
  value       = azurerm_linux_virtual_machine.public.id
}

output "public_ip_address" {
  description = "Public IP address to access the web server"
  value       = azurerm_public_ip.public.ip_address
}

output "private_vm_id" {
  description = "ID of the private backend VM"
  value       = azurerm_linux_virtual_machine.private.id
}

output "private_ip_address" {
  description = "Private IP of backend VM - only reachable inside VNet"
  value       = azurerm_network_interface.private.private_ip_address
}


output "public_ip_address" {
  description = "IP address to access the web server"
  value       = module.compute.public_ip_address
}

output "private_ip_address" {
  description = "Private IP of backend VM"
  value       = module.compute.private_ip_address
}


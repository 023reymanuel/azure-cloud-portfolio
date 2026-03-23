# Public VM Network Interface Card
# The NIC is what connects the VM to the subnet
# It's a separate resource so it can be managed independently
resource "azurerm_network_interface" "public" {
  name                = "nic-public-vm"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.public_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public.id
  }
}

# Public IP for the web server
# This is how the internet reaches your VM
resource "azurerm_public_ip" "public" {
  name                = "pip-public-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Private VM Network Interface Card
# No public IP - only reachable from within the VNet
resource "azurerm_network_interface" "private" {
  name                = "nic-private-vm"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.private_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# Public VM - nginx web server
resource "azurerm_linux_virtual_machine" "public" {
  name                = "vm-public-web"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.public_vm_size
  admin_username      = var.admin_username
  tags                = var.tags

  # Connect VM to subnet via NIC
  network_interface_ids = [azurerm_network_interface.public.id]

  # SSH key authentication - more secure than passwords
  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Ubuntu 20.04 LTS - standard for production Linux servers
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  # Startup script - installs nginx automatically on first boot
  # This is cloud-init - runs once when VM first starts
  custom_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
    echo "<h1>Trustar Bank - Web Server</h1>" > /var/www/html/index.html
  EOF
  )
}

# Private VM - backend server
resource "azurerm_linux_virtual_machine" "private" {
  name                = "vm-private-backend"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.private_vm_size
  admin_username      = var.admin_username
  tags                = var.tags

  network_interface_ids = [azurerm_network_interface.private.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  # Backend server - simulates a database/app server
  custom_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y python3
    echo "Backend server ready" > /tmp/status.txt
  EOF
  )
}

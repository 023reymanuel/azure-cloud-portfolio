terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.111"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "networking" {
  source = "../../modules/networking"

  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  vnet_name             = "trustar-bank-vnet"
  vnet_address_space    = ["10.0.0.0/16"]
  public_subnet_name    = "public-subnet"
  public_subnet_prefix  = "10.0.1.0/27"
  private_subnet_name   = "private-subnet"
  private_subnet_prefix = "10.0.2.0/26"
  bastion_subnet_prefix = "10.0.3.0/26"
  tags                  = var.tags
}

module "compute" {
  source = "../../modules/compute"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  public_subnet_id    = module.networking.public_subnet_id
  private_subnet_id   = module.networking.private_subnet_id
  ssh_public_key      = file("~/.ssh/id_rsa.pub")
  tags                = var.tags
}

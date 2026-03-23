# Trustar Bank Azure Infrastructure

## Project Brief
Based on real job requirements from Trustar Bank 
— a community bank in Washington DC seeking a 
Cloud Engineer. Built a secure, isolated Azure 
environment with network segmentation, enforced 
tagging, and infrastructure as code.

## Architecture Overview
A three-tier network architecture deployed in 
Azure var.location. Public-facing web servers sit 
in an isolated public subnet. Backend servers 
are in a private subnet with no internet access. 
Azure Bastion provides secure admin access 
without exposing SSH ports publicly.

## Network Design

| Subnet | CIDR | Purpose | Size Reasoning |
|--------|------|---------|----------------|
| Public | 10.0.1.0/27 | Web VMs | 27 usable IPs, fits 10 VMs with headroom |
| Private | 10.0.2.0/26 | Backend VMs | 59 usable IPs, fits 20 VMs with headroom |
| Bastion | 10.0.3.0/26 | Azure Bastion | Minimum /26 required by Azure |

VNet address space: 10.0.0.0/16

## Security Decisions

**Private subnet NSG** locks inbound traffic 
to `10.0.1.0/27` only — the exact public subnet 
CIDR. Using the broad `VirtualNetwork` service 
tag was rejected because it allows any peered 
network, which fails least-privilege principles 
for a bank environment.

**SSH authentication** uses key pairs only. 
Password authentication is disabled on all VMs.

**Defense in depth** — NSGs at subnet level 
enforce traffic rules independent of VM 
configuration.

## Trade-offs: Dev vs Production

| Decision | Dev | Production |
|----------|-----|------------|
| VM size | Standard_B1s | Standard_D4s_v3 minimum |
| Storage | Standard_LRS | GRS for database tier |
| State | Local file | Azure Blob Storage |
| Secrets | tfvars file | Azure Key Vault |
| Config | custom_data | Ansible playbooks |

## Tools Used
- Terraform 1.14.6
- Azure CLI 2.83.0
- Azure Provider 3.117.1

## How To Deploy
```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

## Author
Emmanuel — transitioning into cloud engineering.
Built from real job requirements, not tutorials.
```

# Deploy an Azure Virtual Machine Using Terraform

This project provisions a complete Azure Virtual Machine infrastructure using Terraform, including networking, security, and compute resources — all defined as code.

---

## Architecture

```
Internet
    |
Public IP Address
    |
Network Interface (NIC)
    |
Virtual Machine (Ubuntu 20.04)
    |
Subnet (10.0.1.0/24)
    |
Virtual Network (10.0.0.0/16)
    |
Resource Group
```

---

## Resources Provisioned

| Resource | Name | Description |
|---|---|---|
| Resource Group | terraform-vm-rg | Container for all resources |
| Virtual Network | terraform-vnet | Private network (10.0.0.0/16) |
| Subnet | terraform-subnet | VM subnet (10.0.1.0/24) |
| Public IP | terraform-public-ip | Static public IP (Standard SKU) |
| Network Interface | terraform-nic | Connects VM to subnet and public IP |
| Linux Virtual Machine | terraform-vm | Ubuntu 20.04, Standard_B2s |

---

## Prerequisites

Before you begin, make sure you have the following installed and configured:

- [Terraform](https://developer.hashicorp.com/terraform/install) (v1.0+)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- An active [Azure Subscription](https://portal.azure.com)

---

## Quick Start

### Step 1 — Clone the repository

```bash
git clone https://github.com/Nicholasojinni/azure-vm-terraform.git
cd azure-vm-terraform
```

### Step 2 — Log in to Azure

```bash
az login
```

### Step 3 — Initialize Terraform

```bash
terraform init
```

### Step 4 — Preview the deployment plan

```bash
terraform plan
```

### Step 5 — Deploy the infrastructure

```bash
terraform apply
```

Type `yes` when prompted. Deployment takes approximately 2–3 minutes.

### Step 6 — Connect to the VM

After deployment, the output will show your SSH command:

```bash
ssh azureuser@<public_ip_address>
```

Password: `P@ssw0rd1234!`

### Step 7 — Verify the VM is running

```bash
az vm list -d --query "[].{Name:name, Status:powerState}"
```

Expected output:
```json
[
  {
    "Name": "terraform-vm",
    "Status": "VM running"
  }
]
```

### Step 8 — Destroy resources when done

```bash
terraform destroy
```

Type `yes` when prompted. Always destroy after testing to avoid unnecessary charges.

---

## Outputs

After `terraform apply` completes, the following values are printed:

| Output | Description |
|---|---|
| `public_ip_address` | The public IP address of the VM |
| `ssh_command` | Ready-to-use SSH connection command |

---

## Common Errors and Fixes

| Error | Fix |
|---|---|
| `SkuNotAvailable: Standard_B2s` | Change `size` to `Standard_D2s_v3` or use a different region |
| `IPv4BasicSkuPublicIpCountLimitReached` | Add `sku = "Standard"` to the public IP resource |
| `AuthorizationFailed` | Run `az login` and try again |
| `az login` requires MFA security key | Go to https://aka.ms/mfasetup and add phone as alternative MFA method |

---

## Project Structure

```
azure-vm-terraform/
├── main.tf         # All infrastructure resources
├── .gitignore      # Excludes Terraform binaries and state files
└── README.md       # This file
```

---

## Author

**Nicholas Ojinni**
DevOps Micro Internship (DMI) — Cohort 2 | Group 3
LinkedIn: (https://www.linkedin.com/in/ojinni-oluwafemi11/)
GitHub: (https://github.com/Nicholasojinni)

---

## Resources

- [Terraform Azure Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure CLI Installation](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [DevOps Micro Internship](https://pravinmishra.com/dmi)
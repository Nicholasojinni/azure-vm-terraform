# ============================================================
# TERRAFORM PROVIDER CONFIGURATION
# Tells Terraform to use the Azure provider plugin
# ============================================================
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# ============================================================
# RESOURCE GROUP
# A container that holds all related Azure resources together
# ============================================================
resource "azurerm_resource_group" "rg" {
  name     = "terraform-vm-rg"
  location = "Canada Central"
}

# ============================================================
# VIRTUAL NETWORK
# The private network your VM will live inside
# ============================================================
resource "azurerm_virtual_network" "vnet" {
  name                = "terraform-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# ============================================================
# SUBNET
# A smaller segment inside the Virtual Network
# ============================================================
resource "azurerm_subnet" "subnet" {
  name                 = "terraform-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# ============================================================
# PUBLIC IP ADDRESS
# Gives the VM an address reachable from the internet
# ============================================================
resource "azurerm_public_ip" "public_ip" {
  name                = "terraform-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# ============================================================
# NETWORK INTERFACE (NIC)
# The VM's virtual network card — connects it to subnet + public IP
# ============================================================
resource "azurerm_network_interface" "nic" {
  name                = "terraform-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# ============================================================
# VIRTUAL MACHINE
# The actual Ubuntu 18.04 Linux server
# ============================================================
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "terraform-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_D2s_v3"

  admin_username                  = "adminuser"
  admin_password                  = "Oluwafemi11@@"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# ============================================================
# OUTPUT
# Prints the public IP address to your terminal after deployment
# ============================================================
output "public_ip_address" {
  value       = azurerm_public_ip.public_ip.ip_address
  description = "The public IP address of the virtual machine"
}
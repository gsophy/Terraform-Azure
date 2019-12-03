# Define the AzureRM Terraform provider.  The version is optional, but pins the terraform to a specific version. 
provider "azurerm" {
  version = "=1.34.0"
}
# Define the prefix for all resource naming
variable "prefix" {
  default = "app-dss-lnl-demo"
}

variable "access_key" {
  # default = "${var.access_key}"
}

#Define the remote state backend
terraform {
  backend "azurerm" {
    storage_account_name = "gsophyremotestate"
    container_name       = "tf-state-container"
    key                  = "pipeline.terraform.tfstate"

    # rather than defining this inline, the Access Key can also be sourced
    # from an Environment Variable - more information is available below.
    access_key = ""
  }
}
# Create a resource group
resource "azurerm_resource_group" "app-rg" {
  name     = "${var.prefix}-resourcegroup"
  location = "East US"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "app-vnet" {
  name                = "${var.prefix}-network"
  resource_group_name = azurerm_resource_group.app-rg.name
  location            = azurerm_resource_group.app-rg.location
  address_space       = ["10.0.0.0/16"]
}

## added text
# Creates a subnet named "Internal" that attaches to the resource group and vNet.  Also assigns an address space for the subnet.
resource "azurerm_subnet" "internal" {
  name                 = "${var.prefix}-internal"
  resource_group_name  = azurerm_resource_group.app-rg.name
  virtual_network_name = azurerm_virtual_network.app-vnet.name
  address_prefix       = "10.0.2.0/24"
}

# Creates a Network Interface that will be attached to the VM during creation.
# resource "azurerm_network_interface" "app-nic" {
#   name                = "${var.prefix}-nic"
#   location            = azurerm_resource_group.app-rg.location
#   resource_group_name = azurerm_resource_group.app-rg.name

#   ip_configuration {
#     name                          = "${var.prefix}-nic1"
#     subnet_id                     = azurerm_subnet.internal.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# Here we create an Azure VM.  It is during the VM creation process that the Network Interface is attached.
# resource "azurerm_virtual_machine" "main" {
#   name                  = "${var.prefix}-vm"
#   location              = azurerm_resource_group.app-rg.location
#   resource_group_name   = azurerm_resource_group.app-rg.name
#   network_interface_ids = [azurerm_network_interface.app-nic.id]
#   vm_size               = "Standard_DS2_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

#   storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "16.04-LTS"
#     version   = "latest"
#   }
#   storage_os_disk {
#     name              = "myosdisk1"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }
#   os_profile {
#     computer_name  = "hostname"
#     admin_username = "testadmin"
#     admin_password = "Password1234!"
#   }
#   os_profile_linux_config {
#     disable_password_authentication = false
#   }
#   tags = {
#     environment = "staging"
#   }
# }

# resource "azurerm_sql_server" "app-sql-server" {
#   name                         = "${var.prefix}-sqlserver"
#   resource_group_name          = "${azurerm_resource_group.app-rg.name}"
#   location                     = "East US"
#   version                      = "12.0"
#   administrator_login          = "4dm1n157r470r"
#   administrator_login_password = "4-v3ry-53cr37-p455w0rd"
# }
# resource "azurerm_sql_database" "app-sql-database" {
#   name                = "${var.prefix}-sqldatabase"
#   resource_group_name = "${azurerm_resource_group.app-rg.name}"
#   location            = "East US"
#   server_name         = "${azurerm_sql_server.app-sql-server.name}"
#   tags = {
#     environment = "staging"
#   }
# }


#Creates Resource Group
resource "azurerm_resource_group" "main" {
    name = "learn-tf-rg-eastus"
    location = "eastus"

}

#Creates virtual network
resource "azurerm_virtual_network" "main" {
    name                = "learn-tf-vnet-eastus"
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name 
    address_space       = ["10.0.0.0/16"]
}

#Creates subnet
resource "azurerm_subnet" "main" {
    name                    = "learn-tf-subnet-eastus"
    resource_group_name     = azurerm_resource_group.main.name 
    virtual_network_name    = azurerm_virtual_network.main.name
    address_prefixes        = ["10.0.0.0/24"]
}
#address_prefixes have to be within the address space

#Creates network interface card (NIC)
resource "azurerm_network_interface" "internal" {
    name                    = "learn-tf-nic-int-eastus"
    location                = azurerm_resource_group.main.location
    resource_group_name     = azurerm_resource_group.main.name

    ip_configuration {
        name                            = "internal"
        subnet_id                       = azurerm_subnet.main.id
        private_ip_address_allocation   = "Dynamic"
    }
}

#Creates Virtual Machine

variable "storage_account_name"{
    type=string
    default="appstore50011"
}

variable "resource_group_name" {
    type=string
    default="terraform_grp"
}

variable "netowork_name"{
    name=string
    default="staging"
}

variable "vm_name"{
    name=string
    default="stagingvm"
}

provider "azurerm"{
    version ="=2.0"
    subscription_id="7f263856-7664-4cf3-b86e-ce2c9fda5d41"
    tenant_id="adb29633-c28b-4687-81ec-f66bbb0df994"
    features{}
}

resource "azurerm_resource_group" "grp"{
    name=var.resource_group_name
    location="Central India"
}

resoruce "azurerm_storage_account" "store"{
    name                     = var.storage_account_name
    resource_group_name      = azurerm_resource_group.grp.name
    location                 = azurerm_resource_group.grp.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
}

resoruce "azurerm_virtual_network" "staging"{
    name                     = var.netowork_name
    address_space            = ["10.0.0.0/16"]
    location                 = "Central India"
    resource_group_name      = "terraform_grp"
}

resoruce "azurerm_subnet" "default"{
    name                     = "default"
    resource_group_name      = "terraform_grp"
    virtual_network_name     = azurerm_virtual_network.staging.name
    address_prefix           = "10.0.0.0/24"
}

resoruce "azurerm_network_interface" "interface"{
    name                     = "default-interface"
    location                 = "Central India"
    resource_group_name      = "terraform_grp"
}

  ip_configuration {
    name                          = "interfaceconfiguration"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
  }
}
 
resource "azurerm_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = "Central India"
  resource_group_name   = "terraform_grp"
  network_interface_ids = [azurerm_network_interface.interface.id]
  vm_size               = "Standard_DS1_v2"
 
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "stagingvm"
    admin_username = "demousr"
    admin_password = "AzurePortal@123"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }  
}
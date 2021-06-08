variable "storage_account_name"{
    type=string
    default="appstore50011"
}

variable "resource_group_name" {
    type=string
    default="terraform_grp"
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
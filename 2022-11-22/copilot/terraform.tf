// create an azure resource group.
// use a parameter for the name
// use a parameter for the location but allow only swiss datacenters
// we want to use MSI for the authentication to the azure provider
// pin the provider to the latest version

// here is a link to the documentation for the azure provider
// https://www.terraform.io/docs/providers/azurerm/index.html
provider "azurerm" {
  version = "=2.0.0"
  features {}

    // use MSI for authentication
    // https://www.terraform.io/docs/providers/azurerm/guides/managed_service_identity.html
    use_msi = true
}

variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
  validation {
    condition = contains(["switzerlandnorth", "swizterlandwest"], var.rg_location)
    error_message = "The location must be a valid Azure location."
  }
}

// show a link to the documentation
// https://www.terraform.io/docs/providers/azurerm/r/resource_group.html
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.rg_location
}

// create a module to create a storage account using the resource group created above
module "storage_account" {
  source = "./modules/storage_account"
  resource_group_name = azurerm_resource_group.rg.name
}

# Path: modules/storage_account/main.tf
// create a storage account
// use a parameter for the name
// use a parameter for the resource group
// use a parameter for the location but allow only swiss datacenters
// use a parameter for the sku
// use a parameter for the kind

# input variables
variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
  validation {
    condition = contains(["switzerlandnorth", "swizterlandwest"], var.location)
    error_message = "The location must be a valid Azure location."
  }
}

variable "sku" {
  type = string
  validation {
    condition = contains(["Standard_LRS", "Standard_GRS", "Standard_RAGRS", "Standard_ZRS", "Premium_LRS", "Premium_ZRS", "Standard_GZRS", "Standard_RAGZRS"], var.sku)
    error_message = "The sku must be a valid Azure sku."
  }
}

variable "kind" {
  type = string
  validation {
    condition = contains(["Storage", "StorageV2", "BlobStorage", "FileStorage", "BlockBlobStorage"], var.kind)
    error_message = "The kind must be a valid Azure kind."
  }
}

// here is a link to the documentation for the azure provider
// https://www.terraform.io/docs/providers/azurerm/r/storage_account.html
resource "azurerm_storage_account" "sa" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.sku
  account_replication_type = var.kind
}

// output the resource id
output "resource_id" {
  value = azurerm_storage_account.sa.id
}

# how to i run terraform
# terraform init
# terraform plan
# terraform apply

# where do i get terraform from
# https://www.terraform.io/downloads.html

# can i run terraform in a container
# yes, here is a link to the docker image
# https://hub.docker.com/r/hashicorp/terraform


# where does github copilot get the code from? should i be worried? show me some articles
# https://www.theverge.com/2021/6/16/22531500/github-copilot-ai-code-generator-privacy-issues

# use letmegooglethatforyou.com to find more articles
# https://lmgtfy.com/?q=github+copilot+ai+code+generator+privacy+issues

# how do i enable copilot
# https://copilot.github.com/

terraform {
    required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.69.0" # check if newest version is available
    }

}

  backend "azurerm" {
    resource_group_name  = "rg-crc2026-student-201-lab"
    storage_account_name = "jacekstorage2108"
    container_name       = "my-container"
    key                  = "lab06.terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
  }
  resource_provider_registrations = "none"
}
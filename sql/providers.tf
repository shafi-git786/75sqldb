terraform {

  # required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "< 4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  use_oidc                   = true
  skip_provider_registration = true
}
provider "azuread" {
  use_oidc = true
}

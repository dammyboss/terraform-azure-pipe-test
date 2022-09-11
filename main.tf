terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "85c7908d-8028-4894-af5d-1991ee8f0450"
  client_id       = "1b2e5a8a-abe1-415a-9d23-4b868f9d2482"
  client_secret   = "rxC8Q~uJjPMh-oNGeVQGoe4j.UW1eANIr~MiqaGy"
  tenant_id       = "37bb0008-2586-4514-a753-d1092d7259f2"
}

provider "random" {}

resource "random_string" "unique" {
  length  = 2
  lower   = true
  number  = true
  upper   = false
  special = false
}

data "azurerm_resource_group" "rg" {
  name = "bicep"
}

output "id" {
  value = data.azurerm_resource_group.rg.id
}


# resource "azurerm_resource_group" "main" {
#  name     = "${var.prefix}-resources"
#  location = var.location
# }

resource "azurerm_app_service_plan" "main" {
  name                = "${var.prefix}-asp-${random_string.unique.result}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "main" {
  name                = "${var.prefix}-app-${random_string.unique.result}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.main.id

  site_config {
    linux_fx_version = "NODE|14"
  }
}
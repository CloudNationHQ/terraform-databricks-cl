terraform {
  required_version = "~> 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.114"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.51"
    }
  }
}

provider "azurerm" {
  features {}
}


provider "databricks" {
  host = module.dbw.workspace.workspace_url
}

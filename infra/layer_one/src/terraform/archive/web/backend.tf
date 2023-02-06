terraform {
    backend "azurerm" {
      key  = "web.terraform.tfstate"
  }
}
# Terraform is for Create Infrastructure, Update Infrastructure , Replicate the Infrastructure

#Terraform Configurations Files 
-main.tf 
-variables.tf 
-providers.tf 
-dev.tfvars,
-preprod.tfvars,
-prod.tfvars
-output.tf 

#Backend Terraform Files
-State File 

providers.tf 
(Provider configuration file consist of Cloud Provider Declaration like Azure, AWS & backend Remote state file configuration)
terraform {

  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "<storage_account_resource_group>"
    storage_account_name = "<storage_account_name>"
    container_name       = "tfstate"
    key                  = "codelab.microsoft.tfstate"
  }
}

provider "azurerm" {
  features {}
}

main.tf  (It contains the main configuration module of infrastructure.)

# Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}
# Create the Linux App Service Plan
resource "azurerm_app_service_plan" "appserviceplan" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku {
    tier = "Free"
    size = "F1"
  }
}
# Create the web app, pass in the App Service Plan ID

resource "azurerm_app_service" "webapp" {
  name                = var.webapp_service_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id
}
variables.tf 
This helps to declare all the required variables used in main.tf file.


variable "resource_group_name" {
  default       = "webapp-rg"
  description   = "Name of the resource group."
}

variable "resource_group_location" {
  default       = "eastus"
  description   = "Location of the resource group."
}

variable "app_service_plan_name" {
  default       = "webapp-asp"
  description   = "Location of the resource group."
}
 
variable "webapp_service_name" {
  default       = "webapp-demo"
  description   = "Location of the resource group."
}

output.tf 
This helps to extract the Resource detail and display.

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "webapp_service_name" {
    value = azurerm_app_service.webapp.name
}

dev.tfvars
This is used for the defining the variables specific to the environment or service.

resource_group_name ="devops_dev_rg"
resource_group_location="eastus"
app_service_plan_name="asp-webapp"
webapp_service_name="devops-demo-dev"

preprod.tfvars
resource_group_name ="devops_dev_rg"
resource_group_location="eastus"
app_service_plan_name="asp-webapp-prd"
webapp_service_name="devops-demo-dev"

prod.tfvars
resource_group_name ="devops_dev_rg"
resource_group_location="eastus"
app_service_plan_name="name"
webapp_service_name="devops-demo-dev"



Manage Backends
Backend helps to setup the terraform state file. As per best practice we will learn to setup the remote backend using Azure Storage Account.

1. Create Storage Account
2. Create Container and update the providers.tf

 backend "azurerm" {
    resource_group_name  = "<storage_account_resource_group>"
    storage_account_name = "<storage_account_name>"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }


# ---- Content from main.tf ----

provider "azurerm" {
  features {}
  subscription_id = "57480482-27fc-46a6-8643-ee45484365ec"
  resource_provider_registrations = "none"
}

terraform {
  backend "azurerm" {
    resource_group_name   = "tfstaterg"
    storage_account_name  = "autdemotfstate"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "storage" {
  source              = "./modules"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "autdemo-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "sa_diagnostics" {
  name                       = "diag-sa"
  target_resource_id         = module.storage.storage_account_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  log {
    category = "StorageRead"
    enabled  = true

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "StorageWrite"
    enabled  = true

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = false
      days    = 0
    }
  }
}


# ---- Content from monitoring.tf ----

resource "azurerm_log_analytics_workspace" "law" {
  name                = "autdemo-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "storage_diagnostics" {
  name                       = "diag-storage"
  target_resource_id         = module.storage.storage_account_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  log {
    category = "StorageRead"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "function_diagnostics" {
  name                       = "diag-function"
  target_resource_id         = azurerm_linux_function_app.function.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  log {
    category = "FunctionAppLogs"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "app_service_plan_diagnostics" {
  name                       = "diag-app-plan"
  target_resource_id         = azurerm_service_plan.plan.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  log {
    category = "AppServiceConsoleLogs"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  }
}


# ---- Content from variables.tf ----

variable "location" {
  type    = string
  default = "Australia East"
}

variable "resource_group_name" {
  type    = string
  default = "AUT-2025-demo"
}


# ---- Inline module content from modules/st.tf ----

resource "azurerm_storage_account" "storage" {
  name                     = "autdemostorage1234"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "storage_account_key" {
  value = azurerm_storage_account.storage.primary_access_key
}

output "storage_account_id" {
  value = azurerm_storage_account.storage.id
}

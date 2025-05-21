# AUTDEMO2025-2: Azure Function App Deployment

This module deploys the following Azure resources using Terraform:
- App Service Plan
- Function App (Linux)
- Log Analytics Workspace
- Storage Account

## Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5.0
- Azure CLI ([Install Guide](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli))
- Access to an Azure subscription

## Usage
1. Clone this repository and navigate to the `autdemo2025-2` folder.
2. Update `providers.tf` with your Azure subscription and backend state details if needed.
3. Set required variables in a `terraform.tfvars` file or via environment variables.
4. Initialize Terraform:
   ```powershell
   terraform init
   ```
5. Validate the configuration:
   ```powershell
   terraform validate
   ```
6. Plan the deployment:
   ```powershell
   terraform plan
   ```
7. Apply the deployment:
   ```powershell
   terraform apply -auto-approve
   ```

## Security & Best Practices
- Uses Azure Managed Identity for authentication (no credentials in code)
- State is stored securely in Azure Storage
- Follows [Terraform Style Guide](https://developer.hashicorp.com/terraform/language/style)

## References
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Portal](https://portal.azure.com/)

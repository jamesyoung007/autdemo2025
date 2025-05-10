name: Terraform Azure OIDC Deployment

on:
  push:
    branches:
      - main
  workflow_dispatch:

permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Azure Login with OIDC
      uses: azure/login@v1
      with:
        client-id: f13d535c-245d-4da4-819d-c214e657bff7
        tenant-id: 63c1f02b-5eeb-420d-b256-df9c0e96e11e
        subscription-id: 57480482-27fc-46a6-8643-ee45484365ec

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v3
      with:
        terraform_version: 1.6.6

    - name: Terraform Init
      run: terraform init

    - name: Check if Resource Group is already imported
      id: check_rg
      run: |
        if terraform state list | grep -q azurerm_resource_group.rg; then
          echo "rg_imported=true" >> $GITHUB_OUTPUT
        else
          echo "rg_imported=false" >> $GITHUB_OUTPUT
        fi

    - name: Import Resource Group if not already imported
      if: ${{ steps.check_rg.outputs.rg_imported == 'false' }}
      run: |
        terraform import azurerm_resource_group.rg /subscriptions/57480482-27fc-46a6-8643-ee45484365ec/resourceGroups/AUT-2025-demo

    - name: Terraform Plan
      run: terraform plan -out=tfplan

    - name: Terraform Apply
      run: terraform apply -auto-approve tfplan

targetScope='subscription'
param location string
param talosSecrets array

module azureGoatResourceGroup '../../../az-modules/Microsoft.Resources/resourcegroup/deploy.bicep' = {
  name: 'azureGoatResourceGroup'
  params: {
    resourceGroupLocation: 'southeastasia'
    resourceGroupName: 'test-rg'
  }
}
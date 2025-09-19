targetScope='subscription'

param location string
param adminSecrets array
param mainResourceGroup object

// Resource group module
module azureGoatResourceGroup123 '../../../az-modules/Microsoft.Resources/resourcegroup/deploy.bicep' = {
  name: 'azureGoatResourceGroup'
  params: {
    resourceGroupLocation: mainResourceGroup.location
    resourceGroupName: mainResourceGroup.name
  }
}
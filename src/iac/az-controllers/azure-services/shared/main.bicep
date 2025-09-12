targetScope='subscription'

param adminSecrets array
param mainResourceGroup object

// Resource group module
module azureGoatResourceGroup '../../../az-modules/Microsoft.Resources/resourcegroup/deploy.bicep' = {
  name: 'azureGoatResourceGroup'
  params: {
    resourceGroupLocation: mainResourceGroup.location
    resourceGroupName: mainResourceGroup.name
  }
}
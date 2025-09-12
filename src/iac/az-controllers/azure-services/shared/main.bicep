targetScope='subscription'

param mainResourceGroup object
param networking object
param vm object
param cosmosDb object
param storageAccount object
param storageContainers object

param userAssignesdIdentity object
param RoleAssignment object

param userAssignedIdasdentity object
param RoleAssignmenasdt object

param automationAccount object
param automationRunbook object

param appServicePlan object
param functionApp object

// Resource group module
module azureGoatResourceGroup '../../../az-modules/Microsoft.Resources/resourcegroup/deploy.bicep' = {
  name: 'azureGoatResourceGroup'
  params: {
    resourceGroupLocation: mainResourceGroup.location
    resourceGroupName: mainResourceGroup.name
  }
}
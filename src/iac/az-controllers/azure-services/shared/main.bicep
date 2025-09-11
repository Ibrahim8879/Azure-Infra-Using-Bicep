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
module azureGoatResourceGroup '../../az-modules/Microsoft.Resources/resourcegroup/deploy.bicep' = {
  name: 'azureGoatResourceGroup'
  params: {
    resourceGroupLocation: mainResourceGroup.location
    resourceGroupName: mainResourceGroup.name
  }
}

// App Service module
module azureGoatAppService '../../az-modules/Microsoft.Web/appserviceplan/deploy.bicep' = {
  name: 'azureGoatAppService'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    name: appServicePlan.name
    kind: appServicePlan.kind
    sku: appServicePlan.sku
    properties: appServicePlan.properties
  }
  dependsOn: [
    azureGoatResourceGroup
  ]
}

// Frontend Web App
module azureGoatWebApp '../../az-modules/Microsoft.Web/webapp/deploy.bicep' = {
  name: 'azureGoatWebApp'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    appServicePlanId: azureGoatAppService.outputs.appServicePlanId
  }
  dependsOn: [
    azureGoatResourceGroup
    azureGoatAppService
  ]
}

// module sourceControlWebApp '../../az-modules/Microsoft.Web/webapp/sourcecontrols/deploy.bicep' = {
//   name: 'sourceControlWebApp'
//   scope: resourceGroup(mainResourceGroup.name)
//   params: {
//     web: 'web'
//     webApp: 'azuregoat-ibr-webapp'
//   }
//   dependsOn: [
//     azureGoatResourceGroup
//     azureGoatAppService
//     azureGoatWebApp
//   ]
// }

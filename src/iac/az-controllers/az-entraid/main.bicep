targetScope='subscription'

param resourcegroup object
param registrationApp object

// Resource group module
module azureGoatResourceGroup '../../az-modules/Microsoft.Resources/resourcegroup/deploy.bicep' = {
  name: 'azureGoatResourceGroup'
  params: {
    resourceGroupLocation: resourcegroup.location
    resourceGroupName: resourcegroup.name
  }
}

// This have OIDC creation, role assignment etc.
module appRegistrationSetup '../../az-modules/Microsoft.Graph/appregistration/deploy.bicep' = {
  name: 'appRegistrationSetup'
  scope: resourceGroup(resourcegroup.name)
  params: {
    contributorRoleDefinitionId: registrationApp.contributorRoleDefinitionId
    gitHubActionsFederatedIDentitySubject: registrationApp.gitHubActionsFederatedIDentitySubject
  }
}

output AZURE_CLIENT_ID string = appRegistrationSetup.outputs.AZURE_CLIENT_ID
output AZURE_TENANT_ID string = appRegistrationSetup.outputs.AZURE_TENANT_ID
output AZURE_SUBSCRIPTION_ID string = appRegistrationSetup.outputs.AZURE_SUBSCRIPTION_ID

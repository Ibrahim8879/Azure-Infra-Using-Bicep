extension 'br:mcr.microsoft.com/bicep/extensions/microsoftgraph/v1.0:0.2.0-preview'

@description('Contributor role definition ID')
param contributorRoleDefinitionId string

@description('Subject of the Github Action workflow\'s federated identity credentials')
param gitHubActionsFederatedIDentitySubject string

var applicationDisplayName = 'GitHub Actions App'
var applicationName = 'githubActionsApp'
var githubOIDCProvider = 'https://token.actions.githubusercontent.com'
var microsoftEntraAudience = 'api://AzureADTokenExchange'

resource identityGithubActionsApplications 'Microsoft.Graph/applications@v1.0' = {
  displayName: applicationDisplayName
  uniqueName: applicationName

  resource githubFederatedIdentityCredential 'federatedIdentityCredentials@v1.0' = {
    name: '${identityGithubActionsApplications.uniqueName}/githubFederatedIdentityCredential'
    audiences: [
      microsoftEntraAudience
    ]
    issuer: githubOIDCProvider
    subject: gitHubActionsFederatedIDentitySubject
  }
}

resource githubActionsSp 'Microsoft.Graph/servicePrincipals@v1.0' = {
  appId: identityGithubActionsApplications.appId
}

var roleAssignmentName = guid(resourceGroup().id, 'githubactions', contributorRoleDefinitionId)

// Assign the GitHub action service principal the Azure contributor role scoped to a resource group
resource contributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleAssignmentName
  scope: resourceGroup()
  properties: {
    principalId: githubActionsSp.id
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', contributorRoleDefinitionId)
  }
}

output githubActionsSpId string = identityGithubActionsApplications.appId
output AZURE_CLIENT_ID string = identityGithubActionsApplications.appId
output AZURE_TENANT_ID string = subscription().tenantId
output AZURE_SUBSCRIPTION_ID string = subscription().subscriptionId


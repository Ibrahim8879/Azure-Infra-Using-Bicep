
param roleName string
param roleDefinitionId string
param principalId string

resource vmRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(resourceGroup().id, principalId, roleName)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '${roleDefinitionId}') // Contributor
    principalId: principalId
  }
}

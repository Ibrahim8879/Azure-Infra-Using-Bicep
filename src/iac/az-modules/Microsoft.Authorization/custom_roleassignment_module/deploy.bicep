param resourceId string
param principalId string
param roleDefinitionId string

var fullRoleDefId = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  roleDefinitionId
)

resource nested 'Microsoft.Resources/deployments@2021-04-01' = {
  name: 'assignRoleNested'
  properties: {
    mode: 'Incremental'
    template: loadJsonContent('deploy.json')
    parameters: {
      principalId: { value: principalId }
      roleDefinitionId: { value: fullRoleDefId }
      scopeResourceId: { value: resourceId }
    }
  }
}

param location string = resourceGroup().location
param name string
param sku object
param userAssignedIdentityId string

resource automationAccount 'Microsoft.Automation/automationAccounts@2024-10-23' = {
  name: name
  location: location
  identity: {
      type: 'UserAssigned'
      userAssignedIdentities: {
        '${userAssignedIdentityId}': {}
      }
  }
  properties: {
    sku: sku
  }
}


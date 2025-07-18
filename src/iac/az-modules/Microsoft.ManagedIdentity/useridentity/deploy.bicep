param location string = resourceGroup().location
param name string

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2025-01-31-preview' = {
  name: name
  location: location
}

output identityId string = userAssignedIdentity.id

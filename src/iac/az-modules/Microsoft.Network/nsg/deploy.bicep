param name string
param location string = resourceGroup().location
param securityRules array = []

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: name
  location: location
  properties: {
    securityRules: securityRules
  }
}

output nsgId string = nsg.id

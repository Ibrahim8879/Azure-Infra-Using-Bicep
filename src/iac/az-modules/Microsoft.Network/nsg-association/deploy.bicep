param networkSecurityGroupId string
param nicName string

resource nsgAssoc 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: nicName
  properties: {
    networkSecurityGroup: {
      id: networkSecurityGroupId
    }
  }
}

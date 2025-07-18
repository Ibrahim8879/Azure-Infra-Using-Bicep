param location string = resourceGroup().location
param publicIpName string
param domainNameLabel string


resource publicIp 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: publicIpName
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    idleTimeoutInMinutes: 4
    dnsSettings: {
      domainNameLabel: domainNameLabel
    }
  }
  sku: {
    name: 'Basic'
  }
}
output publicIpId string = publicIp.id
output publicIpAddress string = publicIp.properties.ipAddress


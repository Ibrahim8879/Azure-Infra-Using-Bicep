
param location string = resourceGroup().location
param name string
param addressSpace array

resource vnet 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressSpace
    }
  }
}

output vnetId string = vnet.id

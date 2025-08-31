
param name string
param vnetName string
param addressPrefixes array

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${vnetName}/${name}'
  properties: {
    addressPrefixes: addressPrefixes
  }
}

output subnetId string = subnet.id

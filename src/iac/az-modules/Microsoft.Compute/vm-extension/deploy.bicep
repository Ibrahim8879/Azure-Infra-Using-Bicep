param name string
param vmName string
param location string = resourceGroup().location
param properties object

resource extension 'Microsoft.Compute/virtualMachines/extensions@2024-11-01' = {
  name: '${vmName}/${name}'
  location: location
  properties: properties
}

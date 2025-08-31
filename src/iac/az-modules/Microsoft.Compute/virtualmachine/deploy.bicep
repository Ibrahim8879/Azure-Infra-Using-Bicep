param name string
param location string = resourceGroup().location
param nicId string
param vmSize string
param imageReference object
param osDisk object
param oSProfile object

resource vm 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  name: name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: imageReference
      osDisk: osDisk
    }
    osProfile: oSProfile
    networkProfile: {
      networkInterfaces: [
        {
          id: nicId
        }
      ]
    }
  }
}

output vmId string = vm.id

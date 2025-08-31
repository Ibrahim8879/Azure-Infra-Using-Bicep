param name string
param storageAccountName string
param properties object

resource storageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2025-01-01' = {
  name: '${storageAccountName}/default/${name}'
  properties: properties
}

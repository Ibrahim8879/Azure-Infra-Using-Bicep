param storageAccountName string
param storageContainerName string
param sasStart string = utcNow()
var sasEnd = dateTimeAdd(sasStart, 'PT240H')

resource storageAccountBlobContainerSas 'Microsoft.Storage/storageAccounts/blobServices/containers@2025-01-01' existing = {
  name: '${storageAccountName}/default/${storageContainerName}'
}

var sasToken = listServiceSas(resourceId('Microsoft.Storage/storageAccounts', storageAccountName), '2025-01-01', {
  canonicalizedResourceName: '/blob/${storageAccountName}/${storageContainerName}'
  signedStart: sasStart
  signedExpiry: sasEnd
  signedPermission: 'racw'
  signedServices: 'b'
  signedResourceTypes: 'sco'
}).serviceSasToken

// Not Needed as we it will be used to deploy the files on the storage accounts.

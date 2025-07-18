param mainAppName string
param appconfigname string
param storageAccountName string
param storageContainerName string
param sasToken string
param runtime string

resource fnSettings 'Microsoft.Web/sites/config@2022-09-01' = {
  name: '${mainAppName}/${appconfigname}'
  properties: {
    WEBSITE_RUN_FROM_PACKAGE: 'https://${storageAccountName}.blob.core.windows.net/${storageContainerName}/${appconfigname}.zip${sasToken}'
    FUNCTIONS_WORKER_RUNTIME: split(runtime, '|')[0]
  }
}

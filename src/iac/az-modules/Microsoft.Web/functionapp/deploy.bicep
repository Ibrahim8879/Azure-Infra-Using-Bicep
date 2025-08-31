param location string = resourceGroup().location
param name string
param kind string
param appServicePlanId string
param identity string
param storageAccountName string
param storageAccountAccessKey string
param runtime string = 'node'
param extensionVersion string = '~4'
param appSettings array = []

resource functionApp 'Microsoft.Web/sites@2022-09-01' = {
  name: name
  location: location
  kind: kind
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: {
      appSettings: union([
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${storageAccountAccessKey};EndpointSuffix=core.windows.net'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: extensionVersion
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: runtime
        }
      ], appSettings)
    }
    httpsOnly: true
  }
  identity: {
    type: identity
  }
}

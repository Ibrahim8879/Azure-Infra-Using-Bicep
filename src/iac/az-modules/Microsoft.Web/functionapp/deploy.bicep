param location string = resourceGroup().location
param name string
param kind string
param appServicePlanId string
param siteConfig object
param identity string

resource functionApp 'Microsoft.Web/sites@2022-09-01' = {
  name: name
  location: location
  kind: kind
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: siteConfig
    httpsOnly: true
  }
  identity: {
    type: identity
  }
}

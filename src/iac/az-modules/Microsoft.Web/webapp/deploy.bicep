param location string = resourceGroup().location
param webAppName string = 'azuregoat-ibr-webapp'
param appServicePlanId string
param linuxFxVersion string = 'node|20-lts' // Runtime stack of the web app

resource webApp 'Microsoft.Web/sites@2023-12-01' = {
  name: webAppName
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlanId
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: linuxFxVersion
    }
  }
}

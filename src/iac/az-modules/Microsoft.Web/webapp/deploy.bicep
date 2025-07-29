param location string = resourceGroup().location
param webAppName string = 'azuregoat-ibr-webapp'
param appServicePlanId string
param linuxFxVersion string = 'DOTNETCORE|6.0' // Runtime stack of the web app

resource webApp 'Microsoft.Web/sites@2023-12-01' = {
  name: webAppName
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: {
      linuxFxVersion: linuxFxVersion
    }
  }
}

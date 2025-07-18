param location string = resourceGroup().location
param name string
param kind string
param sku object
param properties object


resource appServicePlan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: name
  location: location
  kind: kind
  sku: sku
  properties: properties
}

output appServicePlanId string = appServicePlan.id

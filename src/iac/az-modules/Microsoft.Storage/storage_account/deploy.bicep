param location string = resourceGroup().location
param name string
param sku object
param kind string
param allowBlobPublicAccess bool
param accessTier string

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: name
  location: location
  sku: sku
  kind: kind  
  properties: {
    allowBlobPublicAccess: allowBlobPublicAccess
    accessTier: accessTier
  }
}

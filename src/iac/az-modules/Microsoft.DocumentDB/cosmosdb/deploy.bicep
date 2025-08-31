param location string = resourceGroup().location
param name string
param kind string
param databaseaccountOfferType string
param capabilities array

resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2025-05-01-preview' = {
  name: name
  location: location
  kind: kind
  properties: {
    databaseAccountOfferType: databaseaccountOfferType
    consistencyPolicy: {
      defaultConsistencyLevel: 'BoundedStaleness'
      maxIntervalInSeconds: 300
      maxStalenessPrefix: 100000
    }
    locations: [
      {
        locationName: location
        failoverPriority: 0
      }
    ]
    capabilities: capabilities
  }
}

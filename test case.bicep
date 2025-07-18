param resource_group string = 'azuregoat_app'
param location string = 'eastus'

// Random ID generation - Bicep doesn't have direct equivalent, using uniqueString
var randomId = uniqueString(resourceGroup().id)

// Cosmos DB Account
resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2021-10-15' = {
  name: 'ine-cosmos-db-data-${randomId}'
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'BoundedStaleness'
      maxIntervalInSeconds: 300
      maxStalenessPrefix: 100000
    }
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    databaseAccountOfferType: 'Standard'
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
  }
}

// Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: 'appazgoat${randomId}storage'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: true
    cors: {
      corsRules: [
        {
          allowedOrigins: ['*']
          allowedMethods: ['GET', 'HEAD', 'POST', 'PUT']
          allowedHeaders: ['*']
          exposedHeaders: ['*']
          maxAgeInSeconds: 3600
        }
      ]
    }
  }
}

// Storage Containers
resource storageContainerProd 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  name: 'default/prod-appazgoat${randomId}-storage-container'
  properties: {
    publicAccess: 'Blob'
  }
  dependsOn: [
    storageAccount
  ]
}

resource storageContainerDev 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  name: 'default/dev-appazgoat${randomId}-storage-container'
  properties: {
    publicAccess: 'Container'
  }
  dependsOn: [
    storageAccount
  ]
}

resource storageContainerVm 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-09-01' = {
  name: 'default/vm-appazgoat${randomId}-storage-container'
  properties: {
    publicAccess: 'Container'
  }
  dependsOn: [
    storageAccount
  ]
}

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: 'appazgoat${randomId}-app-service-plan'
  location: location
  kind: 'linux'
  properties: {
    reserved: true
  }
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
}

// Function App
resource functionApp 'Microsoft.Web/sites@2021-03-01' = {
  name: 'appazgoat${randomId}-function'
  location: location
  kind: 'functionapp,linux'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'python|3.9'
      use32BitWorkerProcess: false
      cors: {
        allowedOrigins: ['*']
      }
      appSettings: [
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'python'
        }
        {
          name: 'JWT_SECRET'
          value: 'T2BYL6#]zc>Byuzu'
        }
        {
          name: 'AZ_DB_ENDPOINT'
          value: cosmosDbAccount.properties.documentEndpoint
        }
        {
          name: 'AZ_DB_PRIMARYKEY'
          value: listKeys(cosmosDbAccount.id, cosmosDbAccount.apiVersion).primaryMasterKey
        }
        {
          name: 'CON_STR'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'CONTAINER_NAME'
          value: storageContainerProd.name.split('/')[2]
        }
      ]
    }
    httpsOnly: true
  }
  identity: {
    type: 'SystemAssigned'
  }
  dependsOn: [
    appServicePlan
    storageAccount
    cosmosDbAccount
  ]
}

// Network Security Group
resource netSg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'SecGroupNet${randomId}'
  location: location
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
    ]
  }
}

// Virtual Network
resource vNet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'vNet${randomId}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'Subnet${randomId}'
        properties: {
          addressPrefix: '10.1.0.0/24'
        }
      }
    ]
  }
}

// Public IP
resource vmPublicIP 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: 'developerVMPublicIP${randomId}'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    idleTimeoutInMinutes: 4
    dnsSettings: {
      domainNameLabel: 'developervm-${toLower(randomId)}'
    }
  }
  sku: {
    name: 'Basic'
  }
}

// Network Interface
resource netInt 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: 'developerVMNetInt'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: '${vNet.id}/subnets/Subnet${randomId}'
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: vmPublicIP.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: netSg.id
    }
  }
  dependsOn: [
    vNet
    vmPublicIP
    netSg
  ]
}

// Virtual Machine
resource devVm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: 'developerVM${randomId}'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        name: 'developerVMDisk'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
        deleteOption: 'Delete'
      }
    }
    osProfile: {
      computerName: 'developerVM'
      adminUsername: 'azureuser'
      adminPassword: 'St0r95p@$sw0rd@1265463541'
      linuxConfiguration: {
        disablePasswordAuthentication: false
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: netInt.id
        }
      ]
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
  dependsOn: [
    netInt
  ]
}

// VM Extension
resource vmExtension 'Microsoft.Compute/virtualMachines/extensions@2021-11-01' = {
  name: '${devVm.name}/vm-extension'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.0'
    autoUpgradeMinorVersion: true
    settings: {
      script: base64(loadTextContent('modules/module-1/resources/vm/config.sh'))
    }
  }
  dependsOn: [
    devVm
    storageContainerProd
  ]
}

// Role Assignments
resource vmRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(resourceGroup().id, devVm.id, 'Contributor')
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c') // Contributor
    principalId: devVm.identity.principalId
    scope: resourceGroup().id
  }
}

// User Assigned Identity
resource userId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'user-assigned-id${randomId}'
  location: location
}

resource identityRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(resourceGroup().id, userId.id, 'Owner')
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635') // Owner
    principalId: userId.properties.principalId
    scope: resourceGroup().id
  }
  dependsOn: [
    userId
  ]
}

// Automation Account
resource automationAccount 'Microsoft.Automation/automationAccounts@2021-06-22' = {
  name: 'dev-automation-account-appazgoat${randomId}'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userId.id}': {}
    }
  }
  properties: {
    sku: {
      name: 'Basic'
    }
  }
  tags: {
    environment: 'development'
  }
}

// Automation Runbook
resource automationRunbook 'Microsoft.Automation/automationAccounts/runbooks@2021-06-22' = {
  name: '${automationAccount.name}/Get-AzureVM'
  location: location
  properties: {
    runbookType: 'PowerShellWorkflow'
    logProgress: true
    logVerbose: true
    description: 'This is an example runbook'
    publishContentLink: {
      contentHash: {
        algorithm: 'sha256'
        value: '' // Would need to calculate this
      }
      uri: '' // Would need to provide URI to script
    }
  }
  dependsOn: [
    automationAccount
  ]
}

// Frontend Function App
resource functionAppFront 'Microsoft.Web/sites@2021-03-01' = {
  name: 'appazgoat${randomId}-function-app'
  location: location
  kind: 'functionapp,linux'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'node|12'
      use32BitWorkerProcess: false
      appSettings: [
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'AzureWebJobsDisableHomepage'
          value: 'true'
        }
      ]
    }
    httpsOnly: true
  }
  dependsOn: [
    appServicePlan
    storageAccount
  ]
}

output targetUrl string = 'https://${functionAppFront.properties.defaultHostName}'

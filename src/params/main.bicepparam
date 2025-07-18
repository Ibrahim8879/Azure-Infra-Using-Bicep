using './../iac/az-controllers/az-services/main.bicep'

param mainResourceGroup = {
  location: 'southeastasia'
  name: 'azureGoatRG'
}

param networking = {
  vnet: {
    name: 'azureGoatVnet'
    addressSpace:[
  '10.1.0.0/16'
    ]
  }
  subnet: {
    name: 'azureGoatSubnet'
    addressPrefixes: [
      '10.1.0.0/24'
    ]
  }
  publicIp: {
    name: 'azureGoatPublicIp'
    domainNameLabel: 'azuregoatpublicip'
  }
  nic: {
    name: 'azureGoatNic'
    ipConfigName: 'azureGoatIpConfig1'
  }
  nsg: {
    name: 'azureGoatNsg'
    securityRules: [
      {
        name: 'AllowSSH'
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

param vm = {
  name: 'azureGoatVM'
  vmsize: 'Standard_B1s'
  imageref: {
    publisher: 'Canonical'
    offer: 'UbuntuServer'
    sku: '18.04-LTS'
    version: 'latest'
  }
  osDisk: {
    name: 'developerVMDisk'
    caching: 'ReadWrite'
    createOption: 'FromImage'
    managedDisk: {
      storageAccountType: 'Standard_LRS'
    }
    deleteOption: 'Delete'

  }
  osProfile: {
      computerName: 'azureGoatVM'
      adminUsername: 'azureuser'
      adminPassword: 'St0r95p@$sw0rd@1265463541'
      linuxConfiguration: {
        disablePasswordAuthentication: false
      }
  }
  extensions: [
    {
      name: 'azureGoatVMExtension'
      properties: {
        publisher: 'Microsoft.Azure.Extensions'
        type: 'CustomScript'
        typeHandlerVersion: '2.0'
        autoUpgradeMinorVersion: true
        settings: {
          script: 'https://raw.githubusercontent.com/Azure/AzureGoat/main/scripts/azuregoat.sh'
        }
      }
    }
  ]
}

param cosmosDb = {
  name: 'azureGoatCosmosDb'
  kind: 'GlobalDocumentDB'
  databaseaccountOfferType: 'Standard'
  capabilities: [
    {
      name: 'EnableServerless'
    }
  ]
}

param storageAccount = {
  name: 'azuregoatstorageaccountforallpurpose'
  sku: {
    name:'Standard_LRS'
  }
  kind: 'StorageV2'
  accessTier: 'Hot'
  allowBlobPublicAccess: true
}

param storageContainers = {
  appcontainer: {
    name: 'appazuregoatcontainer'
    properties: {
      publicAccess: 'Blob'
    }
  }
  prodcontainer: {
    name: 'prod-appazuregoatcontainer'
    properties: {
      publicAccess: 'Blob'
    }
  }
  devcontainer: {
    name: 'dev-appazuregoatcontainer'
    properties: {
      publicAccess: 'Container'
    }
  }
  vmcontainer: {
    name: 'vm-appazuregoatcontainer'
    properties: {
      publicAccess: 'Container'
    }
  }
}

param userAssignedIdentity = {
  name: 'azureGoatUserAssignedIdentity'
}

param RoleAssignment = {
  vm: {
    roleName: 'Contributor'
    roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c' // Contributor
  }
  userAssignedIdentity: {
    roleName: 'Owner'
    roleDefinitionId: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635' // Owner
  }
}

param automationAccount = {
  name: 'dev-automation-account-appazgoat'
  sku: {
      name: 'Basic'
  }
}

param automationRunbook = {
  name: 'Get-AzureVM'
  properties: {
    runbookType: 'PowerShellWorkflow'
    logVerbose: true
    logProgress: true
    description: 'Runbook to get Azure VM details'
    runbookContent: ''
  }
}

param appServicePlan = {
  name: 'appazgoat-app-service-plan'
  kind: 'FunctionApp'
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {
    reserved: true
  }
}

param functionApp = {
  frontend: {
    name: 'appazgoat-function-app'
    kind: 'functionapp,linux'
    identity: 'SystemAssigned'
    siteConfig: {
      linuxFxVersion: 'python|3.9'
      use32BitWorkerProcess: false
      cors: {
        allowedOrigins: ['*']
      }
    }
    appconfig: {
      appName: 'appsettings'
      runtime: 'python|3.9'
    }
  }
  backend: {
    name: 'appazgoat-function-app'
    kind: 'functionapp,linux'
    identity: null
    siteConfig: {
      linuxFxVersion: 'node|12'
      use32BitWorkerProcess: false
    }
    appconfig: {
      appName: 'appsettings'
      runtime: 'node|12'
    }
  }
}



targetScope='subscription'

param mainResourceGroup object
param networking object
param vm object
param cosmosDb object
param storageAccount object
param storageContainers object

param userAssignedIdentity object
param RoleAssignment object

param automationAccount object
param automationRunbook object

param appServicePlan object
param functionApp object

// Resource group module
module azureGoatResourceGroup './../../../iac/az-modules/Microsoft.Resources/resourcegroup/deploy.bicep' = {
  name: 'azureGoatResourceGroup'
  params: {
    resourceGroupLocation: mainResourceGroup.location
    resourceGroupName: mainResourceGroup.name
  }
}

// Network modules
module azureGoatVnet './../../../iac/az-modules/Microsoft.Network/vnet/deploy.bicep' = {
  name: 'azureGoatVnet'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    name: networking.vnet.name
    addressSpace: networking.vnet.addressSpace
  }
  dependsOn: [
    azureGoatResourceGroup
  ]
}
module azureGoatSubnet './../../../iac/az-modules/Microsoft.Network/subnets/deploy.bicep' = {
  name: 'azureGoatSubnet'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    name: networking.subnet.name
    vnetName: networking.vnet.name
    addressPrefixes: networking.subnet.addressPrefixes
  }
  dependsOn: [
    azureGoatResourceGroup
    azureGoatVnet
  ]
}
module azureGoatPublicIp './../../../iac/az-modules/Microsoft.Network/publicip/deploy.bicep' = {
  name: 'azureGoatPublicIp'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    publicIpName: networking.publicIp.name
    domainNameLabel: networking.publicIp.domainNameLabel
  }
  dependsOn: [
    azureGoatResourceGroup
  ]
}
module azureGoatNetworkSecurityGroup './../../../iac/az-modules/Microsoft.Network/nsg/deploy.bicep' = {
  name: 'azureGoatNetworkSecurityGroup'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    name: networking.networkSecurityGroup.name
    securityRules: networking.networkSecurityGroup.rules
  }
  dependsOn: [
    azureGoatResourceGroup
  ]
}
module azureGoatNetworkInterface './../../../iac/az-modules/Microsoft.Network/nic/deploy.bicep' = {
  name: 'azureGoatNetworkInterface'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    nicName: networking.nic.name
    ipConfigName: networking.nic.ipConfigName
    subnetId: azureGoatSubnet.outputs.subnetId
    publicIpId: azureGoatPublicIp.outputs.publicIpId
  }
  dependsOn: [
    azureGoatResourceGroup
  ]
}
module azureGoatNetworkInterfaceAssocciatingNsg './../../../iac/az-modules/Microsoft.Network/nsg-association/deploy.bicep' = {
  name: 'azureGoatNetworkInterfaceAssocciatingNsg'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    nicName: networking.nicWithNsg.name
    networkSecurityGroupId: azureGoatNetworkSecurityGroup.outputs.nsgId
  }
  dependsOn: [
    azureGoatResourceGroup
    azureGoatNetworkInterface
  ]
}

// Virtual Machine modules
module azureGoatVirtualMachine './../../../iac/az-modules/Microsoft.Compute/virtualmachine/deploy.bicep' = {
  name: 'azureGoatVirtualMachine'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    name: vm.name
    vmSize: vm.vmSize
    imageReference: vm.imageReference
    osDisk: vm.osDisk
    oSProfile: vm.oSProfile
    nicId: azureGoatNetworkInterface.outputs.nicId
  }
  dependsOn: [
    azureGoatResourceGroup
    azureGoatNetworkInterface
    azureGoatNetworkInterfaceAssocciatingNsg
  ]
}
// Virtual Machine Extension modules
module azureGoatVirtualMachineExtension './../../../iac/az-modules/Microsoft.Compute/vm-extension/deploy.bicep' = {
  name: 'azureGoatVirtualMachineExtension'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    vmName: vm.name
    name: vm.extension.name
    properties: vm.extension.properties
  }
  dependsOn: [
    azureGoatVirtualMachine
  ]
}

// Cosmos DB module
module azureGoatCosmosDb './../../../iac/az-modules/Microsoft.DocumentDB/cosmosdb/deploy.bicep' = {
  name: 'azureGoatCosmosDb'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    name: cosmosDb.name
    kind: cosmosDb.kind
    databaseaccountOfferType: cosmosDb.databaseaccountOfferType
    capabilities: cosmosDb.capabilities
  }
  dependsOn: [
    azureGoatResourceGroup
  ]
}

// Storage Account module
module azureGoatStorageAccount './../../../iac/az-modules/Microsoft.Storage/storage_account/deploy.bicep' = {
  name: 'azureGoatStorageAccount'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    name: storageAccount.name
    sku: storageAccount.sku
    kind: storageAccount.kind
    allowBlobPublicAccess: storageAccount.allowBlobPublicAccess
    accessTier: storageAccount.accessTier
  }
  dependsOn: [
    azureGoatResourceGroup
  ]
}
// Under this account we will have 4 containers.
module azureGoatStorageContainerapp './../../../iac/az-modules/Microsoft.Storage/container/deploy.bicep' = {
  name: 'azureGoatStorageContainerapp'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    name: storageContainers.appcontainer.name
    storageAccountName: storageAccount.name
    properties: storageContainers.appcontainer.properties
  }
  dependsOn: [
    azureGoatResourceGroup
    azureGoatStorageAccount
  ]
}
module azureGoatStorageContainerprod './../../../iac/az-modules/Microsoft.Storage/container/deploy.bicep' = {
  name: 'azureGoatStorageContainerprod'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    name: storageContainers.prodcontainer.name
    storageAccountName: storageAccount.name
    properties: storageContainers.prodcontainer.properties
  }
  dependsOn: [
    azureGoatResourceGroup
    azureGoatStorageAccount
  ]
}
module azureGoatStorageContainerdev './../../../iac/az-modules/Microsoft.Storage/container/deploy.bicep' = {
  name: 'azureGoatStorageContainerdev'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    name: storageContainers.devcontainer.name
    storageAccountName: storageAccount.name
    properties: storageContainers.devcontainer.properties
  }
  dependsOn: [
    azureGoatResourceGroup
    azureGoatStorageAccount
  ]
}
module azureGoatStorageContainervm './../../../iac/az-modules/Microsoft.Storage/container/deploy.bicep' = {
  name: 'azureGoatStorageContainervm'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    name: storageContainers.vmcontainer.name
    storageAccountName: storageAccount.name
    properties: storageContainers.vmcontainer.properties
  }
  dependsOn: [
    azureGoatResourceGroup
    azureGoatStorageAccount
  ]
}


// Managed Identity module
module azureGoatUserAssignedIdentity './../../../iac/az-modules/Microsoft.ManagedIdentity/useridentity/deploy.bicep' = {
  name: 'azureGoatUserAssignedIdentity'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    name: userAssignedIdentity.name
  }
  dependsOn: [
    azureGoatResourceGroup
  ]
}

// Role Assignment module (Add the Proper Resource ID's on it)
module azureGoatRoleAssignmentVM '../../az-modules/Microsoft.Authorization/custom_roleassignment_module/deploy.bicep' = {
  name: 'azureGoatRoleAssignmentVM'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    resourceId: azureGoatVirtualMachine.outputs.vmId
    roleDefinitionId: RoleAssignment.vm.roleDefinitionId
    principalId: azureGoatVirtualMachine.outputs.vmId
  }
  dependsOn: [
    azureGoatResourceGroup
  ]
}
module azureGoatRoleAssignmentUserAssignedIdentity '../../az-modules/Microsoft.Authorization/custom_roleassignment_module/deploy.bicep' = {
  name: 'azureGoatRoleAssignmentUserAssignedIdentity'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    resourceId: azureGoatVirtualMachine.outputs.vmId
    roleDefinitionId: RoleAssignment.userAssignedIdentity.roleDefinitionId
    principalId: azureGoatVirtualMachine.outputs.vmId
  }
  dependsOn: [
    azureGoatResourceGroup
  ]
}

// Automation Account module
module azureGoatAutomationAccount './../../../iac/az-modules/Microsoft.Automation/automationaccount/deploy.bicep' = {
  name: 'azureGoatAutomationAccount'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    name: automationAccount.name
    sku: automationAccount.sku
    userAssignedIdentityId: azureGoatUserAssignedIdentity.outputs.identityId
  }
  dependsOn: [
    azureGoatResourceGroup
    azureGoatUserAssignedIdentity
  ]
}

// Automation Runbook module
module azureGoatAutomationRunbook './../../../iac/az-modules/Microsoft.Automation/automationrunbook/deploy.bicep' = {
  name: 'azureGoatAutomationRunbook'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    name: automationRunbook.name
    automationAccountName: automationAccount.name
    properties: automationRunbook.properties
  }
  dependsOn: [
    azureGoatResourceGroup
    azureGoatAutomationAccount
  ]
}


// App Service module
module azureGoatAppService './../../../iac/az-modules/Microsoft.Web/appserviceplan/deploy.bicep' = {
  name: 'azureGoatAppService'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    name: appServicePlan.name
    kind: appServicePlan.kind
    sku: appServicePlan.sku
    properties: appServicePlan.properties
  }
  dependsOn: [
    azureGoatAutomationAccount
  ]
}

// Frontend Function App module
module azureGoatFunctionAppFront './../../../iac/az-modules/Microsoft.Web/functionapp/deploy.bicep' = {
  name: 'azureGoatFunctionAppFront'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    name: functionApp.frontend.name
    kind: functionApp.frontend.kind
    appServicePlanId: azureGoatAppService.outputs.appServicePlanId
    siteConfig: functionApp.frontend.siteConfig
    identity: functionApp.frontend.identity
  }
  dependsOn: [
    azureGoatResourceGroup
    azureGoatAppService
  ]
}


// Backend Function App module
module azureGoatFunctionAppBack './../../../iac/az-modules/Microsoft.Web/functionapp/deploy.bicep' = {
  name: 'azureGoatFunctionAppBack'
  scope: resourceGroup(mainResourceGroup.name)
  params: {
    name: functionApp.backend.name
    kind: functionApp.backend.kind
    appServicePlanId: azureGoatAppService.outputs.appServicePlanId
    siteConfig: functionApp.backend.siteConfig
    identity: functionApp.backend.identity
  }
  dependsOn: [
    azureGoatResourceGroup
    azureGoatAppService
  ]
}

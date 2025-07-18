param location string = resourceGroup().location
param automationAccountName string
param name string
param properties object

resource automationRunbook 'Microsoft.Automation/automationAccounts/runbooks@2024-10-23' = {
  name: '${automationAccountName}/${name}'
  location: location
  properties: properties
}

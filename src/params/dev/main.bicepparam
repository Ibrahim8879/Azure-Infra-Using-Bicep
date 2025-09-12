using '../../iac/az-controllers/azure-services/shared/main.bicep'

param adminSecrets = []
param location = 'southcentralus'
param mainResourceGroup = {
  location: 'southeastasia'
  name: 'azureGoatRG'
}

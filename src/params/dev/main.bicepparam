using '../../iac/az-controllers/azure-services/shared/main.bicep'

param adminSecrets = []

param mainResourceGroup = {
  location: 'southeastasia'
  name: 'azureGoatRG'
}

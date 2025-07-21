using '../../iac/az-controllers/az-entraid/main.bicep'

param resourcegroup = {
  location:'southeastasia'
  name:'oidcResourceGroup'
}

param registrationApp = {
  contributorRoleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  gitHubActionsFederatedIDentitySubject: 'repo:Ibrahim8879/AzureGoat-Infra-Using-Bicep:ref:refs/heads/main'
}

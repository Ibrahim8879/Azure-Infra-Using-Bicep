using '../../iac/az-controllers/az-entraid/main.bicep'

param resourcegroup = {
  location: 'southeastasia'
  name: 'azureGoatRG'
}

param registrationApp = {
  contributorRoleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c' // Role = Contributor
  gitHubActionsFederatedIDentitySubject: 'repo:Ibrahim8879/dotnetcore-docs-hello-world:ref:refs/heads/main'
}

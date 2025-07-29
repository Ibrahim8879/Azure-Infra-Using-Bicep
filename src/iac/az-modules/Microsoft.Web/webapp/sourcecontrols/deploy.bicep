param webApp string
param web string
param repositoryUrl string = 'https://github.com/Ibrahim8879/dotnetcore-docs-hello-world'
param branch string = 'main'

resource srcControls 'Microsoft.Web/sites/sourcecontrols@2023-12-01' = {
  name: '${webApp}/web'
  properties: {
    repoUrl: repositoryUrl
    branch: branch
    isGitHubAction: true
  }
}

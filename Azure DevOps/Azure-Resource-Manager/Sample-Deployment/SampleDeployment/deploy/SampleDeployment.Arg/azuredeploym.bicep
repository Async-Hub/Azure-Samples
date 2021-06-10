@description('Name of container group.')
param nameSuffix string = 'sd'

var rgLocation = resourceGroup().location
var containerRegistryName = 'acrsampledeployment${nameSuffix}'
var containerGroupName = 'acg-sample-deployment${nameSuffix}'
var storageAccountName = 'stsampledeployment${nameSuffix}'
var applicationInsightsName = 'appi-sample-deployment${nameSuffix}'
var webClientContainerName = 'webapplication'
var apiContainerName = 'functionapp'
var containerHostAddress = '${containerGroupName}.${rgLocation}.azurecontainer.io'

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  location: rgLocation
}

resource applicationInsights 'microsoft.insights/components@2020-02-02-preview' = {
  name: applicationInsightsName
  location: rgLocation
  kind: 'web'
  properties: {
    Application_Type: 'web'
    DisableIpMasking: true
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2019-12-01-preview' = {
  name: containerRegistryName
  location: rgLocation
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2019-12-01' = {
  name: containerGroupName
  location: rgLocation
  properties: {
    containers: [
      {
        name: webClientContainerName
        properties: {
          image: '${containerRegistryName}.azurecr.io/${webClientContainerName}:latest'
          resources: {
            requests: {
              cpu: '0.5'
              memoryInGB: 2
            }
          }
          ports: [
            {
              port: 8081
            }
          ]
          environmentVariables: [
            {
              name: 'ASPNETCORE_HTTPS_PORT'
              value: '8081'
            }
            {
              name: 'API_SERVER_URL'
              value: 'http://${containerHostAddress}:8082'
            }
            {
              name: 'APP_INSTRUMENTATION_KEY'
              value: applicationInsights.properties.InstrumentationKey
            }
          ]
        }
      }
      {
        name: apiContainerName
        properties: {
          image: '${containerRegistryName}.azurecr.io/${apiContainerName}:latest'
          resources: {
            requests: {
              cpu: '0.5'
              memoryInGB: 2
            }
          }
          ports: [
            {
              port: 8082
            }
          ]
          environmentVariables: [
            {
              name: 'WEBSITE_HOSTNAME'
              value: containerHostAddress
            }
            {
              name: 'AzureWebJobsStorage'
              value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${listKeys(resourceId(resourceGroup().name, 'Microsoft.Storage/storageAccounts', storageAccountName), '2019-04-01').keys[0].value};EndpointSuffix=core.windows.net'
            }
            {
              name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
              value: applicationInsights.properties.InstrumentationKey
            }
          ]
        }
      }
    ]
    imageRegistryCredentials: [
      {
        server: containerRegistry.properties.loginServer
        username: listCredentials(containerRegistryName, '2019-12-01-preview').username
        password: listCredentials(containerRegistryName, '2019-12-01-preview').passwords[0].value
      }
    ]
    osType: 'Linux'
    ipAddress: {
      type: 'Public'
      dnsNameLabel: containerGroupName
      ports: [
        {
          protocol: 'TCP'
          port: 8081
        }
        {
          protocol: 'TCP'
          port: 8082
        }
      ]
    }
  }
}

output fullReferenceOutput object = reference(containerRegistryName, '2019-12-01-preview', 'Full').properties

@description('Name of container group.')
param nameSuffix string = 'sd'

var containerRegistryName_var = 'acrsampledeployment${nameSuffix}'
var containerGroupName_var = 'acg-sample-deployment${nameSuffix}'
var storageAccountName_var = 'stsampledeployment${nameSuffix}'
var applicationInsightsName_var = 'appi-sample-deployment${nameSuffix}'
var webClientContainerName = 'webapplication'
var apiContainerName = 'functionapp'
var containerHostAddress = '${containerGroupName_var}.${resourceGroup().location}.azurecontainer.io'

resource storageAccountName 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName_var
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  location: resourceGroup().location
}

resource applicationInsightsName 'microsoft.insights/components@2020-02-02-preview' = {
  name: applicationInsightsName_var
  location: resourceGroup().location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    DisableIpMasking: true
    Flow_Type: 'Redfield'
    Request_Source: 'IbizaAIExtension'
    RetentionInDays: 90
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource containerRegistryName 'Microsoft.ContainerRegistry/registries@2019-12-01-preview' = {
  name: containerRegistryName_var
  location: resourceGroup().location
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  properties: {
    adminUserEnabled: 'true'
  }
}

resource containerGroupName 'Microsoft.ContainerInstance/containerGroups@2019-12-01' = {
  name: containerGroupName_var
  location: resourceGroup().location
  properties: {
    containers: [
      {
        name: webClientContainerName
        properties: {
          image: '${containerRegistryName_var}.azurecr.io/${webClientContainerName}:latest'
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
              value: reference('microsoft.insights/components/${applicationInsightsName_var}', '2020-02-02-preview').InstrumentationKey
            }
          ]
        }
      }
      {
        name: apiContainerName
        properties: {
          image: '${containerRegistryName_var}.azurecr.io/${apiContainerName}:latest'
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
              value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName_var};AccountKey=${listKeys(resourceId(resourceGroup().name, 'Microsoft.Storage/storageAccounts', storageAccountName_var), '2019-04-01').keys[0].value};EndpointSuffix=core.windows.net'
            }
            {
              name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
              value: reference('microsoft.insights/components/${applicationInsightsName_var}', '2020-02-02-preview').InstrumentationKey
            }
          ]
        }
      }
    ]
    imageRegistryCredentials: [
      {
        server: reference(containerRegistryName_var, '2019-12-01-preview', 'Full').properties.loginServer
        username: listCredentials(containerRegistryName_var, '2019-12-01-preview').username
        password: listCredentials(containerRegistryName_var, '2019-12-01-preview').passwords[0].value
      }
    ]
    osType: 'Linux'
    ipAddress: {
      type: 'Public'
      dnsNameLabel: containerGroupName_var
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
  dependsOn: [
    storageAccountName
    applicationInsightsName
    containerRegistryName
  ]
}

output fullReferenceOutput object = reference(containerRegistryName_var, '2019-12-01-preview', 'Full').properties
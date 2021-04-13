# Input bindings are passed in via param block.
param([Hashtable] $QueueItem, $TriggerMetadata)

# Write out the queue message and insertion time to the information log.
Write-Host "PowerShell queue trigger function processed work item: $QueueItem"
Write-Host "Queue item insertion time: $($TriggerMetadata.InsertionTime)"

$environmentVariable = @{}
$environmentVariable["AZP_URL"] = 'https://dev.azure.com/xxx-samples' #$QueueItem["planUri"]
$environmentVariable["AZP_TOKEN"] = $queueItem["agentPersonalAccessToken"]
$environmentVariable["AZP_POOL"] = 'OnDemandBuildAgents'
$environmentVariable["AZP_AGENT_NAME"] = $queueItem["containerName"]

$password = ConvertTo-SecureString 'kJ1PZdrvOLUAlXSJ2=V7djyby5Rq6LTg' -AsPlainText -Force
$registryCredential = New-Object System.Management.Automation.PSCredential('xxx', $password)
New-AzContainerGroup -ResourceGroupName "rg-on-demand-build-agents" `
    -Name $queueItem["containerName"] -OsType Linux -Image xxx.azurecr.io/azure-devops/agent/dotnet/sdk:5.0 -Cpu 3 -MemoryInGB 3 `
    -RegistryCredential $registryCredential -EnvironmentVariable $environmentVariable -IpAddressType Public -RestartPolicy Never

#Write-Host "Azure Containe Group created. Name: " $containerGroup.Name

# https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/utility/azure-function?view=azure-devops#where-should-a-task-signal-completion-when-callback-is-chosen-as-the-completion-event
$uri = "$($QueueItem["planUri"])$($QueueItem["projectId"])/_apis/distributedtask/hubs/$($QueueItem["hubName"])/plans/$($QueueItem["planId"])/events?api-version=2.0-preview.1"
Write-Host "Azure DevOps Uri: " $uri

$authorizationHeaderValue = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($QueueItem["authToken"])"))

# Create a WebClient
$webclient = New-Object System.Net.WebClient
$webclient.Headers["Authorization"] = $authorizationHeaderValue
$webclient.Headers["Content-Type"] = "application/json"

$params = "{ `"name`" : `"TaskCompleted`", `"taskId`" : `"$($QueueItem["taskId"])`", `"jobId`" : `"$($QueueItem["jobId"])`", `"result`" : `"succeeded`" }"

Write-Host "AuthorizationHeaderValue" $authorizationHeaderValue
Write-Host "$$params" $params

$webclient.UploadString($uri, $params)

Write-Host "Completion event sent to Azure DevOps Uri."
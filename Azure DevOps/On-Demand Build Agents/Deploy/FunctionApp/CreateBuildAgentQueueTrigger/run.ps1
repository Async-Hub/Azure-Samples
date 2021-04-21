# Input bindings are passed in via param block.
param([Hashtable] $QueueItem, $TriggerMetadata)

# Write out the queue message and insertion time to the information log.
Write-Host "PowerShell queue trigger function processed work item: $QueueItem"
Write-Host "Queue item insertion time: $($TriggerMetadata.InsertionTime)"

# https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/utility/azure-function?view=azure-devops#where-should-a-task-signal-completion-when-callback-is-chosen-as-the-completion-event
$uri = "$($QueueItem["planUri"])$($QueueItem["projectId"])/_apis/distributedtask/hubs/$($QueueItem["hubName"])/plans/$($QueueItem["planId"])/events?api-version=2.0-preview.1"
Write-Host "Azure DevOps Uri: " $uri
$authorizationHeaderValue = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($QueueItem["authToken"])"))
$params = "{ `"name`" : `"TaskCompleted`", `"taskId`" : `"$($QueueItem["taskId"])`", `"jobId`" : `"$($QueueItem["jobId"])`", `"result`" : `"succeeded`" }"

Write-Host "AuthorizationHeaderValue" $authorizationHeaderValue
Write-Host "$$params" $params

$environmentVariable = @{}
$environmentVariable["AZP_URL"] = 'https://dev.azure.com/xxx-samples' #$QueueItem["planUri"]
$environmentVariable["AZP_TOKEN"] = $queueItem["agentPersonalAccessToken"]
$environmentVariable["AZP_POOL"] = 'OnDemandBuildAgents'
$environmentVariable["AZP_AGENT_NAME"] = $queueItem["containerName"]
$environmentVariable["AZP_AGENT_COMPLETION_SIGNAL_URL"] = $uri
$environmentVariable["AZP_AGENT_COMPLETION_SIGNAL_AUTH_HEADER"] = $authorizationHeaderValue
$environmentVariable["AZP_AGENT_COMPLETION_SIGNAL_REQ_BODY"] = $params

$password = ConvertTo-SecureString 'KAaUZSE3Pe/EKwJRE8rh87KWy8XZEOxc' -AsPlainText -Force
$registryCredential = New-Object System.Management.Automation.PSCredential('acrondemagents', $password)
$containerGroup = New-AzContainerGroup -ResourceGroupName "rg-on-demand-build-agents" `
    -Name $queueItem["containerName"] -OsType Linux -Image acrondemagents.azurecr.io/azure-devops/agent/dotnet/sdk:5.0 -Cpu 3 -MemoryInGB 3 `
    -RegistryCredential $registryCredential -EnvironmentVariable $environmentVariable -IpAddressType Public -RestartPolicy Never

Write-Host "Azure Containe Group created. Name: " $containerGroup.Name
Write-Host "Completion event sent to Azure DevOps Uri."
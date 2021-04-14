using namespace System.Net

# Invoke a function task
# https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/utility/azure-function?view=azure-devops

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell CreateBuildAgentHttpTrigger function processed a request."

# Interact with query parameters or the body of the request.
$queueItem = @{}
$queueItem["planUri"] = $Request.Body.planUri
$queueItem["projectId"] = $Request.Body.projectId
$queueItem["hubName"] = $Request.Body.hubName
$queueItem["planId"] = $Request.Body.planId
$queueItem["authToken"] = $Request.Body.authToken
$queueItem["agentPersonalAccessToken"] = $Request.Body.agentPersonalAccessToken

$queueItem["taskId"] = $Request.Body.taskId
$queueItem["jobId"] = $Request.Body.jobId

$queueItem["containerName"] = $Request.Body.agentName

Write-Host "planUri:" $queueItem["planUri"]
Write-Host "projectId:" $queueItem["projectId"]

Push-OutputBinding -Name BuildAgentsQueue -Value $queueItem

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $queueItem["containerName"]
})
using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell RemoveBuildAgentHttpTrigger function processed a request."

Remove-AzContainerGroup -ResourceGroupName "rg-on-demand-build-agents" -Name $Request.Body.agentName

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $agentName
})
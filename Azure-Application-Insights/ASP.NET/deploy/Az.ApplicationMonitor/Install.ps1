#https://docs.microsoft.com/en-us/azure/azure-monitor/app/status-monitor-v2-api-reference#enable-instrumentationengine

Install-PackageProvider -Name NuGet –Force
Install-Module -Name PowerShellGet –Force
Update-Module -Name PowerShellGet
Install-Module -Name Az.ApplicationMonitor
Enable-ApplicationInsightsMonitoring -InstrumentationKey "6a57f85a-1c41" -EnableInstrumentationEngine
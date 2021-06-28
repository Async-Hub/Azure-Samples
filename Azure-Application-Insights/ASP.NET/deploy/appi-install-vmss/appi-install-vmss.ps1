Connect-AzAccount
Set-AzContext -Subscription "xxx"
$publicCfgHashtable =
@{
  "redfieldConfiguration"= @{
    "instrumentationKeyMap"= @{
      "filters"= @(
        @{
          "appFilter"= ".*";
          "machineFilter"= ".*";
          "virtualPathFilter"= ".*";
          "instrumentationSettings" = @{
            "connectionString"= "InstrumentationKey=xxx;IngestionEndpoint=https://westeurope-3.in.applicationinsights.azure.com/";
          };
          "enableDependencyTracking"="true";
          "dependencyTrackingOptions"=@{
            "enableSqlCommandTextInstrumentation"="true"
          }
        }
      )
    }
  }
};
$privateCfgHashtable = @{};

$vmss = Get-AzVmss -ResourceGroupName "rg-vmss-appi-sample" -VMScaleSetName "vmss-appi-sample"

Add-AzVmssExtension -VirtualMachineScaleSet $vmss -Name "ApplicationMonitoring" -Publisher "Microsoft.Azure.Diagnostics" -Type "ApplicationMonitoringWindows" -TypeHandlerVersion "2.8" -Setting $publicCfgHashtable -ProtectedSetting $privateCfgHashtable

Update-AzVmss -ResourceGroupName $vmss.ResourceGroupName -Name $vmss.Name -VirtualMachineScaleSet $vmss
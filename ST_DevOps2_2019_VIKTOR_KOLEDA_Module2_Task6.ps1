#1.Для каждого пункта написать и выполнить соответсвующий скрипт автоматизации администрирования:
#1.1.Вывести все IP адреса вашего компьютера (всех сетевых интерфейсов)
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName . | `
Where-Object {$_.IPAddress -ne $null} | Select-Object -Property Description, IPAddress
#1.2.Получить mac-адреса всех сетевых устройств вашего компьютера и удалённо.
#MAC-адреса локального компьютера
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName . | `
Where-Object {$_.MACAdress -ne $null} | Select-Object -Property Description, MACAddress
#MAC-адреса удаленного компьютера
param(
    [Parameter(Mandatory=$true,HelpMessage="Enter remote computer IP address or hostname")]
    [ValidateNotNull()]
    [string]$wmihost
)
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $wmihost | `
Where-Object {$_.MACAddress -ne $null} | Select-Object -Property Description, MACAddress
#1.3.На всех виртуальных компьютерах настроить (удалённо) получение адресов с DHСP.
$VMs=Get-WmiObject -Namespace root\virtualization\v2 -Query "SELECT * FROM Msvm_ComputerSystem WHERE Caption = 'Virtual Machine'" 
ForEach ($a in $VMs) {
    $Username="$($a.ElementName)\Administrator"
    $Password='Qwerty1!'
    $pass = ConvertTo-SecureString -AsPlainText $Password -Force
    $MySecureCreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username,$pass
    $NetAdapter=Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $a.ElementName -Credential $MySecureCreds | `
    Where-Object {$_.Description -like "Microsoft Hyper-V Network Adapter*"}
    foreach ($i in $NetAdapter) {
        $i.InvokeMethod("EnableDHCP", $null)
    }
}
#1.4.Расшарить папку на компьютере
New-Item e:\sharedfolder -Type dir
(Get-WmiObject -List -ComputerName . | `
Where-Object -Filter {$_.Name -eq "win32_Share"}).InvokeMethod("Create",("e:\sharedfolder","TestShare",0,15,"Test Share"))
#1.5.Удалить шару из п.1.4
(Get-WmiObject win32_share -ComputerName . | Where-Object {$_.name -eq "TestShare"}).InvokeMethod("Delete",$null)
#1.6.Скрипт входными параметрами которого являются Маска подсети и два ip-адреса. Результат  – сообщение (ответ) в одной ли подсети эти адреса.
param(
    [Parameter(Mandatory=$true, HelpMessage="Enter netmask in CIDR notation. For example 24")]
    [ValidateRange(0,32)]
    [Int32]$CIDR,

    [Parameter(Mandatory=$true, HelpMessage="Enter first IP adress")]
    [ValidateScript({$_ -match [IPAddress]$_ })]
    [string]
    $IPaddress1,

    [Parameter(Mandatory=$true, HelpMessage="Enter first IP adress")]
    [ValidateScript({$_ -match [IPAddress]$_ })]
    [string]
    $IPaddress2
)

[uint32] $mask = ((-bnot [uint32]0) -shl (32 - $CIDR))
[uint32] $IP1 = AddressToBinary $IPaddress1
[uint32] $IP2 = AddressToBinary $IPaddress2
if (($IP1 -band $mask) -eq ($IP2 -band $mask)) {
    Write-Output "These IP addresses in the same subnet"}
else {
    Write-Output "These IP addresses in the different subnet"
}

function AddressToBinary ($IPaddress)
{
    $a = [uint32[]]$IPaddress.split('.')
    return ($a[0] -shl 24) + ($a[1] -shl 16) + ($a[2] -shl 8) + $a[3]
}
#2.Работа с Hyper-V
#2.1.Получить список коммандлетов работы с Hyper-V (Module Hyper-V)
Get-Command -module Hyper-V
<# Command output is located below
CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Cmdlet          Add-VMAssignableDevice                             2.0.0.0    Hyper-V
Cmdlet          Add-VMDvdDrive                                     2.0.0.0    Hyper-V
Cmdlet          Add-VMFibreChannelHba                              2.0.0.0    Hyper-V
Cmdlet          Add-VMGpuPartitionAdapter                          2.0.0.0    Hyper-V
Cmdlet          Add-VMGroupMember                                  2.0.0.0    Hyper-V
Cmdlet          Add-VMHardDiskDrive                                2.0.0.0    Hyper-V
Cmdlet          Add-VMHostAssignableDevice                         2.0.0.0    Hyper-V
Cmdlet          Add-VMKeyStorageDrive                              2.0.0.0    Hyper-V
Cmdlet          Add-VMMigrationNetwork                             2.0.0.0    Hyper-V
Cmdlet          Add-VMNetworkAdapter                               2.0.0.0    Hyper-V
Cmdlet          Add-VMNetworkAdapterAcl                            2.0.0.0    Hyper-V
Cmdlet          Add-VMNetworkAdapterExtendedAcl                    2.0.0.0    Hyper-V
Cmdlet          Add-VMNetworkAdapterRoutingDomainMapping           2.0.0.0    Hyper-V
Cmdlet          Add-VMPmemController                               2.0.0.0    Hyper-V
Cmdlet          Add-VMRemoteFx3dVideoAdapter                       2.0.0.0    Hyper-V
Cmdlet          Add-VMScsiController                               2.0.0.0    Hyper-V
Cmdlet          Add-VMStoragePath                                  2.0.0.0    Hyper-V
Cmdlet          Add-VMSwitch                                       2.0.0.0    Hyper-V
Cmdlet          Add-VMSwitchExtensionPortFeature                   2.0.0.0    Hyper-V
Cmdlet          Add-VMSwitchExtensionSwitchFeature                 2.0.0.0    Hyper-V
Cmdlet          Add-VMSwitchTeamMember                             2.0.0.0    Hyper-V
Cmdlet          Checkpoint-VM                                      2.0.0.0    Hyper-V
Cmdlet          Compare-VM                                         2.0.0.0    Hyper-V
Cmdlet          Complete-VMFailover                                2.0.0.0    Hyper-V
Cmdlet          Connect-VMNetworkAdapter                           2.0.0.0    Hyper-V
Cmdlet          Connect-VMSan                                      2.0.0.0    Hyper-V
Cmdlet          Convert-VHD                                        2.0.0.0    Hyper-V
Cmdlet          Copy-VMFile                                        2.0.0.0    Hyper-V
Cmdlet          Debug-VM                                           2.0.0.0    Hyper-V
Cmdlet          Disable-VMConsoleSupport                           2.0.0.0    Hyper-V
Cmdlet          Disable-VMEventing                                 2.0.0.0    Hyper-V
Cmdlet          Disable-VMIntegrationService                       2.0.0.0    Hyper-V
Cmdlet          Disable-VMMigration                                2.0.0.0    Hyper-V
Cmdlet          Disable-VMRemoteFXPhysicalVideoAdapter             2.0.0.0    Hyper-V
Cmdlet          Disable-VMResourceMetering                         2.0.0.0    Hyper-V
Cmdlet          Disable-VMSwitchExtension                          2.0.0.0    Hyper-V
Cmdlet          Disable-VMTPM                                      2.0.0.0    Hyper-V
Cmdlet          Disconnect-VMNetworkAdapter                        2.0.0.0    Hyper-V
Cmdlet          Disconnect-VMSan                                   2.0.0.0    Hyper-V
Cmdlet          Dismount-VHD                                       2.0.0.0    Hyper-V
Cmdlet          Dismount-VMHostAssignableDevice                    2.0.0.0    Hyper-V
Cmdlet          Enable-VMConsoleSupport                            2.0.0.0    Hyper-V
Cmdlet          Enable-VMEventing                                  2.0.0.0    Hyper-V
Cmdlet          Enable-VMIntegrationService                        2.0.0.0    Hyper-V
Cmdlet          Enable-VMMigration                                 2.0.0.0    Hyper-V
Cmdlet          Enable-VMRemoteFXPhysicalVideoAdapter              2.0.0.0    Hyper-V
Cmdlet          Enable-VMReplication                               2.0.0.0    Hyper-V
Cmdlet          Enable-VMResourceMetering                          2.0.0.0    Hyper-V
Cmdlet          Enable-VMSwitchExtension                           2.0.0.0    Hyper-V
Cmdlet          Enable-VMTPM                                       2.0.0.0    Hyper-V
Cmdlet          Export-VM                                          2.0.0.0    Hyper-V
Cmdlet          Export-VMSnapshot                                  2.0.0.0    Hyper-V
Cmdlet          Get-VHD                                            2.0.0.0    Hyper-V
Cmdlet          Get-VHDSet                                         2.0.0.0    Hyper-V
Cmdlet          Get-VHDSnapshot                                    2.0.0.0    Hyper-V
Cmdlet          Get-VM                                             2.0.0.0    Hyper-V
Cmdlet          Get-VMAssignableDevice                             2.0.0.0    Hyper-V
Cmdlet          Get-VMBios                                         2.0.0.0    Hyper-V
Cmdlet          Get-VMComPort                                      2.0.0.0    Hyper-V
Cmdlet          Get-VMConnectAccess                                2.0.0.0    Hyper-V
Cmdlet          Get-VMDvdDrive                                     2.0.0.0    Hyper-V
Cmdlet          Get-VMFibreChannelHba                              2.0.0.0    Hyper-V
Cmdlet          Get-VMFirmware                                     2.0.0.0    Hyper-V
Cmdlet          Get-VMFloppyDiskDrive                              2.0.0.0    Hyper-V
Cmdlet          Get-VMGpuPartitionAdapter                          2.0.0.0    Hyper-V
Cmdlet          Get-VMGroup                                        2.0.0.0    Hyper-V
Cmdlet          Get-VMHardDiskDrive                                2.0.0.0    Hyper-V
Cmdlet          Get-VMHost                                         2.0.0.0    Hyper-V
Cmdlet          Get-VMHostAssignableDevice                         2.0.0.0    Hyper-V
Cmdlet          Get-VMHostCluster                                  2.0.0.0    Hyper-V
Cmdlet          Get-VMHostNumaNode                                 2.0.0.0    Hyper-V
Cmdlet          Get-VMHostNumaNodeStatus                           2.0.0.0    Hyper-V
Cmdlet          Get-VMHostSupportedVersion                         2.0.0.0    Hyper-V
Cmdlet          Get-VMIdeController                                2.0.0.0    Hyper-V
Cmdlet          Get-VMIntegrationService                           2.0.0.0    Hyper-V
Cmdlet          Get-VMKeyProtector                                 2.0.0.0    Hyper-V
Cmdlet          Get-VMKeyStorageDrive                              2.0.0.0    Hyper-V
Cmdlet          Get-VMMemory                                       2.0.0.0    Hyper-V
Cmdlet          Get-VMMigrationNetwork                             2.0.0.0    Hyper-V
Cmdlet          Get-VMNetworkAdapter                               2.0.0.0    Hyper-V
Cmdlet          Get-VMNetworkAdapterAcl                            2.0.0.0    Hyper-V
Cmdlet          Get-VMNetworkAdapterExtendedAcl                    2.0.0.0    Hyper-V
Cmdlet          Get-VMNetworkAdapterFailoverConfiguration          2.0.0.0    Hyper-V
Cmdlet          Get-VMNetworkAdapterIsolation                      2.0.0.0    Hyper-V
Cmdlet          Get-VMNetworkAdapterRdma                           2.0.0.0    Hyper-V
Cmdlet          Get-VMNetworkAdapterRoutingDomainMapping           2.0.0.0    Hyper-V
Cmdlet          Get-VMNetworkAdapterTeamMapping                    2.0.0.0    Hyper-V
Cmdlet          Get-VMNetworkAdapterVlan                           2.0.0.0    Hyper-V
Cmdlet          Get-VMPartitionableGpu                             2.0.0.0    Hyper-V
Cmdlet          Get-VMPmemController                               2.0.0.0    Hyper-V
Cmdlet          Get-VMProcessor                                    2.0.0.0    Hyper-V
Cmdlet          Get-VMRemoteFx3dVideoAdapter                       2.0.0.0    Hyper-V
Cmdlet          Get-VMRemoteFXPhysicalVideoAdapter                 2.0.0.0    Hyper-V
Cmdlet          Get-VMReplication                                  2.0.0.0    Hyper-V
Cmdlet          Get-VMReplicationAuthorizationEntry                2.0.0.0    Hyper-V
Cmdlet          Get-VMReplicationServer                            2.0.0.0    Hyper-V
Cmdlet          Get-VMResourcePool                                 2.0.0.0    Hyper-V
Cmdlet          Get-VMSan                                          2.0.0.0    Hyper-V
Cmdlet          Get-VMScsiController                               2.0.0.0    Hyper-V
Cmdlet          Get-VMSecurity                                     2.0.0.0    Hyper-V
Cmdlet          Get-VMSnapshot                                     2.0.0.0    Hyper-V
Cmdlet          Get-VMStoragePath                                  2.0.0.0    Hyper-V
Cmdlet          Get-VMStorageSettings                              2.0.0.0    Hyper-V
Cmdlet          Get-VMSwitch                                       2.0.0.0    Hyper-V
Cmdlet          Get-VMSwitchExtension                              2.0.0.0    Hyper-V
Cmdlet          Get-VMSwitchExtensionPortData                      2.0.0.0    Hyper-V
Cmdlet          Get-VMSwitchExtensionPortFeature                   2.0.0.0    Hyper-V
Cmdlet          Get-VMSwitchExtensionSwitchData                    2.0.0.0    Hyper-V
Cmdlet          Get-VMSwitchExtensionSwitchFeature                 2.0.0.0    Hyper-V
Cmdlet          Get-VMSwitchTeam                                   2.0.0.0    Hyper-V
Cmdlet          Get-VMSystemSwitchExtension                        2.0.0.0    Hyper-V
Cmdlet          Get-VMSystemSwitchExtensionPortFeature             2.0.0.0    Hyper-V
Cmdlet          Get-VMSystemSwitchExtensionSwitchFeature           2.0.0.0    Hyper-V
Cmdlet          Get-VMVideo                                        2.0.0.0    Hyper-V
Cmdlet          Grant-VMConnectAccess                              2.0.0.0    Hyper-V
Cmdlet          Import-VM                                          2.0.0.0    Hyper-V
Cmdlet          Import-VMInitialReplication                        2.0.0.0    Hyper-V
Cmdlet          Measure-VM                                         2.0.0.0    Hyper-V
Cmdlet          Measure-VMReplication                              2.0.0.0    Hyper-V
Cmdlet          Measure-VMResourcePool                             2.0.0.0    Hyper-V
Cmdlet          Merge-VHD                                          2.0.0.0    Hyper-V
Cmdlet          Mount-VHD                                          2.0.0.0    Hyper-V
Cmdlet          Mount-VMHostAssignableDevice                       2.0.0.0    Hyper-V
Cmdlet          Move-VM                                            2.0.0.0    Hyper-V
Cmdlet          Move-VMStorage                                     2.0.0.0    Hyper-V
Cmdlet          New-VFD                                            2.0.0.0    Hyper-V
Cmdlet          New-VHD                                            2.0.0.0    Hyper-V
Cmdlet          New-VM                                             2.0.0.0    Hyper-V
Cmdlet          New-VMGroup                                        2.0.0.0    Hyper-V
Cmdlet          New-VMReplicationAuthorizationEntry                2.0.0.0    Hyper-V
Cmdlet          New-VMResourcePool                                 2.0.0.0    Hyper-V
Cmdlet          New-VMSan                                          2.0.0.0    Hyper-V
Cmdlet          New-VMSwitch                                       2.0.0.0    Hyper-V
Cmdlet          Optimize-VHD                                       2.0.0.0    Hyper-V
Cmdlet          Optimize-VHDSet                                    2.0.0.0    Hyper-V
Cmdlet          Remove-VHDSnapshot                                 2.0.0.0    Hyper-V
Cmdlet          Remove-VM                                          2.0.0.0    Hyper-V
Cmdlet          Remove-VMAssignableDevice                          2.0.0.0    Hyper-V
Cmdlet          Remove-VMDvdDrive                                  2.0.0.0    Hyper-V
Cmdlet          Remove-VMFibreChannelHba                           2.0.0.0    Hyper-V
Cmdlet          Remove-VMGpuPartitionAdapter                       2.0.0.0    Hyper-V
Cmdlet          Remove-VMGroup                                     2.0.0.0    Hyper-V
Cmdlet          Remove-VMGroupMember                               2.0.0.0    Hyper-V
Cmdlet          Remove-VMHardDiskDrive                             2.0.0.0    Hyper-V
Cmdlet          Remove-VMHostAssignableDevice                      2.0.0.0    Hyper-V
Cmdlet          Remove-VMKeyStorageDrive                           2.0.0.0    Hyper-V
Cmdlet          Remove-VMMigrationNetwork                          2.0.0.0    Hyper-V
Cmdlet          Remove-VMNetworkAdapter                            2.0.0.0    Hyper-V
Cmdlet          Remove-VMNetworkAdapterAcl                         2.0.0.0    Hyper-V
Cmdlet          Remove-VMNetworkAdapterExtendedAcl                 2.0.0.0    Hyper-V
Cmdlet          Remove-VMNetworkAdapterRoutingDomainMapping        2.0.0.0    Hyper-V
Cmdlet          Remove-VMNetworkAdapterTeamMapping                 2.0.0.0    Hyper-V
Cmdlet          Remove-VMPmemController                            2.0.0.0    Hyper-V
Cmdlet          Remove-VMRemoteFx3dVideoAdapter                    2.0.0.0    Hyper-V
Cmdlet          Remove-VMReplication                               2.0.0.0    Hyper-V
Cmdlet          Remove-VMReplicationAuthorizationEntry             2.0.0.0    Hyper-V
Cmdlet          Remove-VMResourcePool                              2.0.0.0    Hyper-V
Cmdlet          Remove-VMSan                                       2.0.0.0    Hyper-V
Cmdlet          Remove-VMSavedState                                2.0.0.0    Hyper-V
Cmdlet          Remove-VMScsiController                            2.0.0.0    Hyper-V
Cmdlet          Remove-VMSnapshot                                  2.0.0.0    Hyper-V
Cmdlet          Remove-VMStoragePath                               2.0.0.0    Hyper-V
Cmdlet          Remove-VMSwitch                                    2.0.0.0    Hyper-V
Cmdlet          Remove-VMSwitchExtensionPortFeature                2.0.0.0    Hyper-V
Cmdlet          Remove-VMSwitchExtensionSwitchFeature              2.0.0.0    Hyper-V
Cmdlet          Remove-VMSwitchTeamMember                          2.0.0.0    Hyper-V
Cmdlet          Rename-VM                                          2.0.0.0    Hyper-V
Cmdlet          Rename-VMGroup                                     2.0.0.0    Hyper-V
Cmdlet          Rename-VMNetworkAdapter                            2.0.0.0    Hyper-V
Cmdlet          Rename-VMResourcePool                              2.0.0.0    Hyper-V
Cmdlet          Rename-VMSan                                       2.0.0.0    Hyper-V
Cmdlet          Rename-VMSnapshot                                  2.0.0.0    Hyper-V
Cmdlet          Rename-VMSwitch                                    2.0.0.0    Hyper-V
Cmdlet          Repair-VM                                          2.0.0.0    Hyper-V
Cmdlet          Reset-VMReplicationStatistics                      2.0.0.0    Hyper-V
Cmdlet          Reset-VMResourceMetering                           2.0.0.0    Hyper-V
Cmdlet          Resize-VHD                                         2.0.0.0    Hyper-V
Cmdlet          Restart-VM                                         2.0.0.0    Hyper-V
Cmdlet          Restore-VMSnapshot                                 2.0.0.0    Hyper-V
Cmdlet          Resume-VM                                          2.0.0.0    Hyper-V
Cmdlet          Resume-VMReplication                               2.0.0.0    Hyper-V
Cmdlet          Revoke-VMConnectAccess                             2.0.0.0    Hyper-V
Cmdlet          Save-VM                                            2.0.0.0    Hyper-V
Cmdlet          Set-VHD                                            2.0.0.0    Hyper-V
Cmdlet          Set-VM                                             2.0.0.0    Hyper-V
Cmdlet          Set-VMBios                                         2.0.0.0    Hyper-V
Cmdlet          Set-VMComPort                                      2.0.0.0    Hyper-V
Cmdlet          Set-VMDvdDrive                                     2.0.0.0    Hyper-V
Cmdlet          Set-VMFibreChannelHba                              2.0.0.0    Hyper-V
Cmdlet          Set-VMFirmware                                     2.0.0.0    Hyper-V
Cmdlet          Set-VMFloppyDiskDrive                              2.0.0.0    Hyper-V
Cmdlet          Set-VMGpuPartitionAdapter                          2.0.0.0    Hyper-V
Cmdlet          Set-VMHardDiskDrive                                2.0.0.0    Hyper-V
Cmdlet          Set-VMHost                                         2.0.0.0    Hyper-V
Cmdlet          Set-VMHostCluster                                  2.0.0.0    Hyper-V
Cmdlet          Set-VMKeyProtector                                 2.0.0.0    Hyper-V
Cmdlet          Set-VMKeyStorageDrive                              2.0.0.0    Hyper-V
Cmdlet          Set-VMMemory                                       2.0.0.0    Hyper-V
Cmdlet          Set-VMMigrationNetwork                             2.0.0.0    Hyper-V
Cmdlet          Set-VMNetworkAdapter                               2.0.0.0    Hyper-V
Cmdlet          Set-VMNetworkAdapterFailoverConfiguration          2.0.0.0    Hyper-V
Cmdlet          Set-VMNetworkAdapterIsolation                      2.0.0.0    Hyper-V
Cmdlet          Set-VMNetworkAdapterRdma                           2.0.0.0    Hyper-V
Cmdlet          Set-VMNetworkAdapterRoutingDomainMapping           2.0.0.0    Hyper-V
Cmdlet          Set-VMNetworkAdapterTeamMapping                    2.0.0.0    Hyper-V
Cmdlet          Set-VMNetworkAdapterVlan                           2.0.0.0    Hyper-V
Cmdlet          Set-VMPartitionableGpu                             2.0.0.0    Hyper-V
Cmdlet          Set-VMProcessor                                    2.0.0.0    Hyper-V
Cmdlet          Set-VMRemoteFx3dVideoAdapter                       2.0.0.0    Hyper-V
Cmdlet          Set-VMReplication                                  2.0.0.0    Hyper-V
Cmdlet          Set-VMReplicationAuthorizationEntry                2.0.0.0    Hyper-V
Cmdlet          Set-VMReplicationServer                            2.0.0.0    Hyper-V
Cmdlet          Set-VMResourcePool                                 2.0.0.0    Hyper-V
Cmdlet          Set-VMSan                                          2.0.0.0    Hyper-V
Cmdlet          Set-VMSecurity                                     2.0.0.0    Hyper-V
Cmdlet          Set-VMSecurityPolicy                               2.0.0.0    Hyper-V
Cmdlet          Set-VMStorageSettings                              2.0.0.0    Hyper-V
Cmdlet          Set-VMSwitch                                       2.0.0.0    Hyper-V
Cmdlet          Set-VMSwitchExtensionPortFeature                   2.0.0.0    Hyper-V
Cmdlet          Set-VMSwitchExtensionSwitchFeature                 2.0.0.0    Hyper-V
Cmdlet          Set-VMSwitchTeam                                   2.0.0.0    Hyper-V
Cmdlet          Set-VMVideo                                        2.0.0.0    Hyper-V
Cmdlet          Start-VM                                           2.0.0.0    Hyper-V
Cmdlet          Start-VMFailover                                   2.0.0.0    Hyper-V
Cmdlet          Start-VMInitialReplication                         2.0.0.0    Hyper-V
Cmdlet          Start-VMTrace                                      2.0.0.0    Hyper-V
Cmdlet          Stop-VM                                            2.0.0.0    Hyper-V
Cmdlet          Stop-VMFailover                                    2.0.0.0    Hyper-V
Cmdlet          Stop-VMInitialReplication                          2.0.0.0    Hyper-V
Cmdlet          Stop-VMReplication                                 2.0.0.0    Hyper-V
Cmdlet          Stop-VMTrace                                       2.0.0.0    Hyper-V
Cmdlet          Suspend-VM                                         2.0.0.0    Hyper-V
Cmdlet          Suspend-VMReplication                              2.0.0.0    Hyper-V
Cmdlet          Test-VHD                                           2.0.0.0    Hyper-V
Cmdlet          Test-VMNetworkAdapter                              2.0.0.0    Hyper-V
Cmdlet          Test-VMReplicationConnection                       2.0.0.0    Hyper-V
Cmdlet          Update-VMVersion                                   2.0.0.0    Hyper-V
Cmdlet          Wait-VM                                            2.0.0.0    Hyper-V
#>

#2.2.Получить список виртуальных машин 
Get-VM | Select-Object name
<# Command output is located below
Name
----
KOLEDA_VM1
KOLEDA_VM2
KOLEDA_VM3
#>

#2.3.Получить состояние имеющихся виртуальных машин
Get-VM | Select-Object name, state
<# Command output is located below
Name         State
----         -----
KOLEDA_VM1 Running
KOLEDA_VM2 Running
KOLEDA_VM3     Off
#>

#2.4.Выключить виртуальную машину
Stop-VM -Name KOLEDA_VM2
<# Command output is located below
PS C:\Windows\system32> Stop-VM -Name KOLEDA_VM2 -WhatIf
What if: Stop-VM will shut down the virtual machine "KOLEDA_VM2".
#>

#2.5.Создать новую виртуальную машину CPU 2, RAM 1024, Network Private, Disk 60Gb
New-VM -Name NewVM -MemoryStartupBytes 1024MB -NewVHDPath D:\Hyper-V\NewVM\Virtual` Hard` Disks\NewVM.vhdx -NewVHDSizeBytes 60GB
<# Command output is located below
Name  State CPUUsage(%) MemoryAssigned(M) Uptime   Status             Version
----  ----- ----------- ----------------- ------   ------             -------
NewVM Off   0           0                 00:00:00 Operating normally 9.0
#>
#Проверяем существует ли network adapter. Если да, то подключаем его к private сети, 
#если нет, то создаём новый и подключаем его к private сети 
if (((Get-VM -Name NewVM).NetworkAdapters).id -ne $null) {
    Connect-VMNetworkAdapter -VMName NewVM -SwitchName "Private Virtual Network"
}
else {
    Add-VMNetworkAdapter -VMName NewVM -SwitchName "Private Virtual Network"
}
#Устанавливаем количесто CPU равное двум
Set-VMProcessor -VMName NewVM -Count 2
<#Command output is located below
PS C:\Windows\system32> SET-VMProcessor -VMName NewVM -Count 2 -WhatIf
What if: Set-VMProcessor will configure the processor settings of the virtual machine "NewVM".
#>

#2.6.Создать динамический жесткий диск
New-VHD -Path D:\Hyper-V\NewVM\Virtual` Hard` Disks\Test.vhdx -SizeBytes 5GB
<# Command output is located below
ComputerName            : MIPROBOOK
Path                    : D:\Hyper-V\NewVM\Virtual Hard Disks\Test.vhdx
VhdFormat               : VHDX
VhdType                 : Dynamic
FileSize                : 4194304
Size                    : 5368709120
MinimumSize             :
LogicalSectorSize       : 512
PhysicalSectorSize      : 4096
BlockSize               : 33554432
ParentPath              :
DiskIdentifier          : 8F018859-F493-4CF5-A1A5-35E9EECCEB83
FragmentationPercentage : 0
Alignment               : 1
Attached                : False
DiskNumber              :
IsPMEMCompatible        : False
AddressAbstractionType  : None
Number                  :
#>
Add-VMHardDiskDrive -VMName NewVM -Path D:\Hyper-V\NewVM\Virtual` Hard` Disks\Test.vhdx
<# Command output is located below
PS C:\Windows\system32> Add-VMHardDiskDrive -VMName NewVM -Path D:\Hyper-V\NewVM\Virtual` Hard` Disks\Test.vhdx -WhatIf
What if: Add-VMHardDiskDrive will add a hard disk drive to virtual machine "NewVM".
#>
(get-vm -name NewVM).HardDrives
<# Command output is located below
VMName ControllerType ControllerNumber ControllerLocation DiskNumber Path
------ -------------- ---------------- ------------------ ---------- ----
NewVM  IDE            0                0                             D:\Hyper-V\NewVM\Virtual Hard Disks\NewVM.vhdx
NewVM  IDE            0                1                             D:\Hyper-V\NewVM\Virtual Hard Disks\Test.vhdx
#>
# 2.7.	Удалить созданную виртуальную машину
Remove-VM -Name "NewVM" -Force
<# Command output is located below
PS C:\Windows\system32> Remove-VM -Name "NewVM" -Force -WhatIf
What if: Remove-VM will remove virtual machine "NewVM".
#>
#Удаляем файлы жестких дисков
Remove-Item -Path D:\Hyper-V\NewVM -Confirm:$false -Recurse 
<# Command output is located below
PS C:\Windows\system32> Remove-Item -Path D:\Hyper-V\NewVM -Confirm:$false -Recurse -WhatIf
What if: Performing the operation "Remove Directory" on target "D:\Hyper-V\NewVM".
#>
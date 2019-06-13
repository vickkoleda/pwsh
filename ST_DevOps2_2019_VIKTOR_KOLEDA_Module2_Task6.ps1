#1.Для каждого пункта написать и выполнить соответсвующий скрипт автоматизации администрирования:
#1.1.Вывести все IP адреса вашего компьютера (всех сетевых интерфейсов)
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName . | Where-Object {$_.IPAddress -ne $null} | Select-Object -Property Description, IPAddress
#1.2.Получить mac-адреса всех сетевых устройств вашего компьютера и удалённо.
#MAC-адреса локального компьютера
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName . | Where-Object {$_.MACAdress -ne $null} | Select-Object -Property Description, MACAddress
#MAC-адреса удаленного компьютера
param(
    [Parameter(Mandatory=$true,HelpMessage="Enter remote computer IP address or hostname")]
    [ValidateNotNull()]
    [string]$wmihost
)
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $wmihost | Where-Object {$_.MACAddress -ne $null} | Select-Object -Property Description, MACAddress
#1.3.На всех виртуальных компьютерах настроить (удалённо) получение адресов с DHСP.
$VMs=Get-WmiObject -Namespace root\virtualization\v2 -Query "SELECT * FROM Msvm_ComputerSystem WHERE Caption = 'Virtual Machine'" 
ForEach ($a in $VMs) {
    $Username="$($a.ElementName)\Administrator"
    $Password='Qwerty1!'
    $pass = ConvertTo-SecureString -AsPlainText $Password -Force
    $MySecureCreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username,$pass
    $NetAdapter=Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $a.ElementName -Credential $MySecureCreds | Where-Object {$_.Description -like "Microsoft Hyper-V Network Adapter*"}
    foreach ($i in $NetAdapter) {
        $i.InvokeMethod("EnableDHCP", $null)
    }
}
#1.4.Расшарить папку на компьютере
New-Item e:\sharedfolder -Type dir
(Get-WmiObject -List -ComputerName . | Where-Object -Filter {$_.Name -eq "win32_Share"}).InvokeMethod("Create",("e:\sharedfolder","TestShare",0,15,"Test Share"))
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
[uint32] $IP1 = NetworkToBinary $IPaddress1
[uint32] $IP2 = NetworkToBinary $IPaddress2
if (($IP1 -band $mask) -eq ($IP2 -band $mask)) {
    Write-Output "These IP addresses in the same subnet"}
else {
    Write-Output "These IP addresses in the different subnet"
}

function NetworkToBinary ($IPaddress)
{
    $a = [uint32[]]$IPaddress.split('.')
    return ($a[0] -shl 24) + ($a[1] -shl 16) + ($a[2] -shl 8) + $a[3]
}
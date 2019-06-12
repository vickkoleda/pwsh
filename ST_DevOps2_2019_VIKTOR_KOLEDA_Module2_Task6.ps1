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
net share testshare=e:\sharedfolder /users:15 /remark:"test share"
#1.5.Удалить шару из п.1.4
net share testshare /delete
#1.6.Скрипт входными параметрами которого являются Маска подсети и два ip-адреса. Результат  – сообщение (ответ) в одной ли подсети эти адреса.

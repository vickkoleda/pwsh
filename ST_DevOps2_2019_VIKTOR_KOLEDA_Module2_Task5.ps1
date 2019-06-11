#1.При помощи WMI перезагрузить все виртуальные машины.
$VMs=Get-WmiObject -Namespace root\virtualization\v2 -Query "SELECT * FROM Msvm_ComputerSystem WHERE Caption = 'Virtual Machine'" 
ForEach ($a in $VMs) {
    Write-Output "VM $($a.ElementName) is now will restart"
    $a.RequestStateChange(10)
}
#2.При помощи WMI просмотреть список запущенных служб на удаленном компьютере
Get-WmiObject win32_service -Credential koleda_vm2\administrator -Computer 192.168.10.100
#3.Настроить PowerShell Remoting, для управления всеми виртуальными машинами с хостовой
#На каждой виртуальной машине прописываем
Enable-PSremoting
Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP-PUBLIC" -RemoteAddress Any
Set-Service WinRM -startuptype Automatic
winrm set winrm/config/client ‘@{TrustedHosts="*"}’
#4.Для одной из виртуальных машин установить для прослушивания порт 42658. 
Set-Item WSMan:\localhost\listener\*\Port 42658
Restart-Service winrm
netsh advfirewall firewall add rule name="Win rm port 42658" dir=in action=allow protocol=TCP localport=42658
Restart-Service winrm
#5.Создать конфигурацию сессии с целью ограничения использования всех команд, кроме просмотра содержимого дисков.
#Создаем в домене группу HelpDesk и пользователя HelpUser, входящего в данную группу
#Cоздаем новый файл конфигурации сессии ADUser.pssc
New-PSSessionConfigurationFile -Path ADUser.pssc -AliasDefinitions @{Name="dir";Value="Get-ChildItem";Description="Gets the files and folders.";Options="ReadOnly"} `
 -VisibleAliases "dir" -VisibleCmdlets Get-ChildItem, Get-Help, Exit-PSSession, Get-Command, Get-FormatData, Measure-Object, Out-Default, Select-Object -VisibleProviders "FileSystem"
#Сохраняем учетные данные администратора домена
$cred = Get-Credential test\vkoleda
#Регистриуем новый файл конфигурации и даем права на подключение пользователям группы HelpDesk
Register-PSSessionConfiguration -Name ADUser -Path  .\ADUser.pssc -RunAsCredential $cred -ShowSecurityDescriptorUI
#Перезапускаем службу Win RM
Restart-Service winrm
#Проверяем подключение к виртуальной машине KOLEDA_VM3, используя учетные данные пользователя HelpUser
Enter-PSSession -ComputerName 192.168.10.50 -Credential test\helpuser -ConfigurationName ADUser -Port 42658
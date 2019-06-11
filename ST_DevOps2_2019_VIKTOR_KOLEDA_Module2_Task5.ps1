#1.При помощи WMI перезагрузить все виртуальные машины.
ForEach-Object($Vm in (Get-WmiObject -Namespace root\virtualization\v2 Msvm_ComputerSystem | Where-Object {$_.Description -like "Microsoft Virtual Computer System"}) {
$Vm.RequestStateChange(10)
}
#2.При помощи WMI просмотреть список запущенных служб на удаленном компьютере
Get-WmiObject win32_service -Credential koleda_vm3\administrator -Computer 192.168.10.3
#3.Настроить PowerShell Remoting, для управления всеми виртуальными машинами с хостовой
#На каждой виртуальной машине прописываем
Enable-PSremoting
Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP-PUBLIC" -RemoteAddress Any
Set-Service WinRM -startuptype Automatic
winrm set winrm/config/client ‘@{TrustedHosts="*"}’
#4.Для одной из виртуальных машин установить для прослушивания порт 42658. 
Set-Item WSMan:\localhost\listener\*\Port 42658
#5.Создать конфигурацию сессии с целью ограничения использования всех команд, кроме просмотра содержимого дисков.
#1.Вывести список всех классов WMI на локальном компьютере
Get-CimClass
#2.Получить список всех пространств имён классов WMI. 
Get-WmiObject -Namespace root -Class "__namespace"
#3.Получить список классов работы с принтером.
Get-WmiObject -List | Where-Object {$_.name -match "printer"}
#4.Вывести информацию об операционной системе, не менее 10 полей.
#Просмотр классов, связанных с операционной системой
Get-WmiObject -List | Where-Object {$_.name -match "operatingsystem"}
#Вывод информации об операционной системе
Get-WmiObject -Class Win32_OperatingSystem | 
    Select-Object PSComputerName, Caption, Version, OSArchitecture, Organization, SystemDrive, WindowsDirectory, CurrentTimeZone, MUILanguages, OSLanguage |
        format-list
#5.Получить информацию о BIOS
#Просмотр классов, связанных с операционной системой
Get-WmiObject -List | Where-Object {$_.name -match "bios"}
#Вывод информации о BIOS
Get-WmiObject Win32_BIOS
#6.Вывести свободное место на локальных дисках. На каждом и сумму.
#Вывод свободного места на локальных дисках
Get-WmiObject Win32_LogicalDisk -Filter 'DriveType = 3' | 
    ForEach-Object {
                    Write-Output "$($_.DeviceId) $(($_.Freespace/1gb).ToString("#.00")) Gb"
                    }
#Вывод суммарного свободного места на локальных дисках
$TotalFree=(Get-WmiObject Win32_LogicalDisk -Filter 'DriveType = 3' | 
    Select-Object DeviceID, @{L='Freespace'; E={$_.Freespace/1GB}} | 
        Measure-Object -Property Freespace -sum | 
            Select-Object Sum).Sum.ToString("#.00")
Write-Output $TotalFree" Gb"
#7.Написать сценарий, выводящий суммарное время пингования компьютера (например 10.0.0.1) в сети.
param (
    [Parameter(Mandatory=$true, HelpMessage="Enter Host IP")]
    [string]
    $IP_host,
    [Parameter(Mandatory=$true, HelpMessage="Enter Host IP")]
    [int]
    $count
    )
$rt=0
for ($i=0; $i -lt $count; $i++)
{
$info=Get-WmiObject -Class Win32_PingStatus -Filter "Address='$IP_host'"
$rt+=$info.ResponseTime
}
Write-Output "Summary response time for host $($IP_host) is $($rt) ms"
#8.Создать файл-сценарий вывода списка установленных программных продуктов в виде таблицы с полями Имя и Версия.
Get-WmiObject Win32_InstalledWin32Program | Select-Object -Property Name, Version | Sort-Object -Property Name | Format-Table
#9.Выводить сообщение при каждом запуске приложения MS Word.
Register-WmiEvent -query "select * from __instancecreationevent within 5 where targetinstance isa 'Win32_Process' and targetinstance.name='WINWORD.exe'" -sourceIdentifier "ProcessStarted" -Action {Write-Output "Microsoft Word is started"}
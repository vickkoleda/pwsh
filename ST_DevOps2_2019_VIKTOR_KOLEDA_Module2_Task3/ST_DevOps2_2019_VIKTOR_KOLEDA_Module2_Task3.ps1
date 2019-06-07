#.\Exercise1.1.ps1
#1.1.Сохранить в текстовый файл на диске список запущенных(!) служб. Просмотреть содержимое диска. Вывести содержимое файла в консоль PS.
Param (
    [Parameter(HelpMessage="Enter output file location. Default is D:\")]
    [AllowEmptyString()]
    [string]$Location='D:\',
    [Parameter(HelpMessage="Enter output file name. Default is RunningServices.txt")]
    [AllowEmptyString()]
    [string]$File='RunningServices.txt'
)
Get-Service | ? {$_.Status -eq "Running"} | Out-File $Location$File
Get-ChildItem $Location
Get-Content $Location$File

#.\Exercise1.2.ps1
#1.2.Просуммировать все числовые значения переменных среды Windows. (Параметры не нужны)
Get-ChildItem env: | ? {$_.Value -match "^\d+$"} | Measure-Object -Property Value -Sum | Select Sum

#.\Exercise1.3.ps1
#1.3.Вывести список из 10 процессов занимающих дольше всего процессор. Результат записывать в файл.
Param (
    [Parameter(HelpMessage="Enter output file location. Default is D:\")]
    [AllowEmptyString()]
    [string]$Location='D:\',
    [Parameter(HelpMessage="Enter output file name. Default is Processes.txt")]
    [AllowEmptyString()]
    [string]$File='Processes.txt'
)
Get-Process | Sort-Object -Descending CPU | Select -First 10 | Out-File $Location$File

#.\Exercise1.3.1.ps1
#1.3.1.Организовать запуск скрипта каждые 10 минут
Param (
    [Parameter(HelpMessage="Enter Repeat time in minutes. Default is 10")]
    [AllowEmptyString()]
    [ValidateNotNull()]
    [int]$RepeatTime='10'
)
$t=New-JobTrigger -Once -At "07/06/2019 1pm" -RepetitionInterval (New-TimeSpan -Minutes $RepeatTime) -RepetitionDuration ([TimeSpan]::MaxValue)
$Cred=Get-Credential miprobook\Admin
$o=New-ScheduledJobOption -RunElevated
Register-ScheduledJob -Name TopProcessorTime -FilePath E:\Git\pwsh\ST_DevOps2_2019_VIKTOR_KOLEDA_Module2_Task3\Exercise1.3.ps1 -Trigger $t -Credential $Cred -ScheduledJobOption $o

#.\Exercise1.4.ps1
#1.4.Подсчитать размер занимаемый файлами в папке (например C:\windows) за исключением файлов с заданным расширением(напрмер .tmp)
Param (
    [Parameter(HelpMessage="Enter Target Dir. Default is C:\Windows")]
    [AllowEmptyString()]
    [string]$TargetDir='C:\Windows',
    [Parameter(HelpMessage="Enter Files or File extensions which must be excluded from total size calculation. Default is *.tmp")]
    [AllowEmptyString()]
    [string]$ExclusionMask='*.tmp'
)
$TotalSum=((Get-ChildItem $TargetDir -Recurse -Force -ErrorAction SilentlyContinue -Exclude $ExclusionMask | Measure-Object -Property Length -sum).Sum/1Gb).ToString("#.00")
Write-Host $TotalSum"Gb" 

#.\Exercise1.5.ps1
#1.5.Создать один скрипт, объединив 3 задачи:
Param (
    [Parameter(HelpMessage="Enter CSV file Name. Default is SecurityUpdates")]
    [AllowEmptyString()]
    [string]$CsvFile='SecurityUpdates',
    [Parameter(HelpMessage="Enter XML file Name. Default is regeditWU")]
    [AllowEmptyString()]
    [string]$XmlFile='RegeditWU',
    [Parameter(HelpMessage="Enter full path to save CSV and XML files. Default is D:\")]
    [AllowEmptyString()]
    [string]$TargetDir='D:\'
    )
#1.5.1.Сохранить в CSV-файле информацию обо всех обновлениях безопасности ОС.
Get-HotFix -Description "Security*" | Export-Csv -Path $TargetDir$CsvFile.csv -Delimiter ";" -NoTypeInformation
#1.5.2.Сохранить в XML-файле информацию о записях одной ветви реестра HKLM:\SOFTWARE\Microsoft.
Get-ChildItem HKLM:\SOFTWARE\Microsoft\WindowsUpdate\ -Recurse | Export-Clixml $TargetDir$XmlFile.xml
#1.5.3.Загрузить данные из полученного в п.1.5.1 или п.1.5.2 файла и вывести в виде списка  разным разными цветами
Import-Csv $TargetDir$CsvFile.csv -Delimiter ";" | 
    foreach {
                Write-Host -ForegroundColor Green "PSComputerName = "$_.PSComputerName
                Write-Host -ForegroundColor Green "UpdateClass = "$_.Description
                Write-Host -ForegroundColor Green "HotFixID = "$_.HotFixID
                Write-Host -ForegroundColor Green "Installation Date = "$_.InstalledOn
                Write-Host -ForegroundColor Green "Installed By = "$_.InstalledBy
                Write-Host -ForegroundColor Green "Path = "$_.__PATH
                Write-Host -ForegroundColor Green "Caption = "$_.Caption
                Write-Host "----------"
            }   
Import-Clixml $TargetDir$XmlFile.xml | 
    foreach {
                Write-Host -ForegroundColor Blue "Name = "$_.Name
                Write-Host -ForegroundColor Blue "Property = "$_.Property
                Write-Host -ForegroundColor Blue "PSPath = "$_.PSPath
                Write-Host -ForegroundColor Blue "PSParentPath = "$_.PSParentPath
                Write-Host -ForegroundColor Blue "PSChildName = "$_.PSChildName
                Write-Host -ForegroundColor Blue "PSDrive = "$_.PSDrive
                Write-Host -ForegroundColor Blue "PSProvider = "$_.PSProvider
                Write-Host "----------"
            }

#.\Exercise2.ps1
#2.1.Создать профиль
New-Item -ItemType file -Path $profile -force
#2.2.В профиле изненить цвета в консоли PowerShell
echo '(Get-Host).UI.RawUI.ForegroundColor = "yellow"' >> C:\Users\Admin\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
echo '(Get-Host).UI.RawUI.BackgroundColor = "grey"' >> C:\Users\vkaliada\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
#2.3.Создать несколько собственный алиасов
echo "Set-Alias -Name getcom -Value Get-Command" >> c:\Users\vkaliada\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
echo "Set-Alias -Name pwsh -Value Get-PSVersion" >> c:\Users\vkaliada\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
#2.4.Создать несколько констант
echo "`$pi=3.14" >> c:\Users\vkaliada\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
echo "`$e=2.718" >> c:\Users\vkaliada\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
#2.5.Изменить текущую папку
echo "Set-Location D:" >> c:\Users\vkaliada\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
#2.6.Вывести приветсвие
echo 'Write-Host "Are you ready to script?"' >> c:\Users\vkaliada\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

#.\Exercise3.ps1
#3.Получить список всех доступных модулей
Get-Module -ListAvailable
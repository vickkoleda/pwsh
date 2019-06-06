#1.5.Создать один скрипт, объединив 3 задачи:
#1.5.1.Сохранить в CSV-файле информацию обо всех обновлениях безопасности ОС.
Get-HotFix -Description "Security*" | Export-Csv -Path D:\SecurityUpdates.csv -Delimiter ";" -NoTypeInformation
#1.5.2.Сохранить в XML-файле информацию о записях одной ветви реестра HKLM:\SOFTWARE\Microsoft.
Get-ChildItem HKLM:\SOFTWARE\Microsoft\WindowsUpdate\ -Recurse | Export-Clixml D:\regeditWU.xml
#1.5.3.Загрузить данные из полученного в п.1.5.1 или п.1.5.2 файла и вывести в виде списка  разным разными цветами
Import-Csv D:\SecurityUpdates.csv -Delimiter ";" | 
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
Import-Clixml D:\regedit.xml | 
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
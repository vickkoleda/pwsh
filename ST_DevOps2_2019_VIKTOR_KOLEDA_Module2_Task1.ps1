#1.Получите справку о командлете справки
Get-Help Get-Help
#2.Пункт 1, но детальную справку, затем только примеры
#Детальная справка
Get-Help Get-Help -Full
#Примеры
Get-Help Get-Help -Examples
#3.Получите справку о новых возможностях в PowerShell 4.0 (или выше)
Get-Help about_Windows_Powershell_5.0
#4.Получите все командлеты установки значений
Get-Command Set-*
#5.Получить список команд работы с файлами
Get-Command *-Item
Get-Command *-File*
#6.Получить список команд работы с объектами
Get-Command *-Object
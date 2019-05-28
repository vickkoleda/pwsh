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
#7.Получите список всех псевдонимов
Get-Alias
#8.Создайте свой псевдоним для любого командлета
Set-Alias fwrule Get-NetFirewallRule
#9.Просмотреть список методов и свойств объекта типа процесс
Get-Process explorer | Get-Member -MemberType Properties, Methods
#10.Просмотреть список методов и свойств объекта типа строка
$string = "Hello World"
$string | Get-Member -MemberType Properties, Methods
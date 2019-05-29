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
#11.Получить список запущенных процессов, данные об определённом процессе
#Список запущеных процессов
Get-Process
#Данные об определённом процессе
Get-Process chrome | Format-Table *
#12.Получить список всех сервисов, данные об определённом сервисе
#Список запущеных процессов
Get-Service
#Данные об определённом сервисе
Get-Service EventLog | Format-List *
#13.Получить список обновлений системы
Get-HotFix
#14.Узнайте, какой язык установлен для UI Windows
Get-UICulture
#15.Получите текущее время и дату
Get-Date
#16.Сгенерируйте случайное число (любым способом)
Get-Random
#17.Выведите дату и время, когда был запущен процесс «explorer». Получите какой это день недели. 
#Дата и время когда был запущен процесс «explorer»
(Get-Process explorer).StartTime
#День недели, когда был запущен процесс «explorer»
((Get-Process explorer).StartTime).DayOfWeek
#18.Откройте любой документ в MS Word (не важно как) и закройте его с помощью PowerShell
$PSVersionTable.PSVersion > d:\psversion.txt
$Word = New-Object -ComObject Word.Application
$Word.Documents.Open("D:\psversion.txt")
$Word.Documents.Close()
$Word.Quit()

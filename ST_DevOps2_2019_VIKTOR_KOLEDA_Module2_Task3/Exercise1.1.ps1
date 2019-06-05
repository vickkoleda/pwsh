#1.1.Сохранить в текстовый файл на диске список запущенных(!) служб. Просмотреть содержимое диска. Вывести содержимое файла в консоль PS.
Param (
    [Parameter(Mandatory=$true, HelpMessage="Enter output file location. For Example D:\")]
    [string]$Location,
    [Parameter(Mandatory=$true, HelpMessage="Enter output file name. For Example RunningServices.txt")]
    [string]$File
)
Get-Service | ? {$_.Status -eq "Running"} | Out-File $Location$File
Get-ChildItem $Location
Get-Content $Location$File
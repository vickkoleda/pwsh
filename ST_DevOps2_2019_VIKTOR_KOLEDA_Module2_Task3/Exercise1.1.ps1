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
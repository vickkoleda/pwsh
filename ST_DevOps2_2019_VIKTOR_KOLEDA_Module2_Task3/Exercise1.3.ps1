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
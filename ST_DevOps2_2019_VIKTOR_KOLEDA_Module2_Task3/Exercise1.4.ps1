#1.4.Подсчитать размер занимаемый файлами в папке (например C:\windows) за исключением файлов с заданным расширением(напрмер .tmp)
Param (
    [Parameter(HelpMessage="Enter Target Dir. For Example C:\Windows")]
    [string]$TargetDir='C:\Windows',
    [Parameter(HelpMessage="Enter Files or File extensions which must be excluded from total size calculation. For Example *.tmp")]
    [AllowEmptyString()]
    [string]$ExclusionMask='*.tmp'
)
$TotalSum=((Get-ChildItem $TargetDir -Recurse -Force -ErrorAction SilentlyContinue -Exclude $ExclusionMask | Measure-Object -Property Length -sum).Sum/1Gb).ToString("#.00")
Write-Host $TotalSum"Gb" 
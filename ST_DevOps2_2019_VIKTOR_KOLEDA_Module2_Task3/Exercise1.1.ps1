Param (
    [Parameter(Mandatory=$true, HelpMessage="Enter output file location. For Example D:\")]
    [string]$Location='D:\',
    [Parameter(Mandatory=$true, HelpMessage="Enter output file name. For Example RunningServices.txt")]
    [string]$File='RunningServices.txt'
)
Get-Service | ? {$_.Status -eq "Running"} | Out-File $Location$File
Get-ChildItem $Location
Get-Content $Location$File
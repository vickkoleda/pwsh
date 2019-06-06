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


$pslogin = "koleda_vm4\administrator"
$password='Qwerty1!'
$pass = ConvertTo-SecureString -AsPlainText $password -Force
$Creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $pslogin,$pass
$options = New-PSSessionOption -SkipCACheck
$s = New-PSSession -ComputerName koleda_vm4 -Credential $Creds -Port 5986 -SessionOption $options -UseSSL
Invoke-Command -Session $s -ScriptBlock {Install-WindowsFeature AD-Domain-Services -IncludeManagementTools}
Invoke-Command -Session $s -ScriptBlock {  
    Import-Module ADDSDeployment
    Install-ADDSForest `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "Win2012R2" `
    -DomainName "test.local" `
    -DomainNetbiosName "TEST" `
    -ForestMode "Win2012R2" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$false `
    -SysvolPath "C:\Windows\SYSVOL" `
    -SafeModeAdministratorPassword (Convertto-SecureString -AsPlainText "Qwerty1!" -Force) `
    -Force:$true
    }
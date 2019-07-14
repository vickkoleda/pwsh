$pslogin = "koleda\vkoleda"
$password='Qwerty1!'
$pass = ConvertTo-SecureString -AsPlainText $password -Force
$Creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $pslogin,$pass
$options = New-PSSessionOption -SkipCACheck
$s = New-PSSession -ComputerName koleda_vm1 -Credential $Creds -Port 5986 -SessionOption $options -UseSSL
Invoke-Command -Session $s -ScriptBlock {
    New-ADUser –Name "Amy Strande" –SamAccountName "Amy.Strande" -GivenName "Amy" –Surname "Strande" –DisplayName "Strande, Amy" –UserPrincipalName Amy.Strande@koleda.local –Path 'OU=Marketing,DC=koleda, DC=local' -Description "Research Assistant"
    }


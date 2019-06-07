#2.1.Создать профиль
New-Item -ItemType file -Path $profile -force
#2.2.В профиле изненить цвета в консоли PowerShell
echo '(Get-Host).UI.RawUI.ForegroundColor = "yellow"' >> C:\Users\Admin\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
echo '(Get-Host).UI.RawUI.BackgroundColor = "grey"' >> C:\Users\vkaliada\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
#2.3.Создать несколько собственный алиасов
echo "Set-Alias -Name getcom -Value Get-Command" >> c:\Users\vkaliada\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
echo "Set-Alias -Name pwsh -Value Get-PSVersion" >> c:\Users\vkaliada\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
#2.4.Создать несколько констант
echo "`$pi=3.14" >> c:\Users\vkaliada\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
echo "`$e=2.718" >> c:\Users\vkaliada\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
#2.5.Изменить текущую папку
echo "Set-Location D:" >> c:\Users\vkaliada\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
#2.6.Вывести приветсвие
echo 'Write-Host "Are you ready to script?"' >> c:\Users\vkaliada\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
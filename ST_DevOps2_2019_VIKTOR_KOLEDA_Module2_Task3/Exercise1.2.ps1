#1.2.Просуммировать все числовые значения переменных среды Windows. (Параметры не нужны)
Get-ChildItem env: | ? {$_.Value -match "^\d+$"} | Measure-Object -Property Value -Sum | Select Sum
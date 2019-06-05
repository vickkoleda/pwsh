#1.2.Просуммировать все числовые значения переменных среды Windows. (Параметры не нужны)
Get-ChildItem Variable: | ? {$_.Value -is [System.Int32]} | Measure-Object -Property Value -Sum | Select Sum
#1.Просмотреть содержимое ветви реeстра HKCU
cd HKCU:\
dir
#2.Создать, переименовать, удалить каталог на локальном диске
#Создаем каталог TestDir на диске D
New-Item -Path "d:\" -Name "TestDir" -ItemType "directory"
#Переименовываем каталог с TestDir На TestDir01
Rename-Item -Path "D:\TestDir" -NewName "TestDir01"
#Удаляем каталог
Remove-Item -Path "D:\TestDir01"
#3.Создать папку C:\M2T2_ФАМИЛИЯ. Создать диск ассоциированный с папкой C:\M2T2_ФАМИЛИЯ.
#Создаём папку
New-Item -Path "C:\" -Name "M2T2_KOLEDA" -ItemType "directory"
#Создаём диск Task2
New-PSDrive Task2 -PSProvider FileSystem -Root "C:\M2T2_KOLEDA"
#4.Сохранить в текстовый файл на созданном диске список запущенных(!) служб. Просмотреть содержимое диска. Вывести содержимое файла в консоль PS.
#Сохраняем список запущенных служб в файл RunningServices.txt
Get-Service | ? {$_.Status -eq "Running"} > Task2:\RunningServices.txt
#Просматриваем содержимое диска Task2
Get-ChildItem Task2:\
#Выводим в консоль содержимое файла RunningServices.txt
Get-Content Task2:\RunningServices.txt
#5.Просуммировать все числовые значения переменных текущего сеанса.
Get-ChildItem Variable: | ? {$_.Value -is [System.Int32]} | Measure-Object -Property Value -Sum | Select Sum
#6.Вывести список из 6 процессов занимающих дольше всего процессор.
Get-Process | Sort-Object -Descending CPU | Select -First 6
#7.Вывести список названий и занятую виртуальную память (в Mb) каждого процесса, разделённые знаком тире, при этом если процесс занимает более 100Mb – выводить информацию красным цветом, иначе зелёным.
Get-Process | foreach { 
    if(($_.VM/1MB) -gt 100) 
        {Write-host -f Green $_.Name"-"($_.VM/1MB)
    } 
    else 
        {Write-host -f Red $_.Name"-"($_.VM/1MB)
    } 
}
#8.Подсчитать размер занимаемый файлами в папке C:\windows (и во всех подпапках) за исключением файлов *.tmp
Get-ChildItem "C:\Windows" -Recurse -Force -ErrorAction SilentlyContinue -Exclude *.tmp | Measure-Object -Property Length -sum | select sum
#9.Сохранить в CSV-файле информацию о записях одной ветви реестра HKLM:\SOFTWARE\Microsoft.
Get-ChildItem HKLM:\SOFTWARE\Microsoft\WindowsUpdate\ -Recurse | Export-Csv -Path Task2:\regedit.csv -Delimiter ";"
#10.Сохранить в XML -файле историческую информацию о командах выполнявшихся в текущем сеансе работы PS
Get-History | Export-Clixml Task2:\history.xml  
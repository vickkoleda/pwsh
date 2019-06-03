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
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

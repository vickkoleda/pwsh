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
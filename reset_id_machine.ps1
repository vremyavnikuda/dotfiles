# Требует запуска от администратора
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Запустите скрипт от имени администратора!" -ForegroundColor Red
    exit
}

# Вариант 1: Изменить имя компьютера
$newName = Read-Host "Введите новое имя компьютера"
if ($newName -match "^[A-Za-z0-9-]+$") {
    Rename-Computer -NewName $newName -Force
    Write-Host "Имя компьютера изменено. Перезагрузите систему." -ForegroundColor Green
} else {
    Write-Host "Недопустимое имя. Используйте только буквы, цифры и дефис." -ForegroundColor Red
}

# Вариант 2: Сгенерировать новый SID (через Sysprep)
$choice = Read-Host "Сгенерировать новый SID? (y/n)"
if ($choice -eq "y") {
    Write-Host "Запуск Sysprep... После перезагрузки система получит новый SID." -ForegroundColor Yellow
    Write-Host "ВНИМАНИЕ: Это удалит некоторые настройки и программы!" -ForegroundColor Red
    Start-Process -FilePath "$env:SystemRoot\System32\Sysprep\sysprep.exe" -ArgumentList "/generalize /oobe /reboot"
}
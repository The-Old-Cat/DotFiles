#Requires -Version 7.0

# --- 1. Установка oh-my-posh (для Windows) ---

Write-Host "Проверка и установка oh-my-posh..."
if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    # Используем winget для установки, если доступен
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install JanDeDobbeleer.oh-my-posh -e --silent
    } elseif (Get-Command scoop -ErrorAction SilentlyContinue) {
        scoop install oh-my-posh
    } else {
        Write-Warning "Не удалось найти winget или scoop. Пожалуйста, установите oh-my-posh вручную."
    }
}

# --- 2. Установка шрифта для отображения иконок ---
Write-Host "Проверка и установка шрифта для отображения иконок..."
if (-not (Get-Command nerd-fonts -ErrorAction SilentlyContinue)) {
    # Установка шрифта Nerd Fonts
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install NerdFonts.NerdFonts -e --silent
    } else {
        Write-Warning "Не удалось найти winget. Пожалуйста, установите шрифт Nerd Fonts вручную."
    }
}

# --- 3. Создание симлинков с помощью PowerShell ---
Write-Host "Проверка и установка oh-my-posh..."
if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    # Используем winget для установки, если доступен
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install JanDeDobbeleer.oh-my-posh -e --silent
    } elseif (Get-Command scoop -ErrorAction SilentlyContinue) {
        scoop install oh-my-posh
    } else {
        Write-Warning "Не удалось найти winget или scoop. Пожалуйста, установите oh-my-posh вручную."
    }
}

# --- 2. Создание симлинков с помощью PowerShell ---
# Предполагается, что репозиторий будет перемещен в $HOME/dotfiles,
# и скрипт будет запущен из $HOME/dotfiles/install.ps1.

# Используем $MyInvocation.MyCommand.Definition для получения пути к скрипту
$ScriptPath = $MyInvocation.MyCommand.Definition
$ScriptDirectory = Split-Path -Parent $ScriptPath # Теперь используем $ScriptDirectory вместо $PSScriptRoot
$RepoRoot = Split-Path -Path $ScriptDirectory -Parent # Ожидается $HOME/dotfiles

Write-Host "Создание симлинков для Windows..."

# Каталог для конфигурации Oh My Posh в Windows: $HOME\AppData\Local\Programs\oh-my-posh\themes
$PoshConfigDir = Join-Path $HOME "AppData\Local\Programs\oh-my-posh\themes"
if (-not (Test-Path $PoshConfigDir)) {
    # Мы будем использовать $HOME\Documents\PowerShell как место для профилей
    # Для zen.toml, если oh-my-posh установлен, он обычно ищет в $HOME\AppData\Local\Programs\oh-my-posh\themes
    # или в каталоге, указанном в $env:POSH_THEMES.
    # Для простоты, я буду создавать симлинк на $HOME\Documents\PowerShell, как указано в start.ps1.
    
    # Создаем целевой каталог для zen.toml, если он не существует
    $TargetPoshThemeDir = Join-Path $HOME "Documents\PowerShell\oh-my-posh-themes"
    if (-not (Test-Path $TargetPoshThemeDir)) {
        New-Item -ItemType Directory -Force -Path $TargetPoshThemeDir | Out-Null
    }
    
    # Симлинк для zen.toml
    $SourceZenToml = Join-Path $RepoRoot "common\config\oh-my-posh\zen.toml"
    $TargetZenToml = Join-Path $TargetPoshThemeDir "zen.toml"
    
    # Проверяем, существует ли исходный файл (он должен быть создан start.ps1 или README.md)
    if (Test-Path $SourceZenToml) {
        # Удаляем старый файл/симлинк, если он есть, и создаем новый симлинк
        if (Test-Path $TargetZenToml) { Remove-Item $TargetZenToml -Force }
        New-Item -ItemType SymbolicLink -Path $TargetZenToml -Target $SourceZenToml -Force | Out-Null
        Write-Host "Симлинк для zen.toml создан: $TargetZenToml -> $SourceZenToml"
    } else {
        Write-Warning "Исходный файл $SourceZenToml не найден для создания симлинка."
    }
}

# Симлинк для профиля PowerShell
$SourcePSProfile = Join-Path $RepoRoot "windows\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
$TargetPSProfile = Join-Path $HOME "Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

if (Test-Path $SourcePSProfile) {
    # PowerShell профиль обычно находится в $PROFILE, который разрешается в $HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
    if (Test-Path $TargetPSProfile) { Remove-Item $TargetPSProfile -Force }
    New-Item -ItemType SymbolicLink -Path $TargetPSProfile -Target $SourcePSProfile -Force | Out-Null
    Write-Host "Симлинк для PowerShell профиля создан: $TargetPSProfile -> $SourcePSProfile"
} else {
    Write-Warning "Исходный файл $SourcePSProfile не найден для создания симлинка."
}

Write-Host "Установка завершена для Windows."
#Requires -Version 7.0

Write-Host "Создание структуры каталогов и файлов..."

$dirs = @(
    "dotfiles/common/.config/oh-my-posh",
    "dotfiles/linux",
    "dotfiles/windows/Documents/PowerShell"
)

$gitignoreContent = @"
# --- Security First ---
# Никогда не пушим приватные ключи и токены
**/.ssh/*
!**/.ssh/config
**/*.key
**/*.pem
**/credentials
**/.env
**/.secrets

# --- OS Specific ---
# Windows
Thumbs.db
desktop.ini
$RECYCLE.BIN/
*.lnk

# macOS
.DS_Store
.AppleDouble
.LSOverride

# Linux
*~
.fuse_hidden
.directory
.Trash-*

# --- Editors & IDEs ---
# VS Code
.vscode/*
!.vscode/settings.json
!.vscode/extensions.json
*.code-workspace

# JetBrains (IntelliJ, PyCharm, etc.)
.idea/

# Vim / Neovim
*.swp
*.swo
undo/
.netrwhist

# --- Tools & Runtime ---
# Oh My Posh & Shells
.python-version
.node-version
.ruby-version
.oh-my-posh/cache/
.zcompdump*
.zsh_history
.bash_history
.python_history

# --- Infrastructure ---
.terraform/
*.tfstate
*.tfstate.backup
"@

$files = @(
    "dotfiles/common/.config/oh-my-posh/zen.toml",
    "dotfiles/linux/.zshrc",
    "dotfiles/linux/.aliases_linux",
    "dotfiles/windows/Documents/PowerShell/Microsoft.PowerShell_profile.ps1",
    "dotfiles/install.sh",
    "dotfiles/install.ps1"
)

# Создание папок
foreach ($dir in $dirs) { New-Item -ItemType Directory -Force -Path $dir }
Write-Host "Каталоги созданы."

# Создание .gitignore
New-Item -ItemType File -Force -Path "dotfiles/.gitignore" -Value $gitignoreContent | Out-Null
Write-Host ".gitignore обновлен."

# Создание пустых файлов
foreach ($file in $files) { if (!(Test-Path $file)) { New-Item -ItemType File -Force -Path $file } }
Write-Host "Пустые файлы созданы."

Write-Host "Инициализация завершена. Для настройки используйте install.ps1."
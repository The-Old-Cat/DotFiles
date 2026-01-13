#!/bin/bash
# Скрипт для создания структуры каталогов и файлов

echo "Создание структуры каталогов..."
mkdir -p dotfiles/{common/.config/oh-my-posh,linux,windows/Documents/PowerShell} && \
echo "Структура каталогов создана."

echo "Создание .gitignore..."
cat <<EOF > dotfiles/.gitignore
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
EOF
echo ".gitignore обновлен."

echo "Создание пустых файлов..."
touch dotfiles/common/.config/oh-my-posh/zen.toml \
      dotfiles/linux/.zshrc \
      dotfiles/linux/.aliases_linux \
      dotfiles/windows/Documents/PowerShell/Microsoft.PowerShell_profile.ps1 \
      dotfiles/install.sh \
      dotfiles/install.ps1
echo "Пустые файлы созданы."

echo "Инициализация завершена. Для настройки используйте install.sh или install.ps1."
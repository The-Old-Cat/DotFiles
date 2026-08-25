#!/bin/bash
# ~/.local/bin/chezmoi-reset

set -e

echo "🧹 Starting fresh install of dotfiles..."

# 1. Очистка
echo "Cleaning up old files..."
rm -rf ~/.local/share/chezmoi
rm -rf ~/.config/chezmoi
rm -f ~/.local/share/chezmoi-state.boltdb

# 2. Переустановка Chezmoi (опционально)
if ! command -v chezmoi >/dev/null 2>&1; then
    echo "Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
fi

# 3. Свежая установка
echo "Initializing fresh install..."
chezmoi init --apply The-Old-Cat

# 4. Применение
if [ "$(chezmoi data | jq -r '.chezmoi.os')" = "windows" ]; then
    echo "🪟 Applying on Windows (without scripts)..."
    chezmoi apply --exclude=scripts -v
else
    echo "🐧 Applying on Linux..."
    chezmoi apply -v
fi

echo "✅ Done!"

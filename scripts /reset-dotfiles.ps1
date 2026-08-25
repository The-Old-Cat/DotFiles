# reset-dotfiles.ps1

Write-Host "🧹 Starting fresh install of dotfiles..." -ForegroundColor Cyan

# 1. Очистка
Write-Host "Cleaning up old files..." -ForegroundColor Yellow
Remove-Item -Recurse -Force ~/.local/share/chezmoi -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force ~/.config/chezmoi -ErrorAction SilentlyContinue
Remove-Item -Force ~/.local/share/chezmoi-state.boltdb -ErrorAction SilentlyContinue

# 2. Установка Chezmoi (если нет)
if (-not (Get-Command chezmoi -ErrorAction SilentlyContinue)) {
    Write-Host "Installing chezmoi..." -ForegroundColor Yellow
    scoop install main/chezmoi
}

# 3. Свежая установка
Write-Host "Initializing fresh install..." -ForegroundColor Yellow
chezmoi init --apply The-Old-Cat

# 4. Применение (без скриптов)
Write-Host "🪟 Applying on Windows (without scripts)..." -ForegroundColor Yellow
chezmoi apply --exclude=scripts -v

Write-Host "✅ Done!" -ForegroundColor Green

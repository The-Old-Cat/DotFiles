#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() { printf '%s\n' "$*"; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1
}

install_packages() {
  # Минимальный набор для установки zsh/oh-my-zsh/p10k и шрифтов.
  # Примечание: имена пакетов могут отличаться в дистрибутивах.
  if require_cmd apt; then
    sudo apt update
    sudo apt install -y zsh git curl unzip fontconfig stow jq
  elif require_cmd dnf; then
    sudo dnf install -y zsh git curl unzip fontconfig stow jq
  elif require_cmd pacman; then
    sudo pacman -Syu --noconfirm zsh git curl unzip fontconfig stow jq
  else
    log "Не найден пакетный менеджер (apt/dnf/pacman). Установите вручную: zsh, git, curl, fontconfig, stow, jq."
    exit 1
  fi
}

install_oh_my_zsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    log "oh-my-zsh уже установлен: $HOME/.oh-my-zsh"
    return
  fi

  log "Установка oh-my-zsh..."
  # RUNZSH=no / CHSH=no — чтобы скрипт не пытался интерактивно переключить shell и не запускал zsh.
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_powerlevel10k() {
  local theme_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  if [[ -d "$theme_dir" ]]; then
    log "Powerlevel10k уже установлен: $theme_dir"
    return
  fi

  log "Установка Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$theme_dir"
}

install_omz_plugin() {
  local name="$1"
  local repo="$2"
  local dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$name"

  if [[ -d "$dir" ]]; then
    log "Плагин $name уже установлен: $dir"
    return
  fi

  log "Установка плагина $name..."
  git clone --depth=1 "$repo" "$dir"
}

install_meslo_nerd_font() {
  # Рекомендуемый набор шрифтов для Powerlevel10k.
  # Важно: нужно ещё выбрать этот шрифт в настройках терминала.
  if fc-list | grep -qi "MesloLGS NF"; then
    log "MesloLGS Nerd Font уже присутствует в системе."
    return
  fi

  log "Установка MesloLGS Nerd Font (локально в ~/.local/share/fonts)..."
  local fonts_dir="$HOME/.local/share/fonts"
  mkdir -p "$fonts_dir"
  curl -fL -o "$fonts_dir/MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
  curl -fL -o "$fonts_dir/MesloLGS NF Bold.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
  curl -fL -o "$fonts_dir/MesloLGS NF Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
  curl -fL -o "$fonts_dir/MesloLGS NF Bold Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
  fc-cache -fv
}

install_vscode_extensions() {
  if ! require_cmd code; then
    log "VSCode не установлен. Пропуск установки расширений."
    return
  fi

  local json_file="$DOTFILES_DIR/../extensions_recommendations.json"
  if [[ ! -f "$json_file" ]]; then
    log "Файл extensions_recommendations.json не найден."
    return
  fi

  log "Установка расширений VSCode для Python и PowerShell..."
  # Фильтруем расширения для Python и PowerShell
  local extensions
  extensions=$(jq -r '.recommendations[] | select(startswith("ms-python") or startswith("ms-toolsai") or startswith("ms-vscode.powershell") or startswith("tylerleonhardt"))' "$json_file")
  for ext in $extensions; do
    log "Установка расширения: $ext"
    code --install-extension "$ext" --force
  done
}

backup_if_regular_file() {
  local target="$1"
  if [[ -e "$target" && ! -L "$target" ]]; then
    local backup="$target.bak.$(date +%Y%m%d%H%M%S)"
    log "Бэкап: $target -> $backup"
    mv "$target" "$backup"
  fi
}

link_file() {
  local source="$1"
  local target="$2"

  if [[ ! -e "$source" ]]; then
    log "WARN: источник не найден, пропуск: $source"
    return
  fi

  mkdir -p "$(dirname "$target")"
  backup_if_regular_file "$target"
  ln -sfn "$source" "$target"
  log "Link: $target -> $source"
}

main() {
  log "DOTFILES_DIR=$DOTFILES_DIR"

  install_packages
  install_oh_my_zsh
  install_powerlevel10k

  install_omz_plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
  install_omz_plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting

  install_meslo_nerd_font
  install_vscode_extensions

  # Пробрасываем конфиги из репозитория
  link_file "$DOTFILES_DIR/linux/.zshrc" "$HOME/.zshrc"
  link_file "$DOTFILES_DIR/linux/.p10k.zsh" "$HOME/.p10k.zsh"
  link_file "$DOTFILES_DIR/linux/.aliases_linux" "$HOME/.aliases_linux"

  # oh-my-posh конфиг оставляем как опциональный (может быть нужен в bash/pwsh)
  link_file "$DOTFILES_DIR/common/.config/oh-my-posh/zen.toml" "$HOME/.config/oh-my-posh/zen.toml"

  log "Готово. Откройте новый терминал (или выполните 'zsh') и при необходимости запустите: p10k configure"
  log "Важно: выберите шрифт 'MesloLGS NF' (или любой Nerd Font) в настройках вашего терминала."
}

main "$@"

# DotFiles
DotFiles (файлы с точкой) - это конфигурационные файлы и скрипты, которые обычно хранятся в домашней директории пользователя (~) и начинаются с точки (.), что делает их скрытыми в Unix-подобных системах.

## Однострочники, которые гарантируют создание всей иерархии директорий сразу, чтобы избежать ошибок "path not found"

Вот готовые команды для обеих сред.

## 1. Для Linux или WSL (Bash) `start.sh`

Используйте флаг `-p` (parents), чтобы создать всю цепочку вложенных папок одной командой:

```bash
mkdir -p dotfiles/{common/.config/oh-my-posh,linux,windows/Documents/PowerShell} && \
    touch dotfiles/common/.config/oh-my-posh/zen.toml \
          dotfiles/linux/.zshrc \
          dotfiles/linux/.p10k.zsh \
          dotfiles/linux/.aliases_linux \
          dotfiles/windows/Documents/PowerShell/Microsoft.PowerShell_profile.ps1 \
          dotfiles/install.sh \
          dotfiles/install.ps1
```

---

## Установка (Linux/WSL): `install.sh`

Скрипт [`dotfiles/install.sh`](dotfiles/install.sh:1) рассчитан на запуск **в Linux/WSL** и делает следующее:

- устанавливает зависимости: `zsh`, `git`, `curl`, `fontconfig`, `stow` (через `apt/dnf/pacman`);
- устанавливает **Oh My Zsh**;
- ставит тему **Powerlevel10k** и плагины `zsh-autosuggestions` + `zsh-syntax-highlighting`;
- скачивает шрифт **MesloLGS Nerd Font** (нужен для корректных иконок в Powerlevel10k);
- создаёт симлинки в `$HOME` на файлы из `dotfiles/`:
  - `~/.zshrc` → `dotfiles/linux/.zshrc`
  - `~/.p10k.zsh` → `dotfiles/linux/.p10k.zsh`
  - `~/.aliases_linux` → `dotfiles/linux/.aliases_linux`

Запуск:

```bash
cd dotfiles
./install.sh
```

Важно: после установки выберите шрифт **MesloLGS NF** (или любой Nerd Font) в настройках вашего терминала.

---

## 2. Для Windows (PowerShell) `start.ps1`

Если вы находитесь в обычном терминале Windows (не WSL), используйте этот скрипт:

```powershell
$dirs = @(
    "dotfiles/common/.config/oh-my-posh",
    "dotfiles/linux",
    "dotfiles/windows/Documents/PowerShell"
)

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
# Создание пустых файлов
foreach ($file in $files) { New-Item -ItemType File -Force -Path $file }
```

---

### Установка PowerShell модулей

- **oh-my-posh**: Модуль для настройки внешнего вида терминала. Убедитесь, что он установлен и инициализирован.
- **posh-git**: Модуль для улучшения работы с Git в PowerShell, добавляет информацию о статусе репозитория в промпт.
- **Terminal-Icons**: Модуль для отображения иконок файлов и папок в терминале.
- **Devolutions.PowerShell**: Модуль для работы с Devolutions, который может быть полезен для управления удаленными соединениями.

### Проверка установленных модулей

Чтобы проверить, какие модули установлены, выполните команду:

```powershell
Get-Module -ListAvailable
```

### Обновление модулей

Для обновления модулей используйте:

```powershell
Update-Module oh-my-posh
Update-Module posh-git
Update-Module Terminal-Icons
```

### Проверка итогов выполнения

Чтобы проверить итог выполнения настройки Oh My Posh с использованием `zen.toml`, выполните следующие шаги:

### 1. Проверка установки Oh My Posh

Убедитесь, что Oh My Posh установлен, выполнив команду:

```powershell
oh-my-posh --version
```

Если команда возвращает версию, значит Oh My Posh установлен корректно.

### 2. Инициализация темы

Выполните команду для инициализации темы:

```powershell
oh-my-posh init pwsh --config $HOME/dotfiles/common/.config/oh-my-posh/zen.toml | Invoke-Expression
```

### 3. Проверка отображения

После выполнения команды откройте новый терминал или перезапустите текущий. Вы должны увидеть изменённый промпт с элементами, определёнными в `zen.toml` (например, информация о Git, путь, время и т.д.).

### 4. Проверка конфигурации

Если промпт не отображается корректно, проверьте:

- Путь к файлу `zen.toml` указан правильно
- Файл `zen.toml` содержит валидный JSON (несмотря на расширение .toml, текущий файл в формате JSON)
- Файл `zen.toml` содержит валидный TOML
- Шрифт терминала поддерживает Nerd Fonts (для корректного отображения иконок)

### 5. Диагностика

Для диагностики можно использовать:

```powershell
oh-my-posh debug
```

Эта команда покажет информацию о текущей конфигурации и возможных проблемах.

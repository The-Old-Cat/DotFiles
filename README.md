# Dotfiles

[![Managed by chezmoi](https://img.shields.io/badge/managed%20by-chezmoi-3b5c9b?logo=chezmoi&logoColor=white)](https://www.chezmoi.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Мои конфигурационные файлы (dotfiles) для управления настройками окружения в Unix-подобных системах (Debian/Ubuntu, Arch Linux, ALT Linux) и Windows. Управляются с помощью [Chezmoi](https://www.chezmoi.io/).

## 📖 Оглавление

- [📦 Структура репозитория](#-структура-репозитория)
- [🚀 Быстрый старт](#-быстрый-старт)
  - [Linux / WSL](#linux--wsl)
  - [Windows](#windows)
- [🔄 Ежедневное использование](#-ежедневное-использование)
- [📝 Работа с файлами](#-работа-с-файлами)
- [🔧 Run-Once скрипты](#-run-once-скрипты)
  - [Linux / WSL](#linux--wsl-1)
  - [Windows](#windows-1)
- [📊 Шаблоны и данные](#-шаблоны-и-данные)
- [🛠️ Технологии](#️-технологии)
- [👥 Использование сторонними пользователями](#-использование-сторонними-пользователями)
- [📚 Дополнительная информация](#-дополнительная-информация)

---

## 📦 Структура репозитория

```text
dotfiles/
 ├── .git/                                            # Git-метаданные
 ├── .chezmoiignore                                   # Файлы, игнорируемые chezmoi
 ├── .chezmoi.toml.tmpl                               # Шаблон конфига chezmoi
 ├── Documents/
 │   └── PowerShell/
 │       └── Microsoft.PowerShell_profile.ps1.tmpl    # → профиль PowerShell
 ├── dot_bash_logout                                  # → ~/.bash_logout
 ├── dot_bashrc                                       # → ~/.bashrc
 ├── dot_profile                                      # → ~/.profile
 ├── dot_gitconfig.tmpl                               # → ~/.gitconfig (шаблон)
 ├── private_dot_config/                              # → ~/.config/ (права 0600/0700)
 │   ├── chezmoi/
 │   │   └── chezmoi.toml                             # Конфиг chezmoi
 │   ├── helix/
 │   │   ├── config.toml                              # Конфиг редактора Helix
 │   │   └── themes/
 │   │       └── gruvbox.toml
 │   ├── starship/
 │   │   └── starship.toml                            # Конфиг Starship
 │   ├── tmux/
 │   │   └── tmux.conf                                # Конфиг tmux
 │   └── wezterm/
 │       └── wezterm.lua                              # Конфиг WezTerm
 ├── run_once_after_10-base-packages.sh.tmpl          # 10: Кросс-дистрибутивные базовые пакеты
 ├── run_once_after_15-windows-packages.ps1.tmpl      # 15: Пакеты Windows (Scoop)
 ├── run_once_after_20-helix.sh.tmpl                  # 20: Редактор Helix (из бинарного релиза)
 ├── run_once_after_30-hugo.sh.tmpl                   # 30: Генератор Hugo Extended (tar.gz)
 ├── run_once_after_40-uv.sh.tmpl                     # 40: Python-менеджер uv
 ├── run_once_after_50-wsl.sh.tmpl                    # 50: WSL-специфика (Docker)
 ├── run_once_after_60-wezterm.sh.tmpl                # 60: Терминал WezTerm (мульти-дистрибутивный)
 └── run_once_after_70-fonts.sh.tmpl                  # 70: JetBrainsMono Nerd Font

```

---

## 🚀 Быстрый старт

### Linux / WSL

1. **Установите Chezmoi, Git, gh:**
* *Debian / Ubuntu:*
```bash
sudo apt update && sudo apt install -y git gh

```

* *Arch Linux:*
```bash
sudo pacman -S --needed git github-cli

```


* *ALT Linux:*
```bash
sudo apt-get update && sudo apt-get install -y git-core gh

```




Установка Chezmoi:
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin

```


2. **Добавьте `~/.local/bin` в `PATH`:**
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

```


3. **Аутентификация в GitHub:**
```bash
gh auth login

```


4. **Инициализируйте и примените конфигурацию:**
```bash
chezmoi init --apply The-Old-Cat

```



### Windows

1. **Установите Scoop и chezmoi:**
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
iwr -useb get.scoop.sh | iex
scoop install main/chezmoi git gh

```


2. **Аутентификация в GitHub:**
```bash
gh auth login

```


3. **Инициализируйте и примените конфигурацию (в Git Bash или PowerShell):**
```bash
chezmoi init --apply The-Old-Cat

```



---

## 🔄 Ежедневное использование

| Команда | Описание |
| --- | --- |
| `chezmoi edit ~/.bashrc` | Открыть файл для редактирования в редакторе по умолчанию |
| `chezmoi diff` | Показать различия между исходными файлами и текущими в `$HOME` |
| `chezmoi apply -v` | Применить все изменения из исходного состояния в `$HOME` (с подробным выводом) |
| `chezmoi apply --dry-run -v` | **Безопасный режим:** показать, что будет изменено, без применения |
| `chezmoi update` | Получить последние изменения из удалённого репозитория и применить их |
| `chezmoi status` | Показать статус файлов (изменены, добавлены и т.д.) |
| `chezmoi cd && code .` | Перейти в директорию с исходными файлами и открыть её в VS Code |

---

## 📝 Работа с файлами

```bash
# Добавить один файл
chezmoi add ~/.bashrc

# Добавить файл и автоматически создать шаблон (подставив переменные)
chezmoi add --autotemplate ~/.gitconfig

# Добавить целую директорию рекурсивно
chezmoi add ~/.config/starship/

# Зафиксировать и отправить изменения
chezmoi cd
git add -A
git commit -m "feat: update starship configuration"
git push

```

---

## 🔧 Run-Once скрипты

Скрипты с префиксом `run_once_after_XX-` выполняются **только один раз** после первого применения (`chezmoi apply`) в порядке возрастания номера. Состояние их выполнения хранится в `~/.config/chezmoi/chezmoistate.boltdb`.

### Linux / WSL

#### `run_once_after_10-base-packages.sh.tmpl` — Базовые пакеты (Универсальный)

Автоматически определяет дистрибутив (**Debian/Ubuntu**, **Arch Linux**, **ALT Linux**) и использует соответствующий менеджер пакетов (`apt`, `pacman`, `apt-get` ALT) с корректным маппингом имен пакетов:

* **Системные:** `git`, `curl`, `wget`, `htop`, `jq`, `unzip`, `build-essential` / `base-devel` / `glibc-devel`
* **Безопасность и бэкапы:** `age`, `restic`
* **CLI-инструменты:** `gh`, `tmux`, `ripgrep`, `fzf`, `fd-find` / `fd`, `eza`, `micro`
* **Разработка:** `python3-pip` / `python-pip`, `golang-go` / `go` / `golang`
* **Шрифты:** `fontconfig`

#### `run_once_after_20-helix.sh.tmpl` — Редактор Helix

Устанавливает современный терминальный редактор Helix напрямую из архивных релизов GitHub для текущей архитектуры (`x86_64` / `aarch64`) без использования пакетных менеджеров.

#### `run_once_after_30-hugo.sh.tmpl` — Генератор сайтов Hugo Extended

Скачивает и распаковывает бинарный архив `hugo_extended` с поддержкой Sass/CGO из релизов GitHub напрямую в `/usr/local/bin` (универсально для всех дистрибутивов).

#### `run_once_after_40-uv.sh.tmpl` — Python-менеджер uv

Устанавливает `uv` — ультрабыстрый менеджер пакетов и окружений Python от Astral.

#### `run_once_after_50-wsl.sh.tmpl` — WSL-специфичные настройки

* Устанавливает `docker` для контейнеризации.
* Устанавливает `wsl-open` для интеграции с Windows.

#### `run_once_after_60-wezterm.sh.tmpl` — Терминал WezTerm

Устанавливает WezTerm с учетом текущей ОС: подключает PPA `apt.fury.io` для Debian/Ubuntu либо использует штатный `pacman` / `apt-get` для Arch и ALT Linux.

#### `run_once_after_70-fonts.sh.tmpl` — Шрифты

Скачивает и распаковывает JetBrainsMono-NF (Nerd Font) в пользовательскую директорию `~/.local/share/fonts/` и обновляет кэш шрифтов через `fc-cache`.

---

### Windows

#### `run_once_after_15-windows-packages.ps1.tmpl` — Windows-пакеты (Scoop)

Устанавливает пакеты через Scoop:

* **Основные инструменты:** `git`, `gh`, `pwsh`, `vscode`, `windows-terminal`, `wezterm`, `curl`, `wget`, `aria2`, `7zip`, `sudo`, `grep`
* **CLI-улучшения:** `jq`, `yq`, `fd`, `ripgrep`, `fzf`, `zoxide`, `starship`, `dust`, `procs`, `bat`, `lsd`
* **Сеть и утилиты:** `nmap`, `curlie`, `yt-dlp`, `ffmpeg`, `advanced-ip-scanner`
* **Разработка:** `nodejs-lts`, `go`, `uv`
* **Безопасность и продуктивность:** `bitwarden-cli`, `obsidian`, `flow-launcher`, `restic`
* **Sysinternals:** `process-explorer`, `autoruns`, `tcpview`, `handle`, `du`, `procmon`, `psservice`, `rammap`, `sysmon`
* **Шрифты Nerd Fonts:** `Cascadia-Code`, `JetBrainsMono-NF`, `JetBrainsMono-NF-Mono`

**Автоматическая настройка:**

* Регистрация VS Code в системе (контекстное меню, ассоциации файлов)
* Создание и настройка базового `Microsoft.PowerShell_profile.ps1`

---

### Примеры работы с run_once скриптами

```bash
# Просмотр сгенерированного скрипта для текущего хоста
chezmoi cd
chezmoi execute-template < run_once_after_10-base-packages.sh.tmpl

# Симуляция выполнения на Windows
chezmoi cd
chezmoi execute-template --init --promptString "os=windows,hostname=WIN-PC" \
  < run_once_after_15-windows-packages.ps1.tmpl

# Ручной запуск сгенерированного скрипта (Linux)
chezmoi cd
chezmoi execute-template < run_once_after_10-base-packages.sh.tmpl | bash

# Ручной запуск сгенерированного скрипта (Windows)
chezmoi cd
chezmoi execute-template < run_once_after_15-windows-packages.ps1.tmpl | powershell -Command -

```

---

## 📊 Шаблоны и данные

Chezmoi использует шаблоны Go для генерации конфигурационных файлов. Вы можете просмотреть все доступные переменные с помощью команды:

```bash
chezmoi data

```

**Пример вывода:**

```json
{
  "chezmoi": {
    "hostname": "my-laptop",
    "os": "linux",
    "arch": "amd64",
    "username": "yourname",
    "homeDir": "/home/yourname"
  },
  "email": "your.email@example.com",
  "name": "Your Name"
}

```

Эти переменные используются в шаблонах (файлы с расширением `.tmpl`). Например, в `dot_gitconfig.tmpl`:

```ini
[user]
    name = {{ .name }}
    email = {{ .email }}

```

---

## 🛠️ Технологии

* **[Chezmoi](https://www.chezmoi.io/)** — менеджер dotfiles
* **[Git](https://git-scm.com/)** — система контроля версий
* **[GitHub CLI (gh)](https://cli.github.com/)** — для аутентификации и работы с GitHub
* **[VS Code](https://code.visualstudio.com/)** — редактор по умолчанию
* **[Helix](https://helix-editor.com/)** — современный терминальный редактор
* **[tmux](https://github.com/tmux/tmux/wiki)** — терминальный мультиплексор
* **[WezTerm](https://wezfurlong.org/wezterm/)** — кроссплатформенный терминал
* **[Windows Terminal](https://github.com/microsoft/terminal)** — терминал для Windows
* **[Scoop](https://scoop.sh/)** — менеджер пакетов для Windows
* **[Starship](https://starship.rs/)** — кастомный промпт для оболочки
* **[uv](https://github.com/astral-sh/uv)** — быстрый менеджер пакетов для Python
* **[Hugo](https://gohugo.io/)** — генератор статических сайтов
* **[age](https://github.com/FiloSottile/age)** — шифрование файлов
* **[restic](https://restic.net/)** — резервное копирование

---

## 👥 Использование сторонними пользователями

Этот репозиторий создан для **личного использования** и публикуется в ознакомительных целях.

### ⚠️ Важные предупреждения

* **Личные данные:** Файлы `dot_gitconfig.tmpl` и `.chezmoi.toml.tmpl` содержат шаблоны с моими именем и email. Обязательно замените их на свои.
* **Специфичные настройки:** Некоторые скрипты содержат условную логику для моих конкретных хостов. Список устанавливаемых пакетов подобран под мои нужды.
* **Запуск скриптов:** Будьте осторожны с `run_once_*` скриптами — они устанавливают пакеты и изменяют систему. Всегда проверяйте их содержимое: `chezmoi cat <file>` или `chezmoi execute-template < <file>`. На Windows используйте `chezmoi apply --exclude=scripts` для безопасности.

### 🚀 Как использовать (адаптация под себя)

1. **Форкните репозиторий** на GitHub.
2. **Клонируйте свой форк:**
```bash
git clone [https://github.com/](https://github.com/)<ваш-username>/dotfiles.git

```


3. **Замените персональные данные** в файлах:
* `.chezmoi.toml.tmpl`
* `dot_gitconfig.tmpl`
* Других шаблонах с `{{ .name }}` и `{{ .email }}`


4. **Отредактируйте скрипты** под свои нужды (удалите лишние хосты и пакеты).
5. **Примените настройки:**
```bash
chezmoi init --apply <ваш-username>

```



### 💡 Рекомендации

* Всегда проверяйте изменения: `chezmoi diff`
* Используйте `chezmoi apply --dry-run --verbose` перед применением
* На Windows для безопасности: `chezmoi apply --exclude=scripts`
* Не клонируйте репозиторий вручную в `~/dotfiles` — используйте только source-директорию Chezmoi (`~/.local/share/chezmoi`)

---

## 📚 Дополнительная информация

* Официальная документация: [chezmoi.io](https://www.chezmoi.io/)
* Лицензия: [MIT](https://opensource.org/licenses/MIT) (используйте как основу для своих настроек)

# Dotfiles

[![Chezmoi](https://img.shields.io/badge/managed%20by-chezmoi-3b5c9b?logo=chezmoi)](https://www.chezmoi.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Мои конфигурационные файлы (dotfiles) для управления настройками окружения в Unix-подобных системах и Windows. Управляются с помощью [Chezmoi](https://www.chezmoi.io/).

## 📖 Оглавление

- [📦 Структура репозитория](#-структура-репозитория)
- [🚀 Быстрый старт](#-быстрый-старт)
  - [Linux / macOS / WSL](#linux--macos--wsl)
  - [Windows](#windows)
- [🔄 Ежедневное использование](#-ежедневное-использование)
- [📝 Работа с файлами](#-работа-с-файлами)
- [🔧 Run-Once скрипты](#-run-once-скрипты)
- [📊 Шаблоны и данные](#-шаблоны-и-данные)
- [🛠️ Технологии](#️-технологии)
- [📚 Дополнительная информация](#-дополнительная-информация)

## 📦 Структура репозитория

```text
dotfiles/
├── .chezmoi.toml.tmpl                 # Шаблон конфигурации chezmoi
├── .chezmoiignore                     # Файлы и папки, игнорируемые chezmoi
├── dot_bashrc                         # ~/.bashrc
├── dot_bash_logout                    # ~/.bash_logout
├── dot_profile                        # ~/.profile
├── dot_gitconfig.tmpl                 # ~/.gitconfig (с шаблонами для имени и email)
├── private_dot_config/                # Содержимое ~/.config/
│   ├── chezmoi/
│   │   └── chezmoi.toml              # Конфиг chezmoi (управляется через шаблон)
│   ├── tmux/                         # Конфигурация терминального мультиплексора tmux
│   └── alacritty/                    # Конфигурация терминала Alacritty
├── run_once_after_10-base-packages.sh.tmpl  # Установка базовых пакетов (Linux)
└── run_once_after_20-windows-packages.ps1.tmpl # Установка пакетов (Windows)
```

## 🚀 Быстрый старт

### Linux / macOS / WSL

1. **Установите Chezmoi:**
   ```bash
   sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
   ```

2. **Добавьте `~/.local/bin` в `PATH` (если еще не добавлен):**
   ```bash
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```

3. **Инициализируйте и примените конфигурацию:**
   ```bash
   chezmoi init --apply The-Old-Cat
   ```
   Эта команда клонирует репозиторий, сгенерирует файлы из шаблонов и применит их в вашем `$HOME`.

### Windows

1. **Установите Scoop (менеджер пакетов):**
   ```powershell
   Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
   iwr -useb get.scoop.sh | iex
   ```

2. **Установите необходимые пакеты через Scoop:**
   ```powershell
   scoop install chezmoi git gh vscode
   scoop bucket add nerd-fonts
   scoop install Hasklig-NF # Установите ваш любимый шрифт с Nerd Fonts
   ```

3. **Инициализируйте и примените конфигурацию (в Git Bash):**
   ```bash
   chezmoi init --apply The-Old-Cat
   ```
   ```powershell
   gh auth login # Для аутентификации в GitHub
   ```

## 🔄 Ежедневное использование

| Команда | Описание |
| :--- | :--- |
| `chezmoi edit ~/.bashrc` | Открыть файл для редактирования в редакторе по умолчанию. |
| `chezmoi diff` | Показать различия между исходными файлами и текущими в `$HOME`. |
| `chezmoi apply -v` | Применить все изменения из исходного состояния в `$HOME` (с подробным выводом). |
| `chezmoi update` | Получить последние изменения из удаленного репозитория и применить их. |
| `chezmoi status` | Показать статус файлов (изменены, добавлены и т.д.). |
| `chezmoi cd && code .` | Перейти в директорию с исходными файлами и открыть её в VS Code. |

## 📝 Работа с файлами

```bash
# Добавить один файл
chezmoi add ~/.bashrc

# Добавить файл и автоматически создать шаблон, заменяя переменные (например, имя и email)
chezmoi add --autotemplate ~/.gitconfig

# Добавить целую директорию
chezmoi add ~/.config/nvim/

# Зафиксировать и отправить изменения в удаленный репозиторий
chezmoi cd
git add -A
git commit -m "feat: update nvim configuration"
git push
```

## 🔧 Run-Once скрипты

Скрипты с префиксом `run_once_` выполняются только один раз после первого применения (`chezmoi apply`). Состояние их выполнения хранится в `~/.config/chezmoi/chezmoistate.boltdb`.

- **`run_once_after_10-base-packages.sh.tmpl`**: Устанавливает базовые пакеты для Linux (Ubuntu/Debian) с помощью `apt-get` (git, curl, wget, htop, jq, age, restic, gh, docker.io). Использует Go-шаблоны для условной логики в зависимости от ОС и имени хоста.
- **`run_once_after_20-windows-packages.ps1.tmpl`**: Устанавливает пакеты для Windows с помощью `winget` (Git.Git, GitHub.cli, Microsoft.PowerShell и др.) и `scoop`.

**Примеры работы с run_once скриптами:**

```bash
# Просмотр сгенерированного скрипта для текущего хоста
chezmoi execute-template < run_once_after_10-base-packages.sh.tmpl

# Симуляция выполнения на Windows
chezmoi execute-template --init --promptString "os=windows,hostname=WIN-PC" < run_once_after_20-windows-packages.ps1.tmpl

# Ручной запуск сгенерированного скрипта
chezmoi execute-template < run_once_after_10-base-packages.sh.tmpl | bash
```

## 📊 Шаблоны и данные

Chezmoi использует шаблоны Go для генерации конфигурационных файлов. Вы можете просмотреть все доступные переменные с помощью команды:

```bash
chezmoi data
```

Пример вывода:
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

## 🛠️ Технологии

- **[Chezmoi](https://www.chezmoi.io/)** — менеджер dotfiles.
- **[Git](https://git-scm.com/)** — система контроля версий.
- **[GitHub CLI (gh)](https://cli.github.com/)** — для аутентификации и работы с GitHub.
- **[VS Code](https://code.visualstudio.com/)** — редактор по умолчанию.
- **[tmux](https://github.com/tmux/tmux/wiki)** — терминальный мультиплексор.
- **[Alacritty](https://alacritty.org/)** — быстрый терминал с GPU-рендерингом.

## 📚 Дополнительная информация

- Подробный конспект по Chezmoi: [Chezmoi.md](./Chezmoi.md)
- Официальная документация Chezmoi: [chezmoi.io](https://www.chezmoi.io/)

---

**Лицензия**: Этот репозиторий создан для личного использования.
Вы можете использовать его как основу для своих собственных настроек.

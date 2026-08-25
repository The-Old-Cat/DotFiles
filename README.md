# Dotfiles

[![Chezmoi](https://img.shields.io/badge/managed%20by-chezmoi-3b5c9b?logo=chezmoi)](https://www.chezmoi.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Мои конфигурационные файлы (dotfiles) для управления настройками окружения в Unix-подобных системах и Windows. Управляются с помощью [Chezmoi](https://www.chezmoi.io/).

## 📖 Оглавление

- [📦 Структура репозитория](#-структура-репозитория)
- [🚀 Быстрый старт](#-быстрый-старт)
  - [Linux / WSL](#linux-wsl)
  - [Windows](#windows)
- [🔄 Ежедневное использование](#-ежедневное-использование)
- [📝 Работа с файлами](#-работа-с-файлами)
- [🔧 Run-Once скрипты](#-run-once-скрипты)
- [📊 Шаблоны и данные](#-шаблоны-и-данные)
- [🛠️ Технологии](#️-технологии)
- [👥 Использование сторонними пользователями](#-использование-сторонними-пользователями)
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
│   │   └── chezmoi.toml              # Конфиг chezmoi
│   ├── helix/
│   │   ├── config.toml               # Конфиг редактора Helix
│   │   └── themes/                   # Пользовательские темы
│   │       └── gruvbox.toml
│   ├── starship/
│   │   └── starship.toml             # Конфиг Starship
│   ├── tmux/
│   │   └── tmux.conf                 # Конфиг tmux
│   └── wezterm/
│       └── wezterm.lua               # Конфиг WezTerm (кроссплатформенный)
├── run_once_after_10-base-packages.sh.tmpl  # Установка пакетов (Linux/WSL)
└── run_once_after_20-windows-packages.ps1.tmpl # Установка пакетов (Windows)
```

## 🚀 Быстрый старт

### Linux / WSL

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

### Windows

1. **Установите Scoop (менеджер пакетов) и chezmoi :**
   ```powershell
   Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
   iwr -useb get.scoop.sh | iex
   scoop install main/chezmoi git gh
   ```

2. **Инициализируйте и примените конфигурацию (в Git Bash):**
   ```bash
   chezmoi init --apply The-Old-Cat
   ```

3. **Аутентификация в GitHub:**
   ```powershell
   gh auth login
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
chezmoi add ~/.config/helix/

# Зафиксировать и отправить изменения в удаленный репозиторий
chezmoi cd
git add -A
git commit -m "feat: update helix configuration"
git push
```

## 🔧 Run-Once скрипты

Скрипты с префиксом `run_once_` выполняются только один раз после первого применения (`chezmoi apply`). Состояние их выполнения хранится в `~/.config/chezmoi/chezmoistate.boltdb`.

### Linux / WSL (`run_once_after_10-base-packages.sh.tmpl`)

#### 1. Базовые пакеты (16 пакетов)
| Пакет | Описание |
| :--- | :--- |
| `git` | Система контроля версий |
| `curl` | Передача данных по URL |
| `wget` | Загрузка файлов |
| `htop` | Интерактивный монитор процессов |
| `jq` | Обработка JSON в командной строке |
| `age` | Инструмент шифрования файлов |
| `restic` | Резервное копирование |
| `gh` | GitHub CLI |
| `unzip` | Распаковка ZIP-архивов |
| `tmux` | Терминальный мультиплексор |
| `fontconfig` | Утилиты для настройки и управления шрифтами |
| `build-essential` | Пакет компиляторов и утилит для сборки ПО |
| `python3-pip` | Менеджер пакетов Python |
| `ripgrep` | Быстрый поиск в файлах |
| `fzf` | Fuzzy-поиск в командной строке |
| `fd-find` | Альтернатива find |
| `golang-go` | Компилятор и инструменты для Go |

#### 2. Терминалы и редакторы (2 пакета)
| Пакет | Описание |
| :--- | :--- |
| `wezterm` | Терминал с GPU-рендерингом (только для нативного Linux, пропускается в WSL) |
| `helix` | Текстовый редактор (устанавливается из официальных релизов без Snap) |

#### 3. Python-инструменты (2 компонента)
| Компонент | Описание |
| :--- | :--- |
| `uv` | Быстрый менеджер пакетов и окружений Python |
| `python 3.12` | Интерпретатор Python версии 3.12 |

#### 4. Шрифты (1 пакет)
| Пакет | Описание |
| :--- | :--- |
| `JetBrainsMono-NF` | Шрифт JetBrains Mono с иконками Nerd Font (только для нативного Linux, пропускается в WSL) |

#### 5. Специфичные компоненты по окружениям (4 пакета)
| Условие / Окружение | Пакеты / Компоненты | Описание |
| :--- | :--- | :--- |
| **WSL** | `docker`, `wsl-open` | Контейнеризация и открытие ссылок/файлов в Windows из WSL |
| **Proxmox** | `pve-manager-tools`, `qemu-guest-agent` | Утилиты управления PVE и агент интеграции с гипервизором |
### Windows (`run_once_after_20-windows-packages.ps1.tmpl`)

#### 📦 Пакеты (Windows, scoop)

#### 1. Основные инструменты (18 пакетов)
| Пакет | Описание |
| :--- | :--- |
| `git` | Система контроля версий |
| `gh` | GitHub CLI |
| `fd` | Альтернатива find |
| `ripgrep` | Быстрый поиск в файлах |
| `fzf` | Fuzzy-поиск в командной строке |
| `restic` | Резервное копирование |
| `windows-terminal` | Современный терминал от Microsoft |
| `wezterm` | Терминал с GPU-рендерингом |
| `uv` | Быстрый менеджер пакетов Python |
| `advanced-ip-scanner` | Сканер сети |
| `unlocker` | Разблокировка файлов |
| `pwsh` | PowerShell 7 |
| `vscode` | Редактор кода |
| `curl` | Передача данных по URL |
| `sudo` | Выполнение команд с правами администратора |
| `grep` | Поиск текста |
| `aria2` | Многопоточная загрузка |
| `7zip` | Архиватор |

#### 2. CLI-улучшения (7 пакетов)
| Пакет | Описание |
| :--- | :--- |
| `jq` | Обработка JSON в командной строке |
| `yq` | Обработка YAML/TOML/XML |
| `zoxide` | Быстрая навигация по директориям |
| `dust` | Анализ использования диска |
| `procs` | Альтернатива ps |
| `bat` | cat с подсветкой синтаксиса |
| `starship` | Минималистичный промпт для оболочки |
| `lsd` | Современная альтернатива ls с иконками и цветами |

#### 3. Сеть и утилиты (5 пакетов)
| Пакет | Описание |
| :--- | :--- |
| `nmap` | Сканирование портов и сети |
| `curlie` | curl с человеческим интерфейсом |
| `wget` | Загрузка файлов |
| `yt-dlp` | Загрузка видео с YouTube |
| `ffmpeg` | Обработка видео/аудио |

#### 4. Безопасность и продуктивность (3 пакета)
| Пакет | Описание |
| :--- | :--- |
| `bitwarden-cli` | Менеджер паролей (CLI) |
| `obsidian` | База знаний в Markdown |
| `flow-launcher` | Быстрый запуск приложений |

#### 5. Разработка (2 пакета)
| Пакет | Описание |
| :--- | :--- |
| `nodejs-lts` | Node.js LTS версия |
| `go` | Язык программирования Go |

#### 6. Sysinternals (9 пакетов)
| Пакет | Описание |
| :--- | :--- |
| `process-explorer` | Расширенный диспетчер задач |
| `autoruns` | Управление автозагрузкой |
| `tcpview` | Мониторинг TCP-соединений |
| `handle` | Информация о открытых файлах |
| `du` | Анализ использования диска |
| `procmon` | Мониторинг процессов |
| `psservice` | Управление сервисами |
| `rammap` | Анализ использования памяти |
| `sysmon` | Системный мониторинг |

#### 7. Шрифты Nerd Fonts (3 пакета)
| Пакет | Описание |
| :--- | :--- |
| `Cascadia-Code` | Шрифт от Microsoft |
| `JetBrainsMono-NF` | Шрифт для разработчиков |
| `JetBrainsMono-NF-Mono` | Моноширинная версия |
**Автоматическая настройка:**
- Регистрация VS Code в системе (контекстное меню, ассоциации файлов, интеграция с GitHub)
- Создание Microsoft.PowerShell_profile.ps1

### Примеры работы с run_once скриптами

```bash
# Просмотр сгенерированного скрипта для текущего хоста
chezmoi cd
chezmoi execute-template < run_once_after_10-base-packages.sh.tmpl

# Симуляция выполнения на Windows
chezmoi cd
chezmoi execute-template --init --promptString "os=windows,hostname=WIN-PC" < run_once_after_20-windows-packages.ps1.tmpl

# Ручной запуск сгенерированного скрипта (Linux)
chezmoi cd
chezmoi execute-template < run_once_after_10-base-packages.sh.tmpl | bash

# Ручной запуск сгенерированного скрипта (Windows)
chezmoi cd
chezmoi execute-template < run_once_after_20-windows-packages.ps1.tmpl | powershell -Command -
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
- **[Helix](https://helix-editor.com/)** — современный терминальный редактор.
- **[tmux](https://github.com/tmux/tmux/wiki)** — терминальный мультиплексор.
- **[WezTerm](https://wezfurlong.org/wezterm/)** — кроссплатформенный терминал с мультиплексором.
- **[Windows Terminal](https://github.com/microsoft/terminal)** — современный терминал для Windows.
- **[Scoop](https://scoop.sh/)** — менеджер пакетов для Windows.
- **[Starship](https://starship.rs/)** — кастомный промпт для оболочки.
- **[uv](https://github.com/astral-sh/uv)** — быстрый менеджер пакетов для Python.
- **[age](https://github.com/FiloSottile/age)** — простое и современное шифрование файлов.
- **[restic](https://restic.net/)** — резервное копирование с шифрованием.

## 👥 Использование сторонними пользователями

Этот репозиторий создан для личного использования и **публикуется в ознакомительных целях**. Вы можете использовать его как основу или вдохновение для создания собственных dotfiles, но **прямое копирование без изменений не рекомендуется**, так как он содержит персональные настройки, пути и специфичную логику.

### ⚠️ Важные предупреждения

1. **Личные данные**:
   - Файлы, такие как `dot_gitconfig.tmpl` и `.chezmoi.toml.tmpl`, содержат шаблоны с моими именем и email. **Обязательно замените их на свои**.
   - В некоторых скриптах могут быть захардкожены имена хостов и пользователей.

2. **Специфичные настройки**:
   - Некоторые скрипты (например, `run_once_after_10-base-packages.sh.tmpl`) содержат условную логику для моих конкретных хостов . Они могут не работать или устанавливать ненужные пакеты на ваших машинах.
   - Список устанавливаемых пакетов подобран под мои нужды и может не совпадать с вашими.

3. **Запуск скриптов**:
   - Будьте **крайне осторожны** с `run_once_*` скриптами — они устанавливают пакеты и изменяют систему.
   - **Всегда** проверяйте их содержимое перед применением (`chezmoi cat <file>` или `chezmoi execute-template < <file>`).
   - На Windows используйте `chezmoi apply --exclude=scripts`, чтобы избежать случайного выполнения bash-скриптов.

### 🚀 Как использовать (адаптация под себя)

Если вы хотите использовать этот репозиторий как основу для своих dotfiles:

1. **Форкните репозиторий** на GitHub.
2. **Клонируйте** свой форк на локальную машину:
   ```bash
   git clone https://github.com/<ваш-username>/dotfiles.git
   ```
3. **Замените** персональные данные (имя, email) в файлах:
   - `.chezmoi.toml.tmpl`
   - `dot_gitconfig.tmpl`
   - Любых других шаблонах, где встречаются `{{ .name }}` и `{{ .email }}`.
4. **Удалите** или **отредактируйте** скрипты и конфиги, которые вам не нужны.
5. **Измените** или **удалите** условные проверки на хосты под свои.
6. **Адаптируйте** списки пакетов в `run_once_after_10-base-packages.sh.tmpl` и `run_once_after_20-windows-packages.ps1.tmpl` под свои нужды.

После адаптации вы можете использовать Chezmoi для применения настроек:

```bash
# Инициализация и применение
chezmoi init --apply <ваш-username>
```

### 📝 Рекомендации

- **Прочитайте** документацию [Chezmoi](https://www.chezmoi.io/), чтобы понимать, как работают шаблоны и скрипты.
- **Всегда проверяйте** изменения перед применением: `chezmoi diff`.
- **Используйте** `chezmoi apply --dry-run --verbose`, чтобы увидеть, что именно будет сделано.
- На Windows для безопасности используйте `chezmoi apply --exclude=scripts`.
- **Не клонируйте** репозиторий вручную в `~/dotfiles` — используйте только source-директорию Chezmoi (`~/.local/share/chezmoi`).

## 📚 Дополнительная информация

- Официальная документация Chezmoi: [chezmoi.io](https://www.chezmoi.io/)

---

**Лицензия**: Этот репозиторий создан для личного использования. Вы можете использовать его как основу для своих собственных настроек.

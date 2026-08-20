# Dotfiles

Мои конфигурационные файлы под управлением [Chezmoi](https://www.chezmoi.io/).

## 📦 Что внутри

```
dotfiles/
├── .chezmoi.toml.tmpl                 # Шаблон конфига chezmoi (генерируется на каждом хосте)
├── .chezmoiignore                     # Исключения (что не применять в home)
├── README.md                          # Этот файл
├── dot_bashrc                         # ~/.bashrc
├── dot_bash_logout                    # ~/.bash_logout
├── dot_profile                        # ~/.profile
├── dot_gitconfig.tmpl                 # ~/.gitconfig (шаблон с {{ .name }} / {{ .email }})
├── private_dot_config/                # ~/.config/
│   ├── chezmoi/
│   │   └── chezmoi.toml              # Конфиг chezmoi (managed через шаблон)
│   ├── tmux/                         # Tmux
│   └── alacritty/                    # Alacritty terminal
└── run_once_after_10-base-packages.sh.tmpl  # Установка пакетов (Linux/Windows)
```

## 🚀 Быстрый старт

## Установка Chezmoi Linux

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```
## Windows (без winget)

### 1. Scoop

```powershell
# Разрешить скрипты (один раз на юзера)
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force

# Установить scoop
iwr -useb get.scoop.sh | iex

# Валидация
scoop --version
scoop help
```

### 2. Пакеты и шрифты

```powershell
# Установка
scoop install chezmoi
scoop install git gh vscode
scoop bucket add nerd-fonts
scoop install Hasklig-NF
```

### 3. Инициализация (Git Bash)

```bash
chezmoi init --apply The-Old-Cat
gh auth login
```
### Применение конфигурации

```bash
chezmoi init --apply The-Old-Cat
```

Это:
1. Склонирует репозиторий в `~/.local/share/chezmoi`
2. Сгенерирует `~/.config/chezmoi/chezmoi.toml` из `.chezmoi.toml.tmpl`
3. Применит все dotfiles в `$HOME`
4. Выполнит `run_once` скрипты (установка пакетов)

## 🔄 Повседневная работа

```bash
# Редактировать файл
chezmoi edit ~/.bashrc

# Посмотреть изменения (dry-run)
chezmoi diff

# Применить изменения
chezmoi apply -v

# Подтянуть обновления из репозитория
chezmoi update

# Статус синхронизации
chezmoi status

# Открыть source как проект в VS Code
chezmoi cd && code .
```

## 📝 Добавление новых файлов

```bash
chezmoi add ~/.bashrc                    # один файл
chezmoi add --autotemplate ~/.gitconfig  # с автозаменой на {{ .name }}
chezmoi add ~/.config/nvim/              # директория целиком

# Коммит и пуш
chezmoi cd
git add -A
git commit -m "feat: add nvim config"
git push
```

## 🔧 Run-once скрипты

Выполняются один раз на каждом хосте при первом `apply`. Состояние хранится в `~/.config/chezmoi/chezmoistate.boltdb`.

### Условная логика

Скрипт `run_once_after_10-base-packages.sh.tmpl` поддерживает Go-шаблоны:

- **Linux (Ubuntu/Debian)**: `apt-get install` (git, curl, wget, htop, jq, age, restic, gh, docker.io для WSL)
- **Windows**: `winget install` (Git.Git, GitHub.cli, и другие)
- **Proxmox-хосты**: `pve-manager-tools` (определяется по hostname)

### Валидация рендера

```bash
# Текущий хост
chezmoi execute-template < run_once_after_10-base-packages.sh.tmpl

# Симуляция Windows
chezmoi execute-template --init --promptString "os=windows,hostname=WIN-PC" \
    < run_once_after_10-base-packages.sh.tmpl

# Ручной запуск
chezmoi execute-template < run_once_after_10-base-packages.sh.tmpl | bash
```

## 📊 Шаблоны и данные

Доступные переменные в `.tmpl` файлах (проверка: `chezmoi data`):

```json
{
  "chezmoi": {
    "hostname": "ADM00-01IT",
    "os": "linux",
    "arch": "amd64",
    "username": "artkov",
    "homeDir": "/home/artkov"
  },
  "email": "artkov476@gmail.com",
  "name": "The-Old-Cat"
}
```

Пример использования в `.chezmoi.toml.tmpl`:

```toml
[edit]
{{- if eq .chezmoi.os "darwin" }}
    command = "open"
    args = ["-W"]
{{- else }}
    command = "code"
    args = ["--wait"]
{{- end }}

[data]
    name = "The-Old-Cat"
    email = "artkov476@gmail.com"
```

## 🏗️ На новом компьютере

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
~/.local/bin/chezmoi init --apply The-Old-Cat
```

После логина в GitHub CLI (`gh auth login`):

```bash
chezmoi cd
git remote set-url origin git@github.com:The-Old-Cat/dotfiles.git
```

## 📚 Документация

Подробный конспект: [Chezmoi.md](./Chezmoi.md)

## 🛠️ Технологии

- **Chezmoi 2.72.0** — управление dotfiles
- **Git** — версионирование
- **GitHub CLI (gh)** — аутентификация и credential helper
- **VS Code** — редактор по умолчанию (`code --wait`)
- **Ubuntu 26.04 LTS / WSL2** — основная среда
- **Age** — шифрование секретов (в планах)

## 📄 Лицензия

Этот репозиторий создан для личного использования.

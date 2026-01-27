# Создаем папку для бэкапов, если её нет
mkdir "$HOME\Documents\WSL_Backups" -ErrorAction SilentlyContinue

# Экспортируем Ubuntu в файл
wsl --export Ubuntu-24.04 "$HOME\Documents\WSL_Backups\Ubuntu_24_04_Ollama_Ready.tar"

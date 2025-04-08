#!/bin/bash

set -e

# Цвета для логирования
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
  LOG_LEVEL=$1
  case $LOG_LEVEL in
    error)
      COLOR=$RED
      ;;
    info)
      COLOR=$GREEN
      ;;
    warning)
      COLOR=$YELLOW
      ;;
    step)
      COLOR=$BLUE
      ;;
  esac

  timestamp="$(date +"%Y/%m/%d %H:%M:%S")"
  echo -e "$timestamp [$LOG_LEVEL] $0: ${COLOR}$2${NC}"
}

# Создание директории для бэкапа, если она не существует
create_backup_dir() {
  if ! [ -d ~/.dotfiles_backup ]; then
    log info "Создание директории для бэкапа ~/.dotfiles_backup"
    mkdir -p ~/.dotfiles_backup
  fi
}

# Функция для создания символических ссылок
link_file() {
  source_file=$1
  target_file=$2
  
  if [ -f "$target_file" ] && ! [ -L "$target_file" ]; then
    create_backup_dir
    log info "Бэкап существующего файла $target_file в ~/.dotfiles_backup/"
    mv "$target_file" ~/.dotfiles_backup/
  fi
  
  if ! [ -L "$target_file" ]; then
    log info "Создание символической ссылки для $target_file"
    ln -sf "$source_file" "$target_file"
  else
    log info "Символическая ссылка для $target_file уже существует"
  fi
}

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Установка Homebrew
install_homebrew() {
  log step "Установка и настройка Homebrew"
  if ! [ -x "$(command -v brew)" ]; then
    log info "Установка Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Добавление Homebrew в PATH
    if [[ $(uname -m) == "arm64" ]]; then
      echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> /Users/$USER/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv)"
    else
      echo 'eval $(/usr/local/bin/brew shellenv)' >> /Users/$USER/.zprofile
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  else
    log info "Homebrew уже установлен"
  fi
  
  # Обновление Homebrew
  log info "Обновление Homebrew"
  brew update
}

# Установка программ через Homebrew
install_packages() {
  log step "Установка необходимых программ"
  
  # Список программ для установки
  PACKAGES=(
    # базовые пакеты
    "git"
    "npm"
    "neovim"
    "tmux"
    "ripgrep"
    "fd"
    "fzf"
    "eza"
    "jq"
    "htop"
    "gotop"
    "wget"
    "zsh"
    # python tools
    "virtualenvwrapper"
    # devops tools
    "kubectl"
    "helm"
    "colima"
    "docker"
    "minikube"
  )
  
  for package in "${PACKAGES[@]}"; do
    if brew list "$package" &>/dev/null; then
      log info "$package уже установлен"
    else
      log info "Установка $package"
      brew install "$package"
    fi
  done
}

# Настройка Oh My Zsh
setup_oh_my_zsh() {
  log step "Настройка Oh My Zsh"
  
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log info "Установка Oh My Zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  else
    log info "Oh My Zsh уже установлен"
  fi
  
  # Установка плагинов
  ZSH_PLUGINS=(
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
    "zsh-kubectl-prompt"
    "zsh-history-substring-search"
  )
  
  for plugin in "${ZSH_PLUGINS[@]}"; do
    plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin"
    if [ ! -d "$plugin_dir" ]; then
      log info "Установка плагина $plugin"
      case "$plugin" in
        "zsh-autosuggestions")
          git clone https://github.com/zsh-users/zsh-autosuggestions "$plugin_dir"
          ;;
        "zsh-syntax-highlighting")
          git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugin_dir"
          ;;
        "zsh-history-substring-search")
          git clone https://github.com/zsh-users/zsh-history-substring-search.git "$plugin_dir"
          ;;
        "zsh-kubectl-prompt")
          git clone https://github.com/superbrothers/zsh-kubectl-prompt.git "$plugin_dir"
          ;;
      esac
    else
      log info "Плагин $plugin уже установлен"
    fi
  done
}

# Настройка Tmux
setup_tmux() {
  log step "Настройка Tmux"
  
  # Создание директории для tmux, если она не существует
  mkdir -p "$HOME/.tmux"
  
  # Создание символической ссылки для конфигурации tmux
  link_file "${BASEDIR}/tmux.conf" "$HOME/.tmux.conf"
  
  # Создание символической ссылки для темы tmux
  link_file "${BASEDIR}/tmux/theme.conf" "$HOME/.tmux/theme.conf"
  
  # Установка менеджера плагинов для tmux
  if ! [ -d "$HOME/.tmux/plugins/tpm" ]; then
    log info "Установка Tmux Plugin Manager"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  else
    log info "Tmux Plugin Manager уже установлен"
  fi
}

# Настройка ZSH
setup_zsh() {
  log step "Настройка ZSH"
  
  # Создание символической ссылки для конфигурации zsh
  link_file "${BASEDIR}/zshrc" "$HOME/.zshrc"
  
  # Установка zsh как оболочки по умолчанию
  if [[ "$SHELL" != *"zsh"* ]]; then
    log info "Установка ZSH как оболочки по умолчанию"
    chsh -s "$(which zsh)"
  else
    log info "ZSH уже установлен как оболочка по умолчанию"
  fi
}

# Настройка Neovim
setup_neovim() {
  log step "Настройка Neovim"
  
  # Создание директорий для конфигурации Neovim
  mkdir -p "$HOME/.config/nvim"
  
  # Создание символических ссылок для конфигурации Neovim
  link_file "${BASEDIR}/config/nvim/init.lua" "$HOME/.config/nvim/init.lua"
  
  # Lazy.nvim устанавливается автоматически при первом запуске Neovim
  # через код в init.lua, поэтому просто запускаем Neovim для установки плагинов
  log info "Установка плагинов для Neovim"
  nvim --headless "+Lazy! sync" +qa
}

# Основная функция
main() {
  log step "Начало установки dotfiles"
  
  install_homebrew
  install_packages
  setup_oh_my_zsh
  setup_tmux
  setup_zsh
  setup_neovim
  
  log step "Установка dotfiles завершена успешно!"
  log info "Пожалуйста, перезапустите терминал для применения всех изменений."
}

# Запуск основной функции
main

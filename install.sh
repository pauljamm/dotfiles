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

# Определение категорий пакетов
define_package_categories() {
  # Базовые пакеты
  BASE_PACKAGES=(
    "git"
    "neovim"
    "tmux"
    "npm"
    "ripgrep"
    "fd"
    "fzf"
    "eza"
    "jq"
    "htop"
    "gotop"
    "wget"
    "zsh"
  )
  
  # Пакеты для разработки
  DEV_PACKAGES=(
    "virtualenvwrapper"
  )
  
  # DevOps инструменты
  DEVOPS_PACKAGES=(
    "kubectl"
    "helm"
    "colima"
    "docker"
    "minikube"
  )
  
  # Все категории для выбора
  CATEGORIES=("base" "dev" "devops")
  CATEGORIES_NAMES=("Базовые пакеты" "Инструменты разработки" "DevOps инструменты")
}

# Функция для получения списка пакетов по имени категории
get_packages_by_category() {
  local category=$1
  case $category in
    "base")
      echo "${BASE_PACKAGES[@]}"
      ;;
    "dev")
      echo "${DEV_PACKAGES[@]}"
      ;;
    "devops")
      echo "${DEVOPS_PACKAGES[@]}"
      ;;
  esac
}

# Функция для получения названия категории
get_category_name() {
  local category=$1
  case $category in
    "base")
      echo "Базовые пакеты"
      ;;
    "dev")
      echo "Инструменты разработки"
      ;;
    "devops")
      echo "DevOps инструменты"
      ;;
  esac
}

# Определение этапов установки
define_installation_stages() {
  # Все этапы установки
  STAGES=("homebrew" "packages" "oh-my-zsh" "tmux" "zsh" "neovim")
  STAGES_NAMES=("Установка Homebrew" "Установка пакетов" "Настройка Oh My Zsh" "Настройка Tmux" "Настройка ZSH" "Настройка Neovim")
}

# Функция для получения названия этапа
get_stage_name() {
  local stage=$1
  case $stage in
    "homebrew")
      echo "Установка Homebrew"
      ;;
    "packages")
      echo "Установка пакетов"
      ;;
    "oh-my-zsh")
      echo "Настройка Oh My Zsh"
      ;;
    "tmux")
      echo "Настройка Tmux"
      ;;
    "zsh")
      echo "Настройка ZSH"
      ;;
    "neovim")
      echo "Настройка Neovim"
      ;;
  esac
}

# Функция для вывода справки
show_help() {
  echo "Использование: $0 [опции]"
  echo ""
  echo "Опции для выбора этапов установки:"
  echo "  -h, --help                 Показать эту справку"
  echo "  -S, --stages STAGES        Выполнить только указанные этапы установки (через запятую)"
  echo "                             Доступные этапы: homebrew, packages, oh-my-zsh, tmux, zsh, neovim"
  echo "  --all-stages               Выполнить все этапы установки (по умолчанию)"
  echo ""
  echo "Опции для выбора пакетов (применяются только если выбран этап 'packages'):"
  echo "  -c, --categories CATS      Установить только указанные категории пакетов (через запятую)"
  echo "                             Доступные категории: base, dev, devops"
  echo "  -s, --skip-packages PKGS   Пропустить указанные пакеты (через запятую)"
  echo "  -a, --all                  Установить все пакеты (по умолчанию)"
  echo ""
  echo "Примеры:"
  echo "  $0 --stages homebrew,packages,zsh   Выполнить только установку Homebrew, пакетов и настройку ZSH"
  echo "  $0 --stages packages --categories base,dev   Установить только базовые пакеты и инструменты разработки"
  echo "  $0 --stages packages --skip-packages docker,minikube   Установить все пакеты, кроме docker и minikube"
  echo "  $0 --stages packages --categories devops --skip-packages minikube   Установить все devops пакеты, кроме minikube"
}

# Установка программ через Homebrew
install_packages() {
  log step "Установка необходимых программ"
  
  # Определение категорий пакетов
  define_package_categories
  
  # Парсинг аргументов командной строки
  SELECTED_CATEGORIES=()
  SKIP_PACKAGES=()
  
  while [[ $# -gt 0 ]]; do
    case $1 in
      -h|--help)
        show_help
        exit 0
        ;;
      -c|--categories)
        IFS=',' read -r -a SELECTED_CATEGORIES <<< "$2"
        shift 2
        ;;
      -s|--skip-packages)
        IFS=',' read -r -a SKIP_PACKAGES <<< "$2"
        shift 2
        ;;
      -a|--all)
        SELECTED_CATEGORIES=("${CATEGORIES[@]}")
        shift
        ;;
      *)
        shift
        ;;
    esac
  done
  
  # Если категории не выбраны, используем все
  if [ ${#SELECTED_CATEGORIES[@]} -eq 0 ]; then
    SELECTED_CATEGORIES=("${CATEGORIES[@]}")
  fi
  
  # Проверка валидности выбранных категорий
  for category in "${SELECTED_CATEGORIES[@]}"; do
    if [[ ! " ${CATEGORIES[*]} " =~ " ${category} " ]]; then
      log error "Неизвестная категория: $category"
      echo "Доступные категории: ${CATEGORIES[*]}"
      exit 1
    fi
  done
  
  # Установка пакетов по категориям
  for category in "${SELECTED_CATEGORIES[@]}"; do
    category_name=$(get_category_name "$category")
    log info "Установка категории: $category_name"
    
    # Получение списка пакетов для текущей категории
    packages_array=($(get_packages_by_category "$category"))
    
    # Установка пакетов
    for package in "${packages_array[@]}"; do
      # Пропускаем пакет, если он в списке исключений
      if [[ " ${SKIP_PACKAGES[*]} " =~ " ${package} " ]]; then
        log warning "Пропуск пакета $package (указан в --skip-packages)"
        continue
      fi
      
      if brew list "$package" &>/dev/null; then
        log info "$package уже установлен"
      else
        log info "Установка $package"
        brew install "$package"
      fi
    done
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

# Парсинг аргументов командной строки
parse_args() {
  CATEGORIES_ARG=""
  SKIP_PACKAGES_ARG=""
  STAGES_ARG=""
  
  while [[ $# -gt 0 ]]; do
    case $1 in
      -h|--help)
        show_help
        exit 0
        ;;
      -c|--categories)
        CATEGORIES_ARG="$2"
        shift 2
        ;;
      -s|--skip-packages)
        SKIP_PACKAGES_ARG="$2"
        shift 2
        ;;
      -a|--all)
        CATEGORIES_ARG=""
        shift
        ;;
      -S|--stages)
        STAGES_ARG="$2"
        shift 2
        ;;
      --all-stages)
        STAGES_ARG=""
        shift
        ;;
      *)
        shift
        ;;
    esac
  done
}

# Основная функция
main() {
  # Парсинг аргументов
  parse_args "$@"

  # Определение этапов установки
  define_installation_stages
  
  # Определение выбранных этапов установки
  SELECTED_STAGES=()
  
  if [ -n "$STAGES_ARG" ]; then
    IFS=',' read -r -a SELECTED_STAGES <<< "$STAGES_ARG"
    
    # Проверка валидности выбранных этапов
    for stage in "${SELECTED_STAGES[@]}"; do
      if [[ ! " ${STAGES[*]} " =~ " ${stage} " ]]; then
        log error "Неизвестный этап установки: $stage"
        echo "Доступные этапы: ${STAGES[*]}"
        exit 1
      fi
    done
  else
    # Если этапы не выбраны, используем все
    SELECTED_STAGES=("${STAGES[@]}")
  fi

  log step "Начало установки dotfiles"
  
  # Выполнение выбранных этапов установки
  for stage in "${SELECTED_STAGES[@]}"; do
    stage_name=$(get_stage_name "$stage")
    log step "Выполнение этапа: $stage_name"
    
    case $stage in
      "homebrew")
        install_homebrew
        ;;
      "packages")
        # Передача аргументов в функцию установки пакетов
        if [ -n "$CATEGORIES_ARG" ]; then
          if [ -n "$SKIP_PACKAGES_ARG" ]; then
            install_packages --categories "$CATEGORIES_ARG" --skip-packages "$SKIP_PACKAGES_ARG"
          else
            install_packages --categories "$CATEGORIES_ARG"
          fi
        elif [ -n "$SKIP_PACKAGES_ARG" ]; then
          install_packages --skip-packages "$SKIP_PACKAGES_ARG"
        else
          install_packages --all
        fi
        ;;
      "oh-my-zsh")
        setup_oh_my_zsh
        ;;
      "tmux")
        setup_tmux
        ;;
      "zsh")
        setup_zsh
        ;;
      "neovim")
        setup_neovim
        ;;
    esac
  done
  
  log step "Установка dotfiles завершена успешно!"
  log info "Пожалуйста, перезапустите терминал для применения всех изменений."
}

# Запуск основной функции с передачей всех аргументов
main "$@"

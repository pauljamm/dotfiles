ZSH_TMUX_AUTOSTART="true"
KEYTIMEOUT=1
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export GOPATH=~/Code/go

PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH/usr/local/opt/python/libexec/bin:$PATH:$GOPATH/bin:$HOME/Library/Python/3.9/bin:${HOME}/.krew/bin"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"
DEFAULT_USER="$(whoami)"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  docker
  docker-compose
  kubectl
  helm
  tmux
  zsh-kubectl-prompt
  zsh-syntax-highlighting
  zsh-history-substring-search
  zsh-autosuggestions
  terraform
)

source $ZSH/oh-my-zsh.sh

# User configuration

autoload -U colors; colors
RPROMPT='%{$fg[blue]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias python="python3"
alias pip="pip3"

alias k="kubectl"
alias kg="kubectl get"
alias kgy="kubectl get -o yaml"
alias kd="kubectl describe"
alias kl="kubectl logs"
alias kga="kubectl get --all-namespaces"
alias kctx="kubectx"
alias kns="kubens"
alias myip="curl ifconfig.co"
alias vim="nvim"
alias gotop="gotop -p"
# Yandex.Cloud
alias ycprf="yc config profile activate"
# Compute
alias ycc="yc compute"
alias ycci="yc compute instance"
alias yccd="yc compute disk"
alias yccsi="yc compute image list --folder-id standard-images"
# VPC
alias ycv="yc vpc"
alias ycvn="yc vpc network"
alias ycvsn="yc vpc subnet"
# Managed PostgreSQL
alias ycpsql="yc managed-postgresql"
alias ycpsqlc="yc managed-postgresql cluster"
alias ycpsqlh="yc managed-postgresql hosts"
# Managed Kubernetes
alias yck="yc k8s"
alias yckc="yc k8s cluster"
alias yckcg="yc k8s cluster get"
alias yckcl="yc k8s cluster list"

alias -g jid="jq -r '.[].id'"
alias ycj="yc --format json"

# eza instead of ls
eza_params=(
  '--git' '--group' '--group-directories-first'
)

alias ls='eza $eza_params'
alias ll='eza --long $eza_params'
alias la='eza --long --all $eza_params'
alias lal='eza -lbhHigUmuSa'
alias tree='eza --tree $eza_params'

prompt_dir() {
  prompt_segment blue black "%$(( $COLUMNS - 61 ))<...<%2~%<<"
}

export VIRTUALENVWRAPPER_PYTHON=$(which python3)
source /usr/local/bin/virtualenvwrapper.sh

source $HOME/.oh-my-zsh/custom/plugins/yc/yc.zsh

# Улучшенные настройки для автопредложений
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *|ls *|ll *|?(#c100,)"
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=226,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=203,bold'

bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

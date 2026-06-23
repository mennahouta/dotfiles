# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/Applications/Tailscale.app/Contents/MacOS:$PATH"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
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
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias gchb="git checkout -b"
alias gch="git checkout"
alias gs="git status"
alias ga="git add ."
alias gaf="git add"
alias gc="git commit -am"
alias gp="git push"
alias gpu="git push --set-upstream origin"
alias pr="gh pr create"

alias kpods="kubectl get pods -n"
alias kdel="kubectl delete pod -n"
alias kcfgmap="kubectl describe configmap -n"
alias krs="kubectl get rs -n"
kready() {
  local namespace="${1:?namespace required}"
  
  kubectl get pods -n "$namespace" \
    -o jsonpath='{range .items[*]}{"=== "}{.metadata.name}{"\n"}{range .status.containerStatuses[*]}{.name}{"  ready="}{.ready}{"  state="}{.state}{"\n"}{end}{"\n"}{end}'
}
kenv() {
  local namespace="${1:?namespace required}"

  while IFS= read -r pod; do
    echo "=== $pod ==="
    kubectl get pod "$pod" -n "$namespace" \
      -o jsonpath='{range .spec.containers[*].env[*]}{.name}{"="}{.value}{"\n"}{end}'
    echo
  done < <(kubectl get pods -n "$namespace" -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')
}
klogs() {
  local namespace="${1:?namespace required}"

  local pods
  pods=$(kubectl get pods -n "$namespace" -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')

  while IFS= read -r pod; do
    echo "=== $pod ==="
    kubectl logs "$pod" -n "$namespace" --all-containers 2>/dev/null
    echo
  done <<< "$pods"
}

# ── tmux project launcher ──────────────────────────────────────────────────────
# Usage:
#   tm              → list/attach to existing sessions
#   tm <name>       → open project in current directory
#   tm <name> <path>→ open project at given path
function tm() {
  if [[ -z "$1" ]]; then
    # No name: show session picker (or attach to last)
    if [[ -n "$TMUX" ]]; then
      tmux choose-tree -s
    else
      tmux attach 2>/dev/null || echo "No sessions. Run: tm <project-name>"
    fi
    return
  fi

  local session="$1"
  local dir="${2:-$PWD}"

  # If session already exists, just switch to it
  if tmux has-session -t "$session" 2>/dev/null; then
    if [[ -n "$TMUX" ]]; then
      tmux switch-client -t "$session"
    else
      tmux attach-session -t "$session"
    fi
    return
  fi

  # Create new session (detached), left pane is 65% wide
  tmux new-session -d -s "$session" -c "$dir"

  # Split right at 35% width → two right terminals
  tmux split-window -h -p 15 -t "${session}:1" -c "$dir"

  # Split right pane top/bottom
  tmux split-window -v -t "${session}:1.2" -c "$dir"

  # Focus left pane and open nvim
  tmux select-pane -t "${session}:1.1"
  tmux send-keys -t "${session}:1.1" "nvim ." Enter

  # Attach or switch
  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$session"
  else
    tmux attach-session -t "$session"
  fi
}
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

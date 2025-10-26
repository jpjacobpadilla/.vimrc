```
curl -o ~/.vimrc jacobpadilla.com/v
```

Some `.zshrc` stuff:

```
# ------------------------------
# UV
# ------------------------------
export PATH="$HOME/.local/bin:$PATH"
autoload -U compinit && compinit
eval "$(uv generate-shell-completion zsh)"

# https://github.com/astral-sh/uv/issues/8432#issue
_uv_run_mod() {
    if [[ "$words[2]" == "run" && "$words[CURRENT]" != -* ]]; then
        _arguments '*:filename:_files'
    else
        _uv "$@"
    fi
}
compdef _uv_run_mod uv


# ------------------------------
# Aliases
# ------------------------------
alias sd="cd ~/Desktop/ && cd \"\$(find ~/Desktop/ -type d \( -name 'venv' -o -name '__pycache__' -o -name '.*' \) -prune -o -type d -print | fzf)\""
alias l='curl -s https://api.my-ip.io/v2/ip.txt'
alias lss='eza -lhF'
alias path='echo $PATH | tr : "\n"'

alias d='cd ~/Desktop'
alias v='vim -c "Startify" -c "normal 0"'
alias c='clear'

alias gl='git log --oneline'
alias gs='git status'
alias gc='git commit -m'
alias gp='git push origin HEAD'

alias tp='terraform plan -out=tfplan.out'
alias ta='terraform apply tfplan.out'

alias cc='npx claude'

# ------------------------------
# Prompt Configuration
# ------------------------------
function parse_git_branch() {
    if [ -d .git ] || git rev-parse --is-inside-work-tree &>/dev/null; then
        branch=$(git branch --show-current 2>/dev/null)
        echo "[${branch:-Detached}]"
    fi
}

function uv_version() {
  local cfg_file=".venv/pyvenv.cfg"
  if [[ -f "$cfg_file" ]]; then
    local python_version=$(awk -F' = ' '/version_info/ {print $2}' "$cfg_file")
    echo "${COLOR_PYTHON}[${python_version}]${COLOR_DEF}"
  fi
}


COLOR_USR=$COLOR_DEF
COLOR_HOST=$COLOR_DEF
COLOR_DEF=$'%f'
COLOR_DIR=$'%F{39}'
COLOR_GIT=$'%F{197}'
COLOR_PYTHON=$'%F{119}'

setopt PROMPT_SUBST
export PROMPT='${COLOR_USR}%n ${COLOR_DIR}%~ ${COLOR_GIT}$(parse_git_branch)${COLOR_PYTHON}$(uv_version)${COLOR_DEF}
➤ '
```

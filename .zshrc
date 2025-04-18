if [[ ! -f ~/.config/antigen.zsh ]]; then
    mkdir -p ~/.config
    curl -sSL git.io/antigen > ~/.config/antigen.zsh
fi

source $HOME/.config/antigen.zsh

### Fix slowness of pastes with zsh-syntax-highlighting.zsh
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
### Fix slowness of pastes

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle pip
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search

antigen bundle chrissicool/zsh-256color
antigen bundle "MichaelAquilina/zsh-autoswitch-virtualenv"
antigen bundle unixorn/autoupdate-antigen.zshplugin
antigen bundle ael-code/zsh-colored-man-pages
antigen bundle webyneter/docker-aliases.git


antigen theme spaceship-prompt/spaceship-prompt

# Tell Antigen that you're done.
antigen apply

# hotfix for spaceship async
if ! $(sed '30!d' $HOME/.antigen/bundles/spaceship-prompt/spaceship-prompt/async.zsh | grep -q -o 'sleep'); then
    sed -i '30i \\tsleep 0.05' $HOME/.antigen/bundles/spaceship-prompt/spaceship-prompt/async.zsh
fi

plugins=(
    1password
    archlinux
    aws
    docker
    fzf
    git
    pip
    pyenv
    python
    ssh
    ssh-agent
    terraform
    tmux
    vi-mode
)

alias l='ls -hAltr'
alias ll='ls -hltr'
alias lS='ls -SAhlr'
alias shred='shred -uzf'
alias vi='/usr/bin/vim'
alias please='sudo `fc -ln -1`'
alias dropped_pkts='journalctl -fk | grep "DROP"'
alias python='python3'

# Start Functions
rshred() {
    find $1 -type f -exec shred -uzf {} \;
}

pgrep(){
  ps -efH | grep -v grep | grep -i "$1"
}

#--- BEGIN SSH Helpers ---
# https://man.openbsd.org/ssh_config.5#TOKENS
SOCKET_PATH_DIR="${HOME}/.ssh/sockets"
SOCKET_PATH_FILE="${SOCKET_PATH_DIR}/%C"

ssh_socket_create(){
    local SSH_HOST
    SSH_HOST=$1

    if [ "$#" -ne 1 ]; then
        echo "ssh_socket_create <hostname>"
        return
    fi

    if [ ! -d "${SOCKET_PATH_DIR}" ]; then
        mkdir -p "${SOCKET_PATH_DIR}"
    fi

    ssh -fN \
        -o ControlMaster=auto \
        -o Compression=yes \
        -o ForwardX11=yes \
        -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeyChecking=no \
        -o LogLevel=QUIET \
        -S "${SOCKET_PATH_FILE}" "${SSH_HOST}"

}
ssh_socket_cmd(){
    local SSH_HOST REQUEST_TYPE SSH_CMD

    SSH_HOST="$1"
    REQUEST_TYPE="$2"
    SSH_CMD="$3"


    if [[ "$#" -lt 2 || "$#" -gt 3 ]]; then
        cat <<EOF
ssh_socket_cmd <hostname> <request_type> <command>
Request Types:
    check - (check that the master process is running)
    forward - (request forwardings without command execu‐tion)
    cancel - (cancel forwardings)
    proxy - (connect to a running multiplexing master in proxy mode)
    exit - (request the master to  exit)
    stop - (request the master to stop accepting further multiplexing requests)
EOF
        return
    fi

    if [ -z "$SSH_CMD" ]; then
        ssh -O "$REQUEST_TYPE" \
            -S "${SOCKET_PATH_FILE}" "${SSH_HOST}"
    else
        ssh -O "$REQUEST_TYPE" "$SSH_CMD" \
            -S "${SOCKET_PATH_FILE}" "${SSH_HOST}"
    fi
}
ssh_socket_connect(){
    local SSH_HOST
    SSH_HOST=$1
    
    if [ "$#" -ne 1 ]; then
        echo "ssh_socket_create <hostname>"
        return
    fi

    ssh \
        -o ControlMaster=auto \
        -o Compression=yes \
        -o ForwardX11=yes \
        -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeyChecking=no \
        -o LogLevel=QUIET \
        -S "${SOCKET_PATH_FILE}" "${SSH_HOST}"
}
#--- END SSH Helpers ---
# End Functions

# Shell theme
if [[ ! -d ~/.config/base16-shell ]]; then
  git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
fi

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        source "$BASE16_SHELL/profile_helper.sh"

# fzf colors
# Scheme name: Tomorrow Night Eighties
# Scheme system: base16
# Scheme author: Chris Kempson (http://chriskempson.com)
# Template author: Tinted Theming (https://github.com/tinted-theming)

_gen_fzf_default_opts() {

local color00='#2d2d2d'
local color01='#393939'
local color02='#515151'
local color03='#999999'
local color04='#b4b7b4'
local color05='#cccccc'
local color06='#e0e0e0'
local color07='#ffffff'
local color08='#f2777a'
local color09='#f99157'
local color0A='#ffcc66'
local color0B='#99cc99'
local color0C='#66cccc'
local color0D='#6699cc'
local color0E='#cc99cc'
local color0F='#a3685a'

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"\
" --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D"\
" --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C"\
" --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"

}

_gen_fzf_default_opts
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

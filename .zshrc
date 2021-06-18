# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
antigen bundle unixorn/docker-helpers.zshplugin

#antigen theme denysdovhan/spaceship-prompt
antigen theme romkatv/powerlevel10k

# Tell Antigen that you're done.
antigen apply

plugins=(git docker docker-compose)

# Start Exports
export TERM='xterm-256color'
export EDITOR='vim'
export GOPATH=~/go
export XDG_CONFIG_HOME="$HOME/.config"
export PATH="$HOME/bin:$HOME/.local/bin:$GOPATH/bin:$HOME/node_modules/.bin:$PATH"
export KUBECONFIG="$HOME/.kube/config"
# End Exports

alias l='ls -hAltr'
alias ll='ls -hltr'
alias lS='ls -SAhlr'
alias shred='shred -uzf'
alias vi='/usr/bin/vim'
alias please='sudo `fc -ln -1`'
alias cp='rsync -avh --progress'
alias dropped_pkts='journalctl -fk | grep "DROP"'
alias dots="/usr/bin/env git --git-dir='$HOME/.dotfiles' --work-tree='$HOME'"

# Start Functions

rdp(){
  local user host passwd
  
  host='localhost'
  user='Administrator'

  case $# in
    1)
      host="$1"
    ;;
    2)
      host="$1"
      user="$2"
    ;;
    3)
      host="$1"
      user="$2"
      passwd="$3"
    ;;
  esac

  xfreerdp /bpp:32 /gfx +aero +fonts /u:${user} /v:${host} /drive:Share,$HOME/Downloads
}

function rshred() {
    find $1 -type f -exec shred -uzf {} \;
}

tunle() {
    if [ ! -d $HOME/vpn ]; then
        echo "$HOME/vpn does not exist."
        return 1
    fi

    sudo docker pull retenet/tunle
    sudo docker run -dit --rm \
        --name tunle_generic \
        -v $HOME/vpn/wh1t3fox-release.ovpn:/tmp/vpn/user.ovpn \
        --device /dev/net/tun \
        --cap-drop all \
        --cap-add MKNOD \
        --cap-add SETUID \
        --cap-add SETGID \
        --cap-add NET_ADMIN \
        --cap-add NET_RAW \
        retenet/tunle

    # Check for tunle errors.
}

spindra() {
    local network img

    case "$1" in
        "tunle")
            network="container:tunle_generic"
            ;;
        "host")
            network="host"
            ;;
        "rete"|"retenet")
            network="retenet"
            ;;
        *)
            network="bridge"
            ;;

    esac

    sudo docker pull wh1t3f0x/spindra
    sudo docker run -it --rm \
        --net=$network \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /home/craig/spindra:/data \
        -e DISPLAY=$DISPLAY \
        --cap-add NET_ADMIN \
        --cap-add SYS_PTRACE \
        wh1t3f0x/spindra
}

amsi-bypass(){
    curl -sL https://amsi-fail.azurewebsites.net/api/Generate | grep -E '^[^#]'
}

pgrep(){
  ps -efH | grep -v grep | grep -i "$1"
}
# End Functions

# Shell theme
if [[ ! -d ~/.config/base16-shell ]]; then
  git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
fi

BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [[ ! -f $HOME/.config/antigen.zsh ]]; then
    mkdir -p $HOME/.config/
    curl -sSL -o $HOME/.config/antigen.zsh https://git.io/antigen
fi

source $HOME/.config/antigen.zsh

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

antigen theme denysdovhan/spaceship-prompt

# Tell Antigen that you're done.
antigen apply

plugins=(archlinux docker docker-compose fzf git pip nmap sudo)

# Start Exports
export TERM='xterm-256color'
export EDITOR='vim'
export GOPATH=~/go
export XDG_CONFIG_HOME="$HOME/.config"
export PATH="$HOME/bin:$HOME/.local/bin:$GOPATH/bin:$HOME/node_modules/.bin:$PATH"
# End Exports

alias please='sudo `fc -ln -1`'
alias shred='shred -uzf'
alias vi='/usr/bin/vim'
alias dropped_pkts='journalctl -fk | grep "BLOCKED"'
alias l='ls -hAltr'
alias ll='ls -hltr'

# Start Functions
function rshred() {
    find $1 -type f -exec shred -uzf {} \;
}

tunle() {
    if [ ! -d $HOME/vpn ]; then
        echo "$HOME/vpn does not exist."
        return 1
    fi

    sudo docker pull retenet/tunle
    sudo docker run -dit --rm --name tunle \
        -v $HOME/vpn/:/tmp/vpn \
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
            network="container:tunle"
            ;;
        "host")
            network="host"
            ;;
        *)
            network="bridge"
            ;;

    esac

    sudo docker pull wh1t3f0x/spindra
    sudo docker run -it --rm \
        --net=$network \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v $HOME/spindra:/data \
        -e DISPLAY=$DISPLAY \
        --cap-add NET_ADMIN \
        --cap-add SYS_PTRACE \
        wh1t3f0x/spindra
}

amsi-bypass(){
    curl -sL https://amsi-fail.azurewebsites.net/api/Generate | grep -E '^[^#]'
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

typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}" reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi


autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word


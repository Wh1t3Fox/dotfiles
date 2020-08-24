if [ ! -f ~/.config/antigen.zsh ]; then
    echo "Pulling Antigen..." >&2
    curl -SL -o ~/.config/antigen.zsh https://git.io/antigen 
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

plugins=(git docker docker-compose)

zstyle ":prezto:module:thefuck" alias "fuck"
eval $(thefuck --alias)

# Start Exports
export TERM='xterm-256color'
export EDITOR='vim'
export GOPATH=~/go
export XDG_CONFIG_HOME="$HOME/.config"
export PATH="$HOME/bin:$HOME/.local/bin:$GOPATH/bin:$HOME/node_modules/.bin:$PATH"
# End Exports

# Start Aliases
alias please='sudo `fc -ln -1`'
alias shred='shred -uzf'
alias vi='/usr/bin/vim'
alias dropped_pkts='journalctl -fk | grep "BLOCKED"'
alias l='ls -hAltr'
alias ll='ls -hltr'
# End Aliases

# Start Functions
function rshred() {
    find $1 -type f -exec shred -uzf {} \;
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

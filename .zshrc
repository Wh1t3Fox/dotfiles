# Check if zim is installed
if [[ ! -d ~/.zim ]]; then
  git clone --recursive https://github.com/zimfw/zimfw.git ${ZDOTDIR:-${HOME}}/.zim
  for template_file in ${ZDOTDIR:-${HOME}}/.zim/templates/*; do
    user_file="${ZDOTDIR:-${HOME}}/.${template_file:t}"
    cat ${template_file} ${user_file}(.N) > ${user_file}.tmp && mv ${user_file}{.tmp,}
  done
  source ${ZDOTDIR:-${HOME}}/.zlogin
fi

#
# User configuration sourced by interactive shells
#

# Define zim location
export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Start zim
[[ -s ${ZIM_HOME}/init.zsh ]] && source ${ZIM_HOME}/init.zsh


eval $(thefuck --alias)

kitty + complete setup zsh | source /dev/stdin

export TERM='xterm-256color'
export EDITOR='nvim'
export GOPATH=~/go
export XDG_CONFIG_HOME="$HOME/.config"
export PATH="$HOME/bin:$HOME/.local/bin:$GOPATH/bin:$PATH"

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias please='sudo `fc -ln -1`'
alias vim='nvim'
alias vi='nvim'

# Shell theme
if [[ ! -d ~/.config/base16-shell ]]; then
  git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
fi

BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

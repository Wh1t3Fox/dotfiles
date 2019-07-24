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

# Start Exports
export TERM='xterm-256color'
export EDITOR='nvim'
export GOPATH=~/go
export XDG_CONFIG_HOME="$HOME/.config"
export PATH="$HOME/bin:$HOME/.local/bin:$GOPATH/bin:$PATH"
# End Exports

# Start Aliases
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias please='sudo `fc -ln -1`'
alias vim='nvim'
alias vi='nvim'
alias shred='shred -uzf'
alias rotate_node='sudo kill -HUP tor'
alias dropped_pkts='journalctl -fk | grep -E "IN=\w+|OUT=\w+"'
# End Aliases

# Start Functions
function rshred() {
    find $1 -type f -exec shred -uzf {} \;
}

function docker_tmp_shell() {
    docker run --rm -i -t --entrypoint=/bin/bash "$@"
}

function docker_tmp_shell_sh() {
    docker run --rm -i -t --entrypoint=/bin/sh "$@"
}

function docker_shell() {
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/bash -v `pwd`:/${dirname} -w /${dirname} "$@"
}

function docker_shell_sh() {
    docker run --rm -it --entrypoint=/bin/sh -v `pwd`:/${dirname} -w /${dirname} "$@"
}

function dockerwindowshellhere() {
    dirname=${PWD##*/}
    docker -c 2019-box run --rm -it -v "C:${PWD}:C:/source" -w "C:/source" "$@"
}

impacket() {
    docker run --rm -it rflathers/impacket "$@"
}

smbserve() {
    local sharename
    [[ -z $1 ]] && sharename="SHARE" || sharename=$1
    docker run --rm -it -p 445:445 -v "${PWD}:/tmp/serve" rflathers/impacket smbserver.py -smb2support $sharename /tmp/serve
}

nginx_pwd() {
    docker run --rm -it -p 80:80 -p 443:443 -v "${PWD}:/srv/data" rflathers/nginxserve
}

webdav_pwd() {
    docker run --rm -it -p 80:80 -v "${PWD}:/srv/data/share" rflathers/webdav
}

metasploit() {
    docker run --rm -it -v "${HOME}/.msf4:/home/msf/.msf4" metasploitframework/metasploit-framework ./msfconsole "$@"
}

metasploit_ports() {
    docker run --rm -it -v "${HOME}/.msf4:/home/msf/.msf4" -p 8443-8500:8443-8500 metasploitframework/metasploit-framework ./msfconsole "$@"
}

msfvenom_pwd() {
    docker run --rm -it -v "${HOME}/.msf4:/home/msf/.msf4" -v "${PWD}:/data" metasploitframework/metasploit-framework ./msfvenom "$@"
}

reqdump() {
    docker run --rm -it -p 80:3000 rflathers/reqdump
}

postfiledump_pwd() {
    docker run --rm -it -p80:3000 -v "${PWD}:/data" rflathers/postfiledump
}

autopwn() {
    docker run -it -v $PWD:/mount --security-opt="apparmor=unconfined" --cap-add=SYS_PTRACE bannsec/autopwn
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

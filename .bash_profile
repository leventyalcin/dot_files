[ -f ~/.bashrc ] && source ~/.bashrc

[ -d "/opt/local/bin" ] && PATH="$PATH:/opt/local/bin"
[ -d "/opt/local/sbin" ] && PATH="$PATH:/opt/local/sbin"
[ -d  "~/bin" ] && PATH="$PATH:~/bin"
[ -d "$HOME/.rbenv/bin" ] && export PATH="$HOME/.rbenv/bin:$PATH"
[ -d "$HOME/.rbenv/shims" ] && export PATH="$HOME/.rbenv/shims:$PATH"
#for openstack cli tools
[ -f ~/.*-openrc.sh ] && source ~/.*-openrc.sh
export PATH
eval "$(rbenv init -)"

[[ `uname` == "Darwin" ]] && \
  export CPATH=/opt/local/include && \
  export LIBRARY_PATH=/opt/local/lib && \
  export DYLD_FALLBACK_LIBRARY_PATH=$DYLD_FALLBACK_LIBRARY_PATH:/opt/local/lib

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# against of python errors
[[ "`uname`" = "Darwin" ]] && export LC_ALL=en_US.UTF-8 && export LANG=en_US.UTF-8

# append to the history file, don't overwrite it
shopt -s histappend

unset MAILCHECK

HISTSIZE=8192
HISTFILESIZE=8192

# set prompt user@host:dir$ 
export PS1='\[\e[0;34m\]\u\[\e[0;0m\]@\h:\[\e[1;32m\]\w\[\e[0;0m\]\$ '

alias la='ls -A'
alias l='ls -lA'
alias lg='ls -lG'
alias lh='ls -alh'
alias lm='ls -altr'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias less='less -R'
[[ "`uname`" = "Linux" ]] && alias lp='netstat -pntl' || alias lp='netstat -an | grep -i listen'
function ssh-cp-id() {
  if [ -f "$1" ]; then FILE=$1; else FILE="${HOME}/.ssh/id_*.pub"; fi
  TMPKEY=$(cat $FILE)
  ssh -t -t "${@}" "mkdir -p ~/.ssh; echo '${TMPKEY}' >> ~/.ssh/authorized_keys; chmod 700 ~/.ssh; chmod 600 ~/.ssh/authorized_keys"
  unset TMPKEY
}

# Add tab completion for SSH hostnames based on ~/.ssh/config|known_hosts, ignoring wildcards
# Mac sudo port install bash_completion
#   Install +bash_completion variant automatically with all ports
#   Open the file /opt/local/etc/macports/variants.conf in any editor and add a new line
#     +bash_completion
# Debian apt-get install bash-completion
# CentOS (epel) yum --enablerepo=epel install bash-completion.noarch
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh
[ -e "$HOME/.ssh/known_hosts" ] && complete -o "default" -o "nospace" -W "$(awk '{print $1}' ~/.ssh/known_hosts | awk -F":" '{print $1}' | sed  -e 's/\[//g' -e 's/\]//g'|awk -F"," '{print $1}')" scp sftp ssh

[ -f /etc/bash_completion ] && source /etc/bash_completion
[ -f /opt/local/etc/bash_completion ] && source  /opt/local/etc/bash_completion
[ -x /usr/local/bin/aws ] && complete -C aws_completer aws
[ -d ~/.bash_completion.d ] && source ~/.bash_completion.d/*
[ -f /opt/local/etc/profile.d/bash_completion.sh ] && source /opt/local/etc/profile.d/bash_completion.sh
[ -f /opt/local/share/git-core/contrib/completion/git-completion.bash ] && source /opt/local/share/git-core/contrib/completion/git-completion.bash
[ -f ~/.rbenv/completions/rbenv.bash ] && source ~/.rbenv/completions/rbenv.bash

function skype-search() {
  QUERY="SELECT datetime(timestamp, 'unixepoch') AS date, chatname, body_xml FROM Messages"
  [ -n "$1" ] && QUERY="${QUERY} WHERE body_xml LIKE '%${1}%'"
  [ -n "$2" ] && QUERY="${QUERY} AND chatname LIKE '%${2}%'"
  QUERY="${QUERY} ORDER BY timestamp"
  echo "${QUERY}" 
  sqlite3 ~/Library/Application\ Support/Skype/yalcinlevent/main.db "${QUERY}"
}

function biggrep() {
  local PATTERN="${1}"
  local FILENAME="${2}"
  local LEN=${#PATTERN}
  local LIMIT=${3:-"100"}
  let LIMIT+=$LEN

  grep "${PATTERN}" "${FILENAME}" | fold -w ${LIMIT} | grep -C 1 --color=auto "${PATTERN}"
}

function randompass() {
  local LENGTH=${1:-12}
  local let RLENGTH=$LENGTH+24
  
  openssl rand -base64 ${RLENGTH} | tr -d '\n' |sed 's/[^a-zA-Z0-9]//g' | head -c${LENGTH}; echo 
}

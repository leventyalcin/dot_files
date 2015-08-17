[ -f ~/.bashrc ] && source ~/.bashrc

[ -d  "~/bin" ] && PATH="$PATH:~/bin"
#for openstack cli tools
[ -f ~/.*-openrc.sh ] && source ~/.*-openrc.sh
export PATH

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
shopt -s cmdhist #  one command per line

unset MAILCHECK

HISTSIZE=16384
HISTFILESIZE=16384
HISTCONTROL=ignoreboth # don’t store specific lines
HISTIGNORE='ls:bg:fg:history'
HISTTIMEFORMAT='%F %T ' # record timestamps
PROMPT_COMMAND='history -a' # store history immediately
# set prompt user@host:dir$ 
export PS1='\[\e[0;34m\]\u\[\e[0;0m\]@\h:\[\e[1;32m\]\w\[\e[0;0m\] [$?] \$ '

alias la='ls -A'
alias l='ls -lA'
alias ll='ls -lA'
alias lg='ls -lG'
alias lh='ls -alh'
alias lm='ls -altr'
alias sl='ls'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias less='less -R'
[[ "`uname`" = "Linux" ]] && alias lp='netstat -pntl' || alias lp='netstat -an | grep -i listen'
alias cip='curl http://curlmyip.com'

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
[ -e "$HOME/.ssh/known_hosts" ] && complete -o "default" -o "nospace" -W "$(awk '{print $1}' ~/.ssh/known_hosts | awk -F":" '{print $1}' | sed  -e 's/\[//g' -e 's/\]//g'|awk -F"," '{print $1}') $(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

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

function speedtest() {
  local PARAMS=${@}
  curl -o /dev/null -s -w " \
    TIME \n \
    ------------------------- \n \
    namelookup %{time_namelookup} \n \
    connect %{time_connect} \n \
    redirect %{time_redirect} \n \
    appconnect %{time_appconnect} \n \
    pretransfer %{time_pretransfer} \n \
    starttransfer %{time_starttransfer} \n \
    time_total %{time_total} \n \
    SIZE \n \
    ------------------------- \n \
    size_upload %{size_upload} \n \
    size_download %{size_download} \n \
    size_request %{size_request} \n \
    size_header %{size_header} \n \
    speed_upload %{speed_upload} \n \
    speed_download %{speed_download} \n \
    HTTP \n \
    ------------------------- \n \
    http_code %{http_code} \n \
    http_connect %{http_connect} \n \
    num_redirects %{num_redirects} \n \
  " "${PARAMS}"
}


function verify_ssl_keypair() {
    KEY="${1}.key"
    CRT="${1}.crt"
    TMPFILE=$( date +%s)
    (
        openssl x509 -noout -modulus -in "${CRT}" | openssl md5 > /tmp/$TMPFILE \
        && openssl rsa -noout -modulus -in "${KEY}" | openssl md5 >> /tmp/$TMPFILE \
    ) \
    && uniq /tmp/$TMPFILE
    rm -f /tmp/$TMPFILE
}

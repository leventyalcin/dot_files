[ -f ~/.bashrc ] && source ~/.bashrc

[ -d "/opt/local/bin" ] && PATH="$PATH:/opt/local/bin"
[ -d "/opt/local/sbin" ] && PATH="$PATH:/opt/local/sbin"
[ -d  "~/bin" ] && PATH="$PATH:~/bin"
[ -d "$HOME/.rbenv/shims" ] && export PATH="$HOME/.rbenv/shims:$PATH"

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# append to the history file, don't overwrite it
shopt -s histappend

unset MAILCHECK

HISTSIZE=4096
HISTFILESIZE=4096

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
[[ "`uname`" = "Linux" ]] && alias lp='netstat -pant | grep -i listen' || alias lp='netstat -an | grep -i listen'
function ssh-cp-id() {
  if [ -f "$1" ]; then FILE=$1; else FILE="${HOME}/.ssh/id_*.pub"; fi
  TMPKEY=$(cat $FILE)
  ssh -t -t "${@}" "mkdir -p ~/.ssh; echo '${TMPKEY}' >> ~/.ssh/authorized_keys; chmod 700 ~/.ssh; chmod 600 ~/.ssh/authorized_keys"
  unset TMPKEY
}

# Add tab completion for SSH hostnames based on ~/.ssh/config|known_hosts, ignoring wildcards
# Mac sudo port install bash_completion
# Debian apt-get install bash-completion
# CentOS (epel) yum --enablerepo=epel install bash-completion.noarch
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh
[ -e "$HOME/.ssh/known_hosts" ] && complete -o "default" -o "nospace" -W "$(awk '{print $1}' ~/.ssh/known_hosts | awk -F":" '{print $1}' | sed  -e 's/\[//g' -e 's/\]//g'|awk -F"," '{print $1}')" scp sftp ssh
complete -o "default" -W "add bisect branch checkout clone commit diff fetch grep init log merge mv pull push rebase reset rm show status tag" git

[ -f /etc/bash_completion ] && source /etc/bash_completion
[ -f /opt/local/etc/bash_completion ] && source  /opt/local/etc/bash_completion
[ -x /usr/local/bin/aws ] && complete -C aws_completer aws

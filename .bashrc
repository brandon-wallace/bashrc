#------------------------------------------------------------------------------
#==============================================================================
###############################################################################
#""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#             __                        __                     
#            /\ \                      /\ \                    
#            \ \ \____     __      ____\ \ \___   _ __   ___   
#             \ \ '__`\  /'__`\   /',__\\ \  _ `\/\`'__\/'___\ 
#              \ \ \L\ \/\ \L\.\_/\__, `\\ \ \ \ \ \ \//\ \__/ 
#               \ \_,__/\ \__/.\_\/\____/ \ \_\ \_\ \_\\ \____\
#                \/___/  \/__/\/_/\/___/   \/_/\/_/\/_/ \/____/
#                
#                  
#""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
###############################################################################
#==============================================================================
#------------------------------------------------------------------------------
#                     https://github.com/brandon-wallace
#""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


#---------------------------------------------------------------------------------------
# CUSTOM .BASHRC SETTINGS
#---------------------------------------------------------------------------------------

alias dd='dd status=progress '

function git_branch() {
    if [ -d .git ] ; then
        printf "%s" "($(git branch | awk '/\*/{print $2}'))";
    fi
}

function is_venv_enabled() {
    [ -z "$VIRTUAL_ENV" ] || printf "%s" "(venv)"
}

# Set the prompt.
function bash_prompt(){
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]$(git_branch)$(is_venv_enabled)\w \$ \[\033[00m\]'
}

PROMPT_COMMAND=bash_prompt

# Set vi mode.
set -o vi

# Set the umask.
umask 077

# Set the history time format.
HISTTIMEFORMAT="%Y%m%d  %H:%M:%S  "

# Disable the caps lock key.
setxkbmap -option ctrl:nocaps

# Clear the screen.
c(){ clear; }

# Show the command line history.
h(){ history; }

function gl(){ 
    git log --oneline; 
}

function gst(){
    git status; 
}

#
mounted(){ /bin/mount | column -t; }

# Go back directory level.
..(){ cd ..; pwd; }

# List almost all files with classification.
l(){ ls --color=auto -F; }

# List all files with classification.
la(){ ls --color=auto -A -F; }

# Long list almost all files with classification and a humanly-readable size.
ll(){ ls --color=auto -A -F -l -h; }

# Long listing with the newest files last.
lt(){ ls --color=auto -A -F -l -h -t -r; }

l.(){ ls --color=auto -A -F -d .* ; }

# List all directories.
function d(){ dir -lhaF --color=always | egrep '^d'; }

# Find the biggest files or folders in current directory.
function biggest(){ du -sk * | column -t | sort -nr | head -20; }

# Show current time.
function t(){ date +%H:%M:%S; }

# Find PID of process.
function psg(){ prog=$1; ps -ef | grep "$prog"; }
  
# Show active ports.
function ports(){ netstat -tulpna; }
  
# Grep through history.
function hg(){ history | grep $1; }

# Show applications connected to the network.
function listening(){ lsof -P -i -n; }

# Print the number of packages.
function pkgnum(){ dpkg --get-selections | wc -l; }

# Create backup of a file.
function bak(){ cp -v "$1"{,.bak}; }
 
# Display the LAN ip address.
function address(){
    local lan_ip=$(ip addr show enp0s25 | awk '/inet /{print $2}');
    printf "%s\n" "enp0s25: $lan_ip";
}

startssh(){
    eval $(ssh-agent);
    read -r -p "Path to key: " ssh_key;
    ssh-add "$ssh_key";
}

alias tree='tree -F --dirsfirst'

alias jan='cal -m 01'
alias feb='cal -m 02'
alias mar='cal -m 03'
alias apr='cal -m 04'
alias may='cal -m 05'
alias jun='cal -m 06'
alias jul='cal -m 07'
alias aug='cal -m 08'
alias sep='cal -m 09'
alias oct='cal -m 10'
alias nov='cal -m 11'
alias dec='cal -m 12'

clear

# Display system information in the terminal.
printf "%s\n\n" "USERNAME: $USER"
printf "%s\n\n" "HOSTNAME: $(hostname -f)"
printf "%s\n\n" "DATE: $(date)"
printf "%s\n\n" "KERNEL version: $(uname -rms)"
printf "%s\n\n" "UPTIME: $(uptime -p)"
printf "%s\n\n" "PACKAGES: $(dpkg --get-selections | wc -l)" 
# Print the resolution of the screens. printf displays all output on one line.
printf "%s\n\n" "RESOLUTION: $(xrandr | awk '/\*/{printf $1" "}')"
printf "%s\n\n" "$(free -h | awk '/Mem/{print "MEMORY Used: "$3" Total: "$2}')" 
#printf "\n%s\n\n" "$(df -h -x tmpfs | egrep -v '^udev')"

gateways(){
    # Print the default gateway.
    GATEWAY=$(ip route | awk '/default via/{print $3}')
    printf "%s\n" "GATEWAY: ${GATEWAY:=None}"
}

dns_servers(){
    # Print each DNS server in resolv.conf.
    NS1=$(awk '/^nameserver/ {print $2}' /etc/resolv.conf | head -1)
    NS2=$(awk '/^nameserver/ {print $2}' /etc/resolv.conf | tail -1)
    # NS3=$(awk '/^nameserver/ {print $2}' /etc/resolv.conf | tail -1)
    printf "%s\n" "NAMESERVER1: ${NS1:=Not set}"
    if [ "$NS1" == "$NS2" ] ; then
        printf "%s\n\n" "NAMESERVER2: Not set"
    else
        printf "%s\n\n" "NAMESERVER2: $NS2"
    fi
}

# Print the enp0s25 ip address.
ENP0S25=$(ip addr show enp0s25 | awk '/inet /{print $2}')
printf "%s\n" "ENP0S25: ${ENP0S25:=Not Connected}"

gateways
dns_servers

function nvm-start() {
    export NVM_DIR="$HOME/.nvm"
    # This loads nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  
    # This loads nvm bash_completion
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  
}

# Create virtural enviroments in project folders.
export PIPENV_VENV_IN_PROJECT=1

#""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
###############################################################################
#==============================================================================
#------------------------------------------------------------------------------

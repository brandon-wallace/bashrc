#
#
#                   ██████╗  █████╗ ███████╗██╗  ██╗
#                   ██╔══██╗██╔══██╗██╔════╝██║  ██║
#                   ██████╔╝███████║███████╗███████║
#                   ██╔══██╗██╔══██║╚════██║██╔══██║
#                   ██████╔╝██║  ██║███████║██║  ██║
#                   ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
#
#                  https://github.com/brandon-wallace
#
###########################################################################

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
HISTSIZE=2000
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

txtblu='\[\033[00;34m\]'
txtpur='\[\033[00;35m\]'
txtblu='\[\033[00;36m\]'
txtwht='\[\033[00;37m\]'
txtylw='\[\033[00;33m\]'
txtgrn='\[\033[00;32m\]'
txtred='\[\033[00;31m\]'
txtblk='\[\033[00;30m\]'
blu='\[\033[01;34m\]'
pur='\[\033[01;35m\]'
blu='\[\033[01;36m\]'
wht='\[\033[01;37m\]'
ylw='\[\033[01;33m\]'
grn='\[\033[01;32m\]'
red='\[\033[01;31m\]'
blk='\[\033[01;30m\]'
clr='\[\033[01;00m\]'

# Display the prompt on two lines. 
# Show full path and git branch on top.
# Below show double arrow instead of dollar sign.
# Change color of arrow from green to red if command fails.
PROMPT_COMMAND='if [ $? -eq 0 ]; then 
PS1="${debian_chroot:+($debian_chroot)}\[\033[01;34m\] \w\[\033[49;90m\] $(git_branch) 
\[\033[01;32m\] » \[\033[00m\]"
else 
PS1="${debian_chroot:+($debian_chroot)}\[\033[01;34m\] \w\[\033[49;90m\] $(git_branch) 
\[\033[01;31m\] » \[\033[00m\]"
fi'

# Run git branch if there is a .git directory present.
# Display current status of the git repository.
function git_branch() {
    if [ -d .git ] ; then
        GITSTATUS=$(git status | awk '
        /^Changes not staged/{printf("+")} 
        /^Untracked files/{printf("*")} 
        /^Changes to be commited/{printf("?")} 
        /^Your branch is ahead of/{printf("^")}')
        printf "%s" "($(git branch 2> /dev/null | awk '/\*/{print $2}'))${GITSTATUS}";
    fi
}

# Set the prompt.
function bash_prompt(){
    PS1='${debian_chroot:+($debian_chroot)}'${blu}'$(git_branch)'${pur}'\W'${grn}' \$ '${clr}
}

# Set the history time format.
HISTTIMEFORMAT="%F %T "

# View dd progress.
alias dd='dd status=progress '

# Set vi mode.
set -o vi

# Set the umask.
umask 077

# Disable the caps lock key.
setxkbmap -option ctrl:nocaps

function updateos() {
    sudo apt update;
    clear;
    sudo apt list --upgradable;
    read -r -p "Update OS? Type Yes or No. " answer;
    case $answer in
        [yY]*) sudo apt upgrade;
        ;;
        [nN]*) exit 1;
        ;;
        *) echo "Please type Yes or No.";
        exit 1;
        ;;
    esac;
}

# Extract files.
function extract() {

    if [ -f "$1" ]; then

        case $1 in
            *.tar.gz) tar xvzf $1
                ;;
            *.tar.bz2) tar xvjf $1
                ;;
	    *.tar.xz) tar xf $1
                ;;
            *.gz) gunzip $1
                ;;
            *.tar) tar xvf $1
                ;;
            *.zip) unzip $1
                ;;
	    *.bz2) bzip2 -d $1
                ;;
            *) printf "%s\n" "$1 cannot be extracted via this command."
                ;;
        esac
        
    else

        printf "%s\n" "Sorry, $1 is not a valid archive."

    fi

}

# Clear the screen.
function c(){ 
    clear; 
}

# Show the command line history.
function h(){ 
    history; 
}

# See git status.
function gs() {
    git status;
}

# Run git diff to see changes in files.
function gd() {
    git diff;
}

# Add files provided as arguments to Git.
function ga() {
    git add "$*";
}

# Add all changed files to Git.
function gaa() {
    git add --all;
}

# Create a new Git branch and change to that branch.
function gb() {
    git checkout -b "$1";
}

# Show Git logs one line per log in color with formatting.
function gl() {
    git log --graph --abbrev-commit --decorate --all --format=format:'%C(bold blue)%h%C(reset) %C(bold green)%ar%C(reset) %C(white)%s%C(reset) %C(magenta) %an%C(reset)%C(bold yellow)%d%C(reset)';
}

# Show Git logs enhanced in color with formatting and detail.
function gll() {
    git log --graph --abbrev-commit --decorate;
}

# Display mount output in columns.
function mounted(){ 
    /bin/mount | column -t; 
}

# Go back directory level.
function ..(){ 
    builtin cd ..; pwd; 
}

# Go back directory level.
function ...(){ 
    builtin cd ../..; pwd; 
}

# List almost all files with classification.
function l(){ 
    ls --color=auto -F; 
}

# List all files with classification.
function la(){ 
    ls --color=auto -A -F -h --time-style=+"%Y-%m-%d %H:%M:%S"; 
}

# Long list almost all files with classification and a humanly-readable size.
function ll(){ 
    ls --color=auto -A -F -l -h --time-style=+"%Y-%m-%d %H:%M:%S"; 
}

# Long listing with the newest files last.
function lt(){ 
    ls --color=auto -A -F -l -h -t -r --time-style=+"%Y-%m-%d %H:%M:%S"; 
}

function l.(){ 
    ls --color=auto -A -F -d .* ; 
}

function get_ip_address() {
    for iface in /sys/class/net/*/operstate; do 
        if [ "$(cat $iface)" == "up" ]; then
            interface=$(echo $iface | awk -F'/' '{print $5}');
            ip_address=$(ip addr show $interface | awk '/inet /{printf $2}');
        fi
    done
    printf "%s" "${ip_address:=Not Connected}"
}

# List all directories.
function d(){ 
    dir -lhaF --time-style=+"%Y-%m-%d %H:%M:%S" --color=always | egrep '^d'; 
}

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

function startssh(){
    eval $(ssh-agent);
    read -r -p "Enter path to key: " ssh_key;
    ssh-add -i "$ssh_key";
}

function git_init() {
    git config --global init.defaultBranch main
    if [ -z "$1" ]; then
        printf "%s\n" "Please provide a directory name.";
    else
        mkdir "$1";
        builtin cd "$1";
        pwd;
        git init;
        touch readme.md .gitignore LICENSE;
        echo "# $(basename $PWD)" >> readme.md
    fi
}

function get_temperature() {

    local response=""

    response=$(curl --silent 'https://api.openweathermap.org/data/2.5/weather?id=5110253&units=imperial&appid=<your_api_key>')

    local status=$(echo $response | jq -r '.cod')

    case $status in
        200) printf "Location: %s %s\n" "$(echo $response | jq '.name') $(echo $response | jq '.sys.country')"  
             printf "Forecast: %s\n" "$(echo $response | jq '.weather[].description')" 
             printf "Temperature: %.1f°F\n" "$(echo $response | jq '.main.temp')" 
             printf "Temp Min: %.1f°F\n" "$(echo $response | jq '.main.temp_min')" 
             printf "Temp Max: %.1f°F\n" "$(echo $response | jq '.main.temp_max')" 
            ;;
        401) echo "401 error"
            ;;
        *) echo "error"
            ;;
    esac

}

function empty_trash() {
    printf "%s\n" "EMPTYING TRASH";
    rm -rf $HOME/.local/share/Trash/files/*;
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
printf "\n"
printf '\033[00;32m'"%s   IP\t\t:\033[00m\033[01;32m$(curl ifconfig.me 2> /dev/null)\033[00m\n" 
printf '\033[00;32m'"%s   USERNAME\t:\033[00m\033[01;32m$(echo $USER)\033[00m\n"
printf '\033[00;32m'"%s   HOSTNAME\t:\033[00m\033[01;32m$(hostname -f)\033[00m\n" 
printf '\033[00;32m'"%s   DATE\t\t:\033[00m\033[01;32m$(date -R)\033[00m\n"
printf '\033[00;32m'"%s   CPU\t\t:\033[00m\033[01;32m$(echo $(awk -F: '/model name/{print $2}' /proc/cpuinfo | head -1))\033[00m\n"
printf '\033[00;32m'"%s   KERNEL\t:\033[01;32m$(uname -rms)\033[00m\n"
printf '\033[00;32m'"%s   UPTIME\t:\033[01;32m$(uptime -p)\033[00m\n"
printf '\033[00;32m'"%s   PACKAGES\t:\033[01;32m$(dpkg --get-selections | wc -l)\033[00m\n" 
printf '\033[00;32m'"%s   RESOLUTION\t:\033[01;32m$(xrandr | awk '/\*/{printf $1" "}')\033[00m\n"
printf '\033[00;32m'"%s   MEMORY\t:\033[01;32m$(free -m -h | awk '/Mem/{print $3"/"$2}')\033[00m\n" 
printf '\033[00;32m'"%s   IP ADDRESS: \033[01;32m"; get_ip_address "\033[00m\n"; printf "\n"
printf '\033[00;32m'"%s   DNS SERVERS\t:\033[01;32m$(awk '/^nameserver/{print $2" "}' /etc/resolv.conf)\033[00m\n"
printf '\033[00;32m'"%s   GATEWAY\t:\033[01;32m$(ip r | awk '/default/{print $3}')\033[00m\n" 
printf "\n"


export NVM_DIR="$HOME/.nvm"
# Load nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  
# Load nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  


# Create virtural enviroments in project folders.
export PIPENV_VENV_IN_PROJECT=1

# Rust cargo env configuration.
. "$HOME/.cargo/env"

###############################################################################

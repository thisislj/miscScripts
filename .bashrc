###USERDATA (AKA X0STUFF):

# Source global definitions
if [ -f /etc/bashrc ]; then
      . /etc/bashrc
fi

# start p4 daemon
startp4d='p4d -d -r /home/jliu/Development/p4d'

# python
export PYTHONDONTWRITEBYTECODE=1

alias xclip='xclip -selection clipboard'
alias disas='objdump -drwC -Mintel'

alias g11='g++ -std=c++11'

#export PATH=$HOME/Tools/terraform:$PATH
# add intellij
export PATH=/home/jliu/Tools/idea-IC-145.1617.8/bin:$PATH

alias edit='emacs -nw'
# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

###COLORS###

BLACK='\e[0;30m'
BLUE='\e[0;34m'
GREEN='\e[0;32m'
CYAN='\e[0;36m'
RED='\e[0;31m'
PURPLE='\e[0;35m'
BROWN='\e[0;33m'
LIGHTGRAY='\e[0;37m'
DARKGRAY='\e[1;30m'
LIGHTBLUE='\e[1;34m'
LIGHTGREEN='\e[1;32m'
LIGHTCYAN='\e[1;36m'
LIGHTRED='\e[1;31m'
MAGENTA='\e[1;35m'
YELLOW='\e[1;33m'
LIGHTYELLOW='\e[0;33m'
WHITE='\e[1;37m'
NC='\e[0m' # No Color


###STUFF###

alias p5='p4'
#export HISTFILESIZE=20000
#export HISTSIZE=10000
shopt -s histappend
shopt -s cmdhist
HISTCONTROL=ignoreboth
export HISTIGNORE="&:ls:[bf]g:exit"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."


alias su="su -"
alias sudo="sudo -E"

# Colors colors colors
alias less='less -r'
alias tree='tree -C'
alias grep="grep --color=auto"

alias skim="(head -5; tail -5) <"

alias screenalive="xset s off -dpms"
alias screensavepower="xset s on +dpms"
alias lsdirs="ls -l | grep '^d'"


# Slow vim startup fix with many plugins
alias vim="vim -X"

# Sort files by Size
alias sortbysize="ls -s | sort -n"


# Show where you copy
alias cp="cp -v"

# Colorize ls and * and / indicators on directories and .. ?
alias ls="ls --color=auto"
alias sl="ls"
alias updatedb="sudo updatedb"


function diffdocs {
    dir1="$1"
    dir2="$2"
    cd $dir1
    tar zxvf *.tgz
    cd ../$dir2
    tar zxvf *.tgz
    cd ..
    diff -r $dir1 $dir2
}

function setp4config {
    origcwd=$PWD
    cwd=$PWD

    while [ ! -f $cwd/.p4config ]
    do
        cd ..
        cwd=$PWD
        if [ $cwd == '/' ]
        then
            break
        fi
    done

    if [ -f $cwd/.p4config ]
    then
        export P4CONFIG=$cwd/.p4config
        echo "export P4CONFIG=$cwd/.p4config"
    else
        echo ".p4config not found"
    fi
    cd $origcwd
}

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/jliu/.sdkman"
[[ -s "/home/jliu/.sdkman/bin/sdkman-init.sh" ]] && source "/home/jliu/.sdkman/bin/sdkman-init.sh"

export GOBIN="$HOME/Development/goprojects/bin"
export GOPATH="$HOME/Development/goprojects/src"
export PATH=$PATH:$HOME/Development/goprojects/bin

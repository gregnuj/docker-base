# print motd
[ -z "$SUDO_UID" ] && 
[ ! -z "$TERM" ] && 
[ -r /etc/motd ] && 
cat /etc/motd

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# colour Definitions for .bashrc
COL_YEL="\[\e[1;33m\]"
COL_GRA="\[\e[0;37m\]"
COL_WHI="\[\e[1;37m\]"
COL_GRE="\[\e[1;32m\]"
COL_RED="\[\e[1;31m\]"
COL_BLU="\[\e[1;34m\]"

# Bash Prompt
if test "$UID" -eq 0 ; then
	_COL_USER=$COL_RED
	_p=" #"
else
	_COL_USER=$COL_GRE
	_p=">"
fi

COLORIZED_PROMPT="${_COL_USER}\u${COL_WHI}@${COL_YEL}\h${COL_WHI}:${COL_BLU}\w${_p}\[\e[m\]"

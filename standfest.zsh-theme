#!/bin/sh

autoload -Uz vcs_info

zstyle ':vcs_info:*' stagedstr '%F{green}●'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}●'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git svn
theme_precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*' formats ' (%b%c%u%B%F{green})'
    } else {
        zstyle ':vcs_info:*' formats ' (%b%c%u%B%F{red}●%F{green})'
    }

    vcs_info
}

setopt prompt_subst

# [Standfest] modified prompt
if [[ $EUID == 0 ]]
then
PROMPT='%F{red}[ROOT] %F{magenta}%3~%B%F{green}${vcs_info_msg_0_}%B%F{magenta} %{$reset_color%}%$\$ ' # root dir
else
PROMPT='%F{green}%n%B %F{magenta}%3~%B%F{green}${vcs_info_msg_0_}%B%F{magenta} %{$reset_color%}%$\$ '
fi


# [Standfest] right prompt with time
RPROMPT=$'%{\e[1;34m%}%T%{\e[0m%}'

autoload -U add-zsh-hook
add-zsh-hook precmd  theme_precmd

# [Standfest] path
PATH=$PATH:~/.composer/vendor/bin:~/git-scripts:/usr/local/sbin:/usr/sbin:/sbin

# [Standfest] auto-completion. Next two lines lags on Ubuntu. Could be disabled.
#autoload -Uz compinit
#compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
bindkey '\e[3~' delete-char # del
bindkey ';5D' backward-word # ctrl+left
bindkey ';5C' forward-word #ctrl+right

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# [Standfest] git credential helper
git config --global color.ui auto
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=604800'

# [Standfest] git command aliases
alias "cd.."='cd ..'
alias ls='ls -lhas --color=tty'
# for BSD: alias ls='ls -lhasG'

alias gs='git status'
alias gpm='git pull origin master'
alias gp='echo "Executing \"git pull origin $(current_branch)\"..."  && git pull origin $(current_branch)'
alias gpp='echo "Executing \"git push origin $(current_branch)\"..."  && git push origin $(current_branch)'
alias gbd="git branch -D"
alias gu="git-undo"
alias gss="git stash"
alias gsp="git stash pop"
alias gclean='git clean  -d  -fx ""'
alias phinxc='php vendor/bin/phinx create -c phinx.php'
alias phinxm='php vendor/bin/phinx migrate -c phinx.php'
alias phinxs='php vendor/bin/phinx status -c phinx.php'
alias phinxr='php vendor/bin/phinx rollback -c phinx.php'
#alias xd="sudo php5enmod xdebug && sudo service apache2 restart"
#alias xdo="sudo php5dismod xdebug && sudo service apache2 restart"
alias xd="sudo php5enmod xdebug && sudo service php5-fpm restart"
alias xdo="sudo php5dismod xdebug && sudo service php5-fpm restart"
alias gok="git diff | grep HEAD"




# [Standfest] ls colors
export LS_COLORS='no=00:fi=00:di=01;34:ln=00;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=41;33;01:ex=00;32:*.cmd=00;32:*.exe=01;32:*.com=01;32:*.bat=01;32:*.btm=01;32:*.dll=01;32:*.tar=00;31:*.tbz=00;31:*.tgz=00;31:*.rpm=00;31:*.deb=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.zip=00;31:*.zoo=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.tb2=00;31:*.tz2=00;31:*.tbz2=00;31:*.avi=01;35:*.bmp=01;35:*.fli=01;35:*.gif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mng=01;35:*.mov=01;35:*.mpg=01;35:*.pcx=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.xbm=01;35:*.xpm=01;35:*.dl=01;35:*.gl=01;35:*.wmv=01;35:*.aiff=00;32:*.au=00;32:*.mid=00;32:*.mp3=00;32:*.ogg=00;32:*.voc=00;32:*.wav=00;32:'

# [Standfset] make numeric keypad working
# 0 . Enter
bindkey -s "^[Op" "0"
bindkey -s "^[Ol" "."
bindkey -s "^[OM" "^M"
# 1 2 3
bindkey -s "^[Oq" "1"
bindkey -s "^[Or" "2"
bindkey -s "^[Os" "3"
# 4 5 6
bindkey -s "^[Ot" "4"
bindkey -s "^[Ou" "5"
bindkey -s "^[Ov" "6"
# 7 8 9
bindkey -s "^[Ow" "7"
bindkey -s "^[Ox" "8"
bindkey -s "^[Oy" "9"
# + -  * /
bindkey -s "^[Ok" "+"
bindkey -s "^[Om" "-"
bindkey -s "^[Oj" "*"
bindkey -s "^[Oo" "/"



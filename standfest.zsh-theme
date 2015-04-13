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
#PROMPT='%{\e[1;34m%}%~ %B%F{magenta}%c%B%F{green}${vcs_info_msg_0_}%B%F{magenta} %{$reset_color%}%% '

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
PATH=$PATH:~/.composer/vendor/bin:~/git-scripts

# [Standfest] auto-completion
# Use modern completion system
autoload -Uz compinit
compinit

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
alias gs="git status"
alias gd="git diff"
alias gb="git branch"
alias gpm="git pull origin master"
alias gp="git-pull"
alias gpp="git-push"
alias gbd="git branch -D"
alias gco="git checkout "


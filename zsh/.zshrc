# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[white]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.config/zsh/.zsh_history

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit

# Include tetris
autoload -Uz tetriscurses

# Include hidden files in autocomplete:
_comp_options+=(globdots)

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Nordic characters
export LANG=nn_NO.UTF-8

# Add Z jump around
. /usr/local/bin/z.sh

# Git branch
autoload -Uz vcs_info
precmd () { vcs_info }
setopt prompt_subst
PS1="\$vcs_info_msg_0_$PS1"

CASE_SENSITIVE="false"

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# Open new terminals correctly
unsetopt PROMPT_SP

# Enable interactive comments
setopt interactivecomments

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Load aliases
if [ -f ~/.config/aliasrc ]; then
    . ~/.config/aliasrc
fi

# Setting global environmental variables
export SERVER=64.227.73.190
export MYVIMRC=~/.config/nvim/init.vim

# Setting OW stuff
export OW4_ADDRESS='http://online.ntnu.no'
# export OW4_SSO_CLIENT_ID='984239'
export OW4_SSO_CLIENT_ID='181001'
export PATH=$PATH:~/.local/bin
export VISUAL=nvim
export EDITOR=nvim

eval $(thefuck --alias)

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# Load zsh-syntax-highlighting; should be last.
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export ZSH=$HOME/git/oh-my-zsh
ZSH_THEME="gentoo"
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"

plugins=(
    command-not-found
    docker
    git
    mercurial
    tmux
    zsh-history-substring-search
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
unsetopt cdablevars

# nix start script
NIX=$HOME/.nix-profile/etc/profile.d/nix.sh
# aliases
ALIAS=$HOME/alias.zsh
# XYZ customization
XYZ=$HOME/xyz.zsh

if [[ -e $NIX ]] then
    export LOCALE_ARCHIVE="$(readlink ~/.nix-profile/lib/locale)/locale-archive"
    source $NIX

    if [[ $IN_NIX_SHELL -eq 1 ]]
    then
        export PS1="(nix-shell) $PS1"
    fi
fi

if [[ -e $ALIAS ]]; then source $ALIAS; fi
if [[ -e $XYZ ]]; then source $XYZ; fi


export EDITOR="vim"
export LC_ALL=$LANG
export TERM="xterm-256color"
export KEYTIMEOUT=1

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

zle_highlight=(default:bold)

export GOROOT="$HOME/go"
export GOPATH="$HOME/gopkg"
export PATH=/usr/local/bin:$HOME/.cargo/bin:$HOME/bin:$GOPATH/bin:$GOROOT/bin:$PATH
export TZ='America/Los_Angeles'

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable hg git
zstyle ':vcs_info:hg*' get-bookmarks true
zstyle ':vcs_info:hg*' check-for-changes true
zstyle ':vcs_info:hg*' get-revision true
#zstyle ':vcs_info:*+*:*' debug true

precmd() {
    vcs_info
}

zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*+set-message:*' hooks git-highlight-branch

function +vi-git-highlight-branch () {
    hook_com[branch]="%{$fg_bold[red]%}${hook_com[branch]}%{$reset_color%}"
}

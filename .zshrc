#    _____    _
#   |__  /___| |__
#     / // __| '_ \
#    / /_\__ \ | | |
#   /____|___/_| |_|
#=======================
# [ Base_Setting ] {{{
#
export LESSCHARSET=utf-8
export LANG=ja_JP.UTF-8
export OUTPUT_CHARSET=utf-8
export PATH="$HOME/.bin:$PATH"

export PYENV_ROOT="${HOME}/.pyenv"
if [ -d "${PYENV_ROOT}" ]; then
	export PATH=${PYENV_ROOT}/bin:$PATH
	eval "$(pyenv init -)"
fi
[[ -d ~/.rbenv  ]] && \
  export PATH=${HOME}/.rbenv/shims:${PATH} && \
  eval "$(rbenv init -)"
fpath=($HOME/.zsh/comp $fpath)
autoload -U compinit; compinit
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
	/usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin \
	/usr/local/git/bin
# ブラウザ
if [[ -n "$WSL_DISTRO_NAME" ]]; then
  # WSL環境
  export BROWSER="explorer.exe"
elif [[ "$(uname)" == "Darwin" ]]; then
  # macOS環境
  export BROWSER="open"
else
  # その他Linux環境
  export BROWSER="xdg-open"
fi
export EDITOR=vim
bindkey -v
autoload colors; colors
PROMPT='%{$fg[cyan]%}[%n]%{$reset_color%} '

if [ -f ~/.config/exercism/exercism_completion.zsh ]; then
  . ~/.config/exercism/exercism_completion.zsh
fi

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

### }}}

# [ Option_Setting ] {{
setopt no_beep            # シェルの警告・エラー等で発生するベル音（ビープ）を抑制
setopt auto_cd            # ディレクトリ名だけを入力すると自動的に `cd` を実行
setopt auto_pushd         # ディレクトリ移動時に自動でディレクトリスタックへ追加
setopt correct            # コマンド名のタイポを検出し、修正候補を提示
setopt magic_equal_subst  # `=` を使った特殊な展開を有効化
# }}}

# [ History_Setting ] {{{
HISTFILE=~/.zsh/.zhistory
HISTSIZE=100000
SAVEHIST=100000
setopt bang_hist          # !を使ったヒストリ展開を行う(d)
setopt extended_history   # ヒストリに実行時間も保存する
setopt hist_ignore_dups   # 直前と同じコマンドはヒストリに追加しない
setopt share_history      # 他のシェルのヒストリをリアルタイムで共有する
setopt hist_reduce_blanks # 余分なスペースを削除してヒストリに保存する
# マッチしたコマンドのヒストリを表示できるようにする
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
# すべてのヒストリを表示する
function history-all { history -E 1 }
# }}}

# [ Git_Setting ] {{{
autoload -U compinit
compinit -u
zmodload -i zsh/complist

autoload -U colors
colors
zstyle ':completion:*' list-colors "${LS_COLORS}"

setopt complete_in_word
zstyle ':completion:*:default' menu select=1
zstyle ':completion::complete:*' use-cache true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
setopt list_packed
# }}}

# [ Git_Branch ] {{{
autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null
setopt prompt_subst
function rprompt-git-current-branch {
    local name st2 color gitdir action
    if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
        return
    fi
    name=`git rev-parse --abbrev-ref=loose HEAD 2> /dev/null`
    if [[ -z $name ]]; then
        return
    fi
    gitdir=`git rev-parse --git-dir 2> /dev/null`
    action=`VCS_INFO_git_getaction "$gitdir"` && action="($action)"
    st2=`git status 2> /dev/null`
    if [[ -n `echo "$st2" | grep "^nothing to"` ]]; then
        color=%F{green}
    elif [[ -n `echo "$st2" | grep "^nothing added"` ]]; then
        color=%F{yellow}
    elif [[ -n `echo "$st2" | grep "^# Untracked"` ]]; then
        color=%B%F{red}
    else
        color=%F{red}
        fi
    echo "$color$name$action%f%b "
}
RPROMPT='[`rprompt-git-current-branch`%~]'
# }}}

# [ ListColor_Setting ] {{{
export CLICOLOR=true
export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors \
'di=36' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
# }}}

# [ Alias_Setting ] {{{
# =====================
alias o='open .'
alias ls='ls -FG'
alias lf='ls -alF'
alias -g cdhome="cd $HOME"
alias -g cds="cd ~yamanoku/works && ls -lAG"
alias -g ifconfig="/sbin/ifconfig"
alias -g ipp='ifconfig | grep "192\.168\.[0-9]*\.[0-9]*" | sed -e "s/^.*inet //" -e "s/ .*//"'
alias -g killDS_Store="find . -name .DS_Store -exec rm -fr {} \;"
alias -g brclean="git branch --merged|egrep -v '\*|develop|master|main'|xargs git branch -d"
#}}}

# {{{ [ functions ]
code() {
	if [[ $# = 0 ]]
	then
		open -a "Visual Studio Code"
	else
		[[ $1 = /* ]] && F="$1" || F="$PWD/${1#./}"
		open -a "Visual Studio Code" --args "$F"
	fi
}
# }}}

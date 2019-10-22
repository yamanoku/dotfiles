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
export LC___MESSAGES=c

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin
export PATH="$HOME/.nodebrew/current/bin:$PATH"
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.tmux/bin:$PATH"
export PATH="$HOME/.redis/src:$PATH"
export PATH="$HOME/.tmux/plugins/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH=/usr/bin/python:$PATH
export PATH="$HOME/.cabal/bin:$PATH"
export PYENV_ROOT="${HOME}/.pyenv"
export PATH="$PATH:/opt/yarn-[version]/bin"
export PATH=$HOME/cmus/bin:$PATH
if [ -d "${PYENV_ROOT}" ]; then
	export PATH=${PYENV_ROOT}/bin:$PATH
	eval "$(pyenv init -)"
fi
fpath=($HOME/.zsh/comp $fpath)
autoload -U compinit
compinit
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
	/usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin \
	/usr/local/git/bin

export BROWSER=w3m
export EDITOR=vi

bindkey -v
autoload colors
colors
PROMPT='%{$fg[cyan]%}[%n]%{$reset_color%} '

if [ -f ~/.config/exercism/exercism_completion.zsh ]; then
	. ~/.config/exercism/exercism_completion.zsh
fi

### }}}

# [ Option_Setting ] {{{
setopt no_beep
setopt auto_cd
setopt auto_pushd
setopt correct
setopt magic_equal_subst
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
function history-all() {
	history -E 1
}
# }}}

# [ Git_Setting ] {{{
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd() {
	vcs_info
}
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'
# }}}

# [ Git_Branch ] {{{
autoload -Uz VCS_INFO_get_data_git
VCS_INFO_get_data_git 2>/dev/null
setopt prompt_subst
function rprompt-git-current-branch() {
	local name st2 color gitdir action
	if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
		return
	fi
	name=$(git rev-parse --abbrev-ref=loose HEAD 2>/dev/null)
	if [[ -z $name ]]; then
		return
	fi
	gitdir=$(git rev-parse --git-dir 2>/dev/null)
	action=$(VCS_INFO_git_getaction "$gitdir") && action="($action)"
	st2=$(git status 2>/dev/null)
	if [[ -n $(echo "$st2" | grep "^nothing to") ]]; then
		color=%F{green}
	elif [[ -n $(echo "$st2" | grep "^nothing added") ]]; then
		color=%F{yellow}
	elif [[ -n $(echo "$st2" | grep "^# Untracked") ]]; then
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
alias cp='cp -i'
alias mv='mv -i'
alias df='df -H'
alias treec='tree -NC'
alias treee='tree | less -R'
alias ls='ls -FG'
alias lf='ls -alF'
alias edrc='vi ~/.zshrc'
alias rerc='source ~/.zshrc'
alias remem='$ du -sx / &> /dev/null & sleep 25 && kill $!'
alias path='pwd | ruby -pe 'chomp' | pbcopy'
alias cdp='cd "`pbpaste`"'
alias -g cdhome="cd $HOME"
alias -g st="status --short"
alias -g killDS_Store="find . -name .DS_Store -exec rm -fr {} \;"
alias -g grep='grep -n --color=auto'
alias -g ifconfig="/sbin/ifconfig"
alias -g ipp='ifconfig | grep "192\.168\.[0-9]*\.[0-9]*" | sed -e "s/^.*inet //" -e "s/ .*//"'
alias -g C='| pbcopy'
alias brclean="git fetch --prune && git branch --merged | grep -vE '^\*|master$|develop$' | xargs -I % git branch -d %"
alias -g cds="cd /Users/******/WORKSPACE && ls -lAG"

# function cdls() {
# alias -- ..="cd .."
# alias -- ...="cd .. ; cd .."
# alias -- ....="cd .. ; cd .. ; cd .."
# \cd $1; ls;}
# alias cd='cdls'

alias evn='evned $(date +"MEMO_%y%m%d_%H%M")'
alias qp='qlmanage -p "$@" >& /dev/null'
alias imgsize='sips --getProperty pixelHeight --getProperty pixelWidth ./*'
#}}}

# [ fu + z ] {{{
## ==============
## auto-fu.zsh
#{ . ~/.zsh/auto-fu; auto-fu-install; }
#}}}

# [ npm-completion ] {{{
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#
COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
COMP_WORDBREAKS=${COMP_WORDBREAKS/@/}
export COMP_WORDBREAKS

if type complete &>/dev/null; then
	_npm_completion() {
		local si="$IFS"
		IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
			COMP_LINE="$COMP_LINE" \
			COMP_POINT="$COMP_POINT" \
			npm completion -- "${COMP_WORDS[@]}" \
			2>/dev/null)) || return $?
		IFS="$si"
	}
	complete -F _npm_completion npm
elif type compdef &>/dev/null; then
	_npm_completion() {
		si=$IFS
		compadd -- $(COMP_CWORD=$((CURRENT - 1)) \
			COMP_LINE=$BUFFER \
			COMP_POINT=0 \
			npm completion -- "${words[@]}" \
			2>/dev/null)
		IFS=$si
	}
	compdef _npm_completion npm
elif type compctl &>/dev/null; then
	_npm_completion() {
		local cword line point words si
		read -Ac words
		read -cn cword
		let cword-=1
		read -l line
		read -ln point
		si="$IFS"
		IFS=$'\n' reply=($(COMP_CWORD="$cword" \
			COMP_LINE="$line" \
			COMP_POINT="$point" \
			npm completion -- "${words[@]}" \
			2>/dev/null)) || return $?
		IFS="$si"
	}
	compctl -K _npm_completion npm
fi

# }}}

# {{{ [ functions ]
cdf() {
	target=$(osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)')
	if [ "$target" != "" ]; then
		cd "$target"
		pwd
	else
		echo 'No Finder window found' >&2
	fi
}
# }}}

function test() {
	echo "$1"
}

alias ipp='ifconfig | grep "192\.168\.[0-9]*\.[0-9]*" | sed -e "s/^.*inet //" -e "s/ .*//"'

# alias ytget=ytget();

alias jjson='pbpaste | perl -pi -e "s/^\"|\"$//g" $1 | jsonpp $1 | pbcopy'

code() {
	if [[ $# == 0 ]]; then
		open -a "Visual Studio Code"
	else
		[[ $1 == /* ]] && F="$1" || F="$PWD/${1#./}"
		open -a "Visual Studio Code" --args "$F"
	fi
}

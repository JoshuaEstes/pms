bindkey -v # viins
function zle-line-init zle-keymap-select {
	case $KEYMAP in
		(main|viins) RPS1="%F{cyan%}INSERT%{$reset_color%}";;
		(vicmd) RPS1="%F{red%}NORMAL%{$reset_color%}";;
		(*) RPS1="%F{white%}%K{red}${KEYMAP}%{$reset_color%}";;
	esac
	RPS2="%{$reset_color%}"
	zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

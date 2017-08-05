#wiki  https://wiki.archlinux.org/index.php/Zsh_(%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9e
#вариты шелов и их описание http://hyperpolyglot.org/unix-shells
OLDPWD=`pwd`
typeset -U path
path=(~/bin /other/things/in/path $path[@])
#bindkey -v
#autoload -Uz compinit promptinit 
autoload -U compinit promptinit 
compinit
promptinit
#color shema
#prompt adam2 
#ручная тема
####PROMT для git
git_prompt() {
  temp=`git symbolic-ref HEAD 2>/dev/null | cut -d / -f 3`
  if [ "$temp" != "" ]; then echo "$temp:"; fi
}
setopt prompt_subst
PROMPT='%F{green}%n%f@%F{blue}%m%f %F{yellow}%1~%f %# '
RPROMPT='[%F{green}$(git_prompt)%f%F{yellow}%~%f]'

# Для pacman
[[ -a $(whence -p pacman-color) ]] && compdef _pacman pacman-color=pacman
# Корректировка ввода
setopt CORRECT_ALL
# Если в слове есть ошибка, предложить исправить её
SPROMPT="Ошибка! ввести %r вместо %R? ([Y]es/[N]o/[E]dit/[A]bort) "
# Не нужно всегда вводить cd
# просто наберите нужный каталог и окажитесь в нём
setopt autocd
# При совпадении первых букв слова вывести меню выбора
zstyle ':completion:*' menu select=long-list select=0
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

###########################################################
# http://eax.me/zsh/
#Добавляем автокмпликт для программ у которых нет автокомплита по уполномочаю
rebar_args=(clean compile escriptize create create-app \
            create-node list-templates check-deps get-deps \
            update-deps delete-deps list-deps generate \
            overlay generate-upgrade generate-appups eunit \
            ct qc xref help version)
compctl -k rebar_args rebar
# переход в дерикторию без ввода 'cd' оболочка сама догадается
setopt autocd
#настраиваем prompt строока приглашения
#export PROMPT='%n@%m> '
#export RPROMPT='[%~]'
############################################################
#export PROMPT='%m'
#export RPROMPT='[%~]'

#export RPROMPT='[$(git_prompt)%~]'

#echo ^*.erl   ls *.(sh|config)
setopt extendedglob
setopt extended_glob
#отключение сохранения копий команд в истории history [count]
setopt hist_ignore_all_dups
#поиск по истории после нажатия на 'R'
bindkey '^R' history-incremental-search-backward
#Они позволяют выбирать предлагаемые zsh варианты автодополнения с помощью стрелочек.
setopt menucomplete
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
setopt completealiases
#По умолчанию zsh некорректно обрабатывает нажатия клавиш Home, End и других.
bindkey "^[OB" down-line-or-search
bindkey "^[OC" forward-char
bindkey "^[OD" backward-char
bindkey "^[OF" end-of-line
bindkey "^E" end-of-line
bindkey "^[OH" beginning-of-line
bindkey "^X" beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[3~" delete-char
bindkey "^[[4~" end-of-line
bindkey "^[[5~" up-line-or-history
bindkey "^P" up-line-or-history
bindkey "^[[6~" down-line-or-history
bindkey "^?" backward-delete-char
#bindkey -M main -M viins -M vicmd   '^[[33~'    backward-kill-word
#bindkey '^H' backward-kill-word
#Теперь архивы можно распаковывать командой extract архив без мучительного вспоминания аргументов
ex () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2) tar xvjf $1   ;;
      *.tar.gz)  tar xvzf $1   ;;
      *.tar.xz)  tar xvfJ $1   ;;
      *.bz2)     bunzip2 $1    ;;
      *.rar)     unrar x $1    ;;
      *.gz)      gunzip $1     ;;
      *.tar)     tar xvf $1    ;;
      *.tbz2)    tar xvjf $1   ;;
      *.tgz)     tar xvzf $1   ;;
      *.zip)     unzip $1      ;;
      *.Z)       uncompress $1 ;;
      *.7z)      7z x $1       ;;
      *)         echo "'$1' cannot be extracted via >extract<" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
#упаковка архива
pk () {
	if [ $1 ] ; then
		case $1 in
			tbz)       tar cjvf $2.tar.bz2 $2      ;;
			tgz)       tar czvf $2.tar.gz  $2       ;;
			tar)      tar cpvf $2.tar  $2       ;;
			bz2)    bzip $2 ;;
			gz)        gzip -c -9 -n $2 > $2.gz ;;
			zip)       zip -r $2.zip $2   ;;
			7z)        7z a $2.7z $2    ;;
			*)         echo "'$1' не может быть упакован с помощью pk()" ;;
		esac
	else
		echo "'$1' не является допустимым файлом"
	fi
}
#alias
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'
#Запоминаем последние каталоги
#не забудьте содзать mkdir -p ~/.cache/zsh
#touch ~/.cache/zsh
DIRSTACKFILE="$HOME/.cache/zsh/dirs"
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
  [[ -d $dirstack[1] ]] && cd $dirstack[1]
fi
chpwd() {
  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

DIRSTACKSIZE=20
setopt autopushd pushdsilent pushdtohome
## Remove duplicate entries
setopt pushdignoredups
## This reverts the +/- operators.
setopt pushdminus

#цветовой вывод команд с помщью sudo apt install grc
if [ -f /usr/bin/grc ]; then
 alias gcc="grc --colour=auto gcc"
 alias irclog="grc --colour=auto irclog"
 alias log="grc --colour=auto log"
 alias netstat="grc --colour=auto netstat"
 alias ping="grc --colour=auto ping"
 alias proftpd="grc --colour=auto proftpd"
 alias traceroute="grc --colour=auto traceroute"
fi
#команда help в zsh
autoload -U run-help
autoload run-help-git
autoload run-help-svn
autoload run-help-svk
#unalias run-help
alias help=run-help

#Открывать вкладку в текущей дирректории 
cd $OLDPWD

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ДОЛЖЕН БЫТЬ САМЫМ ПОСЛЕДНИМ ПЛАГИНОМ!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#Подстветка от Fish в zsh нужно скачать из репозитория 
#cd /usr/share/zsh
#sudo mkdir plugins
#sudo git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

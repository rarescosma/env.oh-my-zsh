# RIC - by Rares Cosma <office@rarescosma.com>
#
# Colors are at the top so you can mess with those separately if you like.
RIC_RVM_COLOR="%{$fg[red]%}"
RIC_NVM_COLOR="%{$fg[green]%}"
RIC_VENV_COLOR="%{$fg[blue]%}"
RIC_USER_COLOR="%{$fg[yellow]%}"
RIC_HOST_COLOR="%{$fg[magenta]%}"
RIC_DIR_COLOR="%{$fg[cyan]%}"
RIC_PROMPT_COLOR="%{$fg[gray]%}"

RIC_GIT_BRANCH_COLOR="%{$fg[green]%}"
RIC_GIT_UNTRACKED_COLOR="%{$fg[red]%}"
RIC_GIT_DIRTY_COLOR="%{$fg[red]%}"

# These Git variables are used by the oh-my-zsh git_prompt_info helper:
ZSH_THEME_GIT_PROMPT_PREFIX="on $RIC_GIT_BRANCH_COLOR"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" $RIC_GIT_UNTRACKED_COLOR?"
ZSH_THEME_GIT_PROMPT_DIRTY=" $RIC_GIT_DIRTY_COLOR!"
ZSH_THEME_GIT_PROMPT_CLEAN=""

RIC_USER_="$RIC_USER_COLOR%n%{$reset_color%}"
RIC_HOST_="$RIC_HOST_COLOR@%m%{$reset_color%}"
RIC_DIR_="$RIC_DIR_COLOR%d %{$reset_color%}\$(git_prompt_info) "
RIC_PROMPT="$RIC_PROMPT_COLOR%(!.#.$) %{$reset_color%}"

# RVM
if which rvm-prompt &> /dev/null; then
	RIC_RVM_="$RIC_RVM_COLOR\${\$(~/.rvm/bin/rvm-prompt i v g | sed 's/uby\-//')}%{$reset_color%} "
elif which ruby &> /dev/null; then
	RIC_RVM_="$RIC_RVM_COLOR$(echo -n 'r'; ruby -v | cut -d' ' -f 2)%{$reset_color%} "
else
	RIC_RVM_=""
fi


refresh_prompt() {
	# NVM
	if which nvm &> /dev/null; then
		RIC_NVM_="$RIC_NVM_COLOR$(nvm ls | grep current | cut -d' ' -f 2 |  sed 's/\sv0\./n/')%{$reset_color%} "
	else
		RIC_NVM_=""
	fi

	# Virtualenv
	if which virtualenvwrapper.sh &> /dev/null; then
		RIC_VENV_="p$(python -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')"
		if [[ $VIRTUAL_ENV != "" ]]; then
			RIC_VENV_="$RIC_VENV_@${VIRTUAL_ENV##*/}"
		fi
		RIC_VENV_="$RIC_VENV_COLOR%(!..$RIC_VENV_ )%{$reset_color%}"
	else
		RIC_VENV_=""
	fi

	# Put it all together!
	PROMPT="
$RIC_NVM_$RIC_VENV_$RIC_RVM_$RIC_HOST_ $RIC_DIR_
$RIC_PROMPT"
}

refresh_prompt

#!/bin/bash

export LC_ALL=en_US.utf-8
export LANG="$LC_ALL"
# let g:NERDTreeDirArrows=0

# To change default shell from zsh to bash
export BASH_SILENCE_DEPRECATION_WARNING=1

# Securities Project
# export GATSBY_APP_TYPE=TRADING
export PATH_PREFIX="/app"
export VOYAGER_LAUNCHER="true"
# export PATH_PREFIX="/"
# export VOYAGER_LAUNCHER="false"

# Load the dotfiles, and source it:
# * ~/.path can be used to extend `$PATH`.
for file in ~/.{paths,tokens,aliases,functions}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing
shopt -s nocaseglob;

# Autocorrect typos in pathname on `cd`
shopt -s cdspell;

# auto completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null; then
  complete -o default -o nospace -F _git g;
fi;

# Git command completion
source /usr/local/etc/bash_completion.d/git-completion.bash
if [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ]; then
  . `brew --prefix`/etc/bash_completion.d/git-completion.bash
fi

###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#
if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -n : -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${words[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
    if type __ltrim_colon_completions &>/dev/null; then
      __ltrim_colon_completions "${words[cword]}"
    fi
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
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

# npm-which
npm-which () {
  npm_bin=$(npm bin)
  bin_name=$1
  local_path="${npm_bin}/${bin_name}"

  [[ -f $local_path ]] && echo "$local_path" && exit 0

  echo $bin_name
}
###-end-npm-completion-###

# react native
export REACT_EDITOR=vim

[ -s "/Users/wonism/.scm_breeze/scm_breeze.sh" ] && source "/Users/wonism/.scm_breeze/scm_breeze.sh"

##
# Your previous /Users/wonism/.bash_profile file was backed up as /Users/wonism/.bash_profile.macports-saved_2021-08-05_at_18:22:44
##

# MacPorts Installer addition on 2021-08-05_at_18:22:44: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

export GPG_TTY=$(tty)
. "$HOME/.cargo/env"

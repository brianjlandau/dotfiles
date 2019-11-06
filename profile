set noclobber

export LC_CTYPE="en_US.UTF-8"

# Setup my personal shell scripts path
PATH="$HOME/bin"
# add developer
PATH="/usr/local/share/npm/bin:$PATH"
# Add go
PATH="/usr/local/Cellar/go/1.8.3/libexec/bin:$PATH"
# add base path
PATH="/usr/bin:/usr/sbin:/bin:/sbin:$PATH"
# add X11 bin
#PATH="/usr/X11/bin:$PATH"
# Add Personal installs
PATH="/usr/local/bin:/usr/local/sbin:$PATH"
# LibreOffice
# PATH=$PATH:/Applications/LibreOffice.app/Contents/MacOS
export PATH

export GOPATH="$HOME/Projects/go-home"

export RUBY_GC_HEAP_INIT_SLOTS=700000
export RUBY_GC_HEAP_FREE_SLOTS=300000
export RUBY_GC_HEAP_GROWTH_FACTOR=1.3


# export AWS_RDS_HOME=~/bin/rds/
# export PATH=$PATH:$AWS_RDS_HOME/bin
export AWS_CREDENTIAL_FILE=~/.aws/credentials

# Start Boid configuration
# BOIDDIR=/Users/brianlandau/.boid
# IOIMPORT="$IOIMPORT:$BOIDDIR/active/lib"
# PATH="$PATH:$BOIDDIR/active/bin"
# export BOIDDIR IOIMPORT PATH
# End Boid configuration

# History control
HISTFILESIZE=100000
export HISTFILESIZE
HISTSIZE=100000
export HISTSIZE
HISTCONTROL=ignoredups:erasedups
export HISTCONTROL
shopt -s histappend

_bash_history_sync() {
  builtin history -a         #1
  HISTFILESIZE=$HISTSIZE     #2
  builtin history -c         #3
  builtin history -r         #4
}

history() {                  #5
  _bash_history_sync
  builtin history "$@"
}

export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}_bash_history_sync;"

GIT_EDITOR="atom -wn"
export GIT_EDITOR

# command alias's
alias cd="pushd"

# command shortcuts
alias llc="ls -Falh"
alias ll="ls -Falh | less -eg"
alias h?="history|grep"
alias gstat='git status'
alias h='history'
alias trest='touch tmp/restart.txt'
alias dir?="ls -1aF | grep"
alias tf='tail -f -n 160'
alias tfdev='tail -f -n 160 log/development.log'
alias be='bundle exec'
alias brk='bin/rake'
alias bra='bin/rails'
alias brg='bin/rails g'
alias brs='bin/rails s'
alias brc='bin/rails c'
alias bss='bin/spring stop'
alias bu='brew upgrade'
alias bcl='brew cleanup'
alias bot="brew outdated | tail"


# project alias's
PROJECT_PARENT_DIRS[0]="$HOME/Projects"
PROJECT_PARENT_DIRS[1]="$HOME/rails"

for PARENT_DIR in ${PROJECT_PARENT_DIRS[@]} ; do
  if [ -d "$PARENT_DIR" ]; then
    for PROJECT_DIR in $(ls $PARENT_DIR); do
      if [ "$PROJECT_DIR" = "viget" ]; then
        for VIGET_PROJECT_DIR in $(ls $PARENT_DIR/$PROJECT_DIR); do
          if [ "$VIGET_PROJECT_DIR" = "${VIGET_PROJECT_DIR#\~}" ]; then
            if [ -d "$PARENT_DIR/$PROJECT_DIR/$VIGET_PROJECT_DIR" ]; then
              alias "$VIGET_PROJECT_DIR"="cd $PARENT_DIR/$PROJECT_DIR/$VIGET_PROJECT_DIR"
            fi
          fi
        done
      else
        if [ "$PROJECT_DIR" = "${PROJECT_DIR#\~}" ]; then
          if [ -d "$PARENT_DIR/$PROJECT_DIR" ]; then
            alias "$PROJECT_DIR"="cd $PARENT_DIR/$PROJECT_DIR"
          fi
        fi
      fi
    done
  fi
done

# . ~/Projects/git-prompt/git-prompt.sh
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. ~/Library/Python/2.7/lib/python/site-packages/powerline/bindings/bash/powerline.sh


export PS4='+${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '

# colorize ls
export CLICOLOR=1
LSCOLORS="exDxcxfxbxegedabaGaCaB"
export LSCOLORS

# colorize grep
GREP_OPTIONS="--color=auto"
export GREP_OPTIONS
export GREP_COLOR='1;34;43'


# include Bash Completion Library
HOMEBREW_PREFIX=$(brew --prefix)
if type brew &>/dev/null; then
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi

export COMP_WORDBREAKS=${COMP_WORDBREAKS/\:/}

_rakecomplete() {
  COMPREPLY=($(compgen -W "`rake -s -T | awk '{{print $2}}'`" -- ${COMP_WORDS[COMP_CWORD]}))
  return 0
}
complete -o default -o nospace -F _rakecomplete rake
# /bash completion

pman(){
	man -t "${1}" | open -f -a /Applications/Preview.app/
}

tflog (){
	tf log/$1.log
}

function gr {
    ## If the current working directory is inside of
    ## a git repository, this function will change
    ## it to the git root (ie, the directory that
    ## contains the .git/ directory), and then print
    ## the new directory.

    git branch > /dev/null 2>&1 || return 1
    cd "$(git rev-parse --show-cdup)".
    pwd
}

link_dotfiles() {
	for dotfile in $(ls -1 ~/dotfiles) ; do
		ln -vsf ~/dotfiles/$dotfile ~/.$dotfile
	done
}

run_spec(){
  bundle exec rspec spec/$1_spec.rb
  terminal-notifier -message "Tests are done!" -title "rspec" -sound Glass -group "rspec:$(pwd)" -activate "com.apple.Terminal"
}

run_specs(){
  bundle exec rspec "$@"
  terminal-notifier -message "Tests are done!" -title "rspec" -sound Glass -group "rspec:$(pwd)" -activate "com.apple.Terminal"
}

run_all_specs(){
  bin/rake spec
  terminal-notifier -message "Tests are done!" -title "rspec" -sound Glass -group "rspec:$(pwd)" -activate "com.apple.Terminal"
}

run_controller_spec(){
  run_spec controllers/$1_controller
}

run_helper_spec(){
  run_spec helpers/$1_helper
}

run_lib_spec(){
  run_spec lib/$1
}

run_model_spec(){
  run_spec models/$1
}

run_routing_spec(){
  run_spec routing/$1_routing
}

run_request_spec(){
  run_spec requests/$1
}

run_feature_spec(){
  run_spec features/$1
}

run_mailer_spec(){
  run_spec mailers/$1
}

alias rcs=run_controller_spec
alias rhs=run_helper_spec
alias rls=run_lib_spec
alias rms=run_model_spec
alias rrs=run_request_spec
alias rfs=run_feature_spec
alias rss=run_specs
alias ras=run_all_specs

export EDITOR='atom -wn'

if [ -f ~/.amazon_keys ]; then
  . ~/.amazon_keys
fi

. `brew --prefix`/etc/profile.d/z.sh

eval "$(rbenv init -)"

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

test -s "$HOME/.kiex/scripts/kiex" && source "$HOME/.kiex/scripts/kiex"

echo "$(uname -s) $(uname -r) $(uname -p)"
echo "$BASH - $BASH_VERSION"

# Add the following to your ~/.bashrc or ~/.zshrc
hitch() {
  command hitch "$@"
  if [[ -s "$HOME/.hitch_export_authors" ]] ; then source "$HOME/.hitch_export_authors" ; fi
}
alias unhitch='hitch -u'
# Uncomment to persist pair info between terminal instances
# hitch

{ eval `ssh-agent`; ssh-add -A; } &>/dev/null

archey -c -o

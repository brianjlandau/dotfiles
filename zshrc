# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

setopt NO_CASE_GLOB
setopt AUTO_CD
setopt auto_pushd
setopt pushdminus

export DIRSTACKSIZE=12

export LC_CTYPE="en_US.UTF-8"
export LANG="en_US.UTF-8"
export WORDCHARS="*?_-.[]~=&;!#$%^(){}<>"

# PATH config
PATH="/usr/local/sbin:$PATH"
# Setup my personal shell scripts path
PATH="$HOME/bin:$PATH"
PATH="/usr/local/anaconda3/bin:$PATH"
export PATH
# /PATH config

# Completion config
autoload -Uz compinit

if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
	compinit
  touch ~/.zcompdump
else
	compinit -C
fi

bindkey '^i' menu-expand-or-complete

zmodload -i zsh/complist
zstyle ':completion:*' menu select=6
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*' list-colors 'exDxcxfxbxegedabaGaCaB'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
# /Completion config

export GOPATH="$HOME/Projects/go-home"

# History config
export HISTFILE="$HOME/.zsh_history"
export SAVEHIST=100000
export HISTSIZE=100000
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt extended_history
# /History config

# ZPLUG config
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "plugins/colored-man-pages", from:oh-my-zsh

zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3

zplug "mafredri/zsh-async", use:"async.zsh", hook-load:"async_init"

zplug "dijitalmunky/nvm-auto"

zplug "romkatv/gitstatus"
# zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme, as:theme
zplug "romkatv/powerlevel10k", as:theme, depth:1

if ! zplug check; then
  zplug install
fi

zplug load
# /ZPLUG config

# Someother ZSH modules
zmodload -i zsh/clone

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

cycle_prompt_char() {
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION=${default_prompt_symbols[$(( $RANDOM % ${#default_prompt_symbols[@]} + 1 ))]}
  p10k reload
}

cycle_error_prompt_char() {
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION=${error_prompt_symbols[$(( $RANDOM % ${#error_prompt_symbols[@]} + 1 ))]}
  p10k reload
}

# POWERLEVEL9K theme config
# Using p10k for now
# POWERLEVEL9K_MODE='nerdfont-complete'
# POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
# POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="144"
# POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="144"
# POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="025"
# POWERLEVEL9K_DIR_ETC_BACKGROUND="blueviolet"
# POWERLEVEL9K_DIR_ETC_FOREGROUND="grey85"
# POWERLEVEL9K_DIR_HOME_FOREGROUND="grey85"
# POWERLEVEL9K_RBENV_FOREGROUND="014"
# POWERLEVEL9K_RBENV_BACKGROUND="darkviolet"
# POWERLEVEL9K_NVM_FOREGROUND="151"
# POWERLEVEL9K_NVM_BACKGROUND="166"
# POWERLEVEL9K_STATUS_VERBOSE=false
# POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
# POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="\uE0C6"
# POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="\uE0B6"
# POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-untracked git-aheadbehind git-remotebranch git-tagname)
# POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%F{blue}\u256D\u2500%F{white}"
# POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{blue}\u2570\uf460%F{white} "
# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs newline nvm rbenv)
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs time)
# /POWERLEVEL9K theme config

alias llc="ls -Falh"
alias tf='tail -f -n 160'
alias h='history'
alias "h?"="fc -l 0 -1 | grep"
alias cls="colorls -A --gs"
alias cllc="colorls -Al --gs"
alias mux="tmuxinator"

# Ruby stuff
export RUBY_GC_HEAP_INIT_SLOTS=700000
export RUBY_GC_HEAP_FREE_SLOTS=300000
export RUBY_GC_HEAP_GROWTH_FACTOR=1.2
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

alias be='bundle exec'
alias brk='bin/rake'
alias bra='bin/rails'
alias brg='bin/rails g'
alias brs='bin/rails s'
alias brc='bin/rails c'
alias bss='bin/spring stop'
alias brsp='bin/rspec'

run_spec(){
  brsp spec/$1_spec.rb
  terminal-notifier -message "Tests are done!" -title "rspec" -sound Glass -group "rspec:$(pwd)" -activate "com.apple.Terminal"
}

run_specs(){
  brsp "$@"
  terminal-notifier -message "Tests are done!" -title "rspec" -sound Glass -group "rspec:$(pwd)" -activate "com.apple.Terminal"
}

run_all_specs(){
  brsp
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

run_system_spec(){
  run_spec system/$1
}

alias rcs=run_controller_spec
alias rhs=run_helper_spec
alias rls=run_lib_spec
alias rms=run_model_spec
alias rss=run_system_spec
alias rsps=run_specs
alias ras=run_all_specs
# /Ruby stuff

export CLICOLOR=1
LSCOLORS="exDxcxfxbxegedabaGaCaB"
export LSCOLORS

GREP_OPTIONS="--color=auto"
export GREP_OPTIONS

GIT_EDITOR="atom -wn"
export GIT_EDITOR

export EDITOR='atom -n'

tflog (){
	tf log/$1.log
}

link_dotfiles() {
	for dotfile in $(ls -1 ~/dotfiles) ; do
    if [[ -f ~/dotfiles/$dotfile ]]; then
		  ln -vsf ~/dotfiles/$dotfile ~/.$dotfile;
    elif [[ -d ~/dotfiles/$dotfile ]]; then
      if [[ "$dotfile" == "config" ]]; then
        for configdir in $(ls -1 ~/dotfiles/$dotfile) ; do
          ln -vsf ~/dotfiles/$dotfile/$configdir ~/.$dotfile/$configdir;
        done
      else
        ln -vsf ~/dotfiles/$dotfile ~/.$dotfile;
      fi
    fi
	done
}

export GPG_TTY=$(tty)

export AWS_CREDENTIAL_FILE=~/.aws/credentials

if [ -f ~/.amazon_keys ]; then
  . ~/.amazon_keys
fi

if [ -f ~/.github_keys ]; then
  . ~/.github_keys
fi

# Shell extensions
. `brew --prefix`/etc/profile.d/z.sh

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
nvm_auto_switch

 eval "$(rbenv init --no-rehash - zsh)"

if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# node "/usr/local/opt/yvm/yvm.js" configure-shell --yvmDir "/usr/local/opt/yvm"
# /Shell extensions

# SSH setup
{ eval `ssh-agent`; ssh-add -A; } &>/dev/null

# Display some system info
echo "$(uname -s) $(uname -r) $(uname -p)"
echo "ZSH $ZSH_VERSION"

# archey -c -o

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

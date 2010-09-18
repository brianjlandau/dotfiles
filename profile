set noclobber

export LC_CTYPE="en_US.UTF-8"

# Setup my personal shell scripts path
PATH="/Users/brianlandau/bin"
# add developer
PATH="/Developer/usr/bin:/Developer/usr/sbin:$PATH"
# add base path
PATH="/usr/bin:/usr/sbin:/bin:/sbin:$PATH"
# add X11 bin
#PATH="/usr/X11/bin:$PATH"
# Add Personal installs
PATH="/usr/local/bin:/usr/local/sbin:$PATH"
# User Ruby Gem bin directory
# PATH="/Library/Ruby/bin:${PATH}"
# Add MAMP PHP
# PATH="/Applications/MAMP/bin/php5/bin:${PATH}"
# Add DarwinPorts
#PATH="/opt/local/bin:/opt/local/sbin:/opt/local/apache2/bin:$PATH"
# ADD REE
#PATH="/usr/local/ree/bin:$PATH"
export PATH

export RUBY_HEAP_MIN_SLOTS=1000000
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_HEAP_FREE_MIN=500000


#MANPATH="/opt/local/share/man:/opt/local/man:/usr/share/man:/usr/local/man"
#export MANPATH

# INFOPATH="/opt/local/share/info:/usr/share/info"
# export INFOPATH

export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home/

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

export RUBYOPT=rubygems
# export RUBYLIB="/Library/Ruby/Site/1.8:/Library/Ruby/Gems/1.8/gems"
# export GEM_PATH="/Library/Ruby/Gems/1.8"
# export GEM_HOME="/Library/Ruby/Gems/1.8"
export GEMDIR=`gem env gemdir`

# -- start rip config -- #
RIPDIR=/Users/brianlandau/.rip
RUBYLIB="$RUBYLIB:$RIPDIR/active/lib"
PATH="$PATH:$RIPDIR/active/bin"
export RIPDIR RUBYLIB PATH
# -- end rip config -- #

# History control
HISTFILESIZE=10000
export HISTFILESIZE
HISTSIZE=10000
export HISTSIZE
HISTCONTROL=erasedups
export HISTCONTROL
shopt -s histappend

GIT_EDITOR="mate -rw"
export GIT_EDITOR

export EC2_HOME="/Users/brianlandau/.ec2"
export PATH=$PATH:$EC2_HOME/bin
export EC2_PRIVATE_KEY="$EC2_HOME/pk-D6ONQIZ22DX3SX5QOPP4B5WIF4PN4T2E.pem"
export EC2_CERT="$EC2_HOME/cert-D6ONQIZ22DX3SX5QOPP4B5WIF4PN4T2E.pem"
export ODEO_AWS_ACCESS_KEY="1EPQ0AM31F3ZHMHJVKR2"
export ODEO_AWS_SECRET_KEY="BI30mhWVADbGMzfLY66a+yLO/MCkKpONEFbXToco"

# command alias's
alias cd="pushd"
alias tree='tree -FC'
alias tmbup="svn up *.tmbundle"
alias supup="svn up Support"
alias hgre="hg rename -A "
alias mate="mate -r"
alias sscm="/Users/brianlandau/bin/sscm/sscm.rb"
alias irb='irb --readline'
alias apinfo='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport'
alias ajaxrdoc="/usr/bin/rdoc --fmt ajax --exclude .*generator.* --exclude .*test.* --exclude .*spec.* --exclude .*pkg.*"
alias rhino="java org.mozilla.javascript.tools.shell.Main"

# command shortcuts
alias ..="cd .."
alias llc="ls -Falh"
alias ll="ls -Falh | less -eg"
alias h?="history|grep"
alias punin="sudo port -f uninstall"
alias gsd='git svn dcommit'
alias gsr='git svn rebase'
alias gstat='git status'
alias h='history'
alias sc='script/console'
alias ss='script/server'
alias trest='touch tmp/restart.txt'
alias dir?="ls -1aF | grep"
alias tf='tail -f -n 160'
alias tfdev='tail -f -n 160 log/development.log'
alias senv64='sudo env ARCHFLAGS="-arch x86_64"'

# directory alias's
alias gemsdir="cd $GEMDIR/gems"
alias rplugins="cd ~/rails/plugindev/vendor/plugins/"

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

. ~/Projects/git-prompt/git-prompt.sh


# Color stuff:
# DULL=0
# BRIGHT=1
# 
# FG_BLACK=30
# FG_RED=31
# FG_GREEN=32
# FG_YELLOW=33
# FG_BLUE=34
# FG_VIOLET=35
# FG_CYAN=36
# FG_WHITE=37
# 
# FG_NULL=00
# 
# BG_BLACK=40
# BG_RED=41
# BG_GREEN=42
# BG_YELLOW=43
# BG_BLUE=44
# BG_VIOLET=45
# BG_CYAN=46
# BG_WHITE=47
# 
# BG_NULL=00
# 
# ##
# # ANSI Escape Commands
# ##
# ESC_CHAR="\033"
# NORMAL_ESCAPE="\[$ESC_CHAR[m\]"
# RESET_ESCAPE="\[$ESC_CHAR[${DULL};${FG_WHITE};${BG_NULL}m\]"
# 
# ##
# # Shortcuts for Colored Text ( Bright and FG Only )
# ##
# 
# # DULL TEXT
# 
# BLACK="\[$ESC_CHAR[${DULL};${FG_BLACK}m\]"
# RED="\[$ESC_CHAR[${DULL};${FG_RED}m\]"
# GREEN="\[$ESC_CHAR[${DULL};${FG_GREEN}m\]"
# YELLOW="\[$ESC_CHAR[${DULL};${FG_YELLOW}m\]"
# BLUE="\[$ESC_CHAR[${DULL};${FG_BLUE}m\]"
# VIOLET="\[$ESC_CHAR[${DULL};${FG_VIOLET}m\]"
# CYAN="\[$ESC_CHAR[${DULL};${FG_CYAN}m\]"
# WHITE="\[$ESC_CHAR[${DULL};${FG_WHITE}m\]"
# 
# # BRIGHT TEXT
# BRIGHT_BLACK="\[$ESC_CHAR[${BRIGHT};${FG_BLACK}m\]"
# BRIGHT_RED="\[$ESC_CHAR[${BRIGHT};${FG_RED}m\]"
# BRIGHT_GREEN="\[$ESC_CHAR[${BRIGHT};${FG_GREEN}m\]"
# BRIGHT_YELLOW="\[$ESC_CHAR[${BRIGHT};${FG_YELLOW}m\]"
# BRIGHT_BLUE="\[$ESC_CHAR[${BRIGHT};${FG_BLUE}m\]"
# BRIGHT_VIOLET="\[$ESC_CHAR[${BRIGHT};${FG_VIOLET}m\]"
# BRIGHT_CYAN="\[$ESC_CHAR[${BRIGHT};${FG_CYAN}m\]"
# BRIGHT_WHITE="\[$ESC_CHAR[${BRIGHT};${BG_WHITE}m\]"
# 
# PS1="${BRIGHT_BLUE}[${VIOLET}\u${BRIGHT_BLUE}]${YELLOW}: ${WHITE}\w ${NORMAL_ESCAPE}\$ ${RESET_ESCAPE}"
# export PS1

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
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

. ~/bin/z.sh

export COMP_WORDBREAKS=${COMP_WORDBREAKS/\:/}

_rakecomplete() {
  COMPREPLY=($(compgen -W "`rake -s -T | awk '{{print $2}}'`" -- ${COMP_WORDS[COMP_CWORD]}))
  return 0
}
complete -o default -o nospace -F _rakecomplete rake

_thorcomplete() {
  COMPREPLY=($(compgen -W "`thor -T | grep -v "^\-\+\|Tasks" | awk '{{print $1}}'`" -- ${COMP_WORDS[COMP_CWORD]}))
}
complete -o default -o nospace -F _thorcomplete thor

_sakecomplete() {
  COMPREPLY=($(compgen -W "`rake -s -T | awk '{{print $2}}'`" -- ${COMP_WORDS[COMP_CWORD]}))
  return 0
}
complete -o default -o nospace -F _sakecomplete sake

complete -C "/usr/bin/gemedit --complete" gemedit
# /bash completion

pman(){
	man -t "${1}" | open -f -a /Applications/Preview.app/
}

tflog (){
	tf log/$1.log
}

tmup(){
	cd /Applications/TextMate.app/Contents
	svn up PlugIns
	cd SharedSupport
	supup
	svn up Themes
	cd Bundles
	tmbup
	cd /Library/Application\ Support/TextMate/Bundles
	tmbup
	echo "All done updating TextMate."
}

retm(){
	echo "Updating TextMate App contents..."
	cd /Applications/TextMate.app/Contents
	rm -fR PlugIns
	svn co http://svn.textmate.org/trunk/PlugIns
	echo "- PlugIns folder updated"
	cd SharedSupport
	rm -fR Support
	svn co http://svn.textmate.org/trunk/Support
	echo "- Support folder updated"
	rm -fR Themes
	svn co http://svn.textmate.org/trunk/Themes
	echo "- Themes updated"
	cd Bundles
	IFS="
	"
	for bundle in $(ls -1)
	do
	  bundleName=${bundle// /\ }
	  if rm -fR $bundleName
	  then
	    echo "- Old $bundleName Deleted"
	    svn co http://svn.textmate.org/trunk/Bundles/$bundleName
	  else
	    echo "Error Deleting "$bundleName
	  fi
	  echo "- Bundle $bundleName update."
	done
	echo "All done updating TextMate."
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

export EDITOR='mate -wr'

if [ -f ~/.amazon_keys ]; then
  . ~/.amazon_keys
fi

[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

echo "$(uname -s) $(uname -r) $(uname -p)"
echo "$BASH - $BASH_VERSION"

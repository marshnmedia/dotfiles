# Add `~/bin` to the `$PATH`
export PATH="$HOME/.composer/vendor/bin:$HOME/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export ANDROID_HOME=/Users/mmarsh/Library/Android/sdk
#export JAVA_HOME=$(/usr/libexec/java_home)

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.custom can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,custom}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null
done

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
#[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
#complete -W "NSGlobalDomain" defaults

# Add `killall` tab completion for common apps
#complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall

# If possible, add tab completion for many more commands
[ -f /etc/bash_completion ] && source /etc/bash_completion

# Free up Ctrl-s and Crtl-s for use with VIM in terminal app
stty -ixon -ixoff

#colors in tmux
#export TERM=xterm-256color
export TERM=screen-256color

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

function perf {
  curl -4 -o /dev/null -s -w "time_namelookup:  %{time_namelookup}\n time_connect:  %{time_connect}\n time_appconnect: %{time_appconnect}\n time_pretransfer:  %{time_pretransfer}\n time_redirect: %{time_redirect}\n time_starttransfer:  %{time_starttransfer}\n ----------\n time_total:  %{time_total}\n -----------\n size_download: %{size_download}\n size_upload: %{size_upload}\n size_header: %{size_header}\n size_request: %{size_request}\n speed_download: %{speed_download}\n speed_upload: %{speed_upload}" "$1"
}

function homestead() { 
  ( cd ~/projects/Homestead && vagrant $* )
}

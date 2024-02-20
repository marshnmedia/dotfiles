[ -n "$PS1" ] && source ~/.bash_profile

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/vagrant/google-cloud-sdk/path.bash.inc' ]; then source '/home/vagrant/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/vagrant/google-cloud-sdk/completion.bash.inc' ]; then source '/home/vagrant/google-cloud-sdk/completion.bash.inc'; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
alias pip=/Users/mmarsh/.pyenv/shims/pip3

eval "$(/opt/homebrew/bin/brew shellenv)"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(rbenv init - zsh)"
eval "$(direnv hook zsh)"

# If using go
# export PATH="$(go env GOPATH)/bin:$PATH"
# eval "$(goenv init -)"

# JB Toolbox App
# export PATH="$PATH:/Users/mascah/Library/Application Support/JetBrains/Toolbox/scripts"

# added by Snowflake SnowSQL installer v1.2
# export PATH=/Applications/SnowSQL.app/Contents/MacOS:$PATH

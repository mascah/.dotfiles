eval "$(/opt/homebrew/bin/brew shellenv)"

# Env vars only — oh-my-zsh plugins handle init for nvm, pyenv, rbenv
export NVM_DIR="$HOME/.nvm"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

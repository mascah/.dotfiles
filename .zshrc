# Pre-load direnv environment before instant prompt so it has nothing to output later
(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Powerlevel10k theme
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Add wisely, as too many plugins slow down shell startup.
plugins=(git kubectl aws rbenv)

source $ZSH/oh-my-zsh.sh

# User configuration

# direnv (must be after instant prompt to avoid p10k warnings)
eval "$(direnv hook zsh)"

# pyenv shell function & completions (PYENV_ROOT/shims/PATH are set in .zprofile)
eval "$(pyenv init -)"

export EZA_COLORS="da=36:uu=32:gu=32"

# 1Password CLI completion
eval "$(op completion zsh)"; compdef _op op

# FZF
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude Library --exclude .git/ --exclude .pyenv/'

# These must be sourced after oh-my-zsh and all other plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source ~/.p10k.zsh

# bun completions
[ -s "/Users/mascah/.bun/_bun" ] && source "/Users/mascah/.bun/_bun"

if [ -f "$HOME/.zsh_aliases" ]; then
    source "$HOME/.zsh_aliases"
fi

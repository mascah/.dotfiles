#!/usr/bin/env bash
# Bootstrap a fresh macOS machine from this dotfiles repo.
#
# Prerequisites:
#   1. macOS with Xcode Command Line Tools (`xcode-select --install`)
#   2. An SSH key on this machine added to GitHub
#      (easiest path: install 1Password from the App Store, sign in,
#      then `op read op://Personal/id_ed25519/notesPlain > ~/.ssh/id_ed25519`
#      after the brew step below. See .dotfiles_readme.md for the full flow.)
#
# Usage: ~/.dotfiles_bootstrap.sh [--personal]
#   --personal also installs .brewfile.personal (1Password CLI, Docker).
#
# This script is idempotent — safe to re-run.

set -euo pipefail

# ---- Xcode CLT sanity check ----
if ! xcode-select -p >/dev/null 2>&1; then
  echo "Xcode Command Line Tools not found. Installing..."
  xcode-select --install
  echo "Re-run this script once the CLT installer finishes."
  exit 0
fi

# ---- Homebrew ----
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# ---- Bare-repo dotfiles ----
DOTFILES_DIR="$HOME/.dotfiles"
config() { /usr/bin/git --git-dir="$DOTFILES_DIR/" --work-tree="$HOME" "$@"; }

if [[ ! -d "$DOTFILES_DIR" ]]; then
  git clone --bare git@github.com:mascah/.dotfiles.git "$DOTFILES_DIR"
fi
config config --local status.showUntrackedFiles no

# Back up any pre-existing files that would be overwritten, then check out
if ! config checkout 2>/dev/null; then
  BACKUP="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$BACKUP"
  config checkout 2>&1 \
    | grep -E "^\s+\." \
    | awk '{print $1}' \
    | while read -r f; do
        mkdir -p "$(dirname "$BACKUP/$f")"
        mv "$HOME/$f" "$BACKUP/$f"
      done
  config checkout
  echo "Backed up conflicting files to $BACKUP"
fi

# ---- Homebrew bundles ----
brew bundle --file="$HOME/.brewfile"
if [[ "${1:-}" == "--personal" ]]; then
  brew bundle --file="$HOME/.brewfile.personal"
fi

# ---- oh-my-zsh (do not overwrite the checked-out .zshrc) ----
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# ---- vim-plug + plugins ----
if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
vim +PlugInstall +qall

# ---- Language servers not covered by brew (pyright, tsserver are in .brewfile) ----
if command -v rustup >/dev/null 2>&1; then
  rustup component add rust-analyzer
fi

cat <<'EOM'

Bootstrap complete. Manual follow-ups:
  - Install MesloLGS NF font and set it in your terminal:
      https://github.com/romkatv/powerlevel10k#manual-font-installation
  - 'gh auth login' to populate ~/.config/gh/hosts.yml (not tracked)
  - Open a new shell and verify: nvm --version, pyenv versions, vim, p10k
EOM

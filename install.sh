#!/usr/bin/env bash
#
# Bootstrap script for dotfiles on a fresh macOS (Apple Silicon) machine.
#
# Usage (from a fresh machine):
#   bash <(curl -sL https://raw.githubusercontent.com/nffdiogosilva/dotfiles/main/install.sh)
#
set -euo pipefail

DOTFILES="$HOME/.dotfiles"

# ── Helpers ──────────────────────────────────────────────────────────────────
info()  { printf '\033[1;34m→ %s\033[0m\n' "$*"; }
ok()    { printf '\033[1;32m✔ %s\033[0m\n' "$*"; }
fail()  { printf '\033[1;31m✖ %s\033[0m\n' "$*"; exit 1; }

# ── Xcode Command Line Tools ────────────────────────────────────────────────
if ! xcode-select -p &>/dev/null; then
  info "Installing Xcode Command Line Tools…"
  xcode-select --install
  echo "Press any key after the installation finishes…"
  read -rsn1
fi
ok "Xcode CLT"

# ── Homebrew ─────────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
ok "Homebrew"

# ── Brew formulae ────────────────────────────────────────────────────────────
FORMULAE=(
  stow
  starship
  lazygit
  yazi
  gh
  pgcli
  btop
  jq
  ripgrep
  fd
  fzf
  zoxide
  tmux
  glow
  docker
)

CASKS=(
  ghostty
  nikitabobko/tap/aerospace
  raycast
)

info "Installing Homebrew formulae…"
brew install "${FORMULAE[@]}"
ok "Formulae"

info "Installing Homebrew casks…"
brew install --cask "${CASKS[@]}" 2>/dev/null || true
ok "Casks"

# ── Rust (for cargo-based tools if needed) ───────────────────────────────────
if ! command -v rustup &>/dev/null; then
  info "Installing Rust…"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
fi
ok "Rust"

# ── Helix (built from fork) ─────────────────────────────────────────────────
HELIX_SRC="$HOME/Developer/oss/helix"
if [ ! -d "$HELIX_SRC" ]; then
  info "Cloning Helix fork…"
  mkdir -p "$HOME/src"
  git clone https://github.com/nffdiogosilva/helix.git "$HELIX_SRC"
fi
cd "$HELIX_SRC"
git pull --rebase
REPO_COMMIT="$(git rev-parse --short HEAD)"
if command -v hx &>/dev/null; then
  INSTALLED_COMMIT="$(hx --version | awk '{print $3}' | tr -d '()')"
fi
if [ "${INSTALLED_COMMIT:-}" = "$REPO_COMMIT" ]; then
  info "Helix already at $REPO_COMMIT, skipping build"
else
  info "Building Helix from source ($REPO_COMMIT)…"
  cargo install --path helix-term --locked
fi
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/helix"
ln -sf "$HELIX_SRC/runtime" "${XDG_CONFIG_HOME:-$HOME/.config}/helix/runtime"
ok "Helix (from fork)"

# ── Clone dotfiles ───────────────────────────────────────────────────────────
if [ ! -d "$DOTFILES" ]; then
  info "Cloning dotfiles…"
  git clone https://github.com/nffdiogosilva/dotfiles.git "$DOTFILES"
  cd "$DOTFILES"
  git submodule update --init --recursive
else
  info "Dotfiles already cloned, pulling latest…"
  cd "$DOTFILES"
  git pull --rebase
  git submodule update --init --recursive
fi
ok "Dotfiles repo"

# ── Stow ─────────────────────────────────────────────────────────────────────
info "Symlinking dotfiles with stow…"
cd "$DOTFILES"
stow home config zsh local
ok "Stow"

# ── TPM (Tmux Plugin Manager) ───────────────────────────────────────────────
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  info "Installing TPM…"
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi
ok "TPM"

# ── Set default shell to Homebrew zsh ────────────────────────────────────────
BREW_ZSH="$(brew --prefix)/bin/zsh"
if ! grep -qF "$BREW_ZSH" /etc/shells; then
  info "Adding Homebrew zsh to /etc/shells…"
  echo "$BREW_ZSH" | sudo tee -a /etc/shells >/dev/null
fi
if [ "$SHELL" != "$BREW_ZSH" ]; then
  info "Changing default shell to Homebrew zsh…"
  chsh -s "$BREW_ZSH"
fi
ok "Default shell"

# ── Done ─────────────────────────────────────────────────────────────────────
echo ""
ok "All done! Open a new terminal to start using your dotfiles."
echo "   Don't forget to create ~/.config/zsh/secrets.zsh for your API keys."

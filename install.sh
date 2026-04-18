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
# Core CLI utilities
CORE_FORMULAE=(
  stow
  starship
  tmux
  gh
  jq
  ripgrep
  fd
  fzf
  zoxide
  eza
  tree
  glow
  btop
  yazi
  lazygit
)

# Development tools
DEV_FORMULAE=(
  neovim
  just
  lefthook
  tree-sitter-cli
  uv
  pgcli
  docker
)

# Cloud / Kubernetes tooling
CLOUD_FORMULAE=(
  awscli
  azure-cli
  kubernetes-cli
  helm
  kustomize
  argocd
)

# ── Brew casks ───────────────────────────────────────────────────────────────
# Terminals / window management
TERMINAL_CASKS=(
  ghostty
  warp
  nikitabobko/tap/aerospace
)

# Security / networking
SECURITY_CASKS=(
  bitwarden
  cloudflare-warp
  tailscale-app
)

# Daily apps
DAILY_CASKS=(
  google-chrome
  slack
  microsoft-teams
  whatsapp
  notion
  notion-calendar
)

# AI tools (Claude Code CLI is installed separately via official script)
AI_CASKS=(
  claude
  codex
  codex-app
)

info "Installing Homebrew formulae…"
brew install \
  "${CORE_FORMULAE[@]}" \
  "${DEV_FORMULAE[@]}" \
  "${CLOUD_FORMULAE[@]}"
ok "Formulae"

info "Installing Homebrew casks…"
brew install --cask \
  "${TERMINAL_CASKS[@]}" \
  "${SECURITY_CASKS[@]}" \
  "${DAILY_CASKS[@]}" \
  "${AI_CASKS[@]}" 2>/dev/null || true
ok "Casks"

# ── Claude Code (official installer) ─────────────────────────────────────────
if ! command -v claude &>/dev/null; then
  info "Installing Claude Code via official script…"
  curl -fsSL https://claude.ai/install.sh | bash
fi
ok "Claude Code"

# ── Amp (official installer) ─────────────────────────────────────────────────
if ! command -v amp &>/dev/null; then
  info "Installing Amp via official script…"
  curl -fsSL https://ampcode.com/install.sh | bash
fi
ok "Amp"

# ── GitHub auth (mandatory — provisions SSH key on GitHub) ──────────────────
# Must run *before* the SSH URL rewrite below, otherwise HTTPS fallbacks break
# on a fresh machine that has no key on GitHub yet.
# `gh auth login --git-protocol ssh --web` will:
#   1. generate ~/.ssh/id_ed25519 if missing
#   2. open a browser for OAuth
#   3. upload the public key to GitHub
if ! gh auth status &>/dev/null; then
  info "Authenticating with GitHub (browser will open; gh will upload an SSH key)…"
  gh auth login --git-protocol ssh --web
fi
gh auth status &>/dev/null || fail "gh auth login did not complete — rerun the script after authenticating"
ok "GitHub auth"

# Pre-accept github.com host key so the first SSH clone doesn't prompt
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
if ! grep -q "^github.com " "$HOME/.ssh/known_hosts" 2>/dev/null; then
  ssh-keyscan -t rsa,ecdsa,ed25519 github.com 2>/dev/null >> "$HOME/.ssh/known_hosts"
fi
ok "SSH known_hosts"

# ── Git: use SSH for all GitHub HTTPS URLs ──────────────────────
# Safe now that gh has provisioned an SSH key above.
git config --global url."git@github.com:".insteadOf "https://github.com/"
ok "Git SSH URL rewrite"

# ── Clone dotfiles ───────────────────────────────────────────────────────────
if [ ! -d "$DOTFILES" ]; then
  info "Cloning dotfiles…"
  # HTTPS URL here gets rewritten to SSH by the git config set above
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
# `gh auth login` above wrote a default ~/.config/gh/config.yml which blocks
# stow from symlinking the tracked one. If it's a real file (not already our
# stow symlink), remove it so stow can take over.
if [ -f "$HOME/.config/gh/config.yml" ] && ! [ -L "$HOME/.config/gh/config.yml" ]; then
  rm "$HOME/.config/gh/config.yml"
fi

info "Symlinking dotfiles with stow…"
cd "$DOTFILES"
stow home config zsh local
# --no-folding so stow symlinks individual files inside ~/.claude,
# not the whole directory (Claude writes session state there at runtime)
mkdir -p "$HOME/.claude"
stow --no-folding claude
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

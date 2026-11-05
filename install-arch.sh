#!/usr/bin/env bash
# Set up these dotfiles on Arch Linux. Requires yay; run as your normal user.
# Safe to re-run: installed packages, existing clones and links are left alone.
#
# Note: this runs a full system upgrade (yay -Syu), because installing on top
# of a stale package database is a partial upgrade, which Arch does not support.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# Stow packages. Left out: omniwm (macOS only) and bash (.bashrc only does
# `exec zsh`, which the login shell change below makes unnecessary).
STOW_PACKAGES=(zsh git kitty ghostty starship nvim tmux yazi asdf ssh gh)

REPO_PACKAGES=(
  # Core
  stow git base-devel zsh curl wget unzip jq
  # Terminal and shell tools
  kitty ghostty tmux starship zoxide eza yazi github-cli git-delta
  ripgrep fd fzf bat lazydocker podman
  # Fonts used by the terminals, prompt and tmux status bar
  ttf-jetbrains-mono ttf-jetbrains-mono-nerd
  # Neovim: clipboard, treesitter parsers, image.nvim
  neovim wl-clipboard xclip tree-sitter-cli imagemagick luarocks lua51
  # Toolchains Mason needs for the PHP and Elixir tools
  php composer elixir
  # Build dependencies for the asdf Python
  openssl zlib xz tk libffi bzip2 readline sqlite
)

# Built from the AUR. Installed without --noconfirm so PKGBUILDs can be reviewed.
AUR_PACKAGES=(asdf-vm tmux-mem-cpu-load)

ASDF_PLUGINS=(nodejs rust golang python java)

log() { printf '\n==> %s\n' "$*"; }
warn() { printf 'warning: %s\n' "$*" >&2; }

# Print the names yay can resolve; warn about the rest so that one renamed
# package does not abort the whole install.
available() {
  local pkg
  for pkg in "$@"; do
    if yay -Si "$pkg" >/dev/null 2>&1; then
      printf '%s\n' "$pkg"
    else
      warn "package not found, skipping: $pkg"
    fi
  done
}

install_packages() {
  local pkg repo=() aur=()

  log "Upgrading the system"
  yay -Syu --noconfirm

  log "Installing repo packages"
  while IFS= read -r pkg; do repo+=("$pkg"); done < <(available "${REPO_PACKAGES[@]}")
  yay -S --needed --noconfirm "${repo[@]}"

  log "Installing AUR packages"
  while IFS= read -r pkg; do aur+=("$pkg"); done < <(available "${AUR_PACKAGES[@]}")
  if ((${#aur[@]})); then
    yay -S --needed "${aur[@]}"
  fi
}

# Move anything stow would refuse to overwrite, such as an existing ~/.zshrc,
# into $BACKUP.
backup_conflicts() {
  local package=$1 src rel target
  while IFS= read -r -d '' src; do
    rel=${src#"$DOTFILES/$package/"}
    target=$HOME/$rel
    [[ -e $target || -L $target ]] || continue
    # Already linked. Compare the link text, not what it points to, because
    # nvim/.config/nvim/nvim dangles. The parent check covers stow-folded dirs.
    [[ -L $target && "$(readlink "$target")" == *"/$package/$rel" ]] && continue
    [[ "$(dirname "$target")" -ef "$(dirname "$src")" ]] && continue
    mkdir -p "$BACKUP/$(dirname "$rel")"
    mv "$target" "$BACKUP/$rel"
    printf 'backed up ~/%s\n' "$rel"
  done < <(find "$DOTFILES/$package" \( -type f -o -type l \) -print0)
}

link_dotfiles() {
  local package
  log "Linking dotfiles"
  # Create these first so stow links the files inside them. If it linked the
  # directories themselves, SSH keys and gh's auth token would land in the repo.
  mkdir -p "$HOME/.config/gh"
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"

  for package in "${STOW_PACKAGES[@]}"; do
    backup_conflicts "$package"
    stow --dir="$DOTFILES" --target="$HOME" --restow "$package"
  done
}

clone() {
  [[ -d $2 ]] || git clone --depth 1 "$1" "$2"
}

install_plugins() {
  log "Installing zsh and tmux plugins"
  # .zshrc loads these from ~/.zsh on Linux.
  clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
  clone https://github.com/z-shell/F-Sy-H "$HOME/.zsh/F-Sy-H"
  clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
}

set_login_shell() {
  local zsh_path
  zsh_path="$(command -v zsh)"
  if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$zsh_path" ]]; then
    log "Changing login shell to zsh"
    chsh -s "$zsh_path"
  fi
}

# Runs last: compiling Python takes a while, and a version that is no longer
# available should not undo the rest of the setup.
install_runtimes() {
  local plugin
  log "Installing runtimes from ~/.tool-versions"
  export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
  export PATH="$ASDF_DATA_DIR/shims:$PATH"

  if ! command -v asdf >/dev/null; then
    warn "asdf is not installed, skipping runtimes"
    return 0
  fi

  mkdir -p "$ASDF_DATA_DIR/completions"
  asdf completion zsh >"$ASDF_DATA_DIR/completions/_asdf"

  for plugin in "${ASDF_PLUGINS[@]}"; do
    if ! asdf plugin list 2>/dev/null | grep -qx "$plugin"; then
      asdf plugin add "$plugin"
    fi
  done

  (cd "$HOME" && asdf install) || warn "asdf install failed; fix it, then run: cd ~ && asdf install"
}

main() {
  if ((EUID == 0)); then
    echo "Run this as your normal user, not root: yay refuses to run as root." >&2
    exit 1
  fi
  if ! command -v pacman >/dev/null || ! command -v yay >/dev/null; then
    echo "This script needs Arch Linux with yay installed." >&2
    exit 1
  fi

  install_packages
  link_dotfiles
  install_plugins
  set_login_shell
  install_runtimes

  [[ -d $BACKUP ]] && log "Replaced files were saved in $BACKUP"
  cat <<'EOF'

==> Done. Finish these by hand, after logging out and back in:
  gh auth login                 authenticate gh; git uses it for GitHub
  tmux, then prefix + I         install tmux plugins
  nvim, then :MasonToolsInstall install LSP servers and formatters
EOF
}

main "$@"

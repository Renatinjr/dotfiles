# ~/.zshrc — portable (macOS + Linux). Managed via dotfiles + GNU stow.

# --- History ---
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -v

# --- OS detection ---
case "$(uname -s)" in
  Darwin) IS_MAC=1 ;;
  *)      IS_MAC=0 ;;
esac

# --- Homebrew (macOS) ---
if [ "$IS_MAC" = 1 ]; then
  if [ -x /opt/homebrew/bin/brew ]; then        # Apple Silicon (M3)
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then         # Intel fallback
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# --- PATH ---
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# --- Vars ---
export EDITOR="nvim"
export RUST_WITHOUT=rust-docs
# GH_TOKEN intentionally NOT set here — run `gh auth login` instead (token stored in gh's keyring).

# --- Starship prompt ---
export STARSHIP_CONFIG=~/.config/starship.toml
export STARSHIP_CACHE=~/.starship/cache
command -v starship >/dev/null && eval "$(starship init zsh)"

# --- zsh plugins (brew path on mac, ~/.zsh fallback) ---
if [ "$IS_MAC" = 1 ] && command -v brew >/dev/null; then
  ZPLUG="$(brew --prefix)/share"
  [ -f "$ZPLUG/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$ZPLUG/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [ -f "$ZPLUG/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "$ZPLUG/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
else
  [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
  [ -f ~/.zsh/F-Sy-H/F-Sy-H.plugin.zsh ] && source ~/.zsh/F-Sy-H/F-Sy-H.plugin.zsh
  [ -f ~/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh ] && source ~/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh
fi

# --- asdf (version manager) ---
export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
export PATH="$ASDF_DATA_DIR/shims:$PATH"
fpath=("$ASDF_DATA_DIR/completions" $fpath)
autoload -Uz compinit && compinit

# --- Android SDK (path differs per OS) ---
if [ "$IS_MAC" = 1 ]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
else
  export ANDROID_HOME="$HOME/Android/Sdk"
fi
export ANDROID_SDK_ROOT="$ANDROID_HOME"
[ -d "$ANDROID_HOME" ] && export PATH="$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/cmdline-tools/latest/bin"

# --- pnpm ---
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# --- Aliases ---
alias myip="curl -s https://ipinfo.io/ip"
command -v eza >/dev/null && alias ls=eza
alias lzd=lazydocker
alias kthemes="kitty +kitten themes"
# Linux used podman as a docker shim; on macOS use Docker Desktop / colima directly.
if [ "$IS_MAC" = 0 ]; then
  alias docker="sudo podman"
fi

# --- zoxide (smart cd) ---
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd cd)"

# --- Linux-only desktop env ---
if [ "$IS_MAC" = 0 ]; then
  export QT_WAYLAND_DECORATION=whitesur-gtk
fi

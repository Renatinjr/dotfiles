# dotfiles

Personal dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each top-level directory is a **stow package** whose contents mirror `$HOME`.

```
zsh/.zshrc                -> ~/.zshrc
kitty/.config/kitty/...   -> ~/.config/kitty/...
ghostty/.config/ghostty/. -> ~/.config/ghostty/...
git/.gitconfig            -> ~/.gitconfig
```

## Packages

| Package    | Installs to            | Notes |
|------------|------------------------|-------|
| `zsh`      | `~/.zshrc`             | OS-aware (macOS + Linux) |
| `bash`     | `~/.bashrc`            | |
| `git`      | `~/.gitconfig`         | |
| `kitty`    | `~/.config/kitty`      | Terminal (legacy) |
| `ghostty`  | `~/.config/ghostty`    | Terminal (active); `config` includes `config.ghostty` |
| `starship` | `~/.config/starship.toml` | Prompt |
| `nvim`     | `~/.config/nvim`       | Plugins pinned via `lazy-lock.json` |
| `tmux`     | `~/.tmux.conf`, `~/.config/tmux` | Active tmux config and status bar script |
| `yazi`     | `~/.config/yazi`       | File manager |
| `asdf`     | `~/.tool-versions`     | Runtime versions |
| `ssh`      | `~/.ssh/config`        | Host aliases only — **keys are not in this repo** |
| `gh`       | `~/.config/gh/config.yml` | gh CLI prefs (auth `hosts.yml` is gitignored) |
| `omniwm`   | `~/.config/omniwm/settings.toml` | OmniWM tiling WM (macOS 26+); i3-style Option+hjkl keys, Dwindle layout. Strict schema — edit values in place |

## Fresh setup on macOS (Apple Silicon / M3)

```sh
# 1. Xcode CLT + Homebrew
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# 2. Core tools
brew install stow git neovim kitty starship zoxide eza tmux yazi gh asdf \
             zsh-autosuggestions zsh-syntax-highlighting

# 3. Clone
git clone https://github.com/Renatinjr/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 4. Stow the packages you want (NOT .tmux)
stow zsh git kitty starship nvim tmux yazi asdf ssh gh omniwm

# 5. Runtimes via asdf (versions come from ~/.tool-versions)
for p in nodejs rust golang python java; do asdf plugin add $p; done
asdf install        # reads ~/.tool-versions

# 6. tmux plugins (tpm) — see note below
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux                # then press: prefix + I  to install plugins

# 7. Authenticate gh (do NOT hardcode a token)
gh auth login
```

> The nvim config pins plugins via `lazy-lock.json`; first `nvim` launch will
> bootstrap lazy.nvim and restore them. A local `node_modules/typescript` is
> required per-project for TS LSP diagnostics.

## Fresh setup on Arch Linux

Needs `yay` already installed. Run it as your normal user, not root:

```sh
git clone https://github.com/Renatinjr/dotfiles.git ~/dotfiles
~/dotfiles/install-arch.sh
```

The script is safe to re-run. It:

1. Upgrades the system (`yay -Syu`), then installs the repo and AUR packages.
   Any package name it can't find is skipped with a warning.
2. Stows every package except `omniwm` (macOS only) and `bash`. Files that would
   conflict are moved to `~/.dotfiles-backup/<timestamp>/`.
3. Clones the zsh plugins into `~/.zsh` and tpm into `~/.tmux/plugins/tpm`.
4. Sets zsh as the login shell (`chsh` asks for your password).
5. Installs the runtimes from `~/.tool-versions` with asdf. This step runs last
   and takes the longest, because Python compiles from source.

Then log out and back in, and finish by hand:

```sh
gh auth login        # git uses gh for GitHub credentials
tmux                 # then press: prefix + I  to install plugins
nvim                 # then run: :MasonToolsInstall
```

> The `cmd+…` keybinds in Ghostty and kitty become `Super+…` on Linux, so your
> compositor may catch them before they reach tmux.

## Migration gotchas (from the Arch → Mac move)

- **GH token:** the old Arch `~/.zshrc` had a hardcoded `ghp_…` PAT. It is **not**
  in this repo. Rotate it and use `gh auth login` going forward.
- **tmux plugins** under `.tmux/.tmux/plugins/` are committed as bare gitlinks
  with **no `.gitmodules`**, so a plain `git clone` leaves them empty. Install
  tpm fresh (step 6) instead of relying on them.
- **Linux-only bits** in `.zshrc` (podman docker-shim, `QT_WAYLAND_DECORATION`,
  Android SDK path) are guarded by an OS check and stay dormant on macOS.
- **DataGrip/JetBrains** state is intentionally **not** tracked (gitignored).
  Sync IDE settings via JetBrains Settings Sync instead.

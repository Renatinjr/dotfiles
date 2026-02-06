# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v

#Path
export PATH=$PATH:/home/renatojr/.local/bin
export PATH=$PATH:/home/renatojr/.asdf/installs/rust/1.81.0/bin/

# eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/base.json)"
#Vars
export EDITOR="neovim"
export TERM=xterm-256color
export RUST_WITHOUT=rust-docs

#Starship
export STARSHIP_CONFIG=~/.config/starship.toml
export STARSHIP_CACHE=~/.starship/cache
eval "$(starship init zsh)"


#Source pluguins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/F-Sy-H/F-Sy-H.plugin.zsh
source ~/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh

#Asdf
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
#Alias
alias lzd=lazydocker
alias myip="curl -s https://ipinfo.io/ip"
alias ls=eza
alias kthemes="kitty +kitten themes"
alias docker="sudo podman"
alias "docker compose"="sudo podman compose"
# eval "$(ssh-agent -s)"

#Bat
#

#Eval
eval "$(zoxide init zsh --cmd cd)"
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi


ZSH=$HOME/.oh-my-zsh

# You can change the theme with another one from https://github.com/robbyrussell/oh-my-zsh/wiki/themes
ZSH_THEME="robbyrussell"

# Useful oh-my-zsh plugins for Le Wagon bootcamps
plugins=(git gitfast last-working-dir common-aliases zsh-syntax-highlighting history-substring-search pyenv)

# (macOS-only) Prevent Homebrew from reporting - https://github.com/Homebrew/brew/blob/master/docs/Analytics.md
export HOMEBREW_NO_ANALYTICS=1

# Disable warning about insecure completion-dependent directories
ZSH_DISABLE_COMPFIX=true

# Actually load Oh-My-Zsh
source "${ZSH}/oh-my-zsh.sh"
unalias rm # No interactive rm by default (brought by plugins/common-aliases)

# Load rbenv if installed (to manage your Ruby versions)
export PATH="${HOME}/.rbenv/bin:${PATH}" # Needed for Linux/WSL
type -a rbenv > /dev/null && eval "$(rbenv init -)"

# Load pyenv (to manage your Python versions)
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
type -a pyenv > /dev/null && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init -)" && RPROMPT+='[🐍 $(pyenv_prompt_info)]'

# Load nvm (to manage your node versions)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Call `nvm use` automatically in a directory with a `.nvmrc` file
autoload -U add-zsh-hook
load-nvmrc() {
  if nvm -v &> /dev/null; then
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use --silent
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      nvm use default --silent
    fi
  fi
}
type -a nvm > /dev/null && add-zsh-hook chpwd load-nvmrc
type -a nvm > /dev/null && load-nvmrc

# Rails and Ruby uses the local `bin` folder to store binstubs.
# So instead of running `bin/rails` like the doc says, just run `rails`
# Same for `./node_modules/.bin` and nodejs
export PATH="./bin:./node_modules/.bin:${PATH}:/usr/local/sbin"

# Store your own aliases in the ~/.aliases file and load the here.
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Encoding stuff for the terminal
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export BUNDLER_EDITOR=code
export EDITOR=code

# Set ipdb as the default Python debugger
export PYTHONBREAKPOINT=ipdb.set_trace

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="/Users/RicardoGonzales/.local/bin:$PATH"



# Added by Antigravity
export PATH="/Users/RicardoGonzales/.antigravity/antigravity/bin:$PATH"

# bun completions
[ -s "/Users/RicardoGonzales/.bun/_bun" ] && source "/Users/RicardoGonzales/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Added by Antigravity IDE
export PATH="/Users/RicardoGonzales/.antigravity-ide/antigravity-ide/bin:$PATH"

# --- Quick project dirs ---
hash -d artlens=/Users/RicardoGonzales/code/artlens/ArtLens
hash -d galleryiq=/Users/RicardoGonzales/code/ArtGalleryIQ
hash -d artcheck=/Users/RicardoGonzales/art_provenance_tool
hash -d aciq=/Users/RicardoGonzales/artcollectoriq_new_ai
hash -d cultural=/Users/RicardoGonzales/code/artnews-site
hash -d ig-cultural=/Users/RicardoGonzales/instagram-culturalsignal
hash -d ig-aciq=/Users/RicardoGonzales/code/instagram-artagent
hash -d ig-wey=/Users/RicardoGonzales/instagram-wey-advisory
hash -d scrapy=/Users/RicardoGonzales/code/InkaOro/scrapy-projects
hash -d auction=/Users/RicardoGonzales/code/InkaOro/auction-reporting
hash -d upload=/Users/RicardoGonzales/code/InkaOro/artcollectoriq_db
hash -d amoru=/Users/RicardoGonzales/code/Amoru.ai
hash -d eco=/Users/RicardoGonzales/code/ecosystem-strategy
export AGIQ_APPLE_PT='128491729'

# mini [name] — Mac mini. No arg: plain ssh. With a name: make ~/code/<name> on the mini,
# open (or reuse) a tmux window of that name in the `fleet` session running Claude Code, and attach.
# Detach with Ctrl-b d; the window and Claude keep running on the mini.  (2026-10-28)
mini() {
  if [ $# -eq 0 ]; then command ssh mini; return; fi
  local name="$1"
  if [[ ! "$name" =~ ^[A-Za-z0-9._-]+$ ]]; then echo "mini: name must be letters, digits, . _ -"; return 1; fi
  command ssh -t mini "zsh -lc 'mkdir -p ~/code/$name; tmux has-session -t fleet 2>/dev/null || tmux new-session -d -s fleet -c ~/code; if ! tmux list-windows -t fleet -F \"#W\" | grep -qx \"$name\"; then tmux new-window -d -t fleet -n \"$name\" -c ~/code/$name \"claude; exec zsh -l\"; fi; exec tmux attach -t fleet:$name'"
}
# mstatus — email-campaign status from the Mac mini (jobs, what is sending, today's counts, throttles, log tails)
mstatus() { command ssh mini 'code/fleet/bin/status.sh'; }

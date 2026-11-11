# ~/.zshrc — fish-like UX on zsh (suggestions, highlighting, completions)

# --- History ---
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE INC_APPEND_HISTORY

# --- Completions ---
fpath=(/usr/share/zsh/site-functions $fpath)
autoload -U compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# --- Fish-like behavior ---
setopt autocd
setopt interactive_comments

export EDITOR=nvim

# --- Plugins ---
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'

# fzf-tab: tab completion via fzf with previews
[ -f /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh ] && \
  source /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

# zsh-abbr: fish-like abbreviations
[ -f /usr/share/zsh/plugins/zsh-abbr/zsh-abbr.plugin.zsh ] && \
  source /usr/share/zsh/plugins/zsh-abbr/zsh-abbr.plugin.zsh

# forgit: fzf-based git commands (glo, gss, ga, ...)
[ -f /usr/share/zsh/plugins/forgit/forgit.plugin.zsh ] && \
  source /usr/share/zsh/plugins/forgit/forgit.plugin.zsh

# history-substring-search: arrows search history by typed prefix
[ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ] && \
  source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# --- Prompt and navigation ---
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# --- fzf ---
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# --- Aliases ---
alias ls='eza --icons'
alias ll='eza -la --icons'
alias lt='eza --tree --icons'
alias cat='bat --style=plain --paging=never'

# --- Syntax highlighting — must be sourced last! ---
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

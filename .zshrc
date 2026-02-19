# 1. 環境變數優先
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
export LANG="en_US.UTF-8"

# 2. 歷史紀錄
# --- 歷史紀錄設定 ---
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=99999
setopt HIST_IGNORE_ALL_DUPS  # 不記錄重複指令
setopt share_history         # 不同視窗同步紀錄

# 使用 zshaddhistory 函式來精確過濾不想紀錄的指令
zshaddhistory() {
	    # 使用正規表達式匹配你不想紀錄的指令
	    # [[ $1 匹配模式 ]]
	    if [[ "$1" =~ "^(ls|cd|pwd|exit|la|bye|gitui|musicDownloadTui|tmux| )" ]]; then
		            return 1
				        fi
					    return 0
}

# 3. 初始化補全系統 (放在外掛之前)
zstyle ':completion:*' menu yes select
autoload -Uz compinit && compinit

# 3.1載入 fzf 的補全功能與按鍵綁定 (MacPorts 路徑)
[ -f /opt/local/share/fzf/shell/completion.zsh ] && source /opt/local/share/fzf/shell/completion.zsh
[ -f /opt/local/share/fzf/shell/key-bindings.zsh ] && source /opt/local/share/fzf/shell/key-bindings.zsh

# 4. 外掛載入 (MacPorts 路徑)
[ -f /opt/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /opt/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f /opt/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /opt/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# 5. 初始化工具
eval "$(zoxide init zsh)"

# 6. Prompt 設定
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats 'on branch %b %m%u%c'
setopt promptsubst
PROMPT='%F{20}%~ %F{13}${vcs_info_msg_0_}%f
%F{6}%#%f '

# 7. 按鍵綁定
bindkey -e
bindkey "^D" delete-char-or-list
unsetopt IGNORE_EOF

# 8. Alias
alias la="ls -Gla"
alias ll="ls -Gl"
alias vpnLocation="curl ipinfo.io/country"
alias musicDownloadTui="~/ShellScripts/musicDownloadTui.sh"

# 讓 Ctrl-X Ctrl-E 可以編輯長指令
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

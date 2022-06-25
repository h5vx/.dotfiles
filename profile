export TERMINAL=kitty
export EDITOR=nvim
export WORKON_HOME=~/.venv
export QT_AUTO_SCREEN_SCALE_FACTOR=1

# "less" pager configuration
# -i for case-insensitive search
# -R for raw control characters (e.g. ANSI colors, useful when piping dmesg)
export LESS="-i -R"

export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

if [ -d $HOME/.local/bin ]; then
    export PATH=$PATH:$HOME/.local/bin
fi

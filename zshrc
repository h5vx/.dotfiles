setopt histignorespace

source /usr/share/zsh/share/zgen.zsh

SPACESHIP_CHAR_SYMBOL=" "
autoload -U promptinit; promptinit
prompt spaceship

# Customize notification and add sound for bgnotify plugin
function bgnotify_formatted { ## args: (exit_status, command, elapsed_seconds)
    elapsed="$(( $3 % 60 ))s"
    (( $3 >= 60 )) && elapsed="$((( $3 % 3600) / 60 ))m $elapsed"
    (( $3 >= 3600 )) && elapsed="$(( $3 / 3600 ))h $elapsed"
    [ $1 -eq 0 ] && {
        bgnotify "✅ win (took $elapsed)" "$2"
        paplay /usr/share/sounds/freedesktop/stereo/dialog-information.oga
    } || {
        bgnotify "❌ fail (took $elapsed)" "$2"
        paplay /usr/share/sounds/freedesktop/stereo/dialog-error.oga
    }
}

# if the init script doesn't exist
if ! zgen saved; then
  plugins=(
      git
      ansible
      git
      colored-man-pages
      # zsh-autosuggestions
      # zsh-syntax-highlighting
      bgnotify
  )

  zgen oh-my-zsh

  # generate the init script from plugins above
  zgen save
fi

zgen load aperezdc/virtualz
zgen load zsh-users/zsh-autosuggestions
zgen load zsh-users/zsh-syntax-highlighting

VIRTUALZ_HOME="$HOME/.venv"

export EDITOR=nvim

alias ls="exa -b --git --icons --group-directories-first"
alias l="ls -lah"
alias to-en="trans -from ru -to en"
alias to-ru="trans -from en -to ru"
alias loadnvm="source /usr/share/nvm/init-nvm.sh"

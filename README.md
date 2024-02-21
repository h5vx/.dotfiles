# .dotfiles
Managed by [rcm](https://github.com/thoughtbot/rcm)

When files added or removed in that repo, don't forget to run **rcup**!

**Note:** `compton.conf` is host-specific, because of different settings for different GPUs. Copy and adjust manually.

# Installation notes
## 1. Install packages
### 1. Install from official repos
```
base-devel
wget
tmux
git
rcm
firefox
proxychains
imagemagick
rofi
ripgrep
fd
cantarell-fonts
ttf-joypixels
ttf-roboto
ttf-dejavu
ttf-jetbrains-mono
ttf-jetbrains-mono-nerd
ttf-firacode-nerd
kitty
tig
rsync
ddcutil
neovim
python-pynvim
python-poetry
python-pipenv
nodejs
zsh
exa
man-db
github-cli
ecryptfs-utils
lsof
unzip
picom
udiskie
telegram-desktop
redshift
network-manager-applet
guake
mate-polkit
xxkb
pavucontrol
mpv
mpv-mpris
cmus
youtube-dl
docker
docker-compose
lxappearance
papirus-icon-theme
xdotool
xsel
xclip
glow
rofimoji
pamixer
mpris
playerctl
bluez-utils
httpie
zathura
zathura-pdf-mupdf
sxiv
```

### 2. Install yay
```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

### 3. Install from AUR (with yay)
```
rcm
lain-git
awesome-freedesktop-git
i3lock-fancy-rapid-git
ntfs3-dkms
neovim-plug
neovim-symlinks
zgen-git
spaceship-prompt-git
wired
pipe-viewer-git
xcursor-human
materia-gtk-theme
nfs-utils
rofi-file-browser-extended-git
cmusfm
```

## 2. Clone and apply dotfiles
```bash
git clone https://github.com/h5vx/.dotfiles
rcup
# Install global config



~/.local/etc/install.sh
```

## System
```
usermod -aG docker h5v
usermod -aG i2c h5v
```

### Makepkg
* In `/etc/makepkg.conf`
```
MAKEFLAGS="-j8"
CFLAGS="-march=native # ...
RUSTFLAGS="-C opt-level=2 -C target-cpu=native"
BUILDDIR=/tmp/makepkg
```


## Neovim configuration
* In neovim run `:PlugInstall`

## Pacman
* Enable colors and parallel downloads

## tmux
```bash
git clone https://github.com/gpakosz/.tmux.git
cp .tmux/.tmux.conf ~/
```

## Xorg
```
Option "XkbLayout" "us,ru"
Option "XkbOptions" "grp:alt_shift_toggle,compose:ralt,grp_led:caps,ctrl:swapcaps"
```

## AwesomeWM
```bash
git clone --depth=1 https://github.com/lcpz/awesome-copycats
cp -r awesome-copycats/themes ~/.config/awesome/
rm -rf awesome-copycats
cd ~/.config/awesome/themes/copland/icons/
# Colorize all icons
find . -type f | grep -v temp.png | xargs -I {} ./colorize.sh {}

# Download varela round, as there is no package for it
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget 'https://fonts.google.com/download?family=Varela%20Round -O VarelaRound.zip'
unzip VarelaRound.zip
fc-cache -f -v
rm OFL.txt VarelaRound.zip
```
* Adjust theme settings
* lxappearance

## Firefox
```bash
PROFILE_PATH=$(echo ~/.mozilla/firefox/*.default-release)
mkdir $PROFILE_PATH/chrome
wget https://gist.githubusercontent.com/h5vx/7bed35a0f3e15e48d41ac344914e25fa/raw/user.js -O $PROFILE_PATH/user.js
wget https://gist.githubusercontent.com/h5vx/7bed35a0f3e15e48d41ac344914e25fa/raw/userChrome.css -O $PROFILE_PATH/chrome/userChrome.css
```
* Go to `about:preferences#sync` and sign in to synchronize settings
* Restore sideberry settings
 Apply theme
* Adjust `layout.css.devPixelsPerPx` (`1.2` is good for 120DPI)

## Git
```bash
# Export key on remote machine
gpg --export-secret-keys <key-id> > private.key
# Import on local machine
gpg --import private.key
# Show key id
gpg --list-secret-keys --keyid-format long | grep sec
# Adjust ~/.gitconfig.private
```

## ecryptfs
### Migrate home
1. Logout from user
1. Login as root
1. `modprobe ecryptfs`
1. ecryptfs-migrate-home -u user

### Auto-mounting
Change your /etc/pam.d/system-auth as follows
```diff
 #%PAM-1.0
 
 auth       required                    pam_faillock.so      preauth
+
 # Optionally use requisite above if you do not want to prompt for the password
 # on locked accounts.
 -auth      [success=2 default=ignore]  pam_systemd_home.so
-auth       [success=1 default=bad]     pam_unix.so          try_first_pass nullok
+auth       [success=1 default=bad]     pam_unix.so          try_first_pass nullok nodelay
+
 auth       [default=die]               pam_faillock.so      authfail
+
+# ecryptfs
+auth       [success=1 default=ignore]  pam_succeed_if.so    service = systemd-user quiet
+auth       required                    pam_ecryptfs.so      unwrap
+
 auth       optional                    pam_permit.so
 auth       required                    pam_env.so
 auth       required                    pam_faillock.so      authsucc
@@ -17,6 +24,7 @@ account    required                    pam_unix.so
 account    optional                    pam_permit.so
 account    required                    pam_time.so
 
+password   optional                    pam_ecryptfs.so
 -password  [success=1 default=ignore]  pam_systemd_home.so
 password   required                    pam_unix.so          try_first_pass nullok shadow sha512
 password   optional                    pam_permit.so
@@ -24,4 +32,9 @@ password   optional                    pam_permit.so
 -session   optional                    pam_systemd_home.so
 session    required                    pam_limits.so
 session    required                    pam_unix.so
+
+# ecryptfs
+session    [success=1 default=ignore] pam_succeed_if.so     service = systemd-user quiet
+session    optional                   pam_ecryptfs.so       unwrap
+
 session    optional                    pam_permit.so
```

## cmufm
* `cmusfm init`
* in cmus: `:set status_display_program=cmusfm`

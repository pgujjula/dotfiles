#!/bin/bash

# Print commands
set -x

# Quit on error
set -e

### Don't ask for permission for ssh operations (git clone, etc)
sudo sed -e 's/# Host \*/Host \*/g' -i /etc/ssh/ssh_config
sudo sed -e 's/#   StrictHostKeyChecking ask/   StrictHostKeyChecking accept-new/g' -i /etc/ssh/ssh_config

sudo dnf upgrade
sudo dnf install \
  tmux wget unzip zip ncurses-devel cloc time htop traceroute \
  gcc gmp gmp-devel make ncurses ncurses-libs xz perl bat fzf ag \
  exa \
  git \
  neovim \
  xauth \
  nodejs \
  waypipe \
  alacritty \
  python3-pip \
  firefox \
  reuse

### Install configs
# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --apply pgujjula --ssh

### Neovim
# Plugin manager
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim --headless +PlugInstall +qa

# nvr
pip3 install nvr

### Set color scheme to dark
dark

### Install powerline fonts
git clone https://github.com/powerline/fonts
cd fonts
./install.sh
cd ..
rm -rfv fonts

### Install rclone
curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip
unzip rclone-current-linux-amd64.zip
cd rclone-*-linux-amd64

sudo cp rclone /usr/local/bin/
sudo chown root:root /usr/local/bin/rclone
sudo chmod 755 /usr/local/bin/rclone

sudo mkdir -p /usr/local/share/man/man1
sudo cp rclone.1 /usr/local/share/man/man1/
sudo mandb

cd ..
rm -rfv rclone-current-linux-amd64.zip
rm -rfv rclone-*-linux-amd64

### Allow X11 Forwarding
echo "X11Forwarding yes" | sudo tee -a /etc/ssh/sshd_config
touch ~pgujjula/.Xauthority

### Add /usr/local/lib[64] to ldd path
echo /usr/local/lib | sudo tee -a /etc/ld.so.conf
echo /usr/local/lib64 | sudo tee -a /etc/ld.so.conf
sudo ldconfig

### Set git signing program to ssh-keygen, since 1Password isn't available
git config --global gpg.ssh.program ssh-keygen

### Clear all traces and exit
rm -rfv ~/common-config
history -c

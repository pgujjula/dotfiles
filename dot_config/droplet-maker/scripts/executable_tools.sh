#!/bin/bash

# Print commands
set -x

# Quit on error
set -e

### Don't ask for permission for ssh operations (git clone, etc)
sudo sed -e 's/# Host \*/Host \*/g' -i /etc/ssh/ssh_config
sudo sed -e 's/#   StrictHostKeyChecking ask/   StrictHostKeyChecking accept-new/g' -i /etc/ssh/ssh_config

sudo dnf shell -y << EOF
upgrade
install tmux wget unzip zip ncurses-devel cloc time htop traceroute
install gcc gmp gmp-devel make ncurses ncurses-libs xz perl bat fzf ag
install git
install neovim
install xauth
run
EOF

git config --global user.name "Preetham Gujjula"
git config --global user.email "gitcommit@mail.preetham.io"
git config --global core.editor "nvim"

### Neovim
# Plugin manager
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

### Allow X11 Forwarding
echo "X11Forwarding yes" | sudo tee -a /etc/ssh/sshd_config
touch ~pgujjula/.Xauthority

### Add /usr/local/lib[64] to ldd path
echo /usr/local/lib | sudo tee -a /etc/ld.so.conf
echo /usr/local/lib64 | sudo tee -a /etc/ld.so.conf
sudo ldconfig

### Install configs
git clone https://github.com/pgujjula/common-config.git
bash common-config/install.sh

### Clear all traces and exit
rm -rfv ~/common-config
history -c

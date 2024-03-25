#!/bin/bash
set -x
set -e

# Install ghcup
mkdir --parents $HOME/.ghcup/bin
wget https://downloads.haskell.org/~ghcup/x86_64-linux-ghcup \
  -O $HOME/.ghcup/bin/ghcup
chmod u+x $HOME/.ghcup/bin/ghcup

# Install ghc, cabal, stack, and hls
mkdir $HOME/tmp
export TMPDIR=$HOME/tmp
ghcup upgrade
ghcup install cabal
ghcup install stack
ghcup install ghc 9.2.8
ghcup install ghc 9.4.8
ghcup install ghc 9.6.4
ghcup install ghc 9.8.1
ghcup install hls
stack config set install-ghc false --global
stack config set system-ghc true --global
echo "extra-lib-dirs:" >> $HOME/.stack/config.yaml
echo "- /usr/local/lib64" >> $HOME/.stack/config.yaml
echo "- /usr/local/lib" >> $HOME/.stack/config.yaml
export TMPDIR=
rm -rfv $HOME/tmp

# Build a "Hello, World!" program to populate package cache
stack build hello

history -c

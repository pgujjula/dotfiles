#!/bin/bash
set -x
set -e

# Enable swap
sudo truncate -s 0 /swapfile
sudo chattr +C /swapfile
sudo dd if=/dev/zero of=/swapfile count=5000 bs=1MiB
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Install C dependencies
sudo dnf install -y blas-devel lapack-devel mpfr-devel \
  primesieve-devel primecount-devel

# Build project-euler
git clone git@github.com:pgujjula/project-euler.git
cd project-euler
stack build --test --no-run-tests --dependencies-only
stack build --test --no-run-tests --dependencies-only
stack build --test --no-run-tests --dependencies-only
stack build --test --no-run-tests
stack build --test --no-run-tests
stack build --test --no-run-tests

# Remove swap
sudo swapoff /swapfile
sudo rm /swapfile

# Shutdown
history -c

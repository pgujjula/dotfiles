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
  primesieve-devel

# Install custom primecount
git clone git@github.com:pgujjula/primecount
cd primecount
sudo dnf install -y cmake
cmake . -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=OFF
cmake --build .
sudo cmake --install .
sudo ldconfig

# Build project-euler
git clone git@github.com:pgujjula/project-euler.git
cd project-euler
stack build --test --no-run-tests --bench --no-run-benchmarks --haddock
stack build --test --no-run-tests --bench --no-run-benchmarks --haddock
stack build --test --no-run-tests --bench --no-run-benchmarks --haddock
stack build --test --no-run-tests --bench --no-run-benchmarks
stack build --test --no-run-tests --bench --no-run-benchmarks
stack build --test --no-run-tests --bench --no-run-benchmarks

# Remove swap
sudo swapoff /swapfile
sudo rm /swapfile

# Shutdown
history -c

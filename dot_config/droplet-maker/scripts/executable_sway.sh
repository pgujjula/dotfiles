#!/bin/bash

# Print commands
set -x

# Quit on error
set -e

sudo dnf install -y cage sway weston wayvnc

echo "export WLR_BACKENDS=headless" >> ~/.bashrc
echo "export WLR_NO_HARDWARE_CURSORS=1" >> ~/.bashrc
echo "export WLR_RENDERER=pixman" >> ~/.bashrc
echo "export WLR_RENDERER_ALLOW_SOFTWARE=1" >> ~/.bashrc
echo "export WLR_LIBINPUT_NO_DEVICES=1" >> ~/.bashrc

### Clear all traces and exit
history -c

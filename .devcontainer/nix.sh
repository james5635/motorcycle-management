#!/usr/bin/env bash
# Install Nix package manager
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon

# source it
echo "source ~/.nix-profile/etc/profile.d/nix.sh" >> ~/.bashrc

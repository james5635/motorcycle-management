#!/usr/bin/env bash
# Install Nix package manager
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon

# source it
echo "source ~/.nix-profile/etc/profile.d/nix.sh" >> ~/.bashrc

# ERROR:
# -----------------------------------------------------------------------------
# @james5635 ? /workspaces/motorcycle-management (main) $ flutter run -d linux
# Launching lib/main.dart on Linux in debug mode...
# Building Linux application...                                           
# ? Built build/linux/x64/debug/bundle/motorcycle_management
# No provider of eglGetPlatformDisplayEXT found.  Requires one of:
#     EGL_EXT_platform_base
# Error waiting for a debug connection: The log reader stopped unexpectedly, or
# never started.
# Error launching application on Linux.
# -----------------------------------------------------------------------------
#
# SOLUTION:
# -----------------------------------------------------------------------------
# sudo apt-get update -y && sudo apt-get upgrade -y
# sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa
# -----------------------------------------------------------------------------
#
# NOTE: libglu1-mesa is important

sudo chmod 666 /dev/kvm

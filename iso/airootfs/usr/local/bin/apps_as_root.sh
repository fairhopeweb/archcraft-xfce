#!/usr/bin/env bash

## zenity sudo askpass helper
export SUDO_ASKPASS=/usr/local/bin/askpass_zenity.sh

## execute the application
sudo -A $1

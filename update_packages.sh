#!/bin/sh

INSTALLED_PACKAGES=./installed_packages.txt
if [ -f $INSTALLED_PACKAGES ]; then
    for p in $(cat $INSTALLED_PACKAGES); do yay -S $p; done
else
    echo "installed_packages.txt file was not found"
    exit 1
fi

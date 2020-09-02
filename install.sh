#!/bin/sh

##Installing yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

INSTALLED_PACKAGES=./installed_packages.txt
if [ -f $INSTALLED_PACKAGES ]; then
    for p in $(cat $INSTALLED_PACKAGES); do yay -S $p; done
else
    echo "installed_packages.txt file was not found"
    exit 1
fi

#Installing vim-plug for neovim
package=neovim
if pacman -Qs $package > /dev/null ; then
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
else
    echo "neovim not installed"
fi

yay -S rcm && rcup
